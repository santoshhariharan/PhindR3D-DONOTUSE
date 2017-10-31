% Move & renmae files
clc;
rootDirectory = 'F:\Projects\PhlippNeuron\Murphy3DData';
outputImageDirectory = 'F:\Projects\PhlippNeuron\OutputImageMask\';
a = dir(rootDirectory);
for i = 3:size(a)
    fprintf('Dir: %s\n',a(i).name);
    b = dir(fullfile(rootDirectory,a(i).name));
    for j = 3:size(b)
        c = dir(fullfile(rootDirectory,a(i).name,b(j).name));
        for k = 3:size(c)
            if(strcmpi(c(k).name,'crop') || strcmpi(c(k).name,'prot') || strcmpi(c(k).name,'dna') )
                continue;
            end
            d = dir(fullfile(rootDirectory,a(i).name,b(j).name,c(k).name));
            for p = 3:size(d)
                if(d(p).isdir)
                    continue;
                end
                fName = fullfile(rootDirectory,a(i).name,...
                            b(j).name,c(k).name,d(p).name);  
                tok = regexpi(fName,'.tif');
                if(isempty(tok))
                    continue;
                end
                IM = double(imread(fName,'tif'));
                
                pp = getImageThreshold(IM);
                bw = IM>pp;
                newIM = uint8(bw*50+IM.*(~bw));
                
                d1 = strrep(d(p).name,'.z','_z');
%                 d1 = strrep(d1,'ER_','ER');
                dName = [a(i).name '_' b(j).name '_' c(k).name '_' d1];        
                        
                dFile = fullfile(outputImageDirectory,dName);                
%                 copyfile(fName,dFile)
                imwrite(newIM,dFile);
            end
        end
    end
end
disp('done')