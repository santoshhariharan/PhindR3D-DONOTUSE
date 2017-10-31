% load data
clc;clear;close all;
%% Gaussian
mu = [1 5];
Sigma = [1 .5; .5 2]; R = chol(Sigma);
z = repmat(mu,100,1) + randn(100,2)*R;
% r = .5 + (.5)*rand(100,1);
data = [randn(100,2);5+randn(100,2);z;3.5+randn(100,2)];
% data=zscore(data);
figure;hold on;
plot(data(1:100,1),data(1:100,2),'*r');
plot(data(101:200,1),data(101:200,2),'*b');
plot(data(201:300,1),data(201:300,2),'*g');
plot(data(301:400,1),data(301:400,2),'*k');
hold off;
grp = zeros(size(data,1),1);
grp(1:100) = 1;
grp(101:200) = 2;
grp(201:300) = 3;
%% Uniform
% r1 = -2 + 3*rand(100,2);
% r2 = 4 + 3*rand(100,2);
% r3 = 3 + 2*rand(100,2);
% r4 = 1+3*rand(100,2);
% data = [r1;r2;r3;r4];
% data=zscore(data);
% figure;hold on;
% plot(data(1:100,1),data(1:100,2),'*r');
% plot(data(101:200,1),data(101:200,2),'*b');
% plot(data(201:300,1),data(201:300,2),'*g');
% plot(data(301:400,1),data(301:400,2),'*k');
% hold off;
% grp = zeros(size(data,1),1);
% grp(1:100) = 1;
% grp(101:200) = 2;
% grp(201:300) = 3;
% grp(301:400) = 4;
%%
% data = iris_dataset';
data = zscore(data);
clc;
sim = pdist2(data,data,'euclidean');
sim = max(sim(:)) - sim;
% sim = -1*pdist2(data,data,'euclidean');
% sim = 1-pdist2(data,data,'spearman');
% pmed = quantile(sim(:),.05);
% sim(sim<pmed) = -inf;
[pmin,pmax] = preferenceRange(sim);
numStep = 100;
% pmax = median(sim(:));
pref = pmin:(pmax-pmin)/numStep:pmax;
% pref = pref(1:end-1);
numcls = zeros(numel(pref),1);
fprintf('Completed................')
for i = 1:numel(pref)
    id = apcluster(sim,pref(i),'dampfact',.9,'Maxits',2000);
    numcls(i) = numel(unique(id));
    fprintf('\b\b\b\b\b\b\b\b%7.3f%%',i*100/numel(pref));
end
fprintf('\n');
%%
[yp,p1] = getBestPreference(pref',numcls,true);
fprintf('Best Cluster number %i\n',yp);
% return;
%     figure; hold on;plot(pref,numcls,'-r','Markerfacecolor','r');
% maxabd = zeros(numel(pref),1);
% delPref = (pmax-pmin)/numStep;
% 
% for i = 2:numel(pref)-1    
%     maxabd(i) = (numcls(i+1) + numcls(i-1) - 2 * numcls(i))./delPref.^2;    
%     maxabd(i) = maxabd(i)./((1+((numcls(i+1) - numcls(i-1))./(2*delPref)).^2).^1.5);
% end
% maxabd = abs(maxabd(1:end-1));
% [i1] = max(maxabd);
% ii = find(maxabd==i1);
% ii = max(ii);
% optCls = round(numcls(ii));
% plot(pref(ii),numcls(ii),'og','MarkerFaceColor','g');
% return;

% Compute clustering agreement
%
idx = apcluster(sim,p1,'dampfact',.9);
uIdx =unique(idx);
ari = adjRandIndex( grp,idx );
fprintf('Adjusted RAND Index %f\n',ari);
% mp = {'r';'g';'b';'k';'y';'m'};
% figure; hold on;
% for i = 1:numel(uIdx)
%     plot(data(idx==uIdx(i),1),data(idx==uIdx(i),2),'o','Markerfacecolor',mp{i,:});
% end
% hold off;
% mdl = LinearModel.fit(numcls,pref)






