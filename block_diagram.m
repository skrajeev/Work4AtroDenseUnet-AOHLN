% Define Network Layers
inputSize = size(XTrain, 2);
numHiddenUnits = 100;
numClasses = 2;

% Create layers
layers = [
    sequenceInputLayer(inputSize, 'Name', 'Input')
    lstmLayer(numHiddenUnits, 'OutputMode', 'last', 'Name', 'LSTM')
    batchNormalizationLayer('Name', 'BatchNorm1')
    reluLayer('Name', 'ReLU1')
    batchNormalizationLayer('Name', 'BatchNorm2')
    reluLayer('Name', 'ReLU2')
    batchNormalizationLayer('Name', 'BatchNorm3')
    reluLayer('Name', 'ReLU3')
    dropoutLayer(0.6, 'Name', 'Dropout')
    fullyConnectedLayer(numHiddenUnits, 'Name', 'FC1')
    fullyConnectedLayer(numHiddenUnits/2, 'Name', 'FC2')
    fullyConnectedLayer(numClasses, 'Name', 'FC3')
    softmaxLayer('Name', 'Softmax')
    classificationLayer('Name', 'Output')];

% Convert to a Layer Graph
lgraph = layerGraph(layers);

% Visualize the Network
figure;
plot(lgraph);
title('AOHLN Architecture with Auction Optimization');

% Add annotation for ABOA
annotation('textbox', [0.5, 0.8, 0.1, 0.1], 'String', 'Auction Optimization', ...
    'EdgeColor', 'none', 'FontSize', 12, 'FontWeight', 'bold', 'Color', 'red');
