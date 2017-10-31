function [ h,allH ] = viewScatterPie3(x,y,yhat,map,viewVal)
%viewScatterPie Plots data in x using grouping in y with colours of yhat
% 
% 
allH=[];
if(size(x,2)>3)
    error('@viewScatterPie: Only three dmensional plot allowed');    
end

if(size(y,1)~=size(yhat,1))
    error('@viewScatterPie: y and yhat must be of same length');
end

uYhat = unique(yhat);
if(size(map,1) ~= numel(uYhat))
    map = jet(numel(uYhat)); % Default Color map
end
uY = unique(y);
% Compute distribution matrix
disMat = zeros(numel(uYhat),numel(uY));
for iTreatments = 1:numel(uYhat)
    ii = strcmpi(uYhat{iTreatments,:},yhat);
    for jClusters = 1:numel(uY)
        jj = y==uY(jClusters);
        disMat(iTreatments,jClusters) = sum(ii.*jj);
    end
end

rsize = sum(disMat,1);
rsize = rsize./sum(rsize);
scalingFact = 5;
rsize = rsize*scalingFact;
% First plot clusters with lines from centroid of each cluster
clMP = jet(numel(uY));
h=figure;hold on;
for iClusters = 1:numel(uY)
    if(iClusters==1)
%         break;
    end
    ii = y == uY(iClusters);
    for j = 1:numel(uYhat)
        jj = strcmpi(uYhat{j,:},yhat);
        kk = and(ii,jj);
        plot3(x(kk,1),x(kk,2),x(kk,3),'o',...
        'MarkerSize',6,'MarkerEdgeColor','none',...
        'MarkerFaceColor',clMP(iClusters,:));
    end
    
    cCenter = repmat(x(uY(iClusters),:),sum(ii),1);
    x1 = [cCenter(:,1) x(ii,1)];
    y1 = [cCenter(:,2) x(ii,2)];
    z1 = [cCenter(:,3) x(ii,3)];
    line(x1',y1',z1','Color',[.4 .4 .4],'MarkerSize',2,'MarkerEdgeColor','none',...
        'MarkerFaceColor',[.4 .4 .4],'LineWidth',.05,'LineStyle','-');
    
end
hold off;
view(viewVal(1),viewVal(2));
grid on;
xlabel('t-SNE1');ylabel('t-SNE2');zlabel('t-SNE3');
% return;
% return;
%
% In the same figure plot data using patches - Uses inbuilt Matlab function
% logic
% Plot pie charts in sperarate plot:
% Divide the dataset in such a way to have a maximum of 4 rows and 3
% columns
% If more than 12 clusters, then use a different subplot
% numSmallPatch = 30;
numTreatments = size(disMat,1);
% angleStart = 0;
numSteps = 30;
% rsize = 5;
% hold on;
allH = [];
numSubRows = 4;
if(mod(numel(uY),4)==0)
    numSubCols = floor(numel(uY)./4);
else
    numSubCols = floor(numel(uY)./4)+1;
end
% numSubCols = floor(numel(uY)./4)
pltCnt = 1;
for iClusters = 1:numel(uY)
    subplot(numSubRows,numSubCols,pltCnt);hold on;
    startAngle = 0;  
    treatProportion = disMat(:,iClusters)./sum(disMat(:,iClusters));
%     cCenter = x(uY(iClusters),:);
    hall=[];
    for jTreatment =  1:numTreatments
        step = treatProportion(jTreatment)*2*pi/numSteps;
        theta = [0 0:step:treatProportion(jTreatment)*2*pi 0];
        theta = theta + startAngle;
        [x1, y1] = pol2cart(theta,[0 rsize(iClusters).*(ones(1,numel(theta)-2)) 0]);
%         [x1, y1] = sph2cart(theta,[0 rsize(iClusters).*(ones(1,numel(theta)-2)) 0]);
%         x1 = x1 + cCenter(1,1);
%         y1 = y1 + cCenter(1,2);
%         z1 = repmat(cCenter(1,3),1,numel(x1));
        h1 = patch(x1,y1,jTreatment,'FaceColor',map(jTreatment,:),'EdgeColor','none');
%         hall = [hall;h1];
        startAngle = max(theta);         
    end  
    hold off;
    axis off;title(['Cluster - ' num2str(iClusters)],'Color',clMP(iClusters,:),...
        'FontWeight','Bold');
    axis fill;
    pltCnt = pltCnt+1;
    if(iClusters==1)
%         legend(hall,uYhat,'Location','westoutside');
    end
%     allH = [allH;hall];
%     [a1, b1,c1] = sph2cart(viewVal(1),0,5);
%     rotate(hall,[0 0],viewVal(1));
%     rotate(hall,[1 0 0],90-viewVal(2),[0 0 0]);
%     rotate(hall,[0 0 1],viewVal(1),[0 0 0]);
%     re
%     rotate(hall,[0 0 cCenter(1,3)],-viewVal(2)+90);
%     disp('hi');
%     legend(uYhat)
end

% view(viewVal(1),viewVal(2));
% ax = gca;
% rotate(ax,[0 0 1],viewVal(1));
% rotate(ax,[1 1 0],viewVal(2));

% clear hall
% view(viewVal(1),viewVal(2));
% grid on;
% xlabel('t-SNE1');ylabel('t-SNE2');zlabel('t-SNE3');


% 
end

