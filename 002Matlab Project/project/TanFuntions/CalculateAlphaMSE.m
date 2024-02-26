function mse = CalculateAlphaMSE(predictedAlphaFile, groundTruthAlphaFile)
%CALCULATEALPHAMSE Calculates the Mean Squared Error between the predicted alpha matte and the ground truth alpha matte from image files.
%
% Inputs:
%   predictedAlphaFile - The file path to the alpha matte generated by the matting algorithm.
%   groundTruthAlphaFile - The file path to the ground truth alpha matte image.
%
% Output:
%   mse - The Mean Squared Error between the predicted and ground truth alpha mattes.

% Read the image files
predictedAlpha = imread(predictedAlphaFile);
groundTruthAlpha = imread(groundTruthAlphaFile);

% Ensure the alpha mattes are in the correct format
predictedAlpha = double(predictedAlpha) / 255;
groundTruthAlpha = double(groundTruthAlpha) / 255;

% Calculate MSE across the entire image
mse = mean((predictedAlpha(:) - groundTruthAlpha(:)).^2);

end