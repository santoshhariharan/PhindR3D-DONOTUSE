% get data as a matrix
clc;close all;

% Put data manually
% data = x;
numGroups = size(data,2);

% groupsLabels Cell
% point labels (N's)
nval = [1:size(data,1)];
positionVec = [1:numel(groupLabels)];
jitterVal = .15;
uniqueRepeat = unique(nval);
% fpositionVec = positionVec + jitterVal.*rand(1,numel(positionVec));
figure;hold on;
mp = colormap(jet(numel(nval)));
boxplot(data,'Symbol','','Whisker',0,'labels',groupLabels,'labelorientation','inline');
legendnames = {};
for i = 1: numel(uniqueRepeat)
    ii = find(nval == uniqueRepeat(i));
    
    for j = 1:numel(ii)
        fpositionVec = positionVec + (-jitterVal) + 2*jitterVal.*rand(1,numel(positionVec));
        plot(fpositionVec,data(ii(j),:),'o','MarkerFaceColor',mp(i,:),'MarkerEdgeColor','none');
    end
    legendnames = [legendnames; cellstr(['N' num2str(i)])];
end
hold off;
ylabel('Percent classified Buffer');
legend(legendnames);