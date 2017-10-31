function IM = get3DImage(fileNames,param)


% xOffsetStart = param.xOffsetStart;
% xOffsetEnd = param.xOffsetEnd;
% yOffsetStart = param.yOffsetStart;
% yOffsetEnd = param.yOffsetEnd;
% zOffsetStart = param.zOffsetStart;
% zOffsetEnd = param.zOffsetEnd;
fileNames = fileNames(param.zOffsetStart:end-param.zOffsetEnd,:);
numFiles = size(fileNames,1);
% IM = imread(fileNames{1,:},'tiff');
IM = zeros(param.origX,param.origY,param.croppedZ);
for ifiles = 1:numFiles
    IM(:,:,ifiles) = imread(fileNames{ifiles,:},'tiff');
    IM(:,:,ifiles) = tmpImage(param.xOffsetStart:(end - param.xOffsetEnd),param.yOffsetStart:(end - param.yOffsetEnd));
end
end