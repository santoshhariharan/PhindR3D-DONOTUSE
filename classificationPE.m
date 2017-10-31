% Projects_Run2_AllChannel_WITHBKG11_SVVAL_6MVVAL_6_SVCAT15_MVCAT40_output_08-Feb-2017

rootDir = 'F:\Projects\PhlippNeuron\PerkinElmerDataset\Images_Autophagy_2\SplitImages';
filename = 'Projects_Run2_AllChannel_WITHBKG11_SVVAL_6MVVAL_6_SVCAT15_MVCAT40_output_08-Feb-2017.txt';
txtEnd = 13;

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
t2 = cell2mat(t(:,txtEnd+1:end));
ii = sum(isnan(t2),2)==0;
t2 = t2(ii,:);
t1 = t1(ii,:);
cntrl = {'PANC-1_NEGATIVE';'PANC-1_POSITIVE'};
cGrp = getGroupIndices(t1(:,end),cntrl);

nT = t2(cGrp>0,:);
nG = cGrp(cGrp>0);
cPar = equalTrainingSamplePartition(nG,floor(.7.*min(sum(nG==1),sum(nG==2))));
mdl = classRF_train(nT(cPar.training,:),nG(cPar.training,:),100,sqrt(41));
lbl = classRF_predict(nT(cPar.test,:),mdl);

allLbl = classRF_predict(t2(cGrp==0,:),mdl);
uTrt = unique(t1(cGrp==0,end-1));
nT = t1(cGrp==0,end-1);
nMat = zeros(numel(uTrt),2);
for i =1:numel(uTrt)
    ii = strcmpi(uTrt{i,:},nT);
    for j = 1:2
        jj = allLbl==j;
        nMat(i,j) = sum(ii.*jj);
    end
end

cMat = confusionmat(nG(cPar.test),lbl);
nMat = [nMat;cMat];





