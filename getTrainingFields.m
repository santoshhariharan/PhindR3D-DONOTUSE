function [ randFieldID, treatmentValues ] = getTrainingFields( metaInfo,param,treatmentColumn)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

if(nargin<3)
    randomImage = true;
else
    randomImage = false;
    
end
allImageId = cell2mat(metaInfo(:,param.imageIDColNum));
uniqueImageID = unique(allImageId);
if(randomImage)
%     allImageId = cell2mat(metaInfo(:,param.imageIDColNum));
    
    randFieldID = randperm(numel(uniqueImageID),param.randTrainingFields);
    
else
    if(~islogical(treatmentColumn))
    treatmentColumn = strcmpi(param.metaDataHeader,treatmentColumn);       
    
    end
    uTreat = unique(metaInfo(:,treatmentColumn));
    randFieldID = zeros(param.randTrainingPerTreatment,numel(uTreat));
    for i = 1:numel(uTreat)
        ii = strcmpi(metaInfo(:,treatmentColumn),uTreat{i,:});
        tmp = unique(allImageId(ii));
        randFieldID(:,i) = tmp(randperm(numel(tmp),param.randTrainingPerTreatment));
    end
    
end
randFieldID = randFieldID(:);
treatmentValues = cell(numel(randFieldID),1);
for i = 1:numel(randFieldID)
    if(~randomImage)
        ii = metaInfo(allImageId == randFieldID(i),treatmentColumn);
        treatmentValues(i,1) = ii(1,:); 
    else
         treatmentValues(i,1) = cellstr('RR');
    end
end
end

