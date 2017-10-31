function [ param ] = getScalingFactorforImages( metadata,allImageID,param )
%getScalingFactorforImages Computes lower and higher scaking values for
%                       each image
% metadata - Metadata
% param - Structure of parameters value

if(param.intensityNormPerTreatment)
    [randFieldIDforNormalization] = getTrainingFields(metadata,...
        param,param.treatmentColNameForNormalization);
    grpVal = zeros(numel(randFieldIDforNormalization),1);
else
    [randFieldIDforNormalization] = getTrainingFields(metadata,...
        param,param.trainingColforImageCategories);
end

minChannel = zeros(numel(randFieldIDforNormalization),param.numChannels);
maxChannel = zeros(numel(randFieldIDforNormalization),param.numChannels);
numImages = numel(randFieldIDforNormalization);
fprintf('********************\n');
fprintf('Finding Scaling factor.........................');
for i = 1:numImages
    ii = allImageID == randFieldIDforNormalization(i);    
    %     Read Images
    filenames = metadata(ii,1:param.numChannels);
    if(i==1)
        [ d,fmt ] = getImageInformation( filenames(:,1) );        
    end
    d(1,3) = sum(ii);
%     tic;
    param = getTileInfo( d,param );
%     toc;
    randZ = floor(.5*sum(ii));
    randZ = randperm(sum(ii),randZ);
    filenames = filenames(randZ,:);
    minVal = inf(size(filenames,1),param.numChannels);
    maxVal = -inf(size(filenames,1),param.numChannels);
    for j = 1:size(filenames,1)       
        for k  = 1:param.numChannels
            IM = double(imread(filenames{j,k},fmt));
            minVal(j,k) = min(minVal(j,k),min(IM(:)));
            maxVal(j,k) = max(maxVal(j,k),max(IM(:)));
        end
    end
    minChannel(i,:) = min(minVal);
    maxChannel(i,:) = max(maxVal);  
    if(param.intensityNormPerTreatment)
        grpVal(i) = unique(param.grpIndicesForIntensityNormalization(ii));    
    end
    fprintf('\b\b\b\b\b\b\b\b%7.3f%%',i*100/numImages);    
end
fprintf('\n\n\n');

if(param.intensityNormPerTreatment)    
    uGrp = unique(grpVal);
    param.lowerbound = zeros(numel(uGrp),param.numChannels);
    param.upperbound = zeros(numel(uGrp),param.numChannels);
    for i = 1:numel(uGrp)
        ii = grpVal == uGrp(i);
        if(sum(ii)>1)
            param.lowerbound(i,:) = quantile(minChannel(grpVal == uGrp(i),:),.01);
            param.upperbound(i,:) = quantile(maxChannel(grpVal == uGrp(i),:),.99);
        else
            param.lowerbound(i,:) = minChannel(grpVal == uGrp(i),:);
            param.upperbound(i,:) = maxChannel(grpVal == uGrp(i),:);
        end
        
    end
else
    param.lowerbound = quantile(minChannel,.01);
    param.upperbound = quantile(maxChannel,.99);
end


end

