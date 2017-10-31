
r = [.3 .3 .4];
startAngle = 0;
numSteps = 10;
col = [1 0 0; 0 1 0; 0 0 1];
colormap(col);
figure; hold on;
for i = 1:numel(r)
    step = r(i)*2*pi/numSteps;
    theta = [0 0:step:r(i)*2*pi 0];
%     theta = [theta 0];
    theta = theta + startAngle;
    [x, y] = pol2cart(theta,[0 ones(1,numel(theta)-2) 0]);
    patch(x,y,i,'Facecolor',col(i,:));
    startAngle = max(theta);
%     pause;
end
hold off