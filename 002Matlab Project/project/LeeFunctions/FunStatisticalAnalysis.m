function [coF,coB] = FunStatisticalAnalysis(frontImg, backImg)

% FunStatisticalAnalysis
% This function is used for get the mean value and then Covariance Matrix
% MainProcess:

% Inputs:
% 1.frontImg(double matrix, (x, y, channel)) - front Img matrix
% 2.backImg(double matrix, (x, y, channel)) - back Img matrix
% (* drop not used *)3.unkownImg(double matrix, (x, y, channel)) - unkown Img matrix
% Outputs:
% 1. coF(double matrix, 3x3) - Covariance of front
% 2. coB(double matrix, 3x3) - Covariance of back
% Author: ChanghongLi

%------------- Begin Variable --------------
% Revision:
% 0.0 : 2024/02/21 :  First Create : Changhong Lee

%------------- Begin Variable --------------

width = size(frontImg,1);
height = size(frontImg,2);
numFront = 0;
numBack = 0;

%------------- End Variable ----------------
Fmean = [0,0,0] ;
Bmean = [0,0,0] ;

%------------- Begin Code ------------------

% 1.Compute the mean value
mcoF = [0 0 0;0 0 0;0 0 0];
mcoB = [0 0 0;0 0 0;0 0 0];
% Compute the mean value 

for i = 1:3
    Fmean(i) = mean(frontImg(frontImg(:,:,i) > 0), 'all');
    Bmean(i) = mean(backImg(backImg(:,:,i) > 0), 'all');
end

% 2. Compute the Covariance

 for b=1:height
     for a=1:width
        if any(frontImg(a,b,:))
            shiftF = [ (frontImg(a,b,1)-Fmean(1))  
                (frontImg(a,b,2)-Fmean(2))  
                (frontImg(a,b,3)-Fmean(3)) ];
            mcoF = mcoF +(shiftF' * shiftF);
            numFront = numFront +1;
        end
        if any(backImg(a,b,:))
            shiftB = [ (backImg(a,b,1)-Bmean(1))  
                (backImg(a,b,2)-Bmean(2))  
                (backImg(a,b,3)-Bmean(3)) ];
            mcoB = mcoB + (shiftB' * shiftB);     
            numBack = numBack +1;
        end  
     end
  end

% Normalize covariance matrices
coF = mcoF / numFront;
coB = mcoB / numBack;

%------------- End Code --------------------
