%% Input parameters
% clear all ;
clc;close all;warning off;
col4Vis = 9;

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
fprintf('Removed %i rows \n',sum(infRows));
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
data = zscore(data);
[m,n] = size(data);
% minD = min(data);
% maxD = max(data);
% data = bsxfun(@minus,data,minD);
% data = bsxfun(@rdivide,data,maxD-minD);
clear pth filename fid header formatStr
clear textHeaderCol selection ok infRows 
clear fr ii 
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
%
cMap = [.11 .31 .45;
    .16 .45 .65;
    .2 .6 .86;
    .29 .14 .35;
    .42 .32 .51;
    .56 .27 .65;
    .47 .16 .12;
    .69 .23 .18;
    .91 .3 .24;
    .49 .4 .03;
    .72 .58 .04;
    .95 .77 .06;
    .47 .26 .07;
    .69 .38 .1;
    .9 .49 .13;
    .16 .22 .28;
    .14 .61 .34;
    .16 .71 .39;
    .18 .8 .44;
    .56 .58 .59];
% cMap = cMap./255;
%% Group to remove
% gp2Ret = [1:max(grp)];
gp2Ret = [1:6 8:10];
ii = false(numel(grp),1);
for i  = 1:max(grp)
    if(sum(gp2Ret==i)>0)
        ii = or(ii,grp==i);
    end
end
data = data(ii,:);
txtData = txtData(ii,:);
grp = grp(ii,1);
%%
numdims = 2;
rdType = 't-SNE';
addpath(genpath('U:\Projects\Philipp-Neuron\Code-V3\drtoolbox'))
if(numdims ~=3)
    numdims = 2;
end
redData = compute_mapping(data,rdType,numdims);  
% redData = mdscale(pdist2(data,data),2,'Start','random','replicates',10);
%%
treatment4Vis = [unique(grp)];
figure;hold on;
for i = 1:numel(treatment4Vis)
    ii = grp == treatment4Vis(i);
    if(numdims==3)
        plot3(redData(ii,1),redData(ii,2),redData(ii,3),'o','MarkerFaceColor',cMap(treatment4Vis(i),:),...
        'MarkerEdgeColor','none','MarkerSize',6);
    else
        plot(redData(ii,1),redData(ii,2),'o','MarkerFaceColor',cMap(treatment4Vis(i),:),...
            'MarkerEdgeColor','none','MarkerSize',6);
    end
%     
end
hold off;
grid on;
legend(uTreatment(treatment4Vis),'Interpreter','None');
xlabel([rdType num2str(1)]);ylabel([rdType num2str(2)]);zlabel([rdType num2str(3)]);
%%
rootDir = 'Z:\HSH_MCF10AOncogene_20xW_20170825__2017-08-25T16_52_01-Measurement 1b\Images';
numChannels = 3;
numPlanes = 61;
coord = ginput(1);
dd = pdist2(redData,coord);
[~,I] = min(dd);
iValue = txtData(I,1);
iValue = regexpi(iValue,'\\','split');
fprintf('%s\n','SSS');
iValue = iValue{end};
iValue = iValue{end};
fprintf('%s\n',iValue);

% str = 'r02c02f01p01-ch1sk1fk1fl1.tiff';
exprIM = '(?<Well>\w+)f(?<Field>\d+)p(?<Stack>\d+)-ch(?<Channel>\d).*.tif(f)?';
channelCol = 4;
m = regexpi(iValue,exprIM,'Names');
allfNames = cell(numPlanes,numChannels);
for i = 1:numPlanes
    if(i<10)
        np = ['0' num2str(i)];
    else
        np = num2str(i);
    end
    for j = 1:numChannels
        allfNames{i,j} = fullfile(rootDir,[m.Well 'f' m.Field 'p' np '-ch' num2str(j) 'sk1fk1fl1.tiff']);        
    end
end
%% Get Bounding Box and centroids
II = find(strcmpi('Channel1_BB1',txtHeader));
bBox = str2num(char(txtData(I,II:II+3)'))';
cent = str2num(char(txtData(I,II+4:II+5)'))';

%%
colors = [0 1 0;1 0 0;0 0 1];
gammaVal = [3 .5 .6];
% h = figure;
for i = 25:size(allfNames,1)
    im3D = getMerged3DImage(allfNames(i,:),colors,gammaVal);
%     im3D = getMerged3DImage(allfNames(i,3),colors(3,:),.4);
    I2=zeros(bBox(4)+1,bBox(3)+1,3);
    for k = 1:3
        I2(:,:,k) = imcrop(im3D(:,:,k), bBox);
        
    end
%     I2 = imadjust(I2,[],[],gammaVal);
    figure;imshow(I2,[]);
    re
    
end






%% Plot Means
% figure;hold on;
% for i = 1:numel(treatment4Vis)
%     ii = grp == treatment4Vis(i);
% %     plot(redData(ii,1),redData(ii,2),'o','MarkerFaceColor',cMap(i,:),...
% %         'MarkerEdgeColor','none','MarkerSize',5);
%     plot3(mean(redData(ii,1)),mean(redData(ii,2)),mean(redData(ii,3)),'o','MarkerFaceColor',cMap(i,:),...
%         'MarkerEdgeColor','none','MarkerSize',12);
% end
% hold off;
% grid on;
% legend(uTreatment(treatment4Vis),'Interpreter','None');
% xlabel('t-SNE1');ylabel('t-SNE2');zlabel('t-SNE3');
% %%
% C = clsIn(data);
% step = 100;
% pref = [C.pmin:(C.pmax - C.pmin)./step:C.pmax];
% yCls = zeros(numel(pref),1);
% for i = 1:numel(pref)
%     idx = apcluster(C.S,pref(i),'dampfact',.9);
%     yCls(i) = numel(unique(idx));
% end
% k = getBestPreference( pref',yCls,true );
% disp('Done')
% %%
% C = clsIn(data);
% idx = apclusterK(C.S,k);
% % viewScatterPie2(redData,idx,txtData(:,col4Vis),cMap)
% uIdx= unique(idx);
% uGrp = unique(grp);
% conMat = zeros(numel(uGrp),numel(uIdx));
% for i  = 1:numel(uGrp)
%     ii = grp == uGrp(i);
%     fprintf('%s\n',uTreatment{uGrp(i)});
%     for j = 1:numel(uIdx)
%         jj = idx == uIdx(j);
%         conMat(i,j) = sum(ii.*jj);
%         
%     end
% end
% % ylim([-60 60]);ylim([-50 40]);
% %% 
% viewScatterPie2(redData,idx,txtData(:,col4Vis),cMap(treatment4Vis,:));
% HeatMap(bsxfun(@rdivide,conMat,sum(conMat,2)),'RowLabels',unique(txtData(:,col4Vis)),...
%         'Symmetric',false,'Colormap',redbluecmap);
% %%
% conMat = bsxfun(@rdivide,conMat,sum(conMat,2));
% redData2 = compute_mapping(conMat,'Sammon',2); 
% figure;hold on;
% for i = 1:numel(uGrp)
%    
%     plot(redData2(i,1),redData2(i,2),'o','MarkerFaceColor',cMap(i,:),...
%         'MarkerEdgeColor','none','MarkerSize',10);
% %     plot3(mean(redData(ii,1)),mean(redData(ii,2)),mean(redData(ii,3)),'o','MarkerFaceColor',cMap(i,:),...
% %         'MarkerEdgeColor','none','MarkerSize',12);
% end
% hold off;
% legend(uTreatment(treatment4Vis),'Interpreter','None');
