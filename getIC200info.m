function [ metadata, channelInfo] = getIC200info( plateDirectory )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

metadata = {};
% plateDirectory = [plateDirectory '\scan'];

wells = dir([plateDirectory '\scan']);
toggleSwitch = true;
imageIDNum = 1;
for iWells = 3:size(wells,1)
    if(~wells(iWells).isdir)
        continue;
    end
    wellInfo = {};header = {};channelInfo = {};
    channelNames = dir([plateDirectory '\scan\' wells(iWells).name]);
    for iChannels = 3:size(channelNames,1)
        if(~channelNames(iChannels).isdir)
            continue;
        end
        imageFileNames = dir([plateDirectory '\scan\' wells(iWells).name '\' channelNames(iChannels).name]);
        imFiles = {};fieldName = {}; zheight = {};
        for jImages = 3:size(imageFileNames,1)
            if(imageFileNames(jImages).isdir)
                continue;
            end
            extMatch = regexpi(imageFileNames(jImages).name,'.tif','start');        
            if(isempty(extMatch))
                continue;
            end
            tmpName = [plateDirectory '\scan\' wells(iWells).name '\' channelNames(iChannels).name '\' imageFileNames(jImages).name];
%             imageFileName = [imageFileName;cellstr(tmpName)];   
            imFiles = [imFiles;cellstr(tmpName)];
            fieldName = [fieldName;tmpName(end-30:end-18)];
            zheight = [zheight;tmpName(end-9:end-4)];
        end
        wellInfo = [wellInfo imFiles];
        header = [header cellstr(channelNames(iChannels).name)];
        channelInfo = [channelInfo; cellstr(channelNames(iChannels).name)];
    end
    
    uFieldNames = unique(fieldName);
    imageID = zeros(size(fieldName,1),1);
    for iFields = 1:numel(uFieldNames)
        fieldIndex = strcmpi(fieldName,uFieldNames{iFields,:});
        imageID(fieldIndex,1) = imageIDNum;
        imageIDNum = imageIDNum+1;
    end
    wellInfo = [wellInfo fieldName zheight repmat(cellstr(wells(iWells).name),size(fieldName,1),1) num2cell(imageID)];
    header = [header cellstr('Fields') cellstr('Stacks') cellstr('Wells') cellstr('ImageID')];
    if(toggleSwitch)
        metadata = [metadata;header];
%         channelInfo = [channelInfo;]
        toggleSwitch = false;
    end
    metadata = [metadata;wellInfo];
end



end

