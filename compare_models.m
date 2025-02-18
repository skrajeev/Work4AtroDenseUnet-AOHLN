%function [YPredHybrid, results] = compare_models(XTrain, XTest, YTrain, YTest)

   % Normalize using training data parameters
XTrain = normalize_data(XTrain);
XTest = normalize_data(XTest);



    % Convert labels to categorical for deep learning models
    YTrainCat = categorical(YTrain);
    
    % Auction Optimized Hybrid LSTM Network
%     [YPredHybrid, accHybrid] = train_hybrid_lstm(XTrain, XTest, YTrainCat, YTest);

    % SVM Model
    svmModel = fitcsvm(XTrain, YTrain);
    YPredSVM = predict(svmModel, XTest);
    accSVM = sum(YPredSVM == YTest) / numel(YTest);

    % KNN Model
    knnModel = fitcknn(XTrain, YTrain, 'NumNeighbors', 5);
    YPredKNN = predict(knnModel, XTest);
    accKNN = sum(YPredKNN == YTest) / numel(YTest);

    % Random Forest Model
    rfModel = TreeBagger(100, XTrain, YTrain, 'OOBPrediction', 'On', 'Method', 'classification');
    YPredRF = predict(rfModel, XTest);
    YPredRF = str2double(YPredRF);
    accRF = sum(YPredRF == YTest) / numel(YTest);

    % CNN Model
%     [YPredCNN, accCNN] = train_cnn(XTrain, XTest, YTrainCat, YTest);

    % LSTM Model
    [YPredLSTM, accLSTM] = train_lstm(XTrain, XTest, YTrainCat, YTest);

    % Compile results
    results = table({ 'SVM'; 'KNN'; 'Random Forest';  'LSTM'}, ...
                     [ accSVM; accKNN; accRF;  accLSTM], ...
                     'VariableNames', {'Model', 'Accuracy'});


function normalizedData = normalize_data(data)
    mindata = min(data(:));
    maxdata = max(data(:));
    normalizedData = (data - mindata) / (maxdata - mindata);
end

function [YPred, accuracy] = train_hybrid_lstm(XTrain, XTest, YTrain, YTest)
    inputSize = size(XTrain, 2);
    numHiddenUnits = 100;
    numClasses = 2;

    layers = [ ...
        sequenceInputLayer(inputSize)
        lstmLayer(numHiddenUnits, 'OutputMode', 'last')
        batchNormalizationLayer
        reluLayer
        dropoutLayer(0.6)
        fullyConnectedLayer(numHiddenUnits)
        fullyConnectedLayer(numHiddenUnits / 2)
        fullyConnectedLayer(numClasses)
        softmaxLayer
        classificationLayer];

    options = trainingOptions('adam', ...
        'InitialLearnRate', 1e-2, ...
        'MaxEpochs', 100, ...
        'MiniBatchSize', 32, ...
        'Shuffle', 'every-epoch', ...
        'Verbose', 0, ...
        'Plots', 'none');

    net = trainNetwork(num2cell(XTrain', 1)', YTrain, layers, options);

    % Auction-based optimization (mockup here, replace with actual implementation)
    tmp_net = net.saveobj;
    initial_weight = tmp_net.Layers(10).Weights;
    epsilon = 0.1;
    updated_weight = ABOA(initial_weight, epsilon);
    tmp_net.Layers(10).Weights = updated_weight;
    net = net.loadobj(tmp_net);

    YPred = classify(net, num2cell(XTest', 1)');
    accuracy = sum(YPred == categorical(YTest')) / numel(YTest);
end

function [YPred, accuracy] = train_cnn(XTrain, XTest, YTrain, YTest)
    inputSize = size(XTrain, 2);  % Number of features (sequence length)
    numClasses = 2;
    
    % Define the layers for 1D data
    layers = [
        sequenceInputLayer(inputSize)  % Use sequence input layer for 1D data
        convolution1dLayer(3, 8, 'Padding', 'same')  % 1D convolution layer
        batchNormalizationLayer
        reluLayer
        maxPooling1dLayer(2, 'Stride', 2)  % 1D max pooling layer
        fullyConnectedLayer(numClasses)
        softmaxLayer
        classificationLayer];

    options = trainingOptions('adam', ...
        'InitialLearnRate', 1e-3, ...
        'MaxEpochs', 30, ...
        'MiniBatchSize', 64, ...
        'Shuffle', 'every-epoch', ...
        'Verbose', 0, ...
        'Plots', 'none');

    % Reshape data for CNN (adjust input shape for sequence format)
    XTrainSeq = num2cell(XTrain', 1);  % Convert to cell array for sequence input
    XTestSeq = num2cell(XTest', 1);    % Convert to cell array for sequence input
    
    % Train the network
    net = trainNetwork(XTrainSeq, YTrain, layers, options);
    
    % Classify the test data
    YPred = classify(net, XTestSeq);
    accuracy = sum(YPred == categorical(YTest')) / numel(YTest);
end


function [YPred, accuracy] = train_lstm(XTrain, XTest, YTrain, YTest)
    inputSize = size(XTrain, 2);
    numHiddenUnits = 50;
    numClasses = 2;

    layers = [ ...
        sequenceInputLayer(inputSize)
        lstmLayer(numHiddenUnits, 'OutputMode', 'last')
        fullyConnectedLayer(numClasses)
        softmaxLayer
        classificationLayer];

    options = trainingOptions('adam', ...
        'InitialLearnRate', 1e-2, ...
        'MaxEpochs', 50, ...
        'MiniBatchSize', 64, ...
        'Shuffle', 'every-epoch', ...
        'Verbose', 0, ...
        'Plots', 'none');

    % Reshape for LSTM (sequence format)
    XTrainSeq = num2cell(XTrain', 1);
    XTestSeq = num2cell(XTest', 1);

    net = trainNetwork(XTrainSeq, YTrain, layers, options);
    YPred = classify(net, XTestSeq);
    accuracy = sum(YPred == categorical(YTest')) / numel(YTest);
end
