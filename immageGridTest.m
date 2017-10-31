
clear ;clc;
bw1 = imread('peppers.png');
gBw = rgb2gray(bw1);
thresh = quantile(gBw(:),.2);
% bw = im2bw
sSize = 4;
bw2 = (im2col(bw,[sSize sSize],'distinct'));
%
bw3 = sum(bw2)/(sSize*sSize);
bw3 = bw3>.1;
bw2(:,bw3) = 1;
bw2(:,~bw3) = 0;
[m,n] = size(bw);
% figure;imshow(bw2,[]);
bw2 = col2im(bw2,[sSize sSize],[m n],'distinct');
%

% figure;imshow(bw,[]);
% figure;imshow(bw2,[]);
% hold on;
%
im1 = false(256,256);
% [x,y] = meshgrid(1:32:256,1:32:256);
x = [1:sSize:256];
im1(x,:) = 1;
im1(:,x) = 1;
im3 = im1.*bwmorph(bw2,'dilate');
im5 = bw - im3;
%
% figure;imshow(im3,[]);
% im3 = or(im3,bw);
%
bw5 = bw - bw.*im3;
im4 = false(256,256,3);
im4(:,:,1) = im3+bw5;
im4(:,:,2) = bw5;
im4(:,:,3) = bw5;
imagesc(im4)
%% Show color image plus grid
bw1 = imread('peppers.png');
sSz = 16;
bSz = 64;
[m,n,z] = size(bw1);

% Make small Grid lines
x1 = [1:sSz:m];
x2 = [1:sSz:n];
% x = [1:sSz:256];
im1 = uint8(zeros(m,n));
im1(x1,:) = 255;
im1(:,x2) = 255;


% Make larger grid lines
x1 = [1:bSz:m];
x2 = [1:bSz:n];
im2 = uint8(zeros(m,n));
im2(x1,:) = 255;
im2(:,x2) = 255;

% Difference Image
dIm = im1 - im2;
dIm = repmat(dIm,1,1,3);
% dIm(:,:,2) = dIm;
dIm(:,:,2) = uint8(zeros(m,n));

im2 = repmat(im2,1,1,3);

disp('hi')
% im = false(256,256);
% dispIM = bsxfun(@plus,bw1,im);
imagesc(bw1+im2+dIm);




