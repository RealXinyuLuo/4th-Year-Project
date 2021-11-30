function quantized_signal = nonuniformquantization(signal,levels,intervals)
%Turning an input signal into a quantized signal.
%This implementation allows for variable quatization levels 
%and variable quantization intervals 
%   signal: the input signal
%   levels: the number of quantization levels
%   intervals: the number of time intervals 

signal_length = length(signal);

maximum = max(signal);           % Maximum value of the signal 
minimum = min(signal);           % Minimum value of the signal 


partition = linspace(1,signal_length,intervals);
codebook = linspace(minimum,maximum,levels);



[index,quants,distor] = quantiz(signal,partition,codebook); % Quantize.

quantized_signal = quants;

end






