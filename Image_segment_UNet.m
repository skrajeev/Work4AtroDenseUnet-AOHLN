function img = Image_segment_UNet(originalImage)
patchSize = [132 132 132];
numChannels = 4;
inputPatchSize = [patchSize numChannels];
numClasses = 2;
[lgraph,outPatchSize] = unet3dLayers(inputPatchSize,numClasses,ConvolutionPadding="valid");
outputLayer = dicePixelClassificationLayer(Name="Output");
lgraph = replaceLayer(lgraph,"Segmentation-Layer",outputLayer);
inputLayer = image3dInputLayer(inputPatchSize,Normalization="none",Name="ImageInputLayer");
lgraph = replaceLayer(lgraph,"ImageInputLayer",inputLayer);
MiniBatchSize=32;
options = trainingOptions("adam", ...
    MaxEpochs=50, ...
    InitialLearnRate=5e-4, ...
    LearnRateSchedule="piecewise", ...
    LearnRateDropPeriod=5, ...
    LearnRateDropFactor=0.95, ...
    ValidationFrequency=400, ...
    Plots="training-progress", ...
    Verbose=false, ...
    MiniBatchSize=32);

    inputPatchSize = [132 132 132 4];
    outPatchSize = [44 44 44 2];
    classNames = ["background","tumor"];
    pixelLabelID = [0 1];
%     [net,info] = trainNetwork(dsTrain,lgraph,options);
    
figure,
imshow(originalImage,[]);

% Now analyze the image to find blobs in three different intensity ranges.
img = AnalyzeImage(originalImage, 0.69, 0.8);
% figure,
% imshow(originalImage, [])

return;
function img = AnalyzeImage(originalImage, lowThreshold, highThreshold)
fontSize = 17;
binaryImage = (originalImage >= lowThreshold) & (originalImage <= highThreshold);
binaryImage = imfill(binaryImage, 'holes');
[labeledImage, numberOfBlobs] = bwlabel(binaryImage, 8);
coloredLabels = label2rgb (labeledImage, 'hsv', 'k', 'shuffle');
% figure, imshow(binaryImage);

biggestBlob = bwareafilt(binaryImage, 1);
img = binaryImage;
img(~biggestBlob) = false; 
return;