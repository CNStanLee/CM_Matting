classdef FunStatisticalAnalysisUnitTest < matlab.unittest.TestCase

    methods (Test)

        function testFSAFmean(testCase)
            load("FunPreProcessData.mat","frontImg", "backImg");
            load("FSATruth", 'Fmean');
            [mFmean, ~, ~, ~] = FunStatisticalAnalysis(frontImg, ...
    backImg);
            % Add assertions here to validate the results
            verifyEqual(testCase, mFmean, Fmean);            
        end
        
        function testFSABmean(testCase)
            load("FunPreProcessData.mat","frontImg", "backImg");
            load("FSATruth", 'Bmean');
            [~, mBmean, ~, ~] = FunStatisticalAnalysis(frontImg, ...
    backImg);
            % Add assertions here to validate the results
            verifyEqual(testCase, mBmean, Bmean);            
        end

        function testFSAcoF(testCase)
            load("FunPreProcessData.mat","frontImg", "backImg");
            load("FSATruth", 'coF');
            [~, ~, mcoF, ~] = FunStatisticalAnalysis(frontImg, ...
    backImg);
            % Add assertions here to validate the results
            verifyEqual(testCase, mcoF, coF);            
        end

        function testFSAcoB(testCase)
            load("FunPreProcessData.mat","frontImg", "backImg");
            load("FSATruth", 'coB');
            [~, ~, ~, mcoB] = FunStatisticalAnalysis(frontImg, ...
    backImg);
            % Add assertions here to validate the results
            verifyEqual(testCase, mcoB, coB);            
        end

    end
end