function [ aRI ] = adjRandIndex( group,groupHat )
%adjRandIndex Computes adjusted RAND index for 2 assignments
% group - True class labels
% groupHat - Sytemic response
n = numel(group);
uGroup = unique(group);
uGroupHat = unique(groupHat);
nij = zeros(numel(uGroup),numel(uGroupHat));
commbContMat = zeros(numel(uGroup),numel(uGroupHat));
for i = 1:numel(uGroup)
    ii = group==uGroup(i);
    for j = 1:numel(uGroupHat)
        jj = groupHat==uGroupHat(j);
        nij(i,j) = sum(ii.*jj);
        if(nij(i,j)>0)
            commbContMat(i,j) = nij(i,j).*(nij(i,j)-1)./2;
        end
    end
end
RI = sum(commbContMat(:));

a = sum(nij,2);
b = sum(nij,1);

aComb = a.*(a-1)./2;
bComb = b.*(b-1)./2;
maxRI = (sum(aComb)+sum(bComb))./2;
eRI = sum(sum(aComb*bComb))./(n.*(n-1)/2);
aRI = (RI - eRI)./(maxRI - eRI);
end

