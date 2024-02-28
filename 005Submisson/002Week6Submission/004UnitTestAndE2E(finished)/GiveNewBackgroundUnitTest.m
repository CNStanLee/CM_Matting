classdef GiveNewBackgroundUnitTest < matlab.unittest.TestCase

    methods (Test)

        function testBackGroundResult(testCase)
            load("BackInput", 'oriImg', "triMap", "unknownF", "unknownAlpha", ...
    "FThreshold", "BgPath");
            load("BackResult", "m_newBack");
            mm_newBack = GiveNewBackground(oriImg, triMap, unknownF, ...
    unknownAlpha, FThreshold, BgPath);
            % Add assertions here to validate the results
            verifyEqual(testCase, mm_newBack, m_newBack);


            figure('Name', 'testBackGroundResult');
            imshow(mm_newBack);
            fprintf('testBackGroundResult : need mannual check image part\n');


        end

    end
end