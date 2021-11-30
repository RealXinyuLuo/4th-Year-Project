clc
clear


quantized_signal = [1,1,0,2,1];

[code,dict] = huffmanencoder(quantized_signal);
reconstructed_signal = huffmandeco(code,dict);
