% Analyse whetehr th\\
% Input: Grounf Truth image 
% Ouput: 


a = mixedimages(1,32);
a = normalize(a,'range');
a = awgn(a,100);   %rand gaussian noise, 100 is SNR

act = activations(net,a,'layer');   %DL matlab function. net: trained network, 'layer'. Act is a cell
act = cell2mat(act); % data structure converst from cell to matrix                %

LoD = act(1:2); % First half of output vector is decomp filter
LoR = act(3:4); % Second half is synthesis filter

HiD = LoR;   
HiD(1) = - HiD(1);    % LoR = [a b]', HiD = [-a, b]' 

HiR = LoD;
HiR(2) = -HiR(2);    % LoD = [a b]', HiR = [a, -b]'     

[cA,cD] = dwt(a,LoD,HiD);  %Discret wavelet transform, read about dwt first and then ask !
rec = idwt(cA,cD,LoR,HiR); % reconstructed image. IDWT spits out single. 
rec = double(rec); %This is the reconstructed signal, changing data type from single to double 


SSIM = ssim(rec,a); %The SSIM looks at how similair the reconstructed signal is to the original. 1 = perfect, 0 = terrible.


