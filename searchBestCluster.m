function [ yp,p1,h ] = searchBestCluster( sim,maxCluster )
%searchBestCluster Summary of this function goes here
%   Detailed explanation goes here

if(nargin==1)
    maxCluster = size(sim,1);
end
[pmin,pmax] = preferenceRange(sim);
% Coarse Preference Setting
numStep = 20;
pref = pmin:(pmax-pmin)/numStep:pmax;
numcls = zeros(numel(pref),1);
fprintf('Coarse Search................')
for i = 1:numel(pref)
    id = apcluster(sim,pref(i),'dampfact',.9,'Maxits',1000);
    numcls(i) = numel(unique(id));
    fprintf('\b\b\b\b\b\b\b\b%7.3f%%',i*100/numel(pref));
end
fprintf('\n');
[~,p1, ~] = getBestPreference(pref',numcls,true);

% Fine Search
ind = find(pref == p1);
numStep = 30;
stepSize = (pmax - pref(ind-1))/numStep;
npref = pref(ind-1):stepSize:pmax;
numcls = zeros(numel(npref),1);
fprintf('Fine Search................')
for i = 1:numel(npref)
    id = apcluster(sim,npref(i),'dampfact',.9,'Maxits',1000);
    numcls(i) = numel(unique(id));
    fprintf('\b\b\b\b\b\b\b\b%7.3f%%',i*100/numel(npref));
    if(numcls(i)>=maxCluster);
        break;
    end
end
npref = npref(1:i);
numcls = numcls(1:i);
fprintf('\n');
[yp,p1, h] = getBestPreference(npref',numcls,true);
end

