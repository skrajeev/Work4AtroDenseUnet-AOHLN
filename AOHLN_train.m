function [YPred] = CNN_train(XTrain, XTest, YTrain, YTest)

XTrain1 = XTrain;
XTest1 = XTest;
YTrain1 = YTrain;

mindata = min(min(XTrain));
maxdata = max(max(XTrain));
normalised = ((XTrain-mindata)/((maxdata)-mindata));
XTrain = normalised;

mindata = min(min(XTest));
maxdata = max(max(XTest));
normal = ((XTest-mindata)/((maxdata)-mindata));
XTest = normal;

inputSize = size(XTrain, 2);
XTrain = num2cell(XTrain',1)';
YTrain=categorical(YTrain);

XTest = num2cell(XTest',1)';

numHiddenUnits = 100;
numClasses = 2;
%% Define Network Architecture
% Define the convolutional neural network architecture.

layers = [ ...
    sequenceInputLayer(inputSize)
    lstmLayer(numHiddenUnits,'OutputMode','last')
    batchNormalizationLayer
    reluLayer()
    batchNormalizationLayer
    reluLayer()
    batchNormalizationLayer
    reluLayer() 
    dropoutLayer(0.6)
    fullyConnectedLayer(numHiddenUnits)
    fullyConnectedLayer(numHiddenUnits/2)
    fullyConnectedLayer(numClasses)
    softmaxLayer 
    classificationLayer];

options = trainingOptions('adam',...
    'InitialLearnRate',1e-2,...
    'ValidationData',{XTrain,YTrain}, ...
    'ExecutionEnvironment','auto', ...
    'GradientThreshold',2, ...
    'LearnRateDropFactor',0.001,...
    'MaxEpochs',100, ...
    'MiniBatchSize',32, ...
    'Shuffle','every-epoch', ...
    'Verbose',0,...
    'Plots','none');

epsilon = 0.1;
net = trainNetwork(XTrain',YTrain,layers,options);
%% weight updation

tmp_net =  net.saveobj;
initial_weight = tmp_net.Layers(10).Weights;
updated_weight = ABOA(initial_weight, epsilon); % weight obtained by auction based optimization algorithm
tmp_net.Layers(10).Weights = updated_weight;
net = net.loadobj(tmp_net);

YPred = clasify(XTest1,XTrain1,YTrain1);
acc = sum(YPred == YTest')./numel(YTest);
end