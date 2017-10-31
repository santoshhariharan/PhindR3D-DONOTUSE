% Mitochondrial Segmentation
close all;clc;
imagefile = 'Z:\PM_20160204_YASCPgmat\Meas01TiffImages\MIPImages\Untreated_N1_W30030_F1_C1.tif';
[~,metadata] = xlsread('Z:\PM_20160204_YASCPgmat\Meas01TiffImages\MIPImages\metafile_mitochondriasegmentation.xlsx');
hdr = metadata(1,:);
metadata = metadata(2:end,:);
features = zeros(size(metadata,1),6);
for i = 1:1
    fprintf('Percent iteration left %f\n',(1 - (i/size(metadata,1)))*100);
    IM = double(imread(metadata{i,1}));
    imthreshold = getImageThreshold(IM);
    bw = bwmorph(IM>imthreshold,'skel',Inf);
    a = cell2mat(struct2cell(regionprops(bw,'area'))');
    features(i,1) = numel(a);
    features(i,2) = std(a);
    features(i,3) = mean(a); 
    features(i,4) = median(a); 
    features(i,5) = skewness(a); 
    features(i,6) = kurtosis(a); 
    figure;imshow(IM,[]);
    figure;imshow(bw,[]);
end
%%
figure;boxplot(features(:,3),metadata(:,2),'jitter',.3,'Whisker',0,'labelorientation','inline');
title('Mitochondrial Length per Image in Pixels');
% figure;imshow(IM>imthreshold,[]);

% bw = bwareaopen(bw,3,4);
% figure;imshow(bw,[]);
