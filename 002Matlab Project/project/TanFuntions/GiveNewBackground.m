function GiveNewBackground(oriImg, triMap, unknownF, unknownAlpha, FThreshold)
%BLENDWITHNEWBACKGROUND Allows the user to select a new background and blends it with the original image's foreground.
%
% Inputs:
%   oriImg - The original image.
%   triMap - The trimap used for initial alpha matte segmentation.
%   unknownF - The estimated foreground image.
%   unknownAlpha - The refined alpha matte.
%   FThreshold - The threshold for determining definite foreground in the trimap.
%
% Revision:
% 0.0 : 2024/02/21 :  First Create : Qiwen Tan

% Prompt the user to select a new background image
[File, Path] = uigetfile({'*.jpg;*.jpeg;*.png;*.gif;*.bmp;*.tiff', 'Image Files (.jpg, .jpeg, .png, .gif, .bmp, .tiff)'}, 'Select a new Background');
if isequal(File, 0) || isequal(Path, 0)
    disp('User canceled the operation.');
    return;
end


oriImg = imread(oriImg);
triMap = imread(triMap);

% Read and resize the new background to match the original image's dimensions
newBack = imread(fullfile(Path, File));
[height, width, ~] = size(oriImg); % Assuming oriImg is the reference for dimensions
newBack = imresize(newBack, [height, width]);
newBack = double(newBack);

% Blend the new background with the estimated foreground using the alpha matte
for i = 1:3
    newBack(:, :, i) = unknownF(:, :, i) .* unknownAlpha + newBack(:, :, i) .* (1 - unknownAlpha);
     %newBack(:,:,i) = unknownF(:,:,i).*unknownAlpha(:,:) + newBack(:,:,i).*(1-unknownAlpha(:,:));   
end

% Replace background with original image where trimap indicates definite foreground
for a = 1:width
    for b = 1:height
        if triMap(b, a) >= FThreshold
            newBack(b, a, :) = oriImg(b, a, :);
        end
    end
end

% Display and save the result
figure;
imshow(uint8(newBack));
imwrite(uint8(newBack), 'BlendedImage.png'); % Changed filename to be more generic
drawnow;

end
