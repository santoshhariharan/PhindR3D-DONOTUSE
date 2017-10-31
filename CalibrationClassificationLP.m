% Run classification & compute accuracy, fscore and cohen's kappa
clc; clear; close all;
svval = [5:5:40];
mvval = [5:5:40];
boxSize = 6;
rootDir = 'F:\Projects\PhlippNeuron\Calibration\SVMV_SIZE_CATAnalsis_New';
column4controls = 4;
controlNames = {'BSSO';'GMAT25'};
fileList = dir(rootDir);
cohnKap = cell(numel(svval),numel(mvval));
accu = cell(numel(svval),numel(mvval));
% total = numel(svval)*numel(mvval)*10;
kf = 10;
queryVal = cell(numel(svval),numel(mvval));
for isv = 1:numel(svval)    
    for jmv = 1:numel(mvval)
        fprintf('SV: %i MV: %i...............',svval(isv),mvval(jmv));
        fNameSubStr = ['MVVAL_' num2str(boxSize) '_SVCAT' num2str(svval(isv)) '_MVCAT' num2str(mvval(jmv))];
        formatStr = [repmat('%s\t',1,9) repmat('%f\t',1,mvval(jmv)+1)];
        for i = 3:size(fileList)
            if(fileList(i).isdir)
                continue;
            end
            matchstart = regexpi(fileList(i).name,fNameSubStr);
            if(~isempty(matchstart))
                fileName = fileList(i).name;
            end            
        end
        fid = fopen(fullfile(rootDir,fileName),'r');
        t = textscan(fid,formatStr,'headerlines',1);
        fclose(fid);
        text=t{1,column4controls};
        data = cell2mat(t(1,10:end));
%         re
        ii = sum(isnan(data),2)==0;
        data = data(ii,:);
        text = text(ii,:);
%         re
        ii = false(size(data,1),1);
        for i = 1:numel(controlNames)
            ii = or(ii,strcmpi(controlNames{i,:},text));
        end
        cData = data(ii,:);
        cText = text(ii,1);
        B = TreeBagger(50,data(ii,:),text(ii,1),'Method','Classification','NVarToSample',floor(sqrt(size(data,2))));
        
        cPartition = cvpartition(cText,'kfold',kf);
        kap = zeros(1,kf);accuracy = zeros(1,kf);
        classUnk = zeros(1,kf);
        cnt = 1;
        for i = 1:kf
            B = TreeBagger(50,cData(cPartition.training(i),:),cText(cPartition.training(i),1),'Method','Classification','NVarToSample',floor(sqrt(size(data,2))));
            labels = predict(B,cData(cPartition.test(i),:));
            cMat = confusionmat(cText(cPartition.test(i),1),labels);
            labels = predict(B,data(~ii,:));
            classUnk(i) = sum(strcmpi(controlNames{1,1},labels)./numel(labels));
            p0 = cMat(1,1) + cMat(2,2);
            p0 = p0./sum(cMat(:));
            pe = ((cMat(1,1) + cMat(1,2))*(cMat(1,1) + cMat(2,1))) + ((cMat(2,1) + cMat(2,2))*(cMat(1,2) + cMat(2,2)));
            pe = pe./sum(cMat(:));
            pe = pe./sum(cMat(:));
            kap(i) = (p0-pe)./(1-pe);
            accuracy(i) = p0;
            fprintf('\b\b\b\b\b\b\b\b%7.3f%%',cnt*100/kf);
            cnt = cnt+1;
        end
        cohnKap{isv,jmv} = kap;
        accu{isv,jmv} = accuracy;
        queryVal{isv,jmv} = classUnk;
        fprintf('\n');
    end
end
%% Plot kappa curves
colorMap = jet(numel(svval));
% colorMap = [1 0 1];
leg = {};
jitVal = 1;
randVal=sort(-jitVal+2*jitVal*rand(numel(mvval),1));

figure;hold on;
for i = 1:numel(svval)
    meanMV = zeros(1,numel(mvval));
    stdMV = zeros(1,numel(mvval));
    for j = 1:numel(mvval)
        meanMV(j) = median(cohnKap{i,j});
        stdMV(j) = std(cohnKap{i,j});
    end
    errorbar(mvval+randVal(i),meanMV,stdMV,'-o','Color',colorMap(i,:),'Markerfacecolor',colorMap(i,:),'MarkerEdgeColor','none',...
            'LineWidth',2);
%     plot(mvval,meanMV,'-o','Color',colorMap(i,:),'Markerfacecolor',colorMap(i,:),'MarkerEdgeColor','none');
    leg = [leg;cellstr(['#SV Categories -' num2str(svval(i))])];
end
mRandVal =min(randVal);
maxRandVal = max(randVal);
for j = 1:numel(mvval)
    vert = [mvval(j)-jitVal 0;mvval(j)-jitVal 1.2;mvval(j)+jitVal 1.2;mvval(j)+jitVal 0];
    patch('Faces',[1 2 3 4],'Vertices',vert,'Facecolor',[.8 .8 .8],'FaceAlpha',.1,...
        'Edgecolor','none');
end
hold off;
set(gca,'XTick',mvval);
% set(gca,'XTickLabel',cellstr(num2str([5:5:40])));
% set(gca,'XTickLabelRotation',45);
ylabel('Crossvalidated Kappa');
% xlabel('Number of MV categories');
xlabel('Megavoxel categories')
legend(leg,'location','bestoutside');legend('boxoff');
% title('Cohens Kappa');
ylim([0 1.2]);
return;
%% Boxplot for densities

D = cell2mat(cohnKap')';
figure;
boxplot(D,'plotStyle','traditional','boxstyle','outline',...
        'jitter',0,'labels',{'0';'5';'10';'15';'20'},'notch','off','medianstyle','line',...
        'Whisker',3,'width',.3)
    xlabel('SD of Gaussian Kernel');
    ylabel('Crossvalidated Kappa');
    ylim([0 1.2])

%% Plot MK
figure;hold on;
for i = 1:numel(svval)
    meanMV = zeros(1,numel(mvval));
    stdMV = zeros(1,numel(mvval));
    for j = 1:numel(mvval)
        meanMV(j) = median(queryVal{i,j});
        stdMV(j) = std(queryVal{i,j});
    end
    errorbar(mvval+randVal(i),meanMV,stdMV,'-o','Color',colorMap(i,:),'Markerfacecolor',colorMap(i,:),'MarkerEdgeColor','none',...
        'LineWidth',2);
%     plot(mvval,meanMV,'-o','Color',colorMap(i,:),'Markerfacecolor',colorMap(i,:),'MarkerEdgeColor','none');
    leg = [leg;cellstr(['#Supervoxel Size -' num2str(svval(i))])];
end

hold off;
set(gca,'XTick',mvval);
ylabel('Crossvalidated Percent Classified BSSO');
% xlabel('Number of MV categories');
xlabel('Megavoxel Size')
legend(leg);title('Glutamate with MK801')
ylim([0 1]);



