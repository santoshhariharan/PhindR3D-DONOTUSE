

%% Read data
clear ; close all; clc;
% rootDir = 'F:\Projects\PhlippNeuron\SinglePlateData\PM_20160204_YASCPgmat\Image';
rootDir = 'F:\Projects\PhlippNeuron\PerkinElmerDataset\Images_Autophagy_2\Images_Autophagy_2';
% fileName = 'PM_20160204_YASCPgmat_Run2_AllChannel_WITHBKG11_SVVAL_6MVVAL_6_SVCAT20_MVCAT40_output_12-Oct-2016.txt';
fileName = 'Projects_PE1_AllChannel_WITHBKG_SVCAT20_MVCAT40_output_01-Dec-2016.txt';
dataStartCol = 12;
formatStr = [repmat('%s\t',1,dataStartCol-1) repmat('%f\t',1,41)];

colVis = 11;
try
    fid = fopen(fullfile(rootDir,fileName),'r');
    t = textscan(fid,formatStr,'headerlines',1);
    fclose(fid);
catch expc
    fclose(fid);
    rethrow(expc);
end
textData={};
for i = 1:dataStartCol-1
    textData = [textData t{1,i}];
end
data = cell2mat(t(1,dataStartCol:end));
ii = sum(isnan(data),2)==0;
data = data(ii,:);
textData = textData(ii,:);
%% Select control data

% controlNames = {'BSSO';'GMAT25';'GMAT25MK';'GMAT25MSN';'UNTREATED'};
controlNames = unique(textData(:,colVis));
ii = false(size(data,1),1);
for i = 1:numel(controlNames)
    ii = or(ii,strcmpi(controlNames{i,:},textData(:,colVis)));
end
data = data(ii,:);
textData = textData(ii,:);
%% Run Clustering 
sim = -1*pdist2(data,data,'Euclidean');
[pmin,pmax] = preferenceRange(sim);
numStep = 100;
pref = pmin:(pmax-pmin)/numStep:pmax;
numcls = zeros(numel(pref),1);
fprintf('Completed................')
for i = 1:numel(pref)
    id = apcluster(sim,pref(i),'dampfact',.9,'Maxits',1000,'convits',100);
    numcls(i) = numel(unique(id));
    fprintf('\b\b\b\b\b\b\b\b%7.3f%%',i*100/numel(pref));
end
fprintf('\n');
%%
[yp,p1, h] = getBestPreference(pref',numcls,true);
idx = apcluster(sim,p1,'dampfact',.9,'Maxits',1000,'convits',100);
%% Compute Distribution matrix based on user defined column
fprintf('Computing distribution matrix........\n');
uniCol = unique(textData(:,colVis));
uniIdx = unique(idx);

disMat = zeros(numel(uniCol),numel(uniIdx));% Percentage of treatment in every cluster

for iTreatments = 1:numel(uniCol)
    ii = strcmpi(uniCol{iTreatments,:},textData(:,colVis));
    for jClusters = 1:numel(uniIdx)
        jj = idx==uniIdx(jClusters);
        disMat(iTreatments,jClusters) = sum(ii.*jj);
    end
end
%% Reduce data using t-SNE plot
numDims = 2;
redData = compute_mapping(data,'t-SNE',numDims);
%% Plot treatment disribution
% load('colormap.mat');
mp = jet(numel(uniCol));
mSize = [1 2 3 5 7 10 12 14];
uConc = unique(textData(:,8));
figure;hold on;
for iTreatments = 1:numel(uniCol)
    ii = strcmpi(uniCol{iTreatments,:},textData(:,colVis));
    if(numDims ==2)
        plot(redData(ii,1),redData(ii,2),'o','MarkerEdgeColor','none',...
        'MarkerFaceColor',mp(iTreatments,:));
    else
        
        plot3(redData(ii,1),redData(ii,2),redData(ii,3),'o','MarkerEdgeColor','none',...
        'MarkerFaceColor',mp(iTreatments,:));
        
    end
end
hold off;grid on;
xlabel('t-SNE1');ylabel('t-SNE2');
if(numDims ==3)
    zlabel('t-SNE3');
end
l = legend(uniCol);
set(l,'Interpreter','none','Location','bestoutside');
disp('@@@@@@@');


%% Plot cluster pie chart
[a,b] = view;
if(numDims==2)
viewScatterPie2(redData,idx,textData(:,colVis),mp);
else
[~,ah] = viewScatterPie3(redData,idx,textData(:,colVis),mp,[a b]);
end
% 
% rotate(ah,[1 1 0],90+b,[0 0 0]);
% rotate(ah,[0 0 1],a,[0 0 0]);
    
return;
 