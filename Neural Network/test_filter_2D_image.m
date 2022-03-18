clear
clc

% Load image
MeRGB = imread("Me.JPG");
MeGREY = rgb2gray(MeRGB);

% Load filter
load("2coeff_filter_saved.mat");
LoD = filter(:,1);
HiD = filter(:,3);

% 2D Discrete Wavelet Transform 
[cA,cH,cV,cD] = dwt2(MeGREY,LoD,HiD);

cA = uint8(cA); 
cH = uint8(cH);
cV = uint8(cV);
cD = uint8(cD);

figure
subplot(2,3,1)
imshow(MeGREY)

subplot(2,3,2)
imshow(cA)

subplot(2,3,3)
imshow(cH)

subplot(2,3,4)
imshow(MeGREY)

subplot(2,3,5)
imshow(cV)

subplot(2,3,6)
imshow(cD)