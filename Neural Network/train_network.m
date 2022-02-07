training_samples = 12800;
sample_length = 32;
filternumber = 2; %2 for 2 coefficient network, 4 for 4 coefficient network
SNR = 30;
bits = 3;


%%  Generating Target Training data 
target_signals = cell(training_samples,1);
quantized_signals = cell(training_samples,1);
images = mixedimages(12800, sample_length,SNR);


%% Quantization
for i = 1 : training_samples % the number of columns in training data 
    target_signals{i} = images(:,i); % Target/ ground truth 
    [quant,quantnoise] = uniformquantization(images(:,i),bits);
    quantized_signals{i} = quant';       % dimention switch to fit my code to Justin's code
end

setGlobalImage(quantized_signals); % Set training_et as global to be retrieved inside 
                              % deep learning pipeline

%% Generating dummy ground truth (As training data is the ground truth
dummyY = cell(training_samples,1);   % work-around to keep the program happy
s = size(dummyY);

for k = 1:s(1)
    target_images = zeros(filternumber*2,1);  % so that dummyY has the same dimention as output layer 
                                  % we don't need it in this case 
    dummyY{k} = target_images;
end

% Defining layers
if filternumber == 2
    layers = [
    sequenceInputLayer([sample_length])  %
    fullyConnectedLayer(10)
    reluLayer     % ML stuff, read. 
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

% Defining training options
options = trainingOptions('sgdm','InitialLearnRate',0.03,'LearnRateSchedule','piecewise','LearnRateDropPeriod',1,'LearnRateDropFactor',0.2,'Momentum',0.9,'GradientThreshold',1,'L2Regularization',0.1,'MaxEpochs',2,'plots','training-progress');

% main 
net = trainNetwork(target_signals,dummyY,layers,options);

%% Defining layers
if filternumber == 2
    layers = [
    sequenceInputLayer(sample_length)  %
    fullyConnectedLayer(10)
    reluLayer     % ML stuff, read. 
    fullyConnectedLayer(10)
    reluLayer
    fullyConnectedLayer(filternumber*2)    %second last layer has to have the same dimention as the output layer 
    eluLayer      % ML stuff, read
    Wavelet2ReconstructionRegressionLayer('Wavelet2')];
 
else
    layers = [
    sequenceInputLayer(sample_length)
    fullyConnectedLayer(32)
    reluLayer
    fullyConnectedLayer(10)
    reluLayer
    fullyConnectedLayer(10)
    reluLayer
    fullyConnectedLayer(filternumber*2)
    eluLayer
    Wavelet4ReconstructionRegressionLayer('Wavelet4')];
end

%% Defining training options
options = trainingOptions('sgdm','InitialLearnRate',0.03,'LearnRateSchedule','piecewise','LearnRateDropPeriod',1,'LearnRateDropFactor',0.2,'Momentum',0.9,'GradientThreshold',1,'L2Regularization',0.1,'MaxEpochs',2,'plots','training-progress');

% main 
net = trainNetwork(quantized_signals,dummyY,layers,options);




