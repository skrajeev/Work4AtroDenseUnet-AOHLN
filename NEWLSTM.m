% Load data from Features.mat
% Load the .mat file
data = load('Features.mat'); % This file should contain XTrain, XTest, YTrain, YTest
% Assuming the matrix is stored in the variable 'features' in the .mat file
features = data.Features;

% Separate features (X) and labels (y)
X = features(:, 1:end-1);  % All rows, first 15 columns (features)
y = features(:, end);      % All rows, last column (class label)

% Split the data into training and testing sets (80% training, 20% testing)
cv = cvpartition(size(features, 1), 'HoldOut', 0.2);  % 80% training, 20% testing

% Create training and testing datasets
XTrain = X(training(cv), :);
XTest = X(test(cv), :);
YTrain = y(training(cv));
YTest = y(test(cv));

% Now you have:
% X_train - training features
% X_test - testing features
% y_train - training labels
% y_test - testing labels
% Normalize the data
XTrain = normalize_data(XTrain);
XTest = normalize_data(XTest);

% Convert labels to categorical for deep learning models
YTrainCat = categorical(YTrain);
YTestCat = categorical(YTest);

% Define LSTM model
inputSize = size(XTrain, 2);  % Number of features (input size)
numHiddenUnits = 50;          % Number of hidden units in LSTM layer
numClasses = numel(categories(YTrainCat));  % Number of classes

% Define LSTM network architecture
layers = [
    sequenceInputLayer(inputSize)  % LSTM expects sequence data
    lstmLayer(numHiddenUnits, 'OutputMode', 'last')  % LSTM layer
    fullyConnectedLayer(numClasses)  % Fully connected layer for classification
    softmaxLayer  % Softmax activation for multi-class classification
    classificationLayer  % Classification layer
];

% Define training options
options = trainingOptions('adam', ...
    'InitialLearnRate', 1e-2, ...
    'MaxEpochs', 50, ...
    'MiniBatchSize', 64, ...
    'Shuffle', 'every-epoch', ...
    'Verbose', 0, ...
    'Plots', 'none');

% Convert data to cell format for LSTM
XTrainSeq = num2cell(XTrain', 1);  % Transpose and convert to cell array
XTestSeq = num2cell(XTest', 1);    % Transpose and convert to cell array

% Train the LSTM network
net = trainNetwork(XTrainSeq, YTrainCat, layers, options);

% Test the model
YPred = classify(net, XTestSeq);
accuracy = sum(YPred == YTestCat) / numel(YTestCat);

% Display results
fprintf('LSTM Classification Accuracy: %.4f\n', accuracy);

% Helper function to normalize data
function normalizedData = normalize_data(data)
    minData = min(data(:));
    maxData = max(data(:));
    normalizedData = (data - minData) / (maxData - minData);  % Min-Max Normalization
end
