% Demo alpha, C -> F, B
% clear all data
clc;
clear;
close all;

load('EstimateFB_Inputs_Iter1_Pos(38,364).mat');

[F, B] = EstimateFB(a, b, alpha, invcoF, invcoB, oriVar, ...
    Fmean, Bmean, unknownImg);

fprintf("F = \n");
disp(F);
fprintf("B = \n");
disp(B);
%
% Demo F, B, -> alpha
% clear all data
% clc;
% clear;
% close all;

load('CalculateAlpha_Inputs_Iter1_Pos(38,364).mat');

C = currentPixel;
F = tempF;
B = tempB;

alpha = CalculateAlpha(C, F, B);
fprintf("Alpha = %f\n", alpha);