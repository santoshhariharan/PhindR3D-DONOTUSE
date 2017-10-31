%% Input parameters
% clear all ;
clc;close all;warning off;
col4Vis = 9;
plateCol = 12;
% -----Read Input-------
[filename, pth] = uigetfile('.txt','Import source file');
try
    fid = fopen(fullfile(pth,filename),'r');
    header = regexp(strtrim(fgetl(fid)),'\t','split');  
    fclose(fid);
    formatStr = repmat({'%f\t'},1,numel(header));
    textHeaderCol = false(1,numel(header)); 
    [selection,~] = listdlg('ListString',header,'SelectionMode','Multiple',...
                        'Name','Select Text data');
    formatStr(1,selection) = {'%s\t'};
    formatStr = sprintf('%s',formatStr{:});                
    fid = fopen(fullfile(pth,filename),'r');
    t = textscan(fid,formatStr,'Headerlines',1,'delimiter','\t');
    fclose(fid);
catch expc
    fclose(fid);
    rethrow(expc);
end
textHeaderCol(1,selection) = true;
txtData = {};
for i = 1:numel(selection)
    txtData = [txtData t{1,selection(i)}];
end
data = cell2mat(t(1,~textHeaderCol));
txtHeader = header(1,textHeaderCol);
dataHeader = header(1,~textHeaderCol);

infRows = any(data == inf,2);
infRows = or(any(data == -inf,2),infRows);
infRows = or(any(isnan(data),2),infRows);
data(infRows,:)=[];
txtData(infRows,:)=[];

% Remove features that are same through most of the points
[~, fr] = mode(data);
fr = fr./size(data,1);
ii = fr<=.9;
fprintf('Following features were removed for no information \n');
fprintf('%s\n',dataHeader{1,~ii});
dataHeader = dataHeader(1,ii);
data = data(:,ii);
% Zscore data for normalization
% data = zscore(data);
[m,n] = size(data);
minD = min(data);
maxD = max(data);
data = bsxfun(@minus,data,minD);
data = bsxfun(@rdivide,data,maxD-minD);
clear pth filename fid header formatStr
clear textHeaderCol selection ok infRows 
clear fr ii 

%% Normalize data to untreated

treat2Norm = 'Untreated';
normCol = 10;
uTreatment = unique(txtData(:,plateCol));
grp = getGroupIndices(txtData(:,plateCol),uTreatment);
jj = strcmpi(txtData(:,normCol),treat2Norm);
nData = data;
for i = 1:numel(uTreatment)
    ii = grp == i;
    kk = and(ii,jj);
    mVec = mean(nData(kk,:));
    mVec = mVec + eps; % Low noise
    nData(ii,:) = bsxfun(@rdivide,nData(ii,:),mVec);    
end
nData = bsxfun(@rdivide,bsxfun(@minus,nData,min(nData)),max(nData) - min(nData));
%% Reduce data & plot
uTreatment = unique(txtData(:,col4Vis));
% uTreatment ={'BSSO';'GMAT25';'GMAT25MK';'GMAT25MSN0M';'Untreated'};
grp = getGroupIndices(txtData(:,col4Vis),uTreatment);
nuGrp = zeros(numel(uTreatment),1);
for i = 1:numel(uTreatment)
    fprintf('#%s - %i\n',uTreatment{i,:},sum(grp==i));
    nuGrp(i) = sum(grp==i);
end
fprintf('')
% cMap = [1 0 0;
%         0 0 1;
%         0 0 0;
%         .5 .5 .5;
%         1 1 0;
%         0 1 1;
%         1 0 1;
%         .5 .8 .2;
%         0 1 0;
%         0 .5 .5];
% cMap = [0.752941176	0	0;
%     0 0 0;
%     1 0 1;
%     1 .6 .6;
%     .8 .8 0;
%     0 .6 1;
%     .5 0 .5;
%     .7 .7 .7;
%     0 1 1;
%     1 0 0;
%     0 1 0];

% cMap = [.9	.9	.9;
%     .6 .6 .6;
%     .3 .3 .3;
%     0 0 0;
%     1 0 0;
%     .7 0 0;
%     .4 0 0;
%     .2 0 0;
%     0 1 0;
%     0 .7 0;
%     0 .4 0;
%     0 .2 0;
%     0 0 1;
%     0 0 .7;
%     0 0 .4;
%     0 0 .2;
%     0 1 1;
%     1 0 1];
% cMap = cMap./255;
%% Group to remove
gp2Ret = [1:max(grp) ];
ii = false(numel(grp),1);
for i  = 1:max(grp)
    if(sum(gp2Ret==i)>0)
        ii = or(ii,grp==i);
    end
end
nData = nData(ii,:);
txtData = txtData(ii,:);
grp = grp(ii,1);
%%
redData = compute_mapping(nData,'t-SNE',2);  
%%
treatment4Vis = [unique(grp) ];
figure;hold on;
for i = 1:numel(treatment4Vis)
    ii = grp == treatment4Vis(i);
    plot(redData(ii,1),redData(ii,2),'o','MarkerFaceColor',cMap(i,:),...
        'MarkerEdgeColor','none','MarkerSize',5);
%     plot3(redData(ii,1),redData(ii,2),redData(ii,3),'o','MarkerFaceColor',cMap(i,:),...
%         'MarkerEdgeColor','none','MarkerSize',6);
end
hold off;
grid on;
legend(uTreatment(treatment4Vis),'Interpreter','None');
xlabel('t-SNE1');ylabel('t-SNE2');zlabel('t-SNE3');
%% Plot Means
figure;hold on;
for i = 1:numel(treatment4Vis)
    ii = grp == treatment4Vis(i);
%     plot(redData(ii,1),redData(ii,2),'o','MarkerFaceColor',cMap(i,:),...
%         'MarkerEdgeColor','none','MarkerSize',5);
    plot3(mean(redData(ii,1)),mean(redData(ii,2)),mean(redData(ii,3)),'o','MarkerFaceColor',cMap(i,:),...
        'MarkerEdgeColor','none','MarkerSize',12);
end
hold off;
grid on;
legend(uTreatment(treatment4Vis),'Interpreter','None');
xlabel('t-SNE1');ylabel('t-SNE2');zlabel('t-SNE3');
