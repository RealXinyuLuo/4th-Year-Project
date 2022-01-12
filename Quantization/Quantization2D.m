clear
clc

rgb = imread("Assets/Me.JPG");
grey = rgb2gray(rgb);
bits = 3;

% rand_row = randi(size(grey,1));
% grey_signal= greyßrand_row,:);        % Select a random row from the picture

quant_grey = grey();                % Create a copy of the input image 
for row = 1:size(grey,1)
    grey_signal = grey(row,:);
    signal = greynormalize(grey_signal);
    [quant,distor,levels,codebook]= uniformquantization(signal,bits);
    quant_grey(row,:) = greydenormalize(quant);
end

%% Plot
subplot(2,2,1)
imshow(grey)
subplot(2,2,2)
plot(grey_signal)
subplot(2,2,3)
imshow(quant_grey)




