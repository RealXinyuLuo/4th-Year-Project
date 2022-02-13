clear
clc

%%  Independent variables
training_samples = 12800;
sample_length = 34;
filternumber = 2; %2 for 2 coefficient network, 4 for 4 coefficient network
SNR = 30;
bits = 3;
type = 'sine';
isSNRuniform = true;
issingletype = false;   


image = image_generator(1,sample_length,SNR,type,isSNRuniform,issingletype);
image = uniformquantization(image,bits);
image = image';

%% Data storage
ds = image;
ds(end+1) = bits;

act = activations(net,ds,'layer');   %DL matlab function. net: trained network, 'layer'. Act is a cell
act = cell2mat(act); % data structure converst from cell to matrix                %

[LoD,LoR,HiD,HiR] = make2coeffwavelet(act);  

[cA,cD] = dwt(image,LoD,HiD);  %Discret wavelet transform, read about dwt first and then ask !
[cA1,cD1] = dwt(image,'bior4.4'); 

%% Quantization 
bits=8;
quantized_cA = uniformquantization(cA,bits)';
quantized_cD = uniformquantization(cD,bits)';
%% entropy encoding 
% [cA_code,dict_cA] = huffmanencoder(quantized_cA);
% [cD_code,dict_cD] = huffmanencoder(quantized_cD);
%% entropy decoding 
% reconstructed_cA = huffmandeco(cA_code,dict_cA);
% reconstructed_cA = reconstructed_cA';
% reconstructed_cD = huffmandeco(cD_code,dict_cD);
% reconstructed_cD = reconstructed_cD';

%% reconstruction
rec = idwt(quantized_cA,quantized_cD,LoR,HiR); % reconstructed image. IDWT spits out single. 
rec = double(rec); %This is the reconstructed signal, changing data type from single to double 


SSIM = ssim(rec,image); %The SSIM looks at how similair the reconstructed signal is to the original. 1 = perfect, 0 = terrible.

plot(rec)
hold on
plot(image)




