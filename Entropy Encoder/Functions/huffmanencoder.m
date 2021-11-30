function [code,dict] = huffmanencoder(quantized_signal)
%Entropy encoder using huffman encoding 
%   quantized_signal: siganl to be huffman encoded 
%   code: output binary code
%   dict: dictionary mapping signal elements to huffman codes
    
    prob = get_probability_distribution(quantized_signal);
    symbols = unique(quantized_signal);
    [dict,avglen] = huffmandict(symbols,prob);  %Matlab function
    code = huffmanenco(quantized_signal,dict);  %Matlab function
end