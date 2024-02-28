% Unit Test
% Unit Test for FunPreProcess
% Changhong Li
% 2024/02/27
% -------------------------------------------------
% Clear WorkSpace
% -------------------------------------------------
clc;
clear;
close all;
% -------------------------------------------------
% Unit Test FunPreProcessUnitTest
% -------------------------------------------------
result = run(FunPreProcessUnitTest);
% -------------------------------------------------
% Unit Test FunStatisticalAnalysis
% -------------------------------------------------
result2 = run(FunStatisticalAnalysisUnitTest);
% -------------------------------------------------
% Unit Test FunStatisticalAnalysis
% -------------------------------------------------
result3 = run(MattingUnitTest);
% -------------------------------------------------
% Unit Test FunStatisticalAnalysis
% -------------------------------------------------
result4 = run(GiveNewBackgroundUnitTest);
