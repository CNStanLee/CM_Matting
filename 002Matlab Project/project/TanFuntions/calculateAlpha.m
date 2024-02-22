function alpha = CalculateAlpha(C, F, B, preAlpha)
% Calculates the alpha value for a pixel based on the estimated
% foreground and background colors and the pixel's color.
%
% Inputs:
%   C - The color of the current pixel in the image.
%   F - The estimated foreground color for the pixel.
%   B - The estimated background color for the pixel.
%   preAlpha - The alpha value from the previous iteration for convergence check.
%
% Output:
%   alpha - The updated alpha value for the pixel.
%
% Revision:
% 0.0 : 2024/02/21 :  First Create : Qiwen Tan

% Calculate the new alpha value
alpha = dot((C - B), (F - B)) / norm(F - B)^2;

% alpha = dot((C - tempB), (tempF - tempB)) / norm(tempF-tempB).^2;

% Print the calculated alpha value
%fprintf('Previous Alpha: %.4f, Updated Alpha: %.4f\n', preAlpha, alpha);
end