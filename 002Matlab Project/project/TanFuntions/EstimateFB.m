function [F, B] = EstimateFB(a, b, alpha, invcoF, invcoB, oriVar, Fmean, Bmean, unknownImg)
% Estimates the foreground and background colors for a pixel based on the
% alpha value and the pixel's color.
%
% Inputs:
%   a, b - The coordinates of the current pixel.
%   alpha - The alpha value for the pixel.
%   invcoF, invcoB - The inverse covariance matrices for the foreground and background.
%   oriVar - The variance of the original image used in uncertainty calculation.
%   Fmean, Bmean - The mean colors of the foreground and background.
%   unknownImg - The original image with unknown regions.
%
% Outputs:
%   F - The estimated foreground color for the pixel.
%   B - The estimated background color for the pixel.
%
% Revision:
% 0.0 : 2024/02/21 :  First Create : Qiwen Tan

% Calculate the matrices for uncertainty and correction
% UL = invcoF + eye(3) * (alpha^2) / (oriVar^2);
% UR = eye(3) * alpha * (1 - alpha) / (oriVar^2);
% DL = UR; % Symmetric to UR
% DR = invcoB + eye(3) * ((1 - alpha)^2) / (oriVar^2);
% 
% A = [UL UR; DL DR];
% 
% C = reshape(unknownImg(a, b, :), [3, 1]);
% BU = invcoF * Fmean' + C * alpha / (oriVar^2);
% BD = invcoB * Bmean' + C * (1 - alpha) / (oriVar^2);
% B = [BU; BD];
% 
% % Solve for the new foreground and background
% x = A \ B;
% F = x(1:3);
% B = x(4:6);
% 

UL = invcoF + eye(3)*(alpha*alpha)/(oriVar*oriVar);
UR =eye(3)*alpha*(1-alpha)/(oriVar*oriVar);
DL = eye(3)*alpha*(1-alpha)/(oriVar*oriVar);
DR = invcoB + eye(3)*(1-alpha)*(1-alpha)/(oriVar*oriVar);
A = [UL UR;DL DR];
C = reshape(unknownImg(a,b,:),3,1);
BU = invcoF*Fmean' + C*alpha/(oriVar*oriVar);
BD = invcoB*Bmean' + C*(1-alpha)/(oriVar*oriVar);
B = [BU; BD];
x = A\B;
F = x(1:3);
B = x(4:6);
% Print the estimated foreground and background
%fprintf('Estimated Foreground: [%f, %f, %f], Estimated Background: [%f, %f, %f]\n', F, B);
end