%%  Independent variables
training_samples = 12800;
sample_length = 128;
filternumber = 2; %2 for 2 coefficient network, 4 for 4 coefficient network
SNR = 100;
bits = 10;
nn_bits = 5;
type = 'sine';
isSNRuniform = true;
issingletype = false;
isquantafeature = false;


image = image_generator(1,sample_length,SNR,type,isSNRuniform,issingletype);

%% Data storage
if isquantafeature == true
    ds = image;
    ds(end+1) = nn_bits;
else
    ds = image;
end

%%
act = activations(net,ds,'Wavelet4ReconstructionRegressionLayer');   
act = cell2mat(act); % data structure converst from cell to matrix                %




%% Make Wavelet
[LoD,LoR,HiD,HiR] = make4coeffwavelet(act);

[cA,cD] = dwt(image,LoD,HiD);  

cA_entropy = entropy(double(cA));
cD_entropy = entropy(double(cD));

%% Quantization 
cA_quant = uniformquantization(cA,nn_bits)';
cD_quant = uniformquantization(cD,nn_bits)';

cA_quant_entropy = entropy(double(cA_quant));
cD_quant_entropy = entropy(double(cD_quant));

%% Reconstruction
rec = idwt(cA_quant,cD_quant,LoR,HiR); % reconstructed image. IDWT spits out single. 
rec = double(rec); %This is the reconstructed signal, changing data type from single to double 

SSIM = ssim(rec,image); %The SSIM looks at how similair the reconstructed signal is to the original. 1 = perfect, 0 = terrible.

plot(image)
hold on
plot(rec)
legend('image','rec')


