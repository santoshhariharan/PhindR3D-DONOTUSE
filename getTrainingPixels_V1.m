function [ trPixels ] = getTrainingPixels( filenames,param )
%getTrainingPixels Summary of this function goes here
%   Detailed explanation goes here
filenames = filenames(param.zOffsetStart:end-param.zOffsetEnd,:);% Keep z stacks that are divisible by stack count
filenames = filenames(randperm(size(filenames,1),param.randZForTraining),:);
trPixels = zeros(param.pixelsPerImage.*param.randZForTraining,param.numChannels);
startVal = 1;
% endVal = param.pixelsPerImage;
for iImages = 1:size(filenames,1)
    croppedIM = zeros(param.origX,param.origY,param.numChannels);
    
    for jChannels = 1:param.numChannels
%         croppedIM(:,:,jChannels) = imread(filenames{iImages,jChannels},'tiff'); 
        croppedIM(:,:,jChannels) = rescaleIntensity(imread(filenames{iImages,jChannels},'tiff'),...
                                    param.lowerbound(:,jChannels),param.upperbound(:,jChannels));
    end
    
    
    croppedIM = croppedIM(param.xOffsetStart:(end - param.xOffsetEnd),...
                    param.yOffsetStart:(end - param.yOffsetEnd),:);
    if(param.correctshade)
        croppedIM  = croppedIM./param.allRef;
    end
    
    croppedIM = reshape(croppedIM,param.croppedX.*param.croppedY,param.numChannels);
%     t1 = sum(bsxfun(@gt,croppedIM,param.intensityThreshold),2) >= param.numChannels/3;
    croppedIM = croppedIM(sum(bsxfun(@gt,croppedIM,param.intensityThreshold),2) >= param.numChannels/3,:);
%     fprintf('Max 1: %.5f\n',max(croppedIM(:,1)));
%     newIM =  zeros(param.croppedX.*param.croppedY,param.numChannels);
%     newIM(t1,:) = croppedIM;
%     newIM = reshape(newIM,param.croppedX,param.croppedY,param.numChannels);
%     figure; imshow(newIM,'InitialMagnification',25);title(['Slice Number: ' num2str(iImages)]);
%         Pick pixels based on weighted probabilities
    croppedIM = selectPixelsbyweights(croppedIM);
%     fprintf('--Max 2: %.5f\n',max(croppedIM(:,1)));
    
    if(size(croppedIM,1) >= param.pixelsPerImage)
        trPixels(startVal:(startVal + param.pixelsPerImage-1),:) = croppedIM(randperm(size(croppedIM,1),param.pixelsPerImage),:);
        startVal = startVal + param.pixelsPerImage;
%         endVal = endVal + param.pixelsPerImage;
    else        
        trPixels(startVal:startVal+size(croppedIM,1)-1,:) = croppedIM;
        startVal = startVal+size(croppedIM,1);
    end
end
% trPixels = trPixels(sum(trPixels,2) ~=0,:);
end



