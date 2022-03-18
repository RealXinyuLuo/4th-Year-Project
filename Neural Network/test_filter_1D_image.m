%% Load image
picRGB = imread("Balliol.JPG");
picREY = rgb2gray(picRGB);
rand_row = randi(size(picREY,1));
signal = picREY(400,:); 
signal = normalize(signal,'range');
bits = 5;
wavelet = 'haar';

%signal = image_generator(1,500,100,'square',true,true);

%% Load filter
load("2coeff_comb_filter_saved.mat");
LoD = filter(:,1);
LoR = filter(:,2);
HiD = filter(:,3);
HiR = filter(:,4);

%% 2D Discrete Wavelet Transform 
[cA,cD] = dwt(signal,LoD,HiD);
[cA1,cD1] = dwt(signal,wavelet);

%% Quantization
cA_quant = uniformquantization(cA,bits);
cD_quant = uniformquantization(cD,bits);

cA1_quant = uniformquantization(cA1,bits);
cD1_quant = uniformquantization(cD1,bits);


%% Reconstruction 

rec = idwt(cA_quant,cD_quant,LoR,HiR); 
rec1 = idwt(cA1_quant,cD1_quant,wavelet); 


%% Plotting 
figure

% first row
subplot(2,4,1)
imshow(picREY)
title('Grey Scale Image')

subplot(2,4,2)
plot(cA_quant)
title('Quantized cA (Custom Wavelet)')

subplot(2,4,3)
plot(cD_quant)
title('Quantized cD (Custom Wavelet)')

subplot(2,4,4)
plot(rec)
title('Reconstruction (Custom Wavelet)')


% second row 
subplot(2,4,5)
plot(rec)
title('1D Signal from Image')

subplot(2,4,6)
plot(cA1_quant)
title('Quantized cA (Haar Wavelet)')

subplot(2,4,7)
plot(cD1_quant)
title('Quantized cD (Haar Wavelet)')

subplot(2,4,8)
plot(rec1)
title('Reconstruction (Haar Wavelet)')

