
signal_length = 100;
data_points = 1000;
bits = 4;
%images = mixedimages(1,signal_length,30);
ratios30 = zeros(data_points,1);
lengths = zeros(data_points,1);

%Uniform Quantization
for i = 1:length(ratios30)
    images = single_type_images(1,signal_length,30,'sine');
    signal = images(:,1);
    [quant,distor,levels,initcodebook]= uniformquantization(signal,bits);
    signal_entropy = entropy(signal);
    quant_entropy = entropy(quant);
    ratios30(i) = quant_entropy/signal_entropy;
    lengths(i) = signal_length;
    signal_length = signal_length + 100;
end


xlabel('Signal length')
ylabel('Entropy reduction ratio')
%title('Variantion of Entropy Reduction Ratio to Square Wave Signal Size')


%training_set = signal;

%Optimization 
% [partition2,codebook2] = lloyds(training_set,initcodebook);
% [index2,quant2,distor2] = quantiz(signal,partition2,codebook2);
% hold on
% plot(quant2,".")




%quant_entropy2 = entropy(quant2);





