classdef FunPreProcessUnitTest < matlab.unittest.TestCase

    methods (Test)

        function testGeneratefrontImg(testCase)
            oriImg = 'origin.png';
            triMap = 'trimapOrigin.png';
            %targetImg = 'expected_front.jpg';
            [frontImg, backImg, unknownImg] = FunPreProcess(oriImg, triMap);
            % Add assertions here to validate the results
            expectedSize = size(imread(oriImg));
            verifyEqual(testCase, size(frontImg), expectedSize);
            imwrite(frontImg, 'front.jpg', 'jpg');
            %verifyEqual(testCase, frontImg, double(imread(targetImg)));
            fprintf('testGeneratefrontImg : need mannual check image part\n');
            %save("FunPreProcessData", 'frontImg', 'backImg', 'unknownImg');
        end

        function testGeneratebackImg(testCase)
            oriImg = 'origin.png';
            triMap = 'trimapOrigin.png';
            %targetImg = 'expected_back.jpg';
            [~, backImg, ~] = FunPreProcess(oriImg, triMap);
            % Add assertions here to validate the results
            expectedSize = size(imread(oriImg));
            verifyEqual(testCase, size(backImg), expectedSize);
            %verifyEqual(testCase, backImg, double(imread(targetImg)));
            imwrite(backImg, 'back.jpg', 'jpg');
            fprintf('testGeneratebackImg : need mannual check image part\n');
        end

        function testGenerateunknownImg(testCase)
            oriImg = 'origin.png';
            triMap = 'trimapOrigin.png';
            %targetImg = 'expected_unkown.jpg';
            [~, ~, unknownImg] = FunPreProcess(oriImg, triMap);
            % Add assertions here to validate the results
            expectedSize = size(imread(oriImg));
            verifyEqual(testCase, size(unknownImg), expectedSize);
            %verifyEqual(testCase, unknownImg, double(imread(targetImg)));
            imwrite(unknownImg, 'unkown.jpg', 'jpg');
            fprintf('testGenerateunknownImg : need mannual check image part\n');
        end

        function testGrayMapInput(testCase)
            oriImg = 'GT01.png';
            triMap = 'GT01_tri.png';
            %targetImg = 'expected_unkown.jpg';
            [~, ~, unknownImg] = FunPreProcess(oriImg, triMap);
            % Add assertions here to validate the results
            expectedSize = size(imread(oriImg));
            verifyEqual(testCase, size(unknownImg), expectedSize);
            %verifyEqual(testCase, unknownImg, double(imread(targetImg)));
        end
    end
end