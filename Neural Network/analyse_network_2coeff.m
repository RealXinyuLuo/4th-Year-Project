% Analyse


bits = 3;

image = mixedimages(1,32,30);

image = uniformquantization(image,bits);
image = image';

act = activations(net,image,'layer');   %DL matlab function. net: trained network, 'layer'. Act is a cell
act = cell2mat(act); % data structure converst from cell to matrix                %

LoD = act(1:2); % First half of output vector is decomp filter
LoR = act(3:4); % Second half is synthesis filter

HiD = LoR;   
HiD(1) = - HiD(1);    % LoR = [a b]', HiD = [-a, b]' 

HiR = LoD;
HiR(2) = -HiR(2);    % LoD = [a b]', HiR = [a, -b]'     

[cA,cD] = dwt(image,LoD,HiD);  %Discret wavelet transform, read about dwt first and then ask !
rec = idwt(cA,cD,LoR,HiR); % reconstructed image. IDWT spits out single. 
rec = double(rec); %This is the reconstructed signal, changing data type from single to double 


SSIM = ssim(rec,image); %The SSIM looks at how similair the reconstructed signal is to the original. 1 = perfect, 0 = terrible.

plot(rec)
hold on
plot(image)


