function cellRlt = findAllSubfolders(targetDir)
% FINDALLSUBFOLDERS find all subfolders under the given directory
%   targetDir - input directory path
%   cellRlt - output cell containing all subfolders
cellRlt{1}=targetDir;
folderCount = 0;
while(folderCount < length(cellRlt))
    tempDir = cellRlt{folderCount+1};
    tempSubs = dir(tempDir);
    flagFolder = [tempSubs(:).isdir];
    nSubfolder = sum(flagFolder(:))-2;
    if(nSubfolder > 0)
        tempCellSubs={tempSubs(flagFolder).name}';
        tempCellSubs(ismember(tempCellSubs,{'.','..'}))=[];
        tempCellSubs=fullfile(tempDir,tempCellSubs);
        cellRlt=cat(1,cellRlt,tempCellSubs);
    end
    folderCount=folderCount+1;
end
end