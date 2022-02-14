
clear
clc

%%  Independent variables
training_samples = 12800;
sample_length = 34;
filternumber = 2; %2 for 2 coefficient network, 4 for 4 coefficient network
SNR = 30;
bits = 3;
type = 'sine';
isSNRuniform = true;
issingletype = false;   

%%  Dependent variables
nn_input_length = sample_length+1;  %neural network input includes image and bits

%%  Generating empty data storage
target_samples = cell(training_samples,1);
quantized_samples = cell(training_samples,1);
feature_vectors = cell(training_samples,1);
feature_vector = zeros(nn_input_length,1);

%%  Generating image data
images = image_generator(training_samples,sample_length,SNR,type,isSNRuniform,issingletype);

%%  Quantization of image data 
% for i = 1 : training_samples           % the number of columns in training data 
%     quantized_samples{i} = uniformquantization(target_samples{i},bits);   % Target/ ground truth 
% end

%%  Feature vectors 
for i = 1 : training_samples           % the number of columns in training data 
    target_samples{i} = images(:,i);   % Target/ ground truth

    feature_vector(1:sample_length) = images(:,i);  % start with image data
    feature_vector(end) = bits;                     % then quantization data

    feature_vectors{i} = feature_vector;   
end

%% Generating dummy response vector
dummyY = cell(training_samples,1);     % work-around to keep the program happy

for k = 1:size(dummyY,1)
    target_images = zeros(filternumber*2,1);  % so that dummyY has the same dimention as output layer 
                                              % we don't need it in this case 
    dummyY{k} = target_images;
end

responses = dummyY;
responses_size = size(responses,1);

%%  Defining layers
if filternumber == 2
    layers = [
    sequenceInputLayer(nn_input_length)  
    fullyConnectedLayer(10)
    reluLayer     % ML stuff, read 
    fullyConnectedLayer(10)
    reluLayer
    fullyConnectedLayer(filternumber*2)    %second last layer has to have the same dimention as the output layer 
    eluLayer      % ML stuff, read
    Wavelet2ReconstructionRegressionLayer(target_samples,bits)];

%   Wavelet2EntropyRegressionLayer()];

else
    layers = [
    sequenceInputLayer(nn_input_length)
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
%%  main 
net = trainNetwork(feature_vectors,responses,layers,options);
