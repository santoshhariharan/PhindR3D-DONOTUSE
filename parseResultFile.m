function [headerLine, textdata, data ] = parseResultFile( fName,delimiter )
%parseResultFile Reads a result file
%   Input
% fName - Fully qualified file name
% delimiter - Delimiter used for the file, default is tab
%   Output
% textdata - Medtadata for the results
% data - Numerical data for the results

try
    fid = fopen(fileName,'r');
    headerLine = fgetl(fid);
    fclose(fid);
    headerLine = strtrim(headerLine);
    headerLine = strsplit(headerLine,'\t');
    [selColumns, ~] = listdlg('ListString',headerLine,...
                        'Name','Select Metadata for Results file');
    formatStr = [repmat('%s\t',1,numel(selColumns)) repmat('%f\t',1,numel(headerLine) - numel(selColumns))];                
    fid = fopen(fileName,'r');
    allData = textscan(fid,formatStr,'headerlines',1);
    fclose(fid);
    textData={};% Put textdata
    for i = 1:numel(selColumns)
        textData = [textData allData{:,i}];
    end
    data = cell2mat(allData{:,numel(selColumns)+1:end});
catch exception
    fclose(fid);
    errordlg('Unable to read file!!');
    textdata = {};
    data = [];
end


end

