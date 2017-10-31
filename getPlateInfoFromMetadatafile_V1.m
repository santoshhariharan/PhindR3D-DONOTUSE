function [metadata,cInfo] = getPlateInfoFromMetadatafile(metadatafilename,param)
% Read and parse metadatafile
% Inputs:
%   metadatafilename - Excel file containing metadata information. Requires
%   columns wells, fields and stacks
% Output:
%   metadata - Extracted metadata
%   cInfo - Channelinformation

% clc;
% metadatafilename = '\\mercury\ic200\_YASCP\151204_gmat25_row1-2\metadatafile.xlsx';
% [~,d] = xlsread(metadatafilename);

% Open metadata file name
% 
try
    fid = fopen(metadatafilename,r);
%     tline = fgetl(fid);
    header= strtrim(fgetl(fid));
    fclose(fid);
    header = regexpi((header),'\t','split');
%     param.formatString = [repmat('%s',1,sum(param.templatetextfeat)) repmat('%f',1,numel(param.templatetextfeat) - sum(param.templatetextfeat)) ];
    fid = fopen(metadatafilename);
    d = textscan(fid,'%s','headerlines',1,'delimiter','\t');
    fclose(fid);
    
catch excep
    fclose(fid);
    rethrow(excep);
end
% header = d(1,:);
% d = d(2:end,:);
% wellColumn = false(1,size(d,2));
% fieldColumn = false(1,size(d,2));

wellColumn = or(strcmpi('wells',header),strcmpi('well',header));
fieldColumn = or(strcmpi('fields',header),strcmpi('field',header));
imID  = 1;
uWells = unique(d(:,wellColumn)); % Wells is column number 5
uFields = unique(d(:,fieldColumn));
imageIDcol = zeros(size(d,1),1);

for i = 1:numel(uWells)
    ii = strcmpi(d(:,wellColumn),uWells{i,:});
    for j = 1:numel(uFields)
        jj = strcmpi(d(:,fieldColumn),uFields{j,:});
        imageIDcol(logical(ii.*jj),1) = imID;
        imID = imID+1;
    end
end

% Take only slices menthioned by user
uniqImageID = unique(imageIDcol);
indicesToRetain = [1:size(d,1)]';

for iImageID = 1:numel(uniqImageID)
    tmpIdx = indicesToRetain(imageIDcol == uniqImageID(iImageID));
    tmpIdx(param.startZPlane:param.endZPlane) = [];
    indicesToRetain(tmpIdx) = 0;
end
indicesToRetain = indicesToRetain(indicesToRetain~=0);
header = [header cellstr('imageID')];
d = [d num2cell(imageIDcol)] ;
d = d(indicesToRetain,:);
metadata = [header;d];
headerSize = numel(header);
cInfo = {};
for i = 1:headerSize
    m = regexpi(header{1,i},'channel');
    if(~isempty(m))
        cInfo = [cInfo;header(1,i)];
    end
end
% cInfo = {'Channel0';'Channel1';'Channel2'};