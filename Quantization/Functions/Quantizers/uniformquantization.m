function [quant,quantnoise,levels,codebook]=uniformquantization(signal,bits)
%Performs a uniform quantization on 1D signal
%Author: Xinyu Luo 
% signal: the original signal
% bits: number of bits used to quantize the signal (bit depth) 
% quant: quantized signal
% quantnoise: quantisation noise 
%% Defining variables 

maximum=max(signal);                % Maximum value 
minimum=min(signal);  
q=(maximum-minimum)/(2^bits);       % Quantization step-size 
quant = zeros(1,length(signal));    % Pre-allocating memory space
%% Performing quantization
for i =1: length(signal) 
    if round(signal(i)*2^(bits-1))/(2^(bits-1)) == 0
        quant(i)= round(signal(i)*2^(bits-1))/(2^(bits-1));
    else
        quant(i)= round(signal(i)*2^(bits-1))/(2^(bits-1))-sign(signal(i))*q/2;
    end
end
%% Calculating unique levels
codebook = unique(quant);  % Capture the unique values in quant
levels = length(codebook); % Calculate the num of unique levels 
%% Calculating MS error 
quantnoise = mean((signal-quant).^2);      
end  
