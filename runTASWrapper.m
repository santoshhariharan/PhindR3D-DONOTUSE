function [ tasScores ] = runTASWrapper( filenames,param )
%runTASWrapper Wrapper function to parse file names and give images to
%getTAs module


filenames = filenames(param.zOffsetStart:end-param.zOffsetEnd,:);
if(size(filenames,1)>1)
    numNeighbours = 27;
    tasScores = zeros(1,numNeighbours*param.numChannels);
else
    numNeighbours = 27;
    tasScores = zeros(1,numNeighbours*param.numChannels);
end
cnt = 1;
for iChannels =  1 : param.numChannels
    channelFilenames = filenames(:,iChannels);
    croppedIM = zeros(param.origX,param.origY,size(channelFilenames,1));
    for iImages = 1:size(channelFilenames,1)
        croppedIM(:,:,iImages) = rescaleIntensity(imread(channelFilenames{iImages,1},'tiff'));
    end
    croppedIM = croppedIM(param.xOffsetStart:(end - param.xOffsetEnd),...
                param.yOffsetStart:(end - param.yOffsetEnd),:);
    tasScores(1,cnt:cnt+numNeighbours-1) = getImagebasedTAS(croppedIM,...
                                                param.intensityThreshold(1,iChannels));   
    cnt = cnt + numNeighbours ;                                        
end



end

