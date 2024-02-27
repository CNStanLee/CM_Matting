% Linted
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
figure(1);
imshow(oriImg);
figure(2);
imshow(triMap);
% DUT
[frontImg, backImg, unknownImg] = FunPreProcess(oriImg, triMap);
% BENCH
figure(3);
imshow([uint8(frontImg) uint8(backImg) uint8(unknownImg)]);
drawnow;
%% Test FunStatistical Analysis Unit Test (Partitial)
clear;
close all;
clc;
% INPUT
oriImg = 'origin.png';
triMap = 'trimapOrigin.png';
figure(4);
imshow(oriImg);
figure(5);
imshow(triMap);
[frontImg, backImg, unknownImg] = FunPreProcess(oriImg, triMap);
% DUT
[coF, coB] = FunStatisticalAnalysis(frontImg, backImg);
% BENCH
disp(coF);
disp(coB);

