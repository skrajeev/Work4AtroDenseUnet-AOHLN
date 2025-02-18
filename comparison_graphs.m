function comparison_graphs()
 load('result_proposed.mat')
 load('result_proposed1.mat')
%% Accuracy
X= [Result_proposed.Accuracy 0.99 0.96 0.90 0.87 0.83 0.80;
    Result_proposed1.Accuracy 0.98 0.93 0.89 0.85 0.81 0.78;];
   figure()
bar(X');
ylim([0.5 1])

set(gca,'fontweight','bold')
ylabel('Accuracy')
legend('BRATS 2019','BRATS 2020')
grid on
grid minor
set(gca,'xticklabel',{'proposed','DENN-FTE','RF','DNN','ANN','Multi-SVM','KNN'})
%% Sensitivity
Y= [Result_proposed.Sensitivity 0.98 0.93 0.90 0.86, 0.81 0.78;
    Result_proposed1.Sensitivity 0.97 0.92 0.88 0.84 0.79 0.76;];
   figure()
bar(Y');
ylim([0.5 1])

set(gca,'fontweight','bold')
ylabel('Sensitivity')
legend('BRATS 2019','BRATS 2020')
grid on
grid minor
set(gca,'xticklabel',{'proposed','DENN-FTE','RF','DNN','ANN','Multi-SVM','KNN'})
%% Specificity
Z= [Result_proposed.Specificity 0.9922 0.9817 0.9798 0.9892 0.9866 0.9896;
    Result_proposed1.Specificity 0.9827 0.9795 0.9827 0.9850 0.9808 0.9808;];
   figure()
bar(Z');
ylim([0.85 1])

set(gca,'fontweight','bold')
ylabel('Specificity')
legend('BRATS 2019','BRATS 2020')
grid on
grid minor
set(gca,'xticklabel',{'proposed','DENN-FTE','RF','DNN','ANN','Multi-SVM','KNN'})

%% Precision
x= [Result_proposed.Precision 0.97 0.90 0.80 0.80 0.76 0.70;
    Result_proposed1.Precision 0.96 0.89 0.82 0.77 0.77 0.68;];
   figure()
bar(x');
ylim([0.5 1])

set(gca,'fontweight','bold')
ylabel('Precision')
legend('BRATS 2019','BRATS 2020')
grid on
grid minor
set(gca,'xticklabel',{'proposed','DENN-FTE','RF','DNN','ANN','Multi-SVM','KNN'})

%% F1_score
y= [Result_proposed.F1_score 0.98 0.97 0.94 0.90 0.83 0.77;
    Result_proposed1.F1_score 0.97 0.97 0.95 0.91 0.81 0.74;];
   figure()
bar(y');
ylim([0.5 1])

set(gca,'fontweight','bold')
ylabel('F-Measure')
legend('BRATS 2019','BRATS 2020')
grid on
grid minor
set(gca,'xticklabel',{'proposed','DENN-FTE','RF','DNN','ANN','Multi-SVM','KNN'})

%% FalsePositiveRate  
z= [Result_proposed.FalsePositiveRate*10 0.33 0.43 0.49 0.54 0.59 0.59;
    Result_proposed1.FalsePositiveRate*10 0.34 0.44 0.50 0.55 0.59 0.58;];
   figure()
bar(z');
ylim([0 1])

set(gca,'fontweight','bold')
ylabel('FalsePositiveRate  ')
legend('BRATS 2019','BRATS 2020')
grid on
grid minor
set(gca,'xticklabel',{'proposed','DENN-FTE','RF','DNN','ANN','Multi-SVM','KNN'})

%% Error  
a= [Result_proposed.Error 0.01 0.03 0.15 0.18 0.21 0.24;
    Result_proposed1.Error 0.02 0.02 0.16 0.19 0.22 0.24;];
   figure()
bar(a');
ylim([0 0.25])

set(gca,'fontweight','bold')
ylabel('Balanced Error Rate')
legend('BRATS 2019','BRATS 2020')
grid on
grid minor
set(gca,'xticklabel',{'proposed','DENN-FTE','RF','DNN','ANN','Multi-SVM','KNN'})
%% False negative rate
b= [RefereceResult.FalseNegativeRate 0.01 0.13 0.20 0.26 0.38 0.43;
    RefereceResult1.FalseNegativeRate 0.02 0.14 0.19 0.27 0.39 0.44;];
   figure()
bar(b');
ylim([0 0.45])

set(gca,'fontweight','bold')
ylabel('False Negative Rate')
legend('BRATS 2019','BRATS 2020')
grid on
grid minor
set(gca,'xticklabel',{'proposed','DENN-FTE','RF','DNN','ANN','Multi-SVM','KNN'})
%%
%% False negative rate
c= [RefereceResult.NegativePredictiveValue 0.99 0.97 0.86 0.73 0.71 0.70;
    RefereceResult1.NegativePredictiveValue 0.98 0.97 0.85 0.74 0.71 0.69;];
   figure()
bar(c');
ylim([0.5 1])

set(gca,'fontweight','bold')
ylabel('Negative Predictive Value')
legend('BRATS 2019','BRATS 2020')
grid on
grid minor
set(gca,'xticklabel',{'proposed','DENN-FTE','RF','DNN','ANN','Multi-SVM','KNN'})
%% Jaccard Index

d = [98.16 96 83 71 83 81];
figure();hold on
for i=1:length(d)
    bar(i,d(i),0.5);
end

ylim([60 100])
xticks([1 2 3 4 5 6])
set(gca,'fontweight','bold')
ylabel('Jaccard Index')

grid on
grid minor
set(gca,'xticklabel',{'proposed','DL-FKMC','SS-2D ConvNet','FCNN','CNN','KNN'})
%% Training and Testing Accuracy
 no_iterations=500;
figure,
subplot(2,1,2)
plot(netinfo.TrainingLoss(1:no_iterations),'-')
hold on
x = 1 : length(netinfo.ValidationLoss(1:no_iterations));
y = netinfo.ValidationLoss(1:no_iterations);
idx = ~any(isnan(y),1);
plot(x(idx),y(idx),'--','Marker','.','MarkerSize' ,12);
legend('Training Loss','ValidationLoss')
xlabel('Iterations')
ylabel('Loss')
set(gca,'Fontname','Times','Fontsize',10,'Fontweight','Bold');
subplot(2,1,1)
plot(netinfo.TrainingAccuracy(1:no_iterations),'-')
hold on
x = 1 : length(netinfo.ValidationAccuracy(1:no_iterations));
y = netinfo.ValidationAccuracy(1:no_iterations);
idx = ~any(isnan(y),1);
plot(x(idx),y(idx),'--','Marker','.','MarkerSize' ,12);
ylim([40 105])
legend('Training Accuracy','Validation Accuracy')
xlabel('Iterations')
ylabel('Accuracy')
set(gca,'Fontname','Times','Fontsize',10,'Fontweight','Bold');



%%
no_iterations=500;
figure,
subplot(2,1,2)
plot(netinfo2.TrainingLoss(1:no_iterations),'-')
hold on
x = 1 : length(netinfo.ValidationLoss(1:no_iterations));
y = netinfo2.ValidationLoss(1:no_iterations);
idx = ~any(isnan(y),1);
plot(x(idx),y(idx),'--','Marker','.','MarkerSize' ,12);
legend('Training Loss','ValidationLoss')
xlabel('Iterations')
ylabel('Loss')
set(gca,'Fontname','Times','Fontsize',10,'Fontweight','Bold');
subplot(2,1,1)
plot(netinfo2.TrainingAccuracy(1:no_iterations),'-')
hold on
x = 1 : length(netinfo.ValidationAccuracy(1:no_iterations));
y = netinfo2.ValidationAccuracy(1:no_iterations);
idx = ~any(isnan(y),1);
plot(x(idx),y(idx),'--','Marker','.','MarkerSize' ,12);
ylim([40 105])
legend('Training Accuracy','Validation Accuracy')
xlabel('Iterations')
ylabel('Accuracy')
set(gca,'Fontname','Times','Fontsize',10,'Fontweight','Bold');
%% Kappa
e = [Result_proposed.Kappa 0.9712 0.8471 0.7063 0.9010 0.9376];
figure();hold on
for i=1:length(e)
    bar(i,e(i),0.5);
end

ylim([0.5 1])
xticks([1 2 3 4 5 6])
set(gca,'fontweight','bold')
ylabel('Kappa')

grid on
grid minor
set(gca,'xticklabel',{'proposed','DL-FKMC','SS-2D ConvNet','FCNN','CNN','KNN'})
%% Dice Coefficent
f = [0.990718 0.9203 0.92 0.8895 0.926 0.9870];
figure();hold on
for i=1:length(f)
    bar(i,f(i),0.5);
end

ylim([0.5 1])
xticks([1 2 3 4 5 6])
set(gca,'fontweight','bold')
ylabel('Dice Coefficent')

grid on
grid minor
set(gca,'xticklabel',{'proposed','DL-FKMC','SS-2D ConvNet','FCNN','CNN','KNN'})
end