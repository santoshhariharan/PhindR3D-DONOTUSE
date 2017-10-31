% Read XML files
clc;
fname = 'F:\Projects\PhlippNeuron\PerkinElmerDataset\Autophagy_Export\Autophagy_Export\autophagy biotechne plate5 40x__2015-07-13T16_47_33-Measurement2\Assaylayout\Autophagy plate5_AHS.xml';

try
    tree = xmlread(fname);
catch expc
    rethrow(expc)
end

% Get Layer level information
if tree.hasChildNodes
    layerList = tree.getElementsByTagName('Layer');
    rowList = layerList.item(0).getElementsByTagName('Row');
    metadata = cell(rowList.getLength,layerList.getLength);
    for i = 1:layerList.getLength 
%         Get Layer
            layerNode = layerList.item(i-1);
            rowList = layerNode.getElementsByTagName('Row');
            colList = layerNode.getElementsByTagName('Col');
            valList = layerNode.getElementsByTagName('Value');
            for j = 1:rowList.getLength
                metadata{j,1} = char(rowList.item(j-1).getTextContent);
                metadata{j,2} = char(colList.item(j-1).getTextContent);
                metadata{j,i+2} = char(valList.item(j-1).getTextContent);
%                 rowNode = rowList.item(j-1);
                
            end
        
    end
end