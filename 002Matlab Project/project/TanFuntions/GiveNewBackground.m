function [newBack] = GiveNewBackground(oriImg, triMap, unknownF, unknownAlpha, FThreshold, BgPath)
%BLENDWITHNEWBACKGROUND Allows the user to select a new background and blends it with the original image's foreground.
%
% Inputs:
%   oriImg - The original image.
%   triMap - The trimap used for initial alpha matte segmentation.
%   unknownF - The estimated foreground image.
%   unknownAlpha - The refined alpha matte.
%   FThreshold - The threshold for determining definite foreground in the trimap.
% Outputs
%   newBack (uint8 matrix) - The image with new background
% Revision:
% 0.0 : 2024/02/21 :  First Create : Qiwen Tan
% 0.1 : 2024/02/26 :  Add return image : Changhong Li

% Prompt the user to select a new background image
% [File, Path] = uigetfile({'*.jpg;*.jpeg;*.png;*.gif;*.bmp;*.tiff', 'Image Files (.jpg, .jpeg, .png, .gif, .bmp, .tiff)'}, 'Select a new Background');
% if isequal(File, 0) || isequal(Path, 0)
%     disp('User canceled the operation.');
%     return;
% end


oriImg = imread(oriImg);
triMap = imread(triMap);


% Read and resize the new background to match the original image's dimensions
%m_newBack = imread(fullfile(Path, File));
m_newBack = imread(BgPath);
[height, width, ~] = size(oriImg); % Assuming oriImg is the reference for dimensions
m_newBack = imresize(m_newBack, [height, width]);
m_newBack = double(m_newBack);

% Blend the new background with the estimated foreground using the alpha matte
for i = 1:3
    m_newBack(:, :, i) = unknownF(:, :, i) .* unknownAlpha + m_newBack(:, :, i) .* (1 - unknownAlpha);
     %m_newBack(:,:,i) = unknownF(:,:,i).*unknownAlpha(:,:) + m_newBack(:,:,i).*(1-unknownAlpha(:,:));   
end

% Replace background with original image where trimap indicates definite foreground
for a = 1:width
    for b = 1:height
        if triMap(b, a) >= FThreshold
            m_newBack(b, a, :) = oriImg(b, a, :);
        end
    end
end

% Display and save the result
% figure;
% imshow(uint8(m_newBack));
% imwrite(uint8(m_newBack), 'BlendedImage.png'); % Changed filename to be more generic
% drawnow;
% m_newBack = m_newBack * 255;
newBack = uint8(m_newBack);
end
