function [metadata,header,cInfo] = getPlateInfoFromMetadatafile(metadatafilename,param,rootDir,exprIM)
% Read and parse metadatafile
% Inputs:
%   metadatafilename - Excel file containing metadata information. Requires
%   columns wells, fields and stacks
% Output:
%   metadata - Extracted metadata
%   cInfo - Channelinformation

% Open metadata file name
% 
try
    fid = fopen(metadatafilename,'r');
%     tline = fgetl(fid);
    header= strtrim(fgetl(fid));
    fclose(fid);
    header = regexpi((header),'\t','split');
%     param.formatString = [repmat('%s',1,sum(param.templatetextfeat)) repmat('%f',1,numel(param.templatetextfeat) - sum(param.templatetextfeat)) ];
    fid = fopen(metadatafilename);
    metadata = textscan(fid,repmat('%s',1,numel(header)),'headerlines',1,'delimiter','\t');
    fclose(fid);    
catch excep
    fclose(fid);
    rethrow(excep);
end
mData = cell(size(metadata{1,1},1),numel(header));
for i = 1:numel(header)
    mData(:,i) = metadata{1,i};
end
metadata = mData;
clear mData;
% Create a unique image ID for each field
% Use all information apart from sclice nunmber in file name
ii = (strcmpi('Stacks',header) | strcmpi('Stack',header));
if(~ii)
    error('Stacks not defined!');
end
allStk = metadata(:,ii);
allStk = str2num(char(allStk));

% ii = allStk >= param.startZPlane & allStk <= param.endZPlane;
% if(~ii)
%     error('Planes not defined correctly!');
% end
% allStk = allStk(ii);
% metadata = metadata(ii,:);
uniqueStacks = unique(allStk);

jj = strcmpi('Channel1',header);
uCol = metadata(:,jj);
str = uCol{10,:};
str = regexprep(str,rootDir,'');
m1 = regexpi(str,exprIM,'names');
ff = fieldnames(m1);
stackNuminRegexp = or(strcmpi('Stack',ff),strcmpi('Stacks',ff));
stackNuminRegexp = find(stackNuminRegexp);
for i = 1:size(uCol)
    str = uCol{i,:};
    str = regexprep(str,rootDir,'');
    mm = regexpi(str,exprIM,'tokenExtents');
    mm = mm{1,1};
    mm = mm(stackNuminRegexp,:);
    uCol{i,:} = str([1:mm(1)-1 mm(2)+1:end]);
end
uUCol = unique(uCol);
imageIDcol = zeros(size(metadata,1),1);
cnt = 1;
fprintf('Parsing Metadata..................');
numUCol = numel(uUCol);
for i = 1:numUCol
    ii = strcmpi(uCol,uUCol{i,:});
    imageIDcol(ii,1) = cnt;
    cnt=cnt+1;
    fprintf('\b\b\b\b\b\b\b\b%7.3f%%',i*100/numUCol);
end
fprintf('\n\n');
% % Take the first stack & give image ID
% imageIDcol = zeros(size(metadata,1),1);
% % cnt = 1;
% for i = 1:numel(uniqueStacks)
%     ii = allStk == uniqueStacks(i);
%     imageIDcol(ii,1) = 1:sum(ii);
% end


% header = [header cellstr('imageID')];
% metadata = [metadata num2cell(imageIDcol)] ;

% 
% pp = str2num(char(regexprep(uniqueStacks,'p','0')));
% [~, pp] = sort(pp);
% uniqueStacks = uniqueStacks(pp);
% uniqueStacks = uniqueStacks(param.startZPlane:param.endZPlane,1);
% Loop through each stack
% fieldName = metadata(:,1);
% for iSt = 1:numel(uniqueStacks)
%     fieldName = regexprep(fieldName, [uniqueStacks{iSt,:} '+(_|-|\.)'],'');
%     stkToKeep(strcmpi(uniqueStacks{iSt,:},allStk),1) = true;
% end
% 
% metadata = metadata(stkToKeep,:);
% fieldName = fieldName(stkToKeep,:);
% uFields = unique(fieldName);
% imageIDcol = zeros(size(metadata,1),1);
% for i = 1:numel(uFields)
%     imageIDcol(strcmpi(uFields{i,:},fieldName),1) = i;
% end
clear allStk uniqueStacks iSt 

% Get channels selected by user
if(~isempty(param.channelDiscarded))
    colToRemove = false(1,numel(header));
    for i = 1:numel(param.channelDiscarded)
        colToRemove = or(colToRemove,strcmpi(header,param.channelDiscarded{i,:}));
    end
    header = header(1,~colToRemove);
    metadata = metadata(:,~colToRemove);
end

header = [header cellstr('imageID')];
metadata = [metadata num2cell(imageIDcol)] ;
headerSize = numel(header);
cInfo = {};
for i = 1:headerSize
    m1 = regexpi(header{1,i},'channel');
    if(~isempty(m1))
        cInfo = [cInfo;header(1,i)];
    end
end
