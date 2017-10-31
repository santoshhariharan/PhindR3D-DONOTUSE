function [ tasScores ] = getCategoricalTASScores( inputImage, numCategories )
%getCategoricalTASScores Computes TAS for every category in the image


% uniqueCategories = unique(categories);
% numCategories = numel(uniqueCategories);
[~, ~, sizeZ] = size(inputImage);
if(sizeZ>1)
    tasScores = zeros(1,numCategories*27);
    numTas = 27;
else
    tasScores = zeros(1,numCategories*9);
    numTas = 9;
end
tmp = 1;
for iCategory = 1:numCategories
    tasImage = inputImage == iCategory;
    if(sum(tasImage(:)) > 0)
        tasScores(1,tmp:iCategory*numTas) = getImagebasedTAS( tasImage,0 );
    else
        tasScores(1,tmp:iCategory*numTas) = 0;
    end
    tmp = tmp+numTas;
end


end

