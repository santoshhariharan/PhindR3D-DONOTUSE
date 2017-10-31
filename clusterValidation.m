clear; clc;
% Load data
fileName = 'F:\Projects\PhlippNeuron\ClusterValidationDataSets\gaussian15_2D_1.mat';
load(fileName);

%% Perform AP cluster
data = zscore(data);
sim = -1*pdist2(data,data,'Euclidean');
sim = max(sim(:))-sim;
[pmin,pmax] = preferenceRange(sim);
numStep = 100;
pref = pmin:(pmax-pmin)/numStep:pmax;
numcls = zeros(numel(pref),1);
fprintf('Completed................')
for i = 1:numel(pref)
    id = apcluster(sim,pref(i),'dampfact',.99,'Maxits',2000);
    numcls(i) = numel(unique(id));
    fprintf('\b\b\b\b\b\b\b\b%7.3f%%',i*100/numel(pref));
end
fprintf('\n');
%%
[yp,p1, h] = getBestPreference(pref',numcls,true);
text(pref(2),50,'Modified Euclidean similarity');
fprintf('Best Cluster number %i\n',yp);
idx = apcluster(sim,p1,'dampfact',.9);
ari = adjRandIndex( grp,idx );
fprintf('Adjusted RAND Index %f\n',ari);
text(pref(2),100,['Adjusted Rand Index -- ' num2str(ari)]);
str = sprintf('Iris dataset N-%d C-%d D-%d',size(data,1),...
        numel(unique(grp)),size(data,2));
title(str);
return;
%%
colorMap = jet(numel(unique(grp)));
uGrp = unique(grp);
figure; hold on;
for i = 1:numel(uGrp)
    plot(data(grp==uGrp(i),1),data(grp==uGrp(i),2),'o','MarkerEdgecolor','none',...
        'MarkerFaceColor',colorMap(i,:));
end
hold off;
title(str);


