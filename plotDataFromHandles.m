function [ redData, pltHandle ] = plotDataFromHandles( handles )
%plotDataFromHandles plots data based on handles
%   The function plots data from handles
% Author: Santosh Hariharan
% Date: 10/10/2017
% DWA Lab


% Get tSNE perplexity
if(isappdata(handles.viewData,'perplexity'))
    perplexity = getappdata(handles.viewData,'perplexity');
else
    perplexity=30;
end

% Get type of plot
algoVal = get(handles.rbPCA,'Value');
if(algoVal)
    rdType = 'PCA';
else
    rdType = 't-SNE';
end

% Get dimensions
numdims = get(handles.threeDim,checked);
if(numdims) numdims = 3;else numdims = 2; end

% Check whether reduced features are clready computed
if(~isappdata(handles.viewData,'redData'))
    redData = compute_mapping(opData,rdType,numdims,perplexity);
    setappdata(handles.viewData,'redData',redData);
end


if(isappdata(handles.viewData,'treatmentColors'))
    c = getappdata(handles.viewData,'treatmentColors');
else
    c = [0 0 1];
end

if(numdims==2)
    scatter(handles.plotAxes,redData(:,1),redData(:,2),30,c,'filled');
else
    scatter3(handles.plotAxes,redData(:,1),redData(:,2),redData(:,3),30,c,'filled');
end
% setappdata(handles.viewData,'redData',redData);
if(isappdata(handles.viewData,'treatmentNames'))
    treatmentNames = getappdata(handles.viewData,'treatmentNames');
    legend(handles.plotAxes,treatmentNames);
end
end

