function [pminfo] = getAdditionalMetaInfo(plateInfoTable)

pminfo = plateInfoTable;

% hdr = pminfo(:,1);
wellinfocol = pminfo(2:end,strcmpi(pminfo(1,:),'Wells'));

[~,aa] = xlsread('\\mercury\ic200\_YASCP\160114_glutamate\ConsolidatedImages\platemap.xlsx','platemap');
hdr = aa(1,:);
aa = aa(2:end,:);
gg = cell(size(pminfo,1)-1,size(aa,2)-1);
uWell = unique(aa(:,1));
for i = 1:numel(uWell)
    ii = strcmpi(wellinfocol,uWell{i,:});
    if(sum(ii) <=0)
        continue;
    end
    gg(ii,:) = repmat(aa(strcmpi(aa(:,1),uWell{i,:}),2:end),sum(ii),1);
end
gg = [hdr(1,2:end);gg];
pminfo = [pminfo gg];
end