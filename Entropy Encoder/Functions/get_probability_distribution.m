function prob = get_probability_distribution(quantized_signal)
%Return the probability distribution of quantised siganl
%   quantized_signal: quantized signal 
%   prob: probability distribution of quantized signal 

    signal_length = length(quantized_signal);
    unique_symbols = unique(quantized_signal);  %array containing unique quantization levels
    num_symbols = numel(unique_symbols);        %the number of unique quantization levels seen in the signal
    
    count = zeros(num_symbols,1);               %array containing the occurance of each unique quantization level
    prob = zeros(num_symbols,1);                %array containing the discrete pdf of quantization levels 
    
    for i = 1:num_symbols
      count(i) = sum(quantized_signal==unique_symbols(i));
      prob(i) = count(i)/signal_length;
    end

end

