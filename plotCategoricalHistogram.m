function [ output_args ] = plotCategoricalHistogram( y,map )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% if(nargin ==1)
%     map = [0 0 0];
% else
%     if(size(y,2) ~= size(map,1))
%         error('Number of elements should be equal to number of categories');
%     end
% end

if(size(map,1) == 1)
    map = repmat(map,size(y,2),1);
end
if(size(map,1) == 1) % Plot bar graph
    figure;bar(y,'Color',map(1,:));
else % Color each bar based on Map
    barWidth = .45;
    numCat = size(y,2);
    numBarGph = size(y,1);
    for i = 1:numBarGph
        figure;hold on;
        for j = 1:numCat
            vert = [j-barWidth 0;j-barWidth y(i,j);j+barWidth y(i,j);j+barWidth 0];             
            patch('Faces',[1 2 3 4],'Vertices',vert,'FaceColor',map(j,:),...
                'EdgeColor','none');
        end
        hold off;
    end
end

end

