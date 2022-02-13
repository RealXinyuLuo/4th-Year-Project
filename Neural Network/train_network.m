%%  Independent variables
training_samples = 12800;
sample_length = 34;
filternumber = 2; %2 for 2 coefficient network, 4 for 4 coefficient network
SNR = 30;
bits = 3;

%%  Dependent variables
nn_input_length = sample_length+1;


%%  Generating data storage
target_samples = cell(training_samples,1);
quantized_samples = cell(training_samples,1);
feature_vectors  = cell(training_samples,1);


%%  Generating image data
images = mixedimages(training_samples, sample_length,SNR);

%%  Quantization of image data 

for i = 1 : training_samples           % the number of columns in training data 
    quantized_samples{i} = uniformquantization(target_samples{i},bits);   % Target/ ground truth 
end

%%  Feature vectors 
for i = 1 : training_samples           % the number of columns in training data 
    target_samples{i} = images(:,i);   % Target/ ground truth

    feature_vector = images(:,i);
    feature_vector(end+1) = bits;

    feature_vectors{i} = feature_vector;
    
end

%% Quantization 

setGlobalImage(target_samples);        % Set training_set as global to be retrieved inside 
                                       % deep learning pipeline

%%  Load feature vector 
% into cell


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
    sequenceInputLayer([nn_input_length])  
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
    sequenceInputLayer([nn_input_length])
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
