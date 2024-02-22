function [Fmean, Bmean, coF,coB] = FunStatisticalAnalysis(frontImg, backImg)

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
% 3. Fmean(double matrix, 1x3) - mean value of foreground
% 4. Bmean(double matrix, 1x3) - mean value of background
% Author: ChanghongLi

%------------- Begin Variable --------------
% Revision:
% 0.0 : 2024/02/21 :  First Create : Changhong Lee

%------------- Begin Variable --------------

width = size(frontImg,1);
height = size(frontImg,2);
numFront = 0;
numBack = 0;
NF = 0;
NB = 0;

%------------- End Variable ----------------
mFmean = [0,0,0] ;
mBmean = [0,0,0] ;

%------------- Begin Code ------------------

% 1.Compute the mean value
mcoF = [0 0 0;0 0 0;0 0 0];
mcoB = [0 0 0;0 0 0;0 0 0];
% Compute the mean value 




for i=1:3
   temp = frontImg(:,:,i);
   mFmean(i) =mean(temp(find(temp)));  
   temp = backImg(:,:,i);
   mBmean(i) = mean(temp(find(temp)));
end




%for i = 1:3
%    mFmean(i) = mean(frontImg(frontImg(:,:,i) > 0), 'all');
%    mBmean(i) = mean(backImg(backImg(:,:,i) > 0), 'all');
%end

% 2. Compute the Covariance

 %for b=1:height
 %    for a=1:width
 %       if any(frontImg(a,b,:))
 %           shiftF = [ (frontImg(a,b,1)-mFmean(1))  
 %               (frontImg(a,b,2)-mFmean(2))  
 %               (frontImg(a,b,3)-mFmean(3)) ];
 %           mcoF = mcoF +(shiftF' * shiftF);
 %           numFront = numFront +1;
 %       end
 %       if any(backImg(a,b,:))
 %           shiftB = [ (backImg(a,b,1)-mBmean(1))  
 %               (backImg(a,b,2)-mBmean(2))  
 %               (backImg(a,b,3)-mBmean(3)) ];
 %           mcoB = mcoB + (shiftB' * shiftB);     
 %           numBack = numBack +1;
 %       end  
 %    end
 % end
  for b=1:height,
     for a=1:width,
        
        if any(frontImg(a,b,:)),
            shiftF = [ (frontImg(a,b,1)-mFmean(1))  (frontImg(a,b,2)-mFmean(2))  (frontImg(a,b,3)-mFmean(3)) ];
            mcoF = mcoF +(shiftF' * shiftF);
            NF = NF +1;
        end
        if any(backImg(a,b,:)),
            shiftB = [ (backImg(a,b,1)-mBmean(1))  (backImg(a,b,2)-mBmean(2))  (backImg(a,b,3)-mBmean(3)) ];
            mcoB = mcoB + (shiftB' * shiftB);     
            NB = NB +1;
        end
           
     end
  end

% Normalize covariance matrices
% coF = mcoF / numFront;
% coB = mcoB / numBack;
 coF = mcoF / NF;
 coB = mcoB / NB;
 temp = 0;


Fmean = mFmean;
Bmean = mBmean;


%------------- End Code --------------------
