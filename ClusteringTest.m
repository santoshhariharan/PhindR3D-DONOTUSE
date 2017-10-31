% c = clustergram(data,'Rowlabels',treatment,'Colormap','redbluecmap','Symmetric',false);
C = pdist2(data,data,'cosine');
idx = apclusterK(C,7,'dampfat',.8);

uIdx = unique(idx);
uTreatment = unique(treatment);
dist = zeros(numel(uTreatment),numel(uIdx));
for i = 1:numel(uTreatment)
    ii = strcmpi(uTreatment{i,:},treatment);
    for j = 1:numel(uIdx)
        jj = idx==uIdx(j);
        dist(i,j) = sum(ii.*jj)/sum(ii);
    end
end

c = clustergram(dist,'Rowlabels',uTreatment,'Colormap','redbluecmap','Symmetric',false);
