% Load parameter file
clear ; clc;
rPath = 'F:\Projects\PhlippNeuron\SinglePlateData\PM_20160204_YASCPgmat\Image';
fName = 'Projects_Run1_AllChannel_WITHBKG_MV10_output_20-Jul-2016.txt';
fName = fullfile(rPath,fName);
load(fullfile(rPath,'parameters.mat'));

% Read files


fid = fopen(fName,'r');
t = textscan(fid,param.formatString,'headerlines',1);
fclose(fid);

textEle = sum(param.textfeat);
textdata = {};
for i = 1:textEle
    textdata = [textdata t{1,i}];
end
data = cell2mat(t(1,~param.textfeat));
%% Select Treatment and data

%%
clc;
numRepeats = 1;
p = randperm(size(data,1),round(1*size(data,1)));
optCls = zeros(numRepeats,1);
for iRepeats = 1:numRepeats
    fprintf('Repeat #%i....',iRepeats);
    nData = data(p,:);    
    sim = -1*pdist2(nData,nData,'Euclidean');
    [pmin,pmax] = preferenceRange(sim);
    pmax = median(sim(:));
%     sim = sim.*(sim>pmed);
%     re
    numStep = 10;
    pref = pmin:(pmax-pmin)/numStep:pmax;
%     pref = pref(1:end-1);
    numcls = zeros(numel(pref),1);
    fprintf('Completed................')
    for i = 1:numel(pref)
        id = apcluster(sim,pref(i),'dampfact',.75,'maxits',1000);
        numcls(i) = numel(unique(id));
        fprintf('\b\b\b\b\b\b\b\b%7.3f%%',i*100/numel(pref));
    end
    fprintf('\n');
    i2 = numcls>1;
    pref = pref(i2);
    numcls = numcls(i2);
    figure; hold on;plot(pref,numcls,'-r','Markerfacecolor','r');
    maxabd = zeros(numel(numcls),1);  
    
   delPref = (pmax-pmin)/numStep;
%    delPref = 1;
%
for i = 2:numel(pref)-1    
%     maxabd(i) = ;  
    y11 = ((numcls(i+1) + numcls(i-1) - 2 * numcls(i))./(delPref.^2));
    y1 = (numcls(i+1) - numcls(i-1))./(2*delPref);
    maxabd(i) = y11./((1+(y1.^2)).^1.5);
%       maxabd(i) =   abs((numcls(i+1) + numcls(i-1) - 2 * numcls(i)));
end
%     figure; hold on;plot(pref,log(numcls),'-r','Markerfacecolor','r');
%     maxabd = abs(maxabd(1:end-1));
    [i1] = max(maxabd);
    ii = max(find(maxabd==i1));
    optCls(iRepeats) = round(numcls(ii));
    plot(pref(ii),(numcls(ii)),'og','MarkerFaceColor','g');hold off;
end
return;
%%

% Estimate linear curve
% mdlLinear = LinearModel.fit(pref,numcls,'RobustOpts','off');
% linearCoeff = mdlLinear.Coefficients.Estimate;
% linearCls = linearCoeff(1) + linearCoeff(1).*pref;
% figure; hold on;plot(pref,numcls,'-r','Markerfacecolor','r');
% plot(pref,linearCls,'-b','Markerfacecolor','b');hold off;
%%
uTreatment = unique(textdata(:,4));

cMap = [1 0 0;
        0 0 1;
        0 0 0;
        .5 .5 .5;
        1 1 0;
        0 1 1;
        1 0 1;
        .5 .8 .2;
        0 1 0;
        0 .5 .5];
    
redData = compute_mapping(data,'t-SNE',2);  
%%
% idx = apclusterK(sim,10);
idx = kmeans(data,10,'onlinephase','off','replicates',1000);
uIdx = unique(idx);
disp('done');
%% Plot reduced figure
figure; hold on;
for iTreatment = 1:numel(uTreatment)
    ii = strcmpi(uTreatment{iTreatment,:},textdata(:,4));
    plot(redData(ii,1),redData(ii,2),'o','MarkerFaceColor',cMap(iTreatment,:),'Markeredgecolor','none');
    
end
legend(uTreatment);
c ={};
figure; hold on;
for iClusters = 1:numel(uIdx)
    ii = idx == uIdx(iClusters);
    plot(redData(ii,1),redData(ii,2),'o','MarkerFaceColor',cMap(iClusters,:),'Markeredgecolor','none');
    c = [c cellstr(['Cluster' num2str(iClusters)])];
end
legend(c);
%%
% idx = apcluster(sim,pref(ii),'dampfact',.9);
uIdx = unique(idx);
dist = zeros(numel(uTreatment),numel(uIdx));
for iTreatment = 1:numel(uTreatment)
    ii = strcmpi(uTreatment{iTreatment,:},textdata(:,4));
    for j = 1:numel(uIdx)
        jj = idx == uIdx(j);
        dist(iTreatment,j) = sum(ii.*jj);
    end
end
dist = bsxfun(@rdivide,dist,sum(dist,2));
HeatMap(dist,'rowlabels',uTreatment,'Symmetric','false','Colormap','redbluecmap','columnlabels',c)




