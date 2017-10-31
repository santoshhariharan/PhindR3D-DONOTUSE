% Plot t-SNE for data
clear all;clc;
load('parameters.mat');
% Filter data based on number of elements
userSelectedControls = getappdata(0,'alldata');
try
    fid = fopen(fullfile(param.rootpath,'_controls_temp.bin'),'r');
    userSelectedControls.data = fread(fid,[size(userSelectedControls.textdata,1) sum(param.datafeat)],'double');
    fclose(fid);
catch e
    fclose(fid);
    rethrow(e);
end
%%
% uText = unique(userSelectedControls.textdata(:,4));
userSelectedControls.grps = getGroupIndices(userSelectedControls.textdata(:,4),...
                               uText);
userSelectedControls.data = userSelectedControls.data(userSelectedControls.grps>0,:); 
userSelectedControls.textdata = userSelectedControls.textdata(userSelectedControls.grps>0,:);
userSelectedControls.grps = userSelectedControls.grps(userSelectedControls.grps>0,:);



new_Data = compute_mapping(userSelectedControls.data, 't-SNE', 2);
uGrp = unique(userSelectedControls.grps);
% mp = param.maps;
%%
figure;hold on;
for i = 1:numel(uGrp)
    if(i==4)
%         continue;
    end
    ii = userSelectedControls.grps == uGrp(i);
    
    plot(new_Data(ii,1),new_Data(ii,2),'o',...
                'MarkerFaceColor',mp(i,:),'MarkerEdgeColor','none',...
                'MarkerSize',6);
end
xlabel('t-SNE1');ylabel('t-SNE2')
hold off;
%%
cLabel ={};
for i = 1:size(userSelectedControls.data,2)
    cLabel = [cLabel;cellstr(['MV' num2str(i)])];
end

            cobj = clustergram(userSelectedControls.data,'Rowlabels',userSelectedControls.textdata(:,4),...
                'Columnlabels',cLabel,'Symmetric',false,...
    'Colormap',redbluecmap(40));
