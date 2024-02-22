% -------------------------------------------------
% Test FunPreProcess Function Unit Test (Partitial)
% -------------------------------------------------
clear;
close all;
clc;
% INPUT
oriImg = 'troll.png';
triMap = 'troll3.png';
BgPath = "whiteBg.png";
% figure;
% imshow(oriImg);
% figure;
% imshow(triMap);
% DUT
[frontImg, backImg, unknownImg] = FunPreProcess(oriImg, triMap);
% BENCH
% figure;
% imshow([uint8(frontImg) uint8(backImg) uint8(unknownImg)]);
% drawnow;
% -------------------------------------------------
% Test FunStatistical Analysis Unit Test (Partitial)
% -------------------------------------------------
[Fmean, Bmean, coF,coB] = FunStatisticalAnalysis(frontImg, backImg);
disp(Fmean);
disp(Bmean);
disp(coF);
disp(coB);
% -------------------------------------------------
% Main matting session
% -------------------------------------------------
% INPUT
% user input Iteration times
Iteration = 100; % USER INPUT %
oriVar    = 10;  % USER INPUT %
[unknownAlpha, unknownF, unknownB] = Matting(unknownImg, ...
    triMap, coF, coB, Fmean, Bmean, oriVar, Iteration);

figure,
imshow([uint8(unknownAlpha*255)]);
%%
close all;
mat_ori_Img = imread(oriImg);
figure;
imshow(mat_ori_Img);
figure;
imshow(unknownAlpha*255);
result = double(mat_ori_Img) .* unknownAlpha*255;
figure;
imshow(result);
figure;
imshow(unknownF);
%%
FThreshold =  255 * 0.95;
GiveNewBackground(oriImg, triMap, unknownF, unknownAlpha, FThreshold, BgPath);

