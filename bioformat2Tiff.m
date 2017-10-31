clear; clc;
inputPth = 'U:\Projects\Philipp-Neuron\Data\Nikon-Germany\PM_170725\UnZipped\PM_170725_plate2';
outputPth = 'U:\Projects\Philipp-Neuron\Data\Nikon-Germany\PM_170725\TiffFiles';
ext = '.nd2';
fileName = 'U:\Projects\Philipp-Neuron\Data\Nikon-Germany\PM_170725\UnZipped\PM_170725_plate1\NDExp_WellE03_Point0000_Seq0000.nd2';
D = bfopen(fileName);
omeMetadata = D{1,4};
S = D{1,1};
numChannels = omeMetadata.getChannelCount(0);
numPlanes = omeMetadata.getPlaneCount(0)/numChannels;
mkdir(outputPth);
%% List all images and write Tiff files

l = dir(inputPth);
h = waitbar(0,'Writing Tiff files');
total = (size(l,1)-2)*numChannels*numPlanes;
counter = 1;
for i = 3:size(l,1)
    if(l(i).isdir)
        continue;
    end
    
    mt = regexpi(l(i).name,ext,'Split');
    if(isempty(mt))
        continue;
    end
    tmp = mt{1,1};
    fileName = fullfile(inputPth,l(i).name);
    D = bfopen(fileName);
    S = D{1,1};cnt = 1;
    for iPlanes = 1:numPlanes
        if(iPlanes<10)
            zp = ['0' num2str(iPlanes)];
        else
            zp = [num2str(iPlanes)];
        end
        for jChannels = 1:numChannels
            opfName = ['P2_' tmp '_Z' zp '_CH0' num2str(jChannels) '.tiff'];
            opfName = fullfile(outputPth,opfName);
            IM = S{cnt,1};
            imwrite(S{cnt,1},opfName,'tiff');
            waitbar(counter/total,h,'Writing Tiff files');
            counter = counter+1;
            cnt = cnt+1;
        end
    end
 
end

close(h);