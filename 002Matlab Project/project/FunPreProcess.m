function [frontImg, backImg, unknownImg] = FunPreProcess(oriImage, triMap)

% FunPreProcess
% This function is used for preprocessing the input image.
% MainProcess:
% 1. Read Image
% 2. Get Pic Size
% Inputs:
%    oriImage(file path string) - File path to the original image
%    triMap(file path string) - File path to the trimap image
% Outputs:
%    frontImg(double matrix, (x, y, channel)) - front Img matrix
%    backImg(double matrix, (x, y, channel)) - back Img matrix
%    unkownImg(double matrix, (x, y, channel)) - unkown Img matrix
% Author: ChanghongLi

%------------- Begin Variable --------------
% Revision:
% 0.0 : 2024/02/21 :  First Create : Changhong Lee

%------------- Begin Variable --------------


%------------- End Variable -----------


%------------- Begin Code --------------

% Set Threshold to transfrom trimap
FThreshold = 255 * 0.95;    % threshold of trimap foreground
BThreshold = 255 * 0.05;    % bg


%------------- End Code -----------