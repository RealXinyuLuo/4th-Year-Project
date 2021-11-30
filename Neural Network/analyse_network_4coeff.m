a = mixedimages(1,32);
a = normalize(a,'range');
a = awgn(a,100);

act = activations(recon_net_4coeff,a,'layer'); %specify network name here
act = cell2mat(act);

LoD = act(1:4); % First half of output vector is decomp filter
LoR = act(5:8); % Second half is synthesis filter

HiD = LoR;
HiD(1) = - HiD(1);
HiD(3) = - HiD(3);
HiR = LoD;
HiR(2) = -HiR(2);
HiR(4) = -HiR(4);

[cA,cD] = dwt(a,LoD,HiD);
rec = idwt(cA,cD,LoR,HiR);
rec = double(rec); %This is the reconstructed signal
SSIM = ssim(rec,a); %The SSIM looks at how similair the reconstructed signal is to the original. 1 = perfect, 0 = terrible.