% Load parameter file
clear ; clc;
rPath = 'U:\Projects\Philipp-Neuron\Data\Opera\SinglePlateData\PM_20160204_YASCPgmat\NewAnalysis';
fName = 'PM_20160204_YASCPgmat_AllChannel_NoBkg_SVVAL_3MVVAL_3_SVCAT15_MVCAT40_output_11-May-2017.txt';
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

%% Reduce data from multi to 3D
redData = compute_mapping(data,'t-SNE',2);
%% Remove Treatment
treat2Remove = {'GMAT100';'GMAT100MK';'GMAT100MSN';'UNTREATED'};
ii = true(length(textdata),1);
for i = 1:numel(treat2Remove)
    ii(strcmpi(treat2Remove{i,:},textdata(:,4)),1) = false;
end
data = data(ii,:);
textdata = textdata(ii,:);

ii = sum(isnan(data),2)==0;
data = data(ii,:);
textdata = textdata(ii,:);
%% Reduce data
% redData = compute_mapping(data,'t-SNE',2);
% Define Map
uTxt = unique(textdata(:,4));
% mp = lines(numel(uTxt));
figure; hold on;
for i = 1:numel(uTxt)
    ii = strcmpi(uTxt{i,:},textdata(:,4));
    plot(redData(ii,1),redData(ii,2),'o',...
            'Markerfacecolor',mp(i,:),'Markeredgecolor','none',...
            'Markersize',6);
%     plot3(redData(ii,1),redData(ii,2),redData(ii,3),'o',...
%             'Markerfacecolor',mp(i,:),'Markeredgecolor','none',...
%             'Markersize',6);    
end
hold off;
legend(uTxt);
xlabel('tSNE1');ylabel('tSNE2');
% set(gca,'XTickLabel',[]);set(gca,'YTick',[]);
