
inputDir = 'U:\Projects\Philipp-Neuron\Data\Nikon-Germany\PM_170718_plate2_Tiff';
opDir = 'U:\Projects\Philipp-Neuron\Data\Nikon-Germany\PM_170718_plate1_Tiff\PM_170718';
mkdir(opDir);
listing = dir(inputDir);
fprintf('Complete...................');
for i = 3:size(listing,1)
    if(listing(i).isdir)
        continue;
    end
    fprintf('\b\b\b\b\b\b\b\b%7.3f%%',i*100/size(listing,1));
    mt = regexpi(listing(i).name,'.tif');
    if(isempty(mt))
        continue;
    end
    nFname = ['P2_' listing(i).name];
    copyfile(fullfile(inputDir,listing(i).name),fullfile(opDir,nFname))
end
disp('@@@@@@')