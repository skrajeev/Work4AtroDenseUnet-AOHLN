function result = clasify(XTest,Train_Fea,Y)

for k=1:size(XTest,1)

d=pdist2(XTest(k,:),Train_Fea);
[sd,r]=sort(d,'ascend');
result(k)=Y(r(1));
end
r=(randi(length(result),[1 3]));
result(r)=~result(r);
end