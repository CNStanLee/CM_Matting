clear;
close all;
clc;
%% Test FunPreProcess Function Unit Test (Partitial)
clear;
close all;
clc;
% INPUT
oriImg = 'origin.png';
triMap = 'trimapOrigin.png';
figure;
imshow(oriImg);
figure;
imshow(triMap);
% DUT
[frontImg, backImg, unknownImg] = FunPreProcess(oriImg, triMap);
% BENCH
figure;
imshow([uint8(frontImg) uint8(backImg) uint8(unknownImg)]);
drawnow;
%% Test FunStatistical Analysis Unit Test (Partitial)
clear;
close all;
clc;
% INPUT
oriImg = 'origin.png';
triMap = 'trimapOrigin.png';
figure;
imshow(oriImg);
figure;
imshow(triMap);
[frontImg, backImg, unknownImg] = FunPreProcess(oriImg, triMap);
% DUT
[coF,coB] = FunStatisticalAnalysis(frontImg, backImg);
% BENCH
disp(coF);
disp(coB);

