classdef MattingUnitTest < matlab.unittest.TestCase

    methods (Test)

        function testMattingResult(testCase)
            load("MattingInput", 'unknownImg', "triMap", "coF", "coB", ...
    "Fmean", "Bmean", "oriVar", "Iteration");
            load("MattingResult", 'unknownAlpha', "unknownF", "unknownB");
            [munknownAlpha, munknownF, munknownB] = Matting(unknownImg, ...
    triMap, coF, coB, Fmean, Bmean, oriVar, Iteration);
            % Add assertions here to validate the results
            verifyEqual(testCase, munknownAlpha, unknownAlpha);
            verifyEqual(testCase, munknownF, unknownF);
            verifyEqual(testCase, munknownB, unknownB);
        end

    end
end