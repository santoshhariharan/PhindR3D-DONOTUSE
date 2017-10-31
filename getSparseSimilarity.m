function [ s ] = getSparseSimilarity( data )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

[m] = size(data,1);
n = m*(m-1)/2;
s = zeros(n,3);
cnt = 1;
for i = 1:m
    for j =i+1:m
        s(cnt,1) = j;s(cnt,2) = i; 
        cnt = cnt+1;
    end
end
s(:,3) = pdist(data);
% medVal = median(s(:,3));
ii = s(:,3) < median(s(:,3));
s = s(ii,:);
fprintf('%i\n',sum(ii)./numel(ii));
s(:,3) = -1*(s(:,3));
end

