clear; clc;
pdir = {'U:\Projects\Philipp-Neuron\Data\AllenInst\localisation\Fibrillarin-Nucleolus';
    'U:\Projects\Philipp-Neuron\Data\AllenInst\localisation\Desmoplakin-CellJunction';
    'U:\Projects\Philipp-Neuron\Data\AllenInst\localisation\alphaTubulin-Microtubules';
    'U:\Projects\Philipp-Neuron\Data\AllenInst\localisation\alphaActinin-Actin'};

for ip = 1:numel(pdir)
    % inputPth = 'U:\Projects\Philipp-Neuron\Data\AllenInst\localisation\LaminB1-NucEnv';
    % outputPth = 'U:\Projects\Philipp-Neuron\Data\AllenInst\localisation\Tom20-Mitochondria\ParsedImages';
    inputPth = pdir{ip,:};
    disp(inputPth);
    outputPth = fullfile(inputPth,'ParsedImages');
    ext = '.ome';
    % fileName = 'U:\Projects\Philipp-Neuron\Data\AllenInst\localisation\Tom20-Mitochondria\AICS-11_10.ome.tif';
    prefix = regexpi(inputPth,'\\','Split');
    prefix = prefix{1,end};
    l = dir(inputPth);
    D = bfopen(fullfile(inputPth,l(10).name));
    omeMetadata = D{1,4};
    S = D{1,1};
    numChannels = omeMetadata.getChannelCount(0);
    numPlanes = omeMetadata.getPlaneCount(0)/numChannels;
    mkdir(outputPth);
    %% List all images and write Tiff files
    channelPicked = [1 3];
    cName = [2 3];
    nCPicked = numel(channelPicked);
    % h = waitbar(0,'Writing Tiff files');
    total = (size(l,1)-2)*numPlanes;
    counter = 1;
    fieldNumber = 1;
    for i = 3:size(l,1)
        if(l(i).isdir)
            continue;
        end
        
        mt = regexpi(l(i).name,ext,'Split');
        if(isempty(mt))
            continue;
        end
        if(strcmpi(l(i).name,'Thumbs.db'))
            continue;
        end
        tmp = mt{1,1};
        fileName = fullfile(inputPth,l(i).name);
        D = bfopen(fileName);
        S = D{1,1};cnt = 1;
        if(fieldNumber<10)
            fp = ['00' num2str(fieldNumber)];
        elseif(fieldNumber<100)
            fp = ['0' num2str(fieldNumber)];
        else
            fp = [num2str(fieldNumber)];
        end
        for k = 1:nCPicked
            S1 = S(channelPicked(k):numChannels:size(S,1),:);
            m = size(S1,1);
            for iPlanes = 1:m
                if(iPlanes<10)
                    zp = ['0' num2str(iPlanes)];
                else
                    zp = [num2str(iPlanes)];
                end
                
                opfName = [prefix '_F' num2str(fp) '_Z' zp  '_CH0' num2str(cName(k)) '.tiff'];
                opfName = fullfile(outputPth,opfName);
                %         IM = S{iPlanes,1};
                imwrite(S1{iPlanes,1},opfName,'tiff');
                %             waitbar(counter/total,h,'Writing Tiff files');
                counter = counter+1;
            end
            
        end
        
        
        
        
        fieldNumber = fieldNumber+1;
        %     for iPlanes = 1:numPlanes
        %         if(iPlanes<10)
        %             zp = ['0' num2str(iPlanes)];
        %         else
        %             zp = [num2str(iPlanes)];
        %         end
        %         for jChannels = 1:numChannels
        %             opfName = [prefix '_Z' zp '_CH0' num2str(jChannels) '.tiff'];
        %             opfName = fullfile(outputPth,opfName);
        %             IM = S{cnt,1};
        %             imwrite(S{cnt,1},opfName,'tiff');
        %             waitbar(counter/total,h,'Writing Tiff files');
        %             counter = counter+1;
        %             cnt = cnt+1;
        %         end
        %     end
        
    end
end
disp('@@@@@@DONE$$$$$$$$$');
% close(h);