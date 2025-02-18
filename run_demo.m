 warning off;
clear all;
close all;
clc;
%% getting test image
[filename pathname ] = uigetfile('*.*');
fullFileName = fullfile(pathname, filename);
test_Image = niftiread(fullFileName);
test_Image=uint8(test_Image(:,:,round(end/2)));
figure,imshow(test_Image);title('Input image')
J = filtering(test_Image);% adaptive homomorphic wavelet filter
figure,imshow(J);title('Pre Processed Image')

% GLCM features
out = GLCM(J);
% kirsch edge detector (ked)
ked = KED(J);

meanIntensity = mean(ked(:));
SD = std(ked(:));
Fea=real([out.contr, out.energ, out.sosvh, out.entro, out.homop, out.savgh, out.senth, out.svarh, out.denth, out.dvarh, out.inf1h, out.inf2h, out.corrp, meanIntensity, SD]);

Test_feature = real([Fea]);
%%
load('Feature_dataset0.mat');
Features=FEATURES;
out = Features(all(~isnan(Features),2),:);
feat = out(:,1:15);
label = out(:,16);
%% feature selection

opts.N  = 10;     % number of solutions
opts.T  = 100;    % maximum number of iterations
% Number of k in K-nearest neighbor
opts.k = 5;
ho =0.3;
% Parameters of PSO
opts.c1 = 2;
opts.c2 = 2;
opts.w  = 0.9;

% Divide data into training and validation sets
HO = cvpartition(label,'HoldOut',ho); 
opts.Model = HO;
PRO = cat_and_mouse(feat,label,opts);

selected_features = PRO.ff;
label = PRO.l;
cv = cvpartition(size(feat,1),'HoldOut',0.3);
idx = cv.test;
% Separate to training and test data
XTrain = selected_features;
YTrain = label;
 
%% 
for i=1:size(selected_features,2)
  XTest(i)=double(Test_feature(PRO.index(i)));  % test features
end
Ypred= demo_cnn(XTrain, XTest, YTrain); 

%% to display result
if(Ypred==1)
    h = msgbox(sprintf('Tumor'));
     
     else
     h = msgbox(sprintf('Non-Tumor'));
   end
%% segmentation
img = Image_segment_UNet(J);
figure, imshow(img);title('Segmented Image');
%% calculate similarity
filename = filename(1:end-9);
filename = strcat(filename ,'seg.nii');
fullFileName = fullfile(pathname, filename);
seg_img = niftiread(fullFileName);
seg_img=uint8(seg_img(:,:,round(end/2)));
seg_img = Analyzeseg(seg_img,2,4);
dice_similarity = dice(img, seg_img);
jaccard_similarity = jaccard(img, seg_img);
fprintf('Jaccard Index Similarity Value: %f\n', jaccard_similarity);
fprintf('Dice Similarity Value: %f\n', dice_similarity);
comparison_graphs()