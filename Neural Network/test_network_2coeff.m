
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

%% Dependent variables
net_saved = load("Trained Networks/2coeff_comb_net_saved.mat");
net = net_saved.net;
layer = net.Layers(8).Name;

image = image_generator(1,sample_length,SNR,type,isSNRuniform,issingletype);

%% Data storage
if isquantafeature == true
    ds = image;
    ds(end+1) = nn_bits;
else
    ds = image;
end

%% Activation
act = activations(net_saved.net,ds,layer);  
act = cell2mat(act); % data structure converst from cell to matrix               


%% Make Wavelet
[LoD,LoR,HiD,HiR] = make2coeffwavelet(act);

% Save the filter
filter = [LoD,LoR,HiD,HiR];   
save('Project/2coeff_comb_filter_saved.mat','filter','-mat')

[cA,cD] = dwt(image,LoD,HiD);  % Discret wavelet transform

cA_entropy = entropy(double(cA));
cD_entropy = entropy(double(cD));

%% Quantization 
cA_quant = uniformquantization(cA,nn_bits)';
cD_quant = uniformquantization(cD,nn_bits)';

cA_quant_entropy = entropy(double(cA_quant));
cD_quant_entropy = entropy(double(cD_quant));

% %% Entropy encoding 
% [cA_code,dict_cA] = huffmanencoder(quantized_cA);
% [cD_code,dict_cD] = huffmanencoder(quantized_cD);
% 
% % Entropy decoding 
% reconstructed_cA = huffmandeco(cA_code,dict_cA);
% reconstructed_cA = reconstructed_cA';
% reconstructed_cD = huffmandeco(cD_code,dict_cD);
% reconstructed_cD = reconstructed_cD';

%% Reconstruction
rec = idwt(cA_quant,cD_quant,LoR,HiR); % reconstructed image. IDWT spits out single. 
rec = double(rec); %This is the reconstructed signal, changing data type from single to double 

SSIM = ssim(rec,image); %The SSIM looks at how similair the reconstructed signal is to the original. 1 = perfect, 0 = terrible.

plot(image)
hold on
plot(rec)
legend('image','rec')


