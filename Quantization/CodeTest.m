% Fs=100000;
% Ts=1/Fs;
% f=5000;
% n=0:Ts:(4/f);
% y=sin(2*pi*f*n);



signal_length = 10000;

images = mixedimages1(1, signal_length);

L = 3;
signal = images(:,1);

[quant,quantnoise]= uniformquantization(signal,L);



% plot(quant)
% hold on
% plot(signal)

legend('Original signal','Quantized signal');