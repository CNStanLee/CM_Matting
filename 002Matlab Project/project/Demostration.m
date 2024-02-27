% Linted
% -------------------------------------------------
% Test FunPreProcess Function Unit Test (Partitial)
% -------------------------------------------------
clear;
close all;
clc;
% INPUT
oriImg = 'origin.png';
triMap = 'trimapOrigin.png';
BgPath = "WhiteBg.png";
Iteration = 10; % USER INPUT %
oriVar = 10;  % USER INPUT %


% Constant value
FThreshold = 255 * 0.95;


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
[Fmean, Bmean, coF, coB] = FunStatisticalAnalysis(frontImg, backImg);
disp(Fmean);
disp(Bmean);
%disp(coF);
%disp(coB);
% -------------------------------------------------
% Main matting session
% -------------------------------------------------
% INPUT
% user input Iteration times

[unknownAlpha, unknownF, unknownB] = Matting(unknownImg, ...
    triMap, coF, coB, Fmean, Bmean, oriVar, Iteration);

figure(1);
imshow(uint8(unknownAlpha * 255));

m_newBack = GiveNewBackground(oriImg, triMap, unknownF, ...
    unknownAlpha, FThreshold, BgPath);
% Display and save the result
figure(2);
imshow(uint8(m_newBack));

