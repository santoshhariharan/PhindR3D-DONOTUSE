
clear ; clc;
% Load paramater file
% Define root directory
rootDir = 'F:\Projects\PhlippNeuron\PaperData';
paramFile = fullfile(rootDir,'Projects_Run1_AllChannel_WITHBKG_MV10_parameter_21-Jul-2016.mat');
load(paramFile);
opFolder = 'outputfiguresColor'; 
mkdir(opFolder);
% Read Metadatafile
metaFile = fullfile(rootDir,'metadatafile.txt');
formatString = repmat('%s\t',1,9);
fid = fopen(metaFile,'r');
ft = textscan(fid,formatString,'headerlines',1);
treatmentCol = 4;
txt ={};
for i = 1:size(ft,2)
    txt = [txt ft{1,i}];
end
%%
%% Load images in 3D:
% numZPlane = 21;
allImage = zeros(400,400,6);% Use this for multichannel pixel category over 
                            % Z planes
zPlane = [4:9];
rect = [527 151 399 399];
nChan = 3;
toggleCBar = true;
svImage1 = zeros(400,400,3);cnt=1;
svImage2 = zeros(400,400,3);
for nz = 1:numel(zPlane)
    if(zPlane(nz)<10)
        zText = ['Z00' num2str(zPlane(nz))];
    else
        zText = ['Z0' num2str(zPlane(nz))];
    end
%     zPlane = 'Z003';
    ii = strcmpi(zText,txt(:,7));    
    mData = txt(ii,:);
    imageInfo = imfinfo(mData{1,1});
    IM = zeros(imageInfo.Height,imageInfo.Width,3);

    for i = 1:nChan
        P  = imread(mData{1,i});
        P = rescaleIntensity(P,param.lowerbound(i),param.upperbound(i));
        P = P.*(P>param.intensityThreshold(i));
%         v(i) = var(P(:));
%         P = (P-min(P(:)))./(max(P(:)) - min(P(:)));
        IM(:,:,i) = P;
    end
%     Crop image
    IM = IM(rect(1):rect(1)+rect(3),rect(2):rect(2)+rect(3),:);
%     Write Individual data files 
    channelMap = [0 1 0;1 0 0;0 1 1 ];    
    IM1 = zeros(400,400,3);
    outputFileName = [ 'Image_' zText '.png'];
    for j = 1:3
        for i = 1:nChan
            P = rescaleIntensity(IM(:,:,i),min(min(IM(:,:,i))),max(max(IM(:,:,i))));
            IM1(:,:,j) = IM1(:,:,j)+((channelMap(i,j).*P));
        end
%         IM1(:,:,j) = rescaleIntensity(IM1(:,:,j),0,max(quantile(IM1(:,:,j),.999)));
    end    
    imwrite(IM1,fullfile(pwd,opFolder,outputFileName),'png');
    
% Compute Pixel categories    
    IM = reshape(IM,400*400,3);
    ii = bsxfun(@gt,IM,param.intensityThreshold);
    ii = sum(ii,2)==0;
    IM1 = knnclassify(IM, param.pixelBinCenters, [1:size(param.pixelBinCenters,1)]);
    IM1(ii,:)=0;    
    IM1=  (reshape(IM1,400,400));
    
    allImage(:,:,cnt) = IM1;
    cnt = cnt+1;
    map = jet(size(param.pixelBinCenters,1));
    map = [0 0 0;map];
    if(toggleCBar)
        h=figure;
%         imshow(IM1,[]);
        imagesc(IM1);colormap(map);
        colorbar('Ticks',[],...
            'TickLabels',[]);
%         colorbar;
        caxis([0 size(param.pixelBinCenters,1)])
%         colorbar;
        saveas(h,fullfile(pwd,opFolder,'pixelCBar.png'),'png');
        close(h);
        toggleCBar = false;
    end
    outputFileName = [ 'Image_Pixel_category_' zText '.png'];
    
    imwrite(uint8(IM1),map,fullfile(pwd,opFolder,outputFileName),'png');
    
    %   Write Grided Data
    IM1(1:10:400,:) = size(param.pixelBinCenters,1) +1;
    IM1(2:10:400,:) = size(param.pixelBinCenters,1) +1;
%     IM1(3:10:400,:) = size(param.pixelBinCenters,1) +1;
    IM1(:,1:10:400) = size(param.pixelBinCenters,1)+1;
    IM1(:,2:10:400) = size(param.pixelBinCenters,1)+1;
%     IM1(:,3:10:400) = size(param.pixelBinCenters,1)+1;
    map = [map;1 1 1];
    outputFileName = [ 'Image_Grided_Pixelcategory_' zText '.png'];
%     figure;imagesc(IM1);colormap(map);
    imwrite(uint8(IM1),map,fullfile(pwd,opFolder,outputFileName),'png');
    
end
clear IM1 IM nz outputFileName ii cnt P

%% Supervoxel - Computation

[m,p,n] = size(allImage);
allSVImage = zeros(m/10,p/10,2);
cnt= 1;
toggleCBar = true;
for iPlane = 1:3:n
    n1 = im2col(allImage(:,:,iPlane),[param.tileX param.tileY],'distinct');
    n2 = im2col(allImage(:,:,iPlane+1),[param.tileX param.tileY],'distinct');
    n3 = im2col(allImage(:,:,iPlane+2),[param.tileX param.tileY],'distinct');
    svImage1 = [n1' n2' n3'];
    ii = (sum(svImage1 ~= 0,2)./size(svImage1,2))>=param.superVoxelThresholdTuningFactor;
    svImageTypes1 = zeros(size(svImage1,1),21);    
    for i = 0:20
        svImageTypes1(:,i+1) = (sum(svImage1 == i,2)./size(svImage1,2));        
    end
    svCat1 = knnclassify(svImageTypes1, param.supervoxelBincenters, [1:size(param.supervoxelBincenters,1)]);
    svCat1(~ii,1) = 0;
    allSVImage(:,:,cnt) = reshape(svCat1,40,40);
    svCat1 = repmat(svCat1,1,100);
    svImage1 = (col2im(svCat1',[10 10],[400 400],'distinct'));
    map = jet(size(param.supervoxelBincenters,1));
    map = [0 0 0;map];
    outputFileName = [ 'Image_SVcategory_' num2str(iPlane) '.png'];
    imwrite(uint8(svImage1),map,fullfile(pwd,opFolder,outputFileName),'png');
    if(toggleCBar)
        h=figure;
%         imshow(svImage1,[]);
        colorbar;
        imagesc(svImage1);colormap(map);
        colorbar('Ticks',[],...
            'TickLabels',[]);
        caxis([0 size(param.supervoxelBincenters,1)])
        saveas(h,fullfile(pwd,opFolder,'svCBar.png'),'png');
        close(h);
        toggleCBar = false;
    end
    svImage1(1:100:400,:) = size(param.supervoxelBincenters,1)+1;
    svImage1(2:100:400,:) = size(param.supervoxelBincenters,1)+1;
    svImage1(3:100:400,:) = size(param.supervoxelBincenters,1)+1;
    svImage1(4:100:400,:) = size(param.supervoxelBincenters,1)+1;
    svImage1(5:100:400,:) = size(param.supervoxelBincenters,1)+1;
    svImage1(:,1:100:400) = size(param.supervoxelBincenters,1)+1;
    svImage1(:,2:100:400) = size(param.supervoxelBincenters,1)+1;
    svImage1(:,3:100:400) = size(param.supervoxelBincenters,1)+1;
    svImage1(:,4:100:400) = size(param.supervoxelBincenters,1)+1;
    svImage1(:,5:100:400) = size(param.supervoxelBincenters,1)+1;
    map = [map;1 1 1];
    outputFileName = [ 'Image_GridedSVcategory_' num2str(iPlane) '.png'];
    imwrite(uint8(svImage1),map,fullfile(pwd,opFolder,outputFileName),'png');
    cnt=cnt+1;
end
%% Mega Voxel
toggleCBar=true;
[m,p,n] = size(allSVImage);
allMVImage = zeros(m/10,p/10);
n1 = im2col(allSVImage(:,:,1),[10 10],'distinct');
n2 = im2col(allSVImage(:,:,2),[10 10],'distinct');
mvImage1 = [n1' n2'];
ii = (sum(mvImage1 ~= 0,2)./size(mvImage1,2))>=param.megaVoxelThresholdTuningFactor;
mvImageTypes1 = zeros(size(mvImage1,1),21);
for i = 0:30
    mvImageTypes1(:,i+1) = (sum(mvImage1 == i,2)./size(mvImage1,2));
end
mvCat1 = knnclassify(mvImageTypes1, param.megaVoxelBincenters,...
    [1:size(param.megaVoxelBincenters,1)]);
mvCat1(~ii,1) = 0;
mvCat1 = repmat(mvCat1,1,10000);  
mvImage1 = (col2im(mvCat1',[100 100],[400 400],'distinct'));

outputFileName = [ 'Image_MVcategory_' '.png'];
map = jet(size(param.megaVoxelBincenters,1));
map = [0 0 0;map];
imwrite(uint8(mvImage1),map,fullfile(pwd,opFolder,outputFileName),'png');
if(toggleCBar)
    h=figure;
    imshow(mvImage1,[]);
    colorbar;
    imagesc(svImage1);colormap(map);
    colorbar('Ticks',[],...
        'TickLabels',[]);
    caxis([0 size(param.megaVoxelBincenters,1)])
    saveas(h,fullfile(pwd,opFolder,'mvCBar.png'),'png');
    close(h);
    toggleCBar = false;
end
disp('Complete');
return;
%% Post Analysis Compute histogram of categories with different features
h = figure;hold on;
bar([0:numel(mvImageTypes1([1],:))-1],mvImageTypes1([1],:),'Facecolor',[.9 .9 .9]);
bar([0+.7:numel(mvImageTypes1(6,:))-.3],mvImageTypes1(6,:),'Facecolor',[.5 .5 .5]);xlim([-.5 30.5]);

hold off;

ylabel('Freqeuncy');xlabel('Supervoxel Categories');
saveas(h,fullfile(pwd,'outputfigures','mv16histogram.png'),'png');
%% Plot MV histogram
mvhist = zeros(1,41);
for i = 0:40
    mvhist(i+1) = sum(mvCat1(:,1)==i)/16;
end
h = figure;hold on;
bar([0:40],mvhist([1],:),'Facecolor',[0 0 0]);
ylabel('Freqeuncy');xlabel('Megavoxel Categories');xlim([-.5 40.5]);
hold off;
saveas(h,fullfile(pwd,'outputfigures','image16histogram.png'),'png');
%%
h = figure;
plot3(param.pixelBinCenters(:,1),param.pixelBinCenters(:,2),param.pixelBinCenters(:,3),...
    'o','MarkerFacecolor',[.5 .5 .5],'Markersize',6,'MarkerEdgeColor','none');
view(3);grid on;xlabel('Channel1');ylabel('Channel2');zlabel('Channel3');
saveas(h,fullfile(pwd,'outputfigures','pixelCatCenters.png'),'png');
