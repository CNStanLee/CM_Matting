function [unknownAlpha, unknownF, unknownB] = Matting(unknownImg, triMap, coF, coB, Fmean, Bmean, oriVar, Iteration)
%REFINEALPHAMATTE Refines the alpha matte of an image using local averaging and iterative optimization.
%
% Inputs:
%   unknownImg - The input image with unknown regions to refine the alpha matte for.
%   triMap - The trimap of the input image, used to initialize the alpha matte.
%   coF - The covariance matrix of the foreground color distribution.
%   coB - The covariance matrix of the background color distribution.
%   Fmean - The mean color of the foreground.
%   Bmean - The mean color of the background.
%   oriVar - The variance of the original image used in the uncertainty calculation.
%   Iteration - The number of iterations for refining the alpha value.
%
% Outputs:
%   unknownAlpha - The refined alpha matte of the input image.
%   unknownF - The estimated foreground image.
%   unknownB - The estimated background image.
%
% Revision:
% 0.0 : 2024/02/21 :  First Create : Qiwen Tan

% Map the trimap values from 0-255 to 0-1 for alpha matte initialization
unknownAlpha = double(triMap) / 255.0;

% Initialize the foreground and background images
unknownF = unknownImg;
unknownB = unknownImg;

% Precompute the inverses of the covariance matrices
invcoF = inv(coF);
invcoB = inv(coB);

% Image dimensions
[height, width, ~] = size(unknownImg);

% Loop through each pixel in the image
for b = 1:height
    for a = 1:width
        if any(unknownImg(a, b, :)),
            % Initialize variables for alpha computation
            alpha = 0;
            count = 0;

            % Local averaging to smooth the alpha matte
            [alpha, count] = localAverageAlpha(a, b, alpha, count, unknownAlpha, width, height);

            % Initial alpha value after local averaging
            alpha = alpha / count;
            preAlpha = alpha;

            for iter = 1:Iteration
                % Estimate F and B using current alpha
                [tempF, tempB] = estimateFB(a, b, alpha, invcoF, invcoB, oriVar, Fmean, Bmean, unknownImg);
                
                % Calculate new alpha using estimated F and B
                alpha = calculateAlpha(reshape(unknownImg(a, b, :), [3, 1]), tempF, tempB, preAlpha);

                % Check for convergence (optional, depending on your criteria)
                if abs(preAlpha - alpha) < 0.0001
                    break;
                end
                preAlpha = alpha;
            end

            % Update the estimated foreground, background, and alpha matte
            unknownF(a, b, :) = tempF;
            unknownB(a, b, :) = tempB;
            unknownAlpha(a, b) = alpha;
        end
    end
end
end