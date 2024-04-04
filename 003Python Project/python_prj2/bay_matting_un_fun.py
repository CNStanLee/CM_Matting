'''
Author: Changhongli lic9@tcd.com
Date: 2024-03-14 13:45:26
LastEditors: Changhongli lic9@tcd.com
LastEditTime: 2024-03-14 13:58:37
FilePath: /003Python Project/python_prj/bay_matting_un_fun.py
Description: 

'''
import torch
import torch.nn as nn
import torch.nn.functional as F
import numpy as np
import cv2
from PIL import Image as PILImage
from torchvision import transforms
import torch.optim as optim
from IPython.display import Image, display
import os
from torch.utils.data import DataLoader, Dataset
from torchvision import transforms
from sklearn.model_selection import train_test_split
import matplotlib.pyplot as plt
import os
import glob

# U-Net Model
# U-Net Components
class DoubleConv(nn.Module):
    """(convolution => [BN] => ReLU) * 2"""
    def __init__(self, in_channels, out_channels, mid_channels=None):
        super().__init__()
        if not mid_channels:
            mid_channels = out_channels
        self.double_conv = nn.Sequential(
            nn.Conv2d(in_channels, mid_channels, kernel_size=3, padding=1),
            nn.BatchNorm2d(mid_channels),
            nn.ReLU(inplace=True),
            nn.Conv2d(mid_channels, out_channels, kernel_size=3, padding=1),
            nn.BatchNorm2d(out_channels),
            nn.ReLU(inplace=True)
        )
    def forward(self, x):
        return self.double_conv(x)

class Down(nn.Module):
    """Downscaling with maxpool then double conv"""
    def __init__(self, in_channels, out_channels):
        super().__init__()
        self.maxpool_conv = nn.Sequential(
            nn.MaxPool2d(2),
            DoubleConv(in_channels, out_channels)
        )
    def forward(self, x):
        return self.maxpool_conv(x)

class Up(nn.Module):
    """Upscaling then double conv"""
    def __init__(self, in_channels, out_channels, bilinear=True):
        super().__init__()
        if bilinear:
            self.up = nn.Upsample(scale_factor=2, mode='bilinear', align_corners=True)
            self.conv = DoubleConv(in_channels, out_channels, in_channels // 2)
        else:
            self.up = nn.ConvTranspose2d(in_channels , in_channels // 2, kernel_size=2, stride=2)
            self.conv = DoubleConv(in_channels, out_channels)
    def forward(self, x1, x2):
        x1 = self.up(x1)
        diffY = x2.size()[2] - x1.size()[2]
        diffX = x2.size()[3] - x1.size()[3]
        x1 = F.pad(x1, [diffX // 2, diffX - diffX // 2, diffY // 2, diffY - diffY // 2])
        x = torch.cat([x2, x1], dim=1)
        return self.conv(x)

class OutConv(nn.Module):
    def __init__(self, in_channels, out_channels):
        super(OutConv, self).__init__()
        self.conv = nn.Conv2d(in_channels, out_channels, kernel_size=1)
    def forward(self, x):
        return self.conv(x)

# U-Net Model
class UNet(nn.Module):
    def __init__(self, n_channels, n_classes=1, bilinear=True):
        super(UNet, self).__init__()
        self.n_channels = n_channels
        self.n_classes = n_classes
        self.bilinear = bilinear

        self.inc = DoubleConv(n_channels, 64)
        self.down1 = Down(64, 128)
        self.down2 = Down(128, 256)
        self.down3 = Down(256, 512)
        self.down4 = Down(512, 1024 // 2)
        self.up1 = Up(1024, 512 // 2, bilinear)
        self.up2 = Up(512, 256 // 2, bilinear)
        self.up3 = Up(256, 128 // 2, bilinear)
        self.up4 = Up(128, 64, bilinear)
        self.outc = OutConv(64, n_classes)

    def forward(self, x):
        x1 = self.inc(x)
        x2 = self.down1(x1)
        x3 = self.down2(x2)
        x4 = self.down3(x3)
        x5 = self.down4(x4)
        x = self.up1(x5, x4)
        x = self.up2(x, x3)
        x = self.up3(x, x2)
        x = self.up4(x, x1)
        logits = self.outc(x)
        return logits

class DiceLoss(nn.Module):
    """Dice loss, need inputs between 0 and 1."""
    def __init__(self, smooth=1e-6):
        super(DiceLoss, self).__init__()
        self.smooth = smooth

    def forward(self, input, target):
        assert input.size() == target.size(), "Input sizes must be equal."
        assert input.dim() == 4, "Input must be a 4D Tensor."
        # Convert to float to ensure full precision during division
        input = torch.sigmoid(input).float()
        target = target.float()
        
        numerator = 2 * torch.sum(input * target, dim=(2, 3))
        denominator = torch.sum(input + target, dim=(2, 3))
        
        dice_score = (numerator + self.smooth) / (denominator + self.smooth)
        dice_loss = 1 - dice_score
        return dice_loss.mean()


#val_loader = DataLoader(val_dataset, batch_size=4, shuffle=False)

def load_pretrained_model(model_path='model_best.pth', device='cpu'):
    # 确保UNet模型已经被定义在这个函数的外部
    model = UNet(n_channels=3, n_classes=1)
    # 加载预训练的权重，确保指定了map_location来适配你的设备
    model.load_state_dict(torch.load(model_path, map_location=device))
    # 将模型移动到指定的设备
    model.to(device)
    return model

# Image Preprocessing
def preprocess_image(image_path):
    # 直接从文件路径加载图片
    image = PILImage.open(image_path).convert("RGB")
    transform = transforms.Compose([
        transforms.Resize((320, 320)),
        transforms.ToTensor(),
        transforms.Normalize(mean=[0.485, 0.456, 0.406], std=[0.229, 0.224, 0.225]),
    ])
    input_tensor = transform(image)
    input_tensor = input_tensor.unsqueeze(0)  # 增加一个批次维度
    return input_tensor

def inference_and_get_alphamap(image_path, device, model_path='model_best.pth'):
    model = load_pretrained_model(model_path, device)  # 加载模型和权重
    model.eval()  # 设置模型为评估模式

    # 图像预处理
    original_image = PILImage.open(image_path).convert("RGB")
    input_tensor = preprocess_image(image_path)
    input_tensor = input_tensor.to(device)  # 确保张量在正确的设备上

    # 模型推理
    with torch.no_grad():  # 不计算梯度
        output = model(input_tensor)  # 前向传播
    
    # 将输出应用Sigmoid函数转换成概率，进一步得到Alpha Map
    alpha_map = torch.sigmoid(output).squeeze().cpu().numpy()
    alpha_map = np.clip((alpha_map * 255).astype(np.uint8), 0, 255)  # 转换为0-255的整数

    # 调整Alpha Map的尺寸以匹配原始图像的尺寸
    original_width, original_height = original_image.size
    alpha_map_resized = cv2.resize(alpha_map, (original_width, original_height), interpolation=cv2.INTER_LINEAR)

    return alpha_map_resized


# 保存Alpha Map的函数
def save_alpha_map(alpha_map, save_path='alpha_map.png'):
    PILImage.fromarray(alpha_map).save(save_path)