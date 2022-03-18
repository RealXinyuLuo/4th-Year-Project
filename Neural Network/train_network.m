clear
clc

%%  Independent variables
training_samples = 12800;
sample_length = 128;
filternumber = 2; % 2 for 2 coefficient network,4 for 4 coefficient network
SNR = 100;
nn_bits = 5;      % Quantization of latent space happening inside the network
type = 'sine';
isSNRuniform = true;
issingletype = false;
isquantafeature = false;

%%  Dependent variables
if isquantafeature == true
    nn_input_length = sample_length+1; % neural network input includes image and bits
else
    nn_input_length = sample_length;
end
%%  Generating empty data storage
target_samples = cell(training_samples,1);
quantized_samples = cell(training_samples,1);
feature_vectors = cell(training_samples,1);
feature_vector = zeros(nn_input_length,1);

%%  Generating image data
images = image_generator(training_samples,sample_length,...
    SNR,type,isSNRuniform,issingletype);

%%  Feature vectors 
% deciding whether to include quantization level as an input
% controlleg by the 'isquantafeature' flag

if isquantafeature == true
    for i = 1 : training_samples         % the number of columns in training data 
        target_samples{i} = images(:,i); % Target/ ground truth   
        feature_vector(1:sample_length) = images(:,i); % start with image data
        feature_vector(end) = nn_bits;                 % then quantization data   
        feature_vectors{i} = feature_vector;   
    end

else
    for i = 1 : training_samples           % the number of columns in training data 
        target_samples{i} = images(:,i);   % Target/ ground truth
        feature_vector(1:sample_length) = images(:,i); % image data   
        feature_vectors{i} = feature_vector;   
    end
end
%% Generating dummy response vector
dummyY = cell(training_samples,1);  % work-around to keep the program happy

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
    fullyConnectedLayer(10,'WeightsInitializer','he')
    reluLayer('Name','relu1')  
    fullyConnectedLayer(10,'WeightsInitializer','he')
    reluLayer('Name','relu2')  
    fullyConnectedLayer(filternumber*2,'WeightsInitializer','he')
    eluLayer('Name','elu1') 

    Wavelet2CombinedLayer(target_samples,nn_bits,'2coeffcomb')];

    %Wavelet2ReconstructionRegressionLayer(target_samples,nn_bits,'2coeffrec')];

else
    layers = [
    sequenceInputLayer(nn_input_length)
    fullyConnectedLayer(32,'WeightsInitializer','he')
    reluLayer('Name','relu1')  
    fullyConnectedLayer(10,'WeightsInitializer','he')
    reluLayer('Name','relu2') 
    fullyConnectedLayer(10,'WeightsInitializer','he')
    reluLayer('Name','relu3')
    fullyConnectedLayer(filternumber*2,'WeightsInitializer','he')
    eluLayer('Name','elu1')  
    Wavelet4ReconstructionRegressionLayer(target_samples,nn_bits,'4coeffrec')];
end

%%  Defining training options
options = trainingOptions('sgdm','InitialLearnRate',0.0005,...
    'LearnRateSchedule','piecewise','MiniBatchSize',64,...
    'LearnRateDropPeriod',1,'LearnRateDropFactor',0.2,...
    'Momentum',0.9,'GradientThreshold',1,'L2Regularization',0.1,...
    'MaxEpochs',2,'plots','training-progress');

%%  Main 
net = trainNetwork(feature_vectors,responses,layers,options);
save('Project/net_saved.mat','net','-mat')
%%  Plotting a layer graph
%lgraph = layerGraph(layers);
%figure
%plot(lgraph)
