warning off;
clear all;
close all;
clc;
%% ---------------------------------------------------Tumor-------------------------------------------------------

cellRlt = findAllSubfolders('E:\Boaner\Rajeev SK(539601)\BraTS 2020\HGG');
Feat=[];
for k=1
    [fPath, fName, fExt] = fileparts(cellRlt{k});
    srcFiles = dir(fullfile(cellRlt{k,1}, '*'));
for j=3:length(srcFiles)
    filename = strcat(cellRlt{k,1},'\',srcFiles(j).name);
     I=niftiread(filename);
     I=I(:,:,round(end/2));
%% adaptive homomorphic wavelet filter 
Ihmf= filtering(I);
%% GLCM features
out = GLCM(Ihmf);
%% kirsch edge detector (ked)
ked = KED(Ihmf);
meanIntensity = mean(ked(:));
SD = std(ked(:));
Fea=real([out.contr, out.energ, out.sosvh, out.entro, out.homop, out.savgh, out.senth, out.svarh, out.denth, out.dvarh, out.inf1h, out.inf2h, out.corrp, meanIntensity, SD]);

label=1; 
feature(j,:)=real([Fea label]);
end
feature(1:2,:)=[];
Feat=[Feat;feature];
feature=[];
end
feature_tumor= Feat;
%% ---------------------------------------------------Non-Tumor-----------------------------------------------------
cellRlt = findAllSubfolders('E:\Boaner\Rajeev SK(539601)\BraTS 2020\LGG');
Featur=[];
for k=1
    [fPath, fName, fExt] = fileparts(cellRlt{k});
    srcFiles = dir(fullfile(cellRlt{k,1}, '*'));
for j=3:length(srcFiles)
    filename = strcat(cellRlt{k,1},'\',srcFiles(j).name);
     I=niftiread(filename);
     I=I(:,:,round(end/2));
%% adaptive homomorphic wavelet filter 
Ihmf= filtering(I);
%% GLCM features
out = GLCM(Ihmf);
%% kirsch edge detector (ked)
ked = KED(Ihmf);
meanIntensity = mean(ked(:));
SD = std(ked(:));
Fea=real([out.contr, out.energ, out.sosvh, out.entro, out.homop, out.savgh, out.senth, out.svarh, out.denth, out.dvarh, out.inf1h, out.inf2h, out.corrp, meanIntensity, SD]);

label=0; 
feature(j,:)=real([Fea label]);
end
feature(1:2,:)=[];
Featur=[Featur; feature];
feature=[];
end

feature_nontumor = Featur;
FEATURES = [feature_tumor; feature_nontumor];

