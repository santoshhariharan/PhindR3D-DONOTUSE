% Projects_Run2_AllChannel_WITHBKG11_SVVAL_6MVVAL_6_SVCAT15_MVCAT40_output_08-Feb-2017
clear ;clc;close all;
rootDir = 'F:\Projects\PhlippNeuron\PerkinElmerDataset\Images_Autophagy_2\SplitImages';
filename = 'Projects_Run2_AllChannel_WITHBKG11_SVVAL_6MVVAL_6_SVCAT15_MVCAT40_Well_output_08-Feb-2017.txt';
txtEnd = 12;

try
    fid = fopen(fullfile(rootDir,filename),'r');
    hdr = regexp(strtrim(fgetl(fid)),'\t','split');    
    fclose(fid);
    formatStr = [repmat('%s\t',1,txtEnd) repmat('%f\t',1,numel(hdr) - txtEnd)];
    fid = fopen(fullfile(rootDir,filename),'r');
    t = textscan(fid,formatStr,'Headerlines',1,'delimiter','\t');
    fclose(fid);
catch expc
    fclose(fid);
    rethrow(expc);
end
t1={};
for i = 1:txtEnd
    t1 = [t1 t{1,i}];
end
t2 = cell2mat(t(:,txtEnd+1:end));clear t fid hdr formatStr expc; 
ii = sum(isnan(t2),2)==0;
t2 = t2(ii,:);
t1 = t1(ii,:);
numFb = t2(:,end);
t2 = t2(:,1:end-1);


% Compound for Filtering
ii = strcmpi(t1(:,8),'Chloroquine');
t1 = t1(ii,:);
t2 = t2(ii,:);
conc = t2(:,1);
t2 = t2(:,2:end);
% redData = compute_mapping(t2,'t-SNE',3);
[~,redData] = princomp(t2);redData = redData(:,1:3);

%  Map data linearly first

[nS,I] = sort(redData(:,1),'ascend');
mP = (.9.*((nS-min(nS))./(max(nS)-min(nS))))+.1;
redData = redData(I,:);
conc = conc(I,:);
t1 = t1(I,:);
t2 = t2(I,:);
mP = 1-mP;
% Map marker size with concentration
mSize = zeros(size(t2,1),1);
uConc = unique(conc);
mVal = 20;
for i = 1:numel(uConc)
    ii = conc == uConc(i);
    mSize(ii) = mVal;
    mVal = mVal+20;
end


% Create ColorMap with gradient degrees for each cell line alon PCA 1 axis

% mapColor = [0 0 1; 0 1 0; 1 0 0];
uCells = unique(t1(:,9));

% mSize = [2:2:20];
figure; hold on;
for i =1:numel(uCells)
    ii = strcmpi(uCells{i,:},t1(:,9));
    numC = sum(ii);
    cMap = mP(ii)';
    if(i == 1)
%         cMap = [cMap' cMap' ones(numel(cMap),1)];
        cMap = [zeros(numel(cMap),1) zeros(numel(cMap),1) cMap'];
    elseif(i==2)
%         cMap = [cMap' ones(numel(cMap),1) cMap'];
        cMap = [zeros(numel(cMap),1) cMap' zeros(numel(cMap),1)];
    else
%         cMap = [ones(numel(cMap),1) cMap' cMap'];
        cMap = [cMap' zeros(numel(cMap),1) zeros(numel(cMap),1)];
    end
%     cMap = cMap(1:end-1,:);
    nredData = redData(ii,:);
    nConc = conc(ii);
    nMSize = mSize(ii);
%     [~,I] = sort(nredData(:,1),'ascend');
%     nredData = nredData(I,:);
%     nMSize = nMSize(I,:);
%     colormap(cMap);
    scatter3(nredData(:,1),nredData(:,2),nredData(:,3),nMSize,cMap,'filled');
    
    
    
%     for j = 1:numel(uConc)
%         jj = conc == uConc(j);
%         kk = and(ii,jj);
%         nredData = redData(kk,:);
%         plot3(redData(kk,1),redData(kk,2),redData(kk,3),'o','MarkerFacecolor',mapColor(i,:),...
%             'MarkerSize',mSize(1,j),'MarkerEdgeColor','None');
%     end
end
hold off;
xlabel('PCA1');ylabel('PCA2');zlabel('PCA3');
grid on;
view([-74.5 20])
