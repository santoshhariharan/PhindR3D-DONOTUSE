function [ tiledImage ] = getTiledImage( croppedIM, param)
%getTiledImage Summary of this function goes here
%   Detailed explanation goes here


areaPerTile = param.tileX.*param.tileY.*param.tileZ;


% Crop image to specified dimensions

% croppedIM = IM(xOffsetStart:(end - xOffsetEnd),yOffsetStart:(end - yOffsetEnd),zOffsetStart:(end- zOffsetEnd));
numTilesPerSlice = (param.croppedX.*param.croppedY)./(param.tileX.*param.tileY);
tiledImage = zeros(numTilesPerSlice.*(param.croppedZ/param.tileZ),areaPerTile);
sliceCounter = 0;
tmp = [];
startVal = 1;
endVal = numTilesPerSlice;
for iSlice = 1:size(croppedIM,3)
    sliceCounter = sliceCounter+1;
    tmp1 = im2col(croppedIM(:,:,iSlice),[param.tileX param.tileY],'distinct')';
    tmp = [tmp tmp1];
    if(sliceCounter == 3)
        tiledImage(startVal:endVal,:) = tmp;
        sliceCounter = 0;
        tmp = [];
        startVal = startVal+numTilesPerSlice;
        endVal = endVal+numTilesPerSlice;
    end
end

end

