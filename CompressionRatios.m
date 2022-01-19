% Investigate the relationship between compression ratios and signal lengths
% Currently with Huffman encoding

clear
clc

signal_number = 1;
signal_length = 2;
SNR = 80;
type = 'sine';
bits = 4;             % Number of bits used for quantization 

datapoints = 800;     % Number of different signal lengths to try

compression_ratios = zeros(datapoints,1);
signal_lengths = zeros(datapoints,1);



for i = 1:1:datapoints
    signal = single_type_images(signal_number,signal_length,SNR,type);

    % Quantization
    [quantized_signal,quantnoise,levels,codebook]=uniformquantization(signal,bits);
    
    % Entropy encoding 
    [signal_code,signal_dict] = huffmanencoder(signal);
    [quant_code,qunat_dict] = huffmanencoder(quantized_signal);

    signal_lengths(i,1) = signal_length;
    compression_ratios(i,1) = length(quant_code)/length(signal_code);

    signal_length = signal_length + 1;

    fprintf('Signal Length %i\n',signal_length)

end

hold on
plot(signal_lengths,compression_ratios)
xlim([0 1050])


