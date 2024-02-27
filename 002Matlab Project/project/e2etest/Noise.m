

originalImage = imread('E:\CM_Matting\002Matlab Project\project\e2etest\high\GT05_tri2.png'); 
noisyImage = imnoise(originalImage, 'gaussian', 0, 0.05);

imshow(noisyImage);
outputFileName = 'E:\CM_Matting\002Matlab Project\project\e2etest\Noise\Noise_tri_Fig1.jpg';
imwrite(noisyImage, outputFileName);