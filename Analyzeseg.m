function img = Analyzeseg(originalImage, lowThreshold, highThreshold)
fontSize = 17;
binaryImage = (originalImage >= lowThreshold) & (originalImage <= highThreshold);
binaryImage = imfill(binaryImage, 'holes');
[labeledImage, numberOfBlobs] = bwlabel(binaryImage, 8);
coloredLabels = label2rgb (labeledImage, 'hsv', 'k', 'shuffle');
% figure, imshow(binaryImage);

biggestBlob = bwareafilt(binaryImage, 1);
img = binaryImage;
img(~biggestBlob) = false;