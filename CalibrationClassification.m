% Run classification & compute accuracy, fscore and cohen's kappa
clc; clear; close all;
svval = [20];
mvval = [40];
rootDir = 'F:\Projects\PhlippNeuron\OutputImageMask\Image';
column4controls = 5;
% controlNames = {'BSSO';'GMAT25';'GMAT25MK';'Untreated'};
fileList = dir(rootDir);
cohnKap = cell(numel(svval),numel(mvval));
accu = cell(numel(svval),numel(mvval));
% total = numel(svval)*numel(mvval)*10;
kf = 5;
% queryVal = cell(numel(svval),numel(mvval));
numNumericCol = 40;
numTextCol = 5;
for isv = 1:numel(svval)    
    for jmv = 1:numel(mvval)
        fprintf('SV: %i MV: %i...............',svval(isv),mvval(jmv));
        fNameSubStr = ['_SVCAT' num2str(svval(isv)) '_MVCAT' num2str(mvval(jmv))];
        formatStr = [repmat('%s\t',1,numTextCol) repmat('%f\t',1,numNumericCol)];
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
        utext = unique(text);
        controlNames = utext;
        data = cell2mat(t(1,10:end));
        ii = sum(isnan(data),2)==0;
        data = data(ii,:);
        text = text(ii,:);
        ii = false(size(data,1),1);
        for i = 1:numel(controlNames)
            ii = or(ii,strcmpi(controlNames{i,:},text));
        end
        cData = data(ii,:);
        cText = text(ii,1);
        queryNames = unique(text(~ii,:));
        B = TreeBagger(50,data(ii,:),text(ii,1),'Method','Classification','NVarToSample',floor(sqrt(size(data,2))));
        
        cPartition = cvpartition(cText,'kfold',kf);
        kap = zeros(1,kf);accuracy = zeros(1,kf);
        classUnk = zeros(1,kf);
        cnt = 1;
        cVal = cell(kf,numel(utext)-numel(controlNames));
        cMat1 = zeros(numel(controlNames),numel(controlNames),kf);
        for i = 1:kf
            B = TreeBagger(100,cData(cPartition.training(i),:),cText(cPartition.training(i),1),'Method','Classification','NVarToSample',floor(sqrt(size(data,2))));
            labels = predict(B,cData(cPartition.test(i),:));
            [cMat,order] = confusionmat(cText(cPartition.test(i),1),labels);
            cMat1(:,:,i) = cMat;
            labels = predict(B,data(~ii,:));
            classUnk(i) = sum(strcmpi(controlNames{1,1},labels)./numel(labels));
            p0 = cMat(1,1) + cMat(2,2);
            p0 = p0./sum(cMat(:));
            pe = ((cMat(1,1) + cMat(1,2))*(cMat(1,1) + cMat(2,1))) + ((cMat(2,1) + cMat(2,2))*(cMat(1,2) + cMat(2,2)));
            pe = pe./sum(cMat(:));
            pe = pe./sum(cMat(:));
            kap(i) = (p0-pe)./(1-pe);
%             accuracy(i) = p0;
            accuracy(i) = sum(diag(cMat))*100./sum(cMat(:));
            fprintf('\b\b\b\b\b\b\b\b%7.3f%%',cnt*100/kf);
            cnt = cnt+1;
            for jj = 1:size(cVal,2)
                kk = strcmpi(text,queryNames{jj,:});
                cVal{i,jj} = predict(B,data(kk,:));
%                 classUnk(i) = sum(strcmpi(controlNames{1,1},labels)./numel(labels));
            end
        end
        cohnKap{isv,jmv} = kap;
        accu{isv,jmv} = accuracy;
%         queryVal{isv,jmv} = classUnk;
        fprintf('\n');
    end
end
%% Unwind query data
cValMean = zeros(numel(queryNames),numel(controlNames));
cValStd = zeros(numel(queryNames),numel(controlNames));
% Loop through the answer
for j  = 1:size(cVal,2)
    tmp = zeros(size(cVal,1),numel(controlNames));
    for i = 1:size(cVal,1)        
        for kk = 1:numel(controlNames)
            t = strcmpi(cVal{i,j},controlNames{kk,:});
            tmp(i,kk) = sum(t);
        end
    end
    
    cValMean(j,:) = mean(tmp);
    cValStd(j,:) = std(tmp);
    
end
%% Plot bar graph
%% Plot kappa using box plots

% cohnKapMat = cell2mat(cohnKap')';
% % Create box plot
% positionVal = [1:.5:3.5];
% figure; hold on;
% boxplot(cohnKapMat,'Whisker',0,'boxstyle','outline',...
%     'jitter',.3,'labels',{'No Noise','SD.1','SD.2','SD.3','SD.4','SD.5'},...
%     'notch','off','width',.2,'symbol','ow','positions',positionVal,'outliersize',1,'Color',[1 0 0],...
%     'extrememode','compress','labelorientation','horizontal');
% ylim([-.3 1.3]);
% randShiftVal = .05;
% randVal=-randShiftVal+2*randShiftVal*rand(size(cohnKapMat,1),1);
% for i =1:size(cohnKapMat,2)
%     
%     plot(repmat(positionVal(i),10,1)+randVal,cohnKapMat(:,i),'o','MarkerFacecolor',[.5 .5 .5],'MarkerEdgeColor','none',...
%         'MarkerSize',5);
% end
% hold off;
% % xlabel('Blur Level');
% ylabel('Crossvalidated Cohens Kappa');
return;

%% Plot kappa curves
% colorMap = jet(numel(svval));
colorMap = [1 0 1];
leg = {};
randShiftVal = 0;
randVal=-randShiftVal+2*randShiftVal*rand(numel(mvval),1);
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
    leg = [leg;cellstr(['#Supervoxel Size -' num2str(svval(i))])];
end

hold off;
set(gca,'XTick',mvval);
set(gca,'XTickLabel',{'NoBlur';'SD.1';'SD.2';'SD.3';'SD.4';'SD.5'});
% set(gca,'XTickLabelRotation',90);
ylabel('Crossvalidated Kappa');
% xlabel('Number of MV categories');
% xlabel('Megavoxel Size')
% legend(leg);
title('Cohens Kappa');
ylim([0 1]);

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



