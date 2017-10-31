function [ scores ] = getImagebasedTAS( IM,thresholdValues )
%getImagebasedTAS Compute 2D-3D TAS scores
% Input - 
% IM - Multidimensional image vector (2 or 3 D)
% thresholdValues - Threshold at which TAS should be computed
% param - Optional paramater structure that contains information about cropping
%           and thresholding for each indovidual channel

% Output
% scores - A 1xN vector where N is the number of TAS scores
%           if image is 2D N = 9
%           if image is 3D N = 27

p = size(IM,3);
if(p == 1) % Image is 2D
%     scores = zeros(1,9);
    threshIM = IM > thresholdValues;
    bkgval = sum(threshIM(:) >0);
    tasKernel = ones(3,3);
    tasKernel(2,2) = 10;
%     tasIM = conv2(threshIM,tasKernel,'Same');
    scores = getTAS(conv2(double(threshIM),tasKernel,'same'));
elseif(p>1) % Image is 3D
%     scores = zeros(1,27);
    threshIM = IM > thresholdValues;
    bkgval = sum(threshIM(:) >0);
    tasKernel = ones(3,3,3);
    tasKernel(2,2,2) = 28;
    scores = getTAS(convn(double(threshIM),tasKernel,'same'));
end
scores = scores./bkgval;
end
function thresholdAdjacencyStat = getTAS(tasImage)

p = size(tasImage,3);

if(p>1)
    minval = 28;
    numNeighbours = 26;
    N = 27;
else
    minval = 10;
    numNeighbours = 8;
    N=9;
end
thresholdAdjacencyStat = zeros(1,N);

for iNeighbours = minval:(minval + numNeighbours)
    thresholdAdjacencyStat(1,iNeighbours - numNeighbours -1 )  = sum(tasImage(:) == iNeighbours );
end



end
