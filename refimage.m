% refimagepath = '\\mercury\ic200\_YASCP\151218_glutamate\151218_shading reference';
clc;
% refFileNames = {'\\mercury\ic200\_YASCP\ASCP_OCT12015_density_20151002144251\scan\Well__L_014\Annexin\Annexin__L_014_r_0003_c_0002_t_0000_z_0009.tif';
%                 '\\mercury\ic200\_YASCP\ASCP_OCT12015_density_20151002144251\scan\Well__L_014\Annexin\Annexin__L_014_r_0005_c_0002_t_0000_z_0009.tif';
%                 '\\mercury\ic200\_YASCP\ASCP_OCT12015_density_20151002144251\scan\Well__L_014\Annexin\Annexin__L_014_r_0005_c_0005_t_0000_z_0009.tif';
%                 '\\mercury\ic200\_YASCP\ASCP_OCT12015_density_20151002144251\scan\Well__M_014\Annexin\Annexin__M_014_r_0003_c_0002_t_0000_z_0009.tif';                
%                 '\\mercury\ic200\_YASCP\ASCP_OCT12015_density_20151002144251\scan\Well__M_014\Annexin\Annexin__M_014_r_0005_c_0005_t_0000_z_0009.tif';};
refFileNames = {'\\mercury\ic200\_YASCP\151218_glutamate\151218_shadingreference\151218_shadingreference_S0000(P1-E5)_Z0009_C00_M0000_ORG.tif';
                '\\mercury\ic200\_YASCP\151218_glutamate\151218_shadingreference\151218_shadingreference_S0002(P3-E5)_Z0009_C00_M0000_ORG.tif';
                '\\mercury\ic200\_YASCP\151218_glutamate\151218_shadingreference\151218_shadingreference_S0003(P4-E5)_Z0009_C00_M0000_ORG.tif';
                '\\mercury\ic200\_YASCP\151218_glutamate\151218_shadingreference\151218_shadingreference_S0004(P5-E5)_Z0009_C00_M0000_ORG.tif';                
                '\\mercury\ic200\_YASCP\151218_glutamate\151218_shadingreference\151218_shadingreference_S0001(P2-E5)_Z0009_C00_M0000_ORG.tif';};            
refFileNames={'\\mercury\ic200\_YASCP\160114_glutamate\160114_P-002-16_shading images\160114_P-002-16_shading images_S0000(P1-A2)_Z0011_C00_M0000_ORG.tif'};            
            
tmpFiles = imread(refFileNames{1,:},'tiff');

refUniImage = zeros(size(tmpFiles,1),size(tmpFiles,2),size(refFileNames,1));
for irefFiles = 1:size(refFileNames,1)
    refUniImage(:,:,irefFiles) = imread(refFileNames{irefFiles,:},'tiff');
end
 

% refUniImage = bsxfun(@minus,refUniImage,double(refBkgImage));
meanRefUniImage = mean(refUniImage(:));
refUniImage = mean(refUniImage,3);
refUniImage = double(refUniImage./meanRefUniImage);
ref_annexin = refUniImage;
% imwrite(uint16(refUniImage),'\\mercury\ic200\ReferenceImage\Ref_Annexin.tif','tiff');
%%
% refFileNames = {'\\mercury\ic200\ReferenceImage\40x_Cy5_Ref1.tif';
%                 '\\mercury\ic200\ReferenceImage\40x_Cy5_Ref2.tif';
%                 '\\mercury\ic200\ReferenceImage\40x_Cy5_Ref3.tif';
%                 };
refFileNames = {'\\mercury\ic200\_YASCP\151218_glutamate\151218_shadingreference\151218_shadingreference_S0000(P1-E5)_Z0009_C01_M0000_ORG.tif';
                '\\mercury\ic200\_YASCP\151218_glutamate\151218_shadingreference\151218_shadingreference_S0002(P3-E5)_Z0009_C01_M0000_ORG.tif';
                '\\mercury\ic200\_YASCP\151218_glutamate\151218_shadingreference\151218_shadingreference_S0003(P4-E5)_Z0009_C01_M0000_ORG.tif';
                '\\mercury\ic200\_YASCP\151218_glutamate\151218_shadingreference\151218_shadingreference_S0004(P5-E5)_Z0009_C01_M0000_ORG.tif';                
                '\\mercury\ic200\_YASCP\151218_glutamate\151218_shadingreference\151218_shadingreference_S0001(P2-E5)_Z0009_C01_M0000_ORG.tif';};
refFileNames={'\\mercury\ic200\_YASCP\160114_glutamate\160114_P-002-16_shading images\160114_P-002-16_shading images_S0000(P1-A2)_Z0011_C01_M0000_ORG.tif'};             
tmpFiles = imread(refFileNames{1,:},'tiff');

refUniImage = zeros(size(tmpFiles,1),size(tmpFiles,2),size(refFileNames,1));
for irefFiles = 1:size(refFileNames,1)
    refUniImage(:,:,irefFiles) = imread(refFileNames{irefFiles,:},'tiff');
end
 

% refUniImage = bsxfun(@minus,refUniImage,double(refBkgImage));
meanRefUniImage = mean(refUniImage(:));
refUniImage = mean(refUniImage,3);
ref_draq5 = double(refUniImage./meanRefUniImage);
% imwrite(uint16(refUniImage),'\\mercury\ic200\ReferenceImage\Ref_Draq5.tif','tiff');   
%%
% refFileNames = {'\\mercury\ic200\ReferenceImage\40x_Tritc_Ref1.tif';
%                 '\\mercury\ic200\ReferenceImage\40x_Tritc_Ref2.tif';
%                 '\\mercury\ic200\ReferenceImage\40x_Tritc_Ref3.tif';
%                 };
refFileNames = {'\\mercury\ic200\_YASCP\151218_glutamate\151218_shadingreference\151218_shadingreference_S0000(P1-E5)_Z0009_C02_M0000_ORG.tif';
                '\\mercury\ic200\_YASCP\151218_glutamate\151218_shadingreference\151218_shadingreference_S0002(P3-E5)_Z0009_C02_M0000_ORG.tif';
                '\\mercury\ic200\_YASCP\151218_glutamate\151218_shadingreference\151218_shadingreference_S0003(P4-E5)_Z0009_C02_M0000_ORG.tif';
                '\\mercury\ic200\_YASCP\151218_glutamate\151218_shadingreference\151218_shadingreference_S0004(P5-E5)_Z0009_C02_M0000_ORG.tif';                
                '\\mercury\ic200\_YASCP\151218_glutamate\151218_shadingreference\151218_shadingreference_S0001(P2-E5)_Z0009_C02_M0000_ORG.tif';};            
tmpFiles = imread(refFileNames{1,:},'tiff');
refFileNames={'\\mercury\ic200\_YASCP\160114_glutamate\160114_P-002-16_shading images\160114_P-002-16_shading images_S0000(P1-A2)_Z0011_C02_M0000_ORG.tif'}; 
refUniImage = zeros(size(tmpFiles,1),size(tmpFiles,2),size(refFileNames,1));
for irefFiles = 1:size(refFileNames,1)
    refUniImage(:,:,irefFiles) = imread(refFileNames{irefFiles,:},'tiff');
end
 

% refUniImage = bsxfun(@minus,refUniImage,double(refBkgImage));
meanRefUniImage = mean(refUniImage(:));
refUniImage = mean(refUniImage,3);
ref_tmre = double(refUniImage./meanRefUniImage);
% imwrite(uint16(refUniImage),'\\mercury\ic200\ReferenceImage\Ref_TMRE.tif','tiff'); 
allref = zeros(size(ref_tmre,1),size(ref_tmre,2),3);
allref(:,:,1) = ref_draq5;
allref(:,:,2) = ref_tmre;
allref(:,:,3) = ref_annexin;
clear refFileNames tmpFiles refUniImage irefFiles refUniImage meanRefUniImage;
return;

%%
channelName = 'Draq5';
refileName = ref_draq5;
inputPlateDirectory = '\\mercury\ic200\_YASCP\ASCP_151016_OCT162015_GMat_1_20151016095505';
outputPlateDirectory = '\\mercury\ic200\_YASCP\AASCP_151016_OCT162015_GMat_1_20151016095505_Shadecorrected';
mkdir(outputPlateDirectory);
mkdir([outputPlateDirectory]);
wells = dir([inputPlateDirectory '\scan']);
for iWells = 3:size(wells,1)
    
    if(~wells(iWells).isdir)
        continue;
    end
%     if(~strcmpi(wells(iWells).name,'Well__G_010'))
%         continue;
%     end
    fprintf('%s\n',wells(iWells).name);
    channelFolder = [inputPlateDirectory '\scan\' wells(iWells).name '\' channelName];
    mkdir([outputPlateDirectory '\scan\' wells(iWells).name '\' channelName]);
%     opChannelFolder = [outputPlateDirectory '\scan\' wells(iWells).name '\' channelName];
    opChannelFolder = [outputPlateDirectory ];
    imageFiles = dir(channelFolder);
    imageFileName = {};
    for jFiles = 3:size(imageFiles,1)
        if(imageFiles(jFiles).isdir)
            continue;
        end
        extMatch = regexpi(imageFiles(jFiles).name,'.tif','start');        
        if(isempty(extMatch))
            continue;
        end
        tmp = double(imread([channelFolder '\' imageFiles(jFiles).name],'tiff'));
        tmp = tmp./ref_annexin;
        imwrite(uint16(tmp),[opChannelFolder '\' imageFiles(jFiles).name],'tiff');
    end
end
disp('Completed')
