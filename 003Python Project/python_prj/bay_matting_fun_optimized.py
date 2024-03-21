import cv2
import numpy as np
from matplotlib import pyplot as plt
import time
from memory_profiler import profile
import psutil
import os
import tracemalloc
from PIL import Image
from math import log10, sqrt
from tqdm import tqdm

# ------------- function define  ---------------------- #
def compute_mean_cov(frontImg, backImg, unknownImg, width, height):
    """
    Compute the mean and covariance matrices for foreground and background.

    Parameters:
    frontImg (numpy.ndarray): The image representing the foreground.
    backImg (numpy.ndarray): The image representing the background.
    unknownImg (numpy.ndarray): The image representing the unknown region.
    width (int): The width of the images.
    height (int): The height of the images.

    Returns:
    tuple: A tuple containing:
        Fmean (numpy.ndarray): Mean vector for foreground.
        Bmean (numpy.ndarray): Mean vector for background.
        coF (numpy.ndarray): Covariance matrix for foreground.
        coB (numpy.ndarray): Covariance matrix for background.
    """
    # Initialize avg and cov matrix
    Fmean = np.zeros(3)
    Bmean = np.zeros(3)
    Umean = np.zeros(3)
    coF = np.zeros((3, 3))
    coB = np.zeros((3, 3))
    NF = 0
    NB = 0
    # calculate foreground avg
    for i in range(3):
        temp = frontImg[:, :, i]
        Fmean[i] = np.mean(temp[temp > 0])
    # calculate background avg
    for i in range(3):
        temp = backImg[:, :, i]
        Bmean[i] = np.mean(temp[temp > 0])
    # calculate covariance of foreground and background
    for b in range(height):
        for a in range(width):
            if np.any(frontImg[a, b, :]):
                shiftF = frontImg[a, b, :] - Fmean
                coF += np.outer(shiftF, shiftF)
                NF += 1
            if np.any(backImg[a, b, :]):
                shiftB = backImg[a, b, :] - Bmean
                coB += np.outer(shiftB, shiftB)
                NB += 1
    coF /= NF
    coB /= NB
    return Fmean, Bmean, coF, coB



def update_alpha(unknownImg, triMap, Fmean, Bmean, coF, coB, oriVar, Iteration, width, height):
    """
    Update the alpha matte based on the given inputs.

    Parameters:
    unknownImg (numpy.ndarray): The image representing the unknown region.
    triMap (numpy.ndarray): The trimap.
    Fmean (numpy.ndarray): Mean vector for foreground.
    Bmean (numpy.ndarray): Mean vector for background.
    coF (numpy.ndarray): Covariance matrix for foreground.
    coB (numpy.ndarray): Covariance matrix for background.
    oriVar (float): Original variance.
    Iteration (int): The number of iterations for updating alpha.
    width (int): The width of the images.
    height (int): The height of the images.

    Returns:
    tuple: A tuple containing:
        unknownAlpha (numpy.ndarray): The updated alpha matte.
        unknownF (numpy.ndarray): The updated foreground image.
        unknownB (numpy.ndarray): The updated background image.
    """
    unknownAlpha = triMap.astype(float) / 255.0
    invcoF = np.linalg.inv(coF)
    invcoB = np.linalg.inv(coB)
 
    # Vectorized approach to initialize foreground and background
    unknownF = np.zeros_like(unknownImg)
    unknownB = np.zeros_like(unknownImg)
 
    # Pre-compute constants for the equations
    inv_oriVar_square = 1.0 / (oriVar ** 2)
    eye3 = np.eye(3)
    
    # Only work on unknown pixels
    unknown_pixels = np.nonzero((triMap > 0.95) & (triMap < 0.05))
 
    for a, b in tqdm(zip(*unknown_pixels)):
        # Initialize alpha based on the trimap
        alpha = unknownAlpha[a, b]
        preAlpha = alpha
        
        C = unknownImg[a, b, :]
        
        for i in range(Iteration):
            UL = invcoF + eye3 * (alpha ** 2) * inv_oriVar_square
            UR = eye3 * alpha * (1 - alpha) * inv_oriVar_square
            DL = UR  # Same as UR because of symmetry
            DR = invcoB + eye3 * ((1 - alpha) ** 2) * inv_oriVar_square
            A = np.block([[UL, UR], [DL, DR]])
            BU = np.dot(invcoF, Fmean) + C * alpha * inv_oriVar_square
            BD = np.dot(invcoB, Bmean) + C * (1 - alpha) * inv_oriVar_square
            B = np.concatenate([BU, BD])
            x = np.linalg.solve(A, B)
            tempF = x[:3]
            tempB = x[3:]
            alpha = np.dot((C - tempB), (tempF - tempB)) / np.linalg.norm(tempF - tempB) ** 2
            
            # Break if change in alpha is small
            if abs(preAlpha - alpha) < 0.0001:
                break
            preAlpha = alpha
        
        unknownF[a, b, :] = tempF
        unknownB[a, b, :] = tempB
        unknownAlpha[a, b] = alpha
    
    return unknownAlpha, unknownF, unknownB

def bayesian_matting(image_path, trimap_path, oriVar=8, Iteration=10):
    """
    Perform Bayesian matting to compute alpha matte from the given image and trimap.

    Parameters:
    image_path (str): The path to the input image.
    trimap_path (str): The path to the trimap image.
    oriVar (float): Original variance for alpha matte computation (default is 8).
    Iteration (int): Number of iterations for alpha matte refinement (default is 10).

    Returns:
    numpy.ndarray: The computed alpha matte as a 2D numpy array.
    """
    oriImg = cv2.imread(image_path)
    triMap = cv2.imread(trimap_path, cv2.IMREAD_GRAYSCALE)
    if oriImg is None or triMap is None:
        raise ValueError("Image or trimap path is invalid.")

    FThreshold = 255 * 0.95
    BThreshold = 255 * 0.05
    width, height = triMap.shape

    triMap_expanded = np.expand_dims(triMap, axis=-1)
    frontImg = np.where(triMap_expanded >= FThreshold, oriImg, 0).astype(float)
    backImg = np.where(triMap_expanded <= BThreshold, oriImg, 0).astype(float)
    unknownImg = np.where((triMap_expanded > BThreshold) & (triMap_expanded < FThreshold), oriImg, 0).astype(float)

    Fmean, Bmean, coF, coB = compute_mean_cov(frontImg, backImg, unknownImg, width, height)
    unknownAlpha, _, _ = update_alpha(unknownImg, triMap, Fmean, Bmean, coF, coB, oriVar, Iteration, width, height)

    AlphaMap = (unknownAlpha * 255).astype(np.uint8)
    return AlphaMap

def show_foreground_with_threshold(image_path, trimap_path, threshold):
    """
    Display the foreground of an image based on the given trimap and threshold.

    Parameters:
    image_path (str): The path to the input image.
    trimap_path (str): The path to the trimap image.
    threshold (float): The threshold value to determine the foreground (0 to 1).

    Returns:
    None
    """
    # load figure and trimap
    image = cv2.imread(image_path)
    trimap = cv2.imread(trimap_path, cv2.IMREAD_GRAYSCALE)

    # ensure alpha_map is float and range from 0 - 1
    alpha_map = trimap.astype(float) / 255.0

    # initialize background as black
    final_image = np.zeros_like(image)

    # set pixel as foreground when alpha > threshold
    foreground_mask = alpha_map >= threshold

    # copy foreground pixel from original pic to the result pic
    for c in range(3):  # vary each channel
        final_image[:, :, c] = image[:, :, c] * foreground_mask

    # transfer the image from BGR to RGB to display
    final_image_rgb = cv2.cvtColor(final_image, cv2.COLOR_BGR2RGB)

    # show the figure with matplotlib
    plt.figure(figsize=(6, 6))
    plt.imshow(final_image_rgb)
    plt.title("Foreground with Threshold")
    plt.axis('off')
    plt.show()
    
def calculate_alpha_mse(predicted_alpha_file, ground_truth_alpha_file):
    """
    Calculates the Mean Squared Error between the predicted alpha matte and the ground truth alpha matte from image files.

    Inputs:
        predicted_alpha_file (str): The file path to the alpha matte generated by the matting algorithm.
        ground_truth_alpha_file (str): The file path to the ground truth alpha matte image.

    Output:
        mse (float): The Mean Squared Error between the predicted and ground truth alpha mattes.
    """

    # Read the image files
    predicted_alpha = np.array(Image.open(predicted_alpha_file))
    ground_truth_alpha = np.array(Image.open(ground_truth_alpha_file).convert('L'))  # Convert to grayscale

    # Ensure the alpha mattes are in the correct format
    predicted_alpha = predicted_alpha.astype(np.float32) / 255.0
    ground_truth_alpha = ground_truth_alpha.astype(np.float32) / 255.0

    # Calculate MSE across the entire image
    mse = np.mean((predicted_alpha - ground_truth_alpha) ** 2)

    return mse

def calculate_psnr(predicted_alpha_file, ground_truth_alpha_file):
    """
    Calculate the Peak Signal-to-Noise Ratio (PSNR) between two images.

    Parameters:
        original_img_path (str): The file path to the original image.
        compressed_img_path (str): The file path to the compressed (or reconstructed) image.

    Returns:
        psnr_value (float): The PSNR value between the two images.
    """

    # Read the image files
    predicted_alpha = np.array(Image.open(predicted_alpha_file))
    ground_truth_alpha = np.array(Image.open(ground_truth_alpha_file).convert('L'))  # Convert to grayscale

    # Ensure the alpha mattes are in the correct format
    predicted_alpha = predicted_alpha.astype(np.float32) / 255.0
    ground_truth_alpha = ground_truth_alpha.astype(np.float32) / 255.0

    # Calculate MSE across the entire image
    mse = np.mean((predicted_alpha - ground_truth_alpha) ** 2)

    # Calculate the maximum possible pixel value
    max_pixel_value = np.max(ground_truth_alpha)

    # Calculate PSNR
    if mse == 0:
        psnr_value = float('inf')
    else:
        psnr_value = 20 * log10(max_pixel_value / sqrt(mse))

    return psnr_value