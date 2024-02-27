% Linted
function [frontImg, backImg, unknownImg] = FunPreProcess(oriImg, triMap)

    % FunPreProcess
    % This function is used for preprocessing the input image.
    % MainProcess:
    % 1. Convert Trimap Matrix from rgb to gray if needed
    % 2. Iterate all the pixels and compare with threshold
    % Inputs:
    %    oriImg(file path string) - File path to the original image
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

    % read the trimap and image to matrix
    triMapMatrix = imread(triMap);
    oriImgMatrix = imread(oriImg);
    
    
    % initial picture
    mfrontImg = double(oriImgMatrix);
    mbackImg = double(oriImgMatrix);
    munknownImg = double(oriImgMatrix);
    
    % threshold to judge if it is front or back (could be adjusted)
    FThreshold = 255 * 0.95;    % threshold of trimap foreground
    BThreshold = 255 * 0.05;    % bg
    
    % size of the picture
    width = size(oriImgMatrix, 1);
    height = size(oriImgMatrix, 2);
    
    
    %------------- End Variable -----------
    
    
    %------------- Begin Code --------------
    % 1. Convert Trimap Matrix from rgb to gray if needed
    
    % if trimap is not gray format, force it to gray format
    triMapMatrix_size = size(triMapMatrix);
    dimension = numel(triMapMatrix_size);
    if(dimension == 3)
        triMapMatrix = rgb2gray(triMapMatrix);
    end
    
    % 2. Iterate all the pixels and compare with threshold
    for b = 1:height
        for a = 1:width
            % classificate to F/B/U
            if triMapMatrix(a, b) >= FThreshold
                mbackImg(a, b, :) = 0;
                munknownImg(a, b, :) = 0;
            elseif triMapMatrix(a, b) <= BThreshold
                mfrontImg(a, b, :) = 0;
                munknownImg(a, b, :) = 0;
            else
                mbackImg(a, b, :) = 0;
                mfrontImg(a, b, :) = 0;
            end
        end
    end
    
    
    frontImg = mfrontImg;
    backImg = mbackImg;
    unknownImg = munknownImg;
%------------- End Code -----------

