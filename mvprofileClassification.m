% Load parameter file
% Load text file for respective controls
% Compute enrichment
% Compute MV categories enriched for treatments specified
% Classify other MV categories based on these
pFile = 'U:\Projects\Philipp-Neuron\Data\Opera\SinglePlateData\PM_20160204_YASCPgmat\Projects_Run1_AllChannel_WITHBKG_MV10_parameter_20-Jul-2016.mat';
load(pFile);
rd = 'U:\Projects\Philipp-Neuron\Data\Opera\SinglePlateData\PM_20160204_YASCPgmat\MV\';
% load text files
fnames = {fullfile(rd,'Projects_Run1_AllChannel_WITHBKG_MV10_BSSO_MV_output_21-Jul-2016.txt');
          fullfile(rd,'Projects_Run1_AllChannel_WITHBKG_MV10_GMAT25_MV_output_21-Jul-2016.txt');
          };
treatment = {'BSSO';'GMAT25'};      


numText = 9;
numInt = size(param.megaVoxelBincenters,2);

formatstr = [];
for i = 1:(numText+numInt)
    if(i<=numText)
        formatstr = [formatstr '%s\t'];
    else
        formatstr = [formatstr '%f\t'];
    end
end
textData = cell(100000,numText);
data = -1*ones(100000,numInt);
cnt = 0;
for i = 1:size(fnames,1)
    try
        fid = fopen(fnames{i,:},'r');
        C = textscan(fid,formatstr,'headerlines',1);
        fclose(fid);        
    catch expc
        fclose(fid); 
        rethrow(expc);
    end
    m = size(C{1,1},1);
    for j = 1:numText
        textData(cnt+1:cnt+m,j) = C{1,j};
    end
    data(cnt+1:cnt+m,:) = cell2mat(C(1,numText+1:end));
    cnt = cnt+m;   
end

ii = sum(data,2) == -numInt;
textData = textData(~ii,:);
data = data(~ii,:);
%% Assign to bin centers
rProfile = zeros(2,size(param.megaVoxelBincenters,1)+1);
for i = 1:2
    ii = strcmpi(textData(:,4),treatment{i,:});
    [~,rProfile(i,:)] = getImageProfile(data(ii,:),true(sum(ii),1),param);
end
%%
p = enrich_score(rProfile);
pval = .0001;
fToKeep = p<=pval;
fToKeep = sum(fToKeep,1)>0;
fToKeep = fToKeep(2:end);
r2Profile = rProfile(:,fToKeep);
%%
param.megaVoxelBincenters = param.megaVoxelBincenters(fToKeep,:);
param.numMegaVoxelBins = size(param.megaVoxelBincenters,1);
%% 
listing = dir(rd); 
rProfile = zeros(20,size(param.megaVoxelBincenters,1)+1);
rowLabels={};
for i  = 3:size(listing)-1 
    if(listing(i).isdir)
        continue;
    end
    fprintf('%s\n',listing(i).name);
    try
        fid = fopen(fullfile(rd,listing(i).name),'r');
        C = textscan(fid,formatstr,'headerlines',1);
        fclose(fid);        
    catch expc
        fclose(fid); 
        fprintf('--Error!!!\n');
        continue;
    end
    m = size(C{1,1},1);
    textData = cell(m,numText);
    for j = 1:numText
        textData(:,j) = C{1,j};
    end
    rowLabels = [rowLabels;cellstr(unique(textData(:,4)))];
    data = cell2mat(C(1,numText+1:end));    
    fprintf('@@@@@\n');
%     Assign to closest centers
    tmp = getImageProfile(data,true(size(data,1),1),param);
    [~,rProfile(i,:)] = getImageProfile(data,true(size(data,1),1),param);
end
%%
rProfile = rProfile(sum(rProfile,2)>0,:);
%%
nrProfile = bsxfun(@rdivide,rProfile,sum(rProfile,2));

HeatMap(nrProfile,'Symmetric',false,'Colormap','redbluecmap','RowLabels',rowLabels)












