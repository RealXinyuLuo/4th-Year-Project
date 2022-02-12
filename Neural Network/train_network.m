training_samples = 12800;
sample_length = 32;
filternumber = 2; %2 for 2 coefficient network, 4 for 4 coefficient network
SNR = 30;
bits = 3;

%%  Generating Target Training data 
target_signals = cell(training_samples,1);
quantized_signals = cell(training_samples,1);
%zero_signals = cell(training_samples,1);

images = mixedimages(training_samples, sample_length,SNR);
%zeros = zeros(sample_length,1);

%%  Signal 
for i = 1 : training_samples           % the number of columns in training data 
    target_signals{i} = images(:,i);   % Target/ ground truth 
end

%% Quantization 

for i = 1 : training_samples           % the number of columns in training data 
    quantized_signals{i} = uniformquantization(target_signals{i},bits);   % Target/ ground truth 
end
setGlobalImage(target_signals);        % Set training_set as global to be retrieved inside 
                                       % deep learning pipeline

%% Generating dummy ground truth (As training data is the ground truth
dummyY = cell(training_samples,1);     % work-around to keep the program happy
s = size(dummyY);

for k = 1:s(1)
    target_images = zeros(filternumber*2,1);  % so that dummyY has the same dimention as output layer 
                                              % we don't need it in this case 
    dummyY{k} = target_images;
end

%%  Defining layers
if filternumber == 2
    layers = [
    sequenceInputLayer([sample_length])  
    fullyConnectedLayer(10)
    reluLayer     % ML stuff, read 
    fullyConnectedLayer(10)
    reluLayer
    fullyConnectedLayer(filternumber*2)    %second last layer has to have the same dimention as the output layer 
    eluLayer      % ML stuff, read
    Wavelet2ReconstructionRegressionLayer()];

%   Wavelet2EntropyRegressionLayer()];

else
    layers = [
    sequenceInputLayer([sample_length])
    fullyConnectedLayer(32)
    reluLayer
    fullyConnectedLayer(10)
    reluLayer
    fullyConnectedLayer(10)
    reluLayer
    fullyConnectedLayer(filternumber*2)
    eluLayer
    Wavelet4ReconstructionRegressionLayer()];
end

%%  Defining training options
options = trainingOptions('sgdm','InitialLearnRate',0.03,'LearnRateSchedule','piecewise','MiniBatchSize',64,'LearnRateDropPeriod',1,'LearnRateDropFactor',0.2,'Momentum',0.9,'GradientThreshold',1,'L2Regularization',0.1,'MaxEpochs',2,'plots','training-progress');

%%  Defining feature vector 
feature = target_signals;
%%  Defining response vector
responses = dummyY;
%%  main 
net = trainNetwork(feature,responses,layers,options);


