

%% Read data
clear ; close all; clc;
rootDir = 'F:\Projects\PhlippNeuron\SinglePlateData\PM_20160204_YASCPgmat\Image';
fileName = 'PM_20160204_YASCPgmat_Run2_AllChannel_WITHBKG11_SVVAL_6MVVAL_6_SVCAT20_MVCAT40_output_12-Oct-2016.txt';
dataStartCol = 10;
formatStr = [repmat('%s\t',1,dataStartCol-1) repmat('%f\t',1,41)];

colVis = 4;
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
repeatColumn = 8;ouputColumn = 9;
controlNames = {'BSSO';'GMAT25';'GMAT25MK'};
uniqueText = unique(textData(:,ouputColumn));
uRepeat = unique(textData(:,repeatColumn));
distMat = zeros(numel(unique(textData(:,ouputColumn))),numel(controlNames),numel(uRepeat));
for i = 1:numel(uRepeat)
    controlRepeat = ~strcmpi(uRepeat{i,:},textData(:,repeatColumn));
%     allData = data(controlRepeat,:);
%     allText = textdata(controlRepeat,:);
    fprintf('In repeat %s\n',uRepeat{i,:});
    ii = false(size(data,1),1);
    for j = 1:numel(controlNames)
        ii = or(ii,strcmpi(controlNames{j,:},textData(:,colVis)));
    end
    ii = and(ii,controlRepeat);
    B = TreeBagger(50,data(ii,:),textData(ii,colVis),'Method',...
        'Classification','NVarToSample',floor(sqrt(size(data,2))));
    unklabels = predict(B,data(~ii,:));
    
    for j = 1:numel(uniqueText)
        jj = strcmpi(uniqueText{j,:},textData(~ii,ouputColumn));
        if(sum(jj)<=0)
            continue;
        end
        
        for k = 1:numel(controlNames)
            kk = strcmpi(controlNames{k,:},unklabels);
            distMat(j,k,i) = sum(jj.*kk);
        end
    end
end
disp('DDD');
%% Run Clustering 


%% Compute Distribution matrix based on user defined column

%% Reduce data using t-SNE plot

%% Plot treatment disribution


%% Plot cluster pie chart

 