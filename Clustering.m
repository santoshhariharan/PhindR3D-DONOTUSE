% Open file for clustering
clc;clear;
fName = 'Projects_Run1_AllChannel_WITHBKG_MV10_output_20-Jul-2016.txt';
% Load parameters
load('parameters.mat');

% Read file
try
    fid = fopen(fName,'r');
    t = textscan(fid,param.formatString,'headerlines',1);
    fclose(fid);
catch expc
    fclose(fid);
    rethrow(expc);
end
textdata = {};
for i = 1:sum(param.textfeat)
    textdata = [textdata t{1,i}];
end
data  = cell2mat(t(:,~param.textfeat));
tFactor = .5;
% sim = pdist2(data,data,'euclidean');
%%
% m = size(data,1);
% sim = single(zeros(m*(m-1)/2,3));
% sim(:,3) = pdist(data);
% cnt = 1;
% for i = 1:m
%     for j = i+1:m
%         sim(cnt,1) = j;sim(cnt,2) = i;
%         cnt =cnt+1;
%     end
% end
% sim(:,3) = -sim(:,3);

% tFactor = .5;
% distanceThreshold = quantile(sim(:,3),tFactor);
% ii = sim(:,3)>distanceThreshold;
% sim = sim(ii,:);
% C1 = clsIn(data);
clc;
sim = -1*pdist2(data,data,'Cityblock');
pmed = median(sim(:)); 
[pmin, pmax] = preferenceRange(sim);
maxPIter = [1:100];
allData = zeros(numel(maxPIter),2);
fprintf('In iteration.....................')
for i = 1:numel(maxPIter)
    fprintf('\b\b%2d',i);
    pref = pmed-((pmed-pmin)/(2.^maxPIter(i)));
    idx = apcluster(sim,pref,'dampfact',.8);
    allData(i,1) = pref;
    allData(i,2) = numel(unique(idx));
    
end

fprintf('Completed \n');
%%
plot(allData(:,1),allData(:,2))
%%

idx = apclusterK(sim,9);



