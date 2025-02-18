warning off;
clear all;
close all;
clc;
%% load the feature(from feature extraction file)

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
%%
cv = cvpartition(size(feat,1),'HoldOut',0.3);
idx = cv.test;
% Separate to training and test data
XTrain = selected_features;
YTrain = label;
XTest  = selected_features(idx,:);
YTest = label(idx,:);

Ypred= AOHLN_train(XTrain, XTest, YTrain, YTest); 
%% Confusion Matrix
[c_matrix_proposed,Result_proposed,RefereceResult]= confusion.getMatrix(YTest,(Ypred));
figure;
plotConfMat(c_matrix_proposed, {'Tumor', 'Non-Tumor'}); hold on
save result_proposed Result_proposed RefereceResult netinfo