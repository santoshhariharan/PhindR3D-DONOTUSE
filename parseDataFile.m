function [ opText, opData, textHeader, dataHeader, imageID ] = parseDataFile( metadatafilename )
%parseMetadataFile Parses metadata file 
%   Author: Santosh hariharan @ DWA Lab Toronto
% Date oct 4 2017

try
    fid = fopen(metadatafilename,'r');
    header= strtrim(fgetl(fid));
    fclose(fid);
    header = regexpi((header),'\t','split');
    if(~strcmpi(header,'ImageID'))
        errordlg('Please choose appropriate metadata file');
        return;
    end
    fid = fopen(metadatafilename);
    tmp = textscan(fid,repmat('%s',1,numel(header)),'headerlines',1,'delimiter','\t');
    fclose(fid);    
catch excep
    fclose(fid);
    rethrow(excep);
end


% Select Image ID column
imageIDCol = strcmpi(header,'imageID');
imageID = str2num(char(tmp(:,imageIDCol)));
tmp = tmp(:,~imageIDCol);
header = header(1,~imageIDCol);


[selection,~] = listdlg('ListString',header,'SelectionMode','Multiple',...
                        'Name','Select Text Data');
textHeaderCol = false(1,numel(header));
textHeaderCol(1,selection) = true;
textHeader = header(1,textHeaderCol);
dataHeader = header(1,~textHeaderCol);
opText=[];
for i = 1:numel(selection)
    opText = [opText tmp{1,selection(i)}];
end
opData = cell2mat(t(1,~textHeaderCol));

end
