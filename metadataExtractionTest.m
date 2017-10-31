
clear ;clc;
str = 'r03c03f01p10-ch8sk1fk1fl1.tiff';
% str = 'P1_NDExp_WellC09_Point0000_Seq0000_Z01_CH01.tiff';
% For Nikon
% exprIM = '(?<PLATE>\w+)_NDExp_Well(?<Well>\w+)_Point(?<Field>\d+)_Seq\d+_Z(?<Stack>\d+)_CH(?<Channel>\d+).*.tif(f)?';
% For Pheonix
exprIM = '(?<Well>\w+)f(?<Field>\d+)p(?<Stack>\d+)-ch(?<Channel>\d).*.tif(f)?';
channelCol = 4;
m = regexpi(str,exprIM,'Names');
sizeHeader = numel(fieldnames(m));
%%
pth = 'Z:\JMP_20170908_Phindr3DExp_Neurons_SANTOSH\20170908_Phindr3DNeuron__2017-09-08T09_43_24-Measurement 1\Images';
l = dir(pth);
mxRws = 100000;
metadata = cell(mxRws,sizeHeader+1);cnt = 1;
fprintf('Extracting metadata................');
for i = 3:size(l,1)
    fprintf('\b\b\b\b\b\b\b\b%7.3f%%',i*100/size(l,1));
    if(l(i).isdir)
        continue;
    end    
    m = regexpi(l(i).name,exprIM,'Names');
    if(~isempty(m))
        names = fieldnames(m);
        if(numel(names)~=sizeHeader)
            error('HHHHH');
        else
            metadata{cnt,1} = fullfile(pth,l(i).name);
            for j = 1:sizeHeader
                metadata{cnt,j+1} = getfield(m, names{j});
            end
            cnt = cnt+1;
        end
    end
end
if(cnt <= mxRws)
    metadata = metadata(1:cnt-1,:);
end
numChannels = numel(unique(metadata(:,channelCol+1)));
%%
[~,idx] = sort(metadata(:,sizeHeader+1));
metadata = metadata(idx,:);
allChl = reshape(metadata(:,1),size(metadata,1)/numChannels,numChannels);
ii = str2num(char(metadata(:,sizeHeader+1))) == 1;
nMetadata = [allChl metadata(ii,2:end-1)];

%% Write Data
header = cell(1,size(nMetadata,2));
for i = 1:numChannels
    header{1,i} = ['Channel' num2str(i)] ;
end
for i = numChannels+1:size(nMetadata,2)
    header(1,i) = names(i-numChannels);
end

[m,n] = size(nMetadata);

fileName = fullfile(pth,'metadatafile.txt');
try
    fid = fopen(fileName,'w');
    for i = 1:n
        fprintf(fid,'%s\t',header{1,i});
    end
    fprintf(fid,'\n');
    
    
    for i = 1:m
        for j = 1:n
            fprintf(fid,'%s\t',nMetadata{i,j});
        end
        fprintf(fid,'\n');
    end
%     fprintf(fid,'\n');
    
    fclose(fid);
catch expc
    fclose(fid);
    rethrow(expc);
end

disp('Done');











