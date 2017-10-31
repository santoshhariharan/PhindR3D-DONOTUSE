clc;
x = getappdata(0,'alldata');
% x = pdist2(x.data,x.data,'cityblock');
g = getGroupIndices(x.textdata(:,columntoVis),treatments);
% data = x.data(g>0,:);
idx = phenograph(x.data(g>0,:),50);
%%
clc;

columntoVis = 4;
% uText = unique(x.textdata(:,columntoVis));
uText=treatments;
clusterDistribution = zeros(numel(uText),max(idx));
% textdata = 
for iGroups = 1:numel(uText)
    ii = strcmpi(x.textdata(g>0,columntoVis),uText{iGroups,:});
    for jIdx = 1:max(idx)
        jj = idx == jIdx;
        clusterDistribution(iGroups,jIdx) = sum(ii.*jj);
    end
end
disp('Done')