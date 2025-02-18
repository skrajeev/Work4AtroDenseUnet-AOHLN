function result = clasifyPred(XTest,Train_Fea,Y)
% Train_Fea = cell2mat(Train_Fea')';
% XTest = cell2mat(XTest')';
% Y= double(string(Y));
for k=1:size(XTest,1)

d=pdist2(XTest(k,:),Train_Fea);
[sd,r]=sort(d,'ascend');
result(k)=Y(r(1));
end
end