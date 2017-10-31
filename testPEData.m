% Custom script for PE data

fileName = 'Projects_PE1_AllChannel_WITHBKG_SVCAT20_MVCAT40_Well_output_01-Dec-2016.txt';
rootPath='F:\Projects\PhlippNeuron\PerkinElmerDataset\Images_Autophagy_2\Images_Autophagy_2';
load(fullfile(rootPath,'Classification','parameters.mat'));
try
    fid = fopen(fullfile(rootPath,fileName),'r');
    t = textscan(fid,param.formatString,'Headerlines',1,'Delimiter','\t');
    fclose(fid);
catch ecpc
    fclose(fid);
    rethrow(ecpc);
end
t1 = cell(81,11);
for i = 1:11
    t1(:,i) = t{1,i};
end
t2 = cell2mat(t(:,13:end-1));
ii = strcmpi('Chloroquine',t1(:,7));
t1 = t1(ii,:);
t2 = t2(ii,:);
% jj = strcmpi('0',t1(:,8));
% t1 = t1(~jj,:);
% t2 = t2(~jj,:);
%%
% [~,p] = princomp(t2);
p = compute_mapping(zscore(t2),'t-SNE',3);
% p = p(:,1:3);
%%
mSize = [4:18];
uCells = unique(t1(:,9));
% uConc = unique(t1(:,8));
cmap = [.5 .5 1;.5 1 .5;1 .5 .5];
uConc = {'0';'1.6';'3.125';'6.25';'12.5';'25';'50';'100'};
figure;hold on;
for i = 1:numel(uCells)
    ii = strcmpi(uCells{i,:},t1(:,9));
    for j = 1:numel(uConc)
        jj = strcmpi(uConc{j,:},t1(:,8));
        tmp = p(and(ii,jj),:);
%         plot(tmp(:,1),tmp(:,2),'o','MarkerSize',mSize(j),...
%             'MarkerFacecolor',cmap(i,:),'MarkerEdgeColor','none');
        plot3(tmp(:,1),tmp(:,2),tmp(:,3),'o','MarkerSize',mSize(j),...
            'MarkerFacecolor',cmap(i,:),'MarkerEdgeColor','none');
    end
end
hold off;
xlabel('Axis-1');
ylabel('Axis-2');
zlabel('Axis-3');
grid on;




