function [ tas ] = getTASScores( IM, threshold )
%getTASScores Compute threshold adjacency stats for a 2D or 3D image

[m,n,p] = size(IM);
[numThresh, ~] = size(threshold);
if(p == 1) % 2D image
    numNeighbors = 8;
    ker = ones(3);
    ker(2,2) = 10;
    tas = zeros(numThresh,numNeighbors +1);
    tmp = zeros(m,n,numThresh);
    for iThresh = 1:numThresh
        tmp(:,:,iThresh) = conv2(double(IM == threshold(iThresh,1)),ker,'same');
    end
%     tmp = tmp -1;
    allSum = squeeze(sum(sum(tmp >= 10,2 )));
    for iNeighbors = 1:numNeighbors
        tas(:,iNeighbors) = squeeze(sum(sum(tmp == (iNeighbors-1+10),2 )));
    end
    tas = bsxfun(@rdivide,tas,allSum);
elseif(p>1)
    if(p==2)
        numNeighbors = 17;
    else
        numNeighbors = 26;
    end
    ker = ones(3,3,3);
    tas = zeros(numThresh,numNeighbors +1);
    tmp = zeros(m,n,p,numThresh);
    for iThresh = 1:numThresh
        tmp(:,:,:,iThresh) = convn(double(IM > threshold(iThresh,1)),ker,'same');
    end 
    tmp = tmp -1;
    allSum = squeeze(sum(sum(sum(tmp >=0,3 ),2)));
    for iNeighbors = 1:numNeighbors
        
        tas(:,iNeighbors) = squeeze(sum(sum(sum(tmp == (iNeighbors-1),3 ),2)));
    end
    tas = tas./allSum;
end


end

