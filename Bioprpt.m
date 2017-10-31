
figure; hold on;

markers = ['o';'s';'d'];
mp = lines(3);
for i = 1:size(D,1)
    for j = 1:size(D,2)
        plot(i,D(i,j),markers(j),'MarkerEdgeColor','none',...
        'MarkerFaceColor',mp(j,:),'MarkerSize',10);
    end
end
hold off;
set(gca,'XTick',[1:3]);
xlim([0.5 3.5]);
set(gca,'XTickLabel',{'Buffer';'Glutamate 25uM';'MK801'});
legend({'N1';'N2';'N3'});
ylabel('% Classified Glutamate 25uM')
return;
%%


for j = 1:numel(mvval)
    vert = [mvval(j)-jitVal 0;mvval(j)-jitVal 1.2;mvval(j)+jitVal 1.2;mvval(j)+jitVal 0];
    patch('Faces',[1 2 3 4],'Vertices',vert,'Facecolor',[.8 .8 .8],'FaceAlpha',.1,...
        'Edgecolor','none');
end