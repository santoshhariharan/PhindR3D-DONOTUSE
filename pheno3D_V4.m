% Main script for 3D voxel based analysis - Voxelizer
warning off;
close all;
clearvars;
clc;
%% Define number of plates to be analyzed
exprIM = '(?<Well>\w+)f(?<Field>\d+)p(?<Stack>\d+)-ch(?<Channel>\d).*.tif(f)?';
svval = [15];
mvval = [40];
filePrefix = 'AllChannel_NoBkg_SVVAL';
plateDirectoryList = {
%                     'Z:\JMP_20170728_Phindr3D-Neuron-Exp\20170728_YASCP_Hoescht_Mito_Annexin__2017-07-28T13_27_58-Measurement 1\Images';
%                     'U:\Projects\Philipp-Neuron\Data\Nikon-Germany\PM_170725\TiffFiles';
%                     'U:\Projects\Philipp-Neuron\Data\Nikon-Germany\PM_170718_plate2_Tiff';
                      'Z:\JMP_20170908_Phindr3DExp_Neurons_SANTOSH\20170908_Phindr3DNeuron__2017-09-08T09_43_24-Measurement 1\Images'  
%                     'Z:\PM_20160225_YASCPgmat_plate4\Meas01-Tiff-Images'
%                     'Z:\PM_20160311_YASCPgmat_plate1\Meas01Tiff-Images';
%                     'Z:\PM_20160311_YASCPgmat_plate2\Meas01Tiff-Images';
%                     'Z:\PM_20160311_YASCPgmat_plate3\Meas01Tiff-Images';
};
numPlates = size(plateDirectoryList,1);
%%
for iSuperVoxel = 1:numel(svval)
    for iMegaVoxel = 1:numel(mvval)
        usePreviousParameterFile = 0;        
%         h1 = waitbar(0,'Current Plate:','Name','Plate Info');
        
        param.channelDiscarded = {''};
               
        % Define input parameters - User defined input parameters
        % allStart = tic;
        if(~usePreviousParameterFile)
            param.tileX = 10;
            param.tileY = 10;
            param.tileZ = 3;
            param.intensityThresholdTuningFactor = .5;
            param.numVoxelBins = 20;
            param.numSuperVoxelBins = svval(iSuperVoxel);
            param.numMegaVoxelBins = mvval(iMegaVoxel);
            % param.randTrainingFields = 10;
            param.randTrainingSuperVoxel = 10000;
            param.superVoxelThresholdTuningFactor = .5;
            param.megaVoxelTileX = 3;
            param.megaVoxelTileY = 3;
            param.megaVoxelTileZ = 2;
            param.countBackground = false;
            param.megaVoxelThresholdTuningFactor = .5;
            param.pixelsPerImage = 200;
            param.randTrainingPerTreatment = 10;
            param.randTrainingFields = 20;
            param.showImage = 0;
            param.startZPlane = 1;
            param.endZPlane = 18;
            param.numRemoveZStart = 1;
            param.numRemoveZEnd = 1;
            param.computeTAS = 0;
            %     param.computeTAS = 1;
            param.showImage = 0;
            param.intensityNormPerTreatment = false;
            param.treatmentColNameForNormalization = 'Treatment'; % Default Change Later
            param.trainingColforImageCategories = 'TreatmentSum';
        else
            [filename,path] = uigetfile('.mat');
            if(isempty(filename))
                disp('Stopping.....');
                return;
            end
            load([path '\' filename]);
        end
        outputPrefix = [filePrefix '_' num2str(param.tileX) 'MVVAL_' num2str(param.megaVoxelTileX) '_SVCAT' num2str(svval(iSuperVoxel)) '_MVCAT' num2str(mvval(iMegaVoxel))];
        
        
%         Print All the inpur parameters
        fprintf('SVSize %i x %i x %i\n',param.tileX,param.tileY,param.tileZ);
        fprintf('MVSize %i x %i\n',param.megaVoxelTileX,param.megaVoxelTileX);
        fprintf('Supervoxel: %i Megavoxel: %i\n',svval(iSuperVoxel),mvval(iMegaVoxel));
        fprintf('Background Count %i\n',param.countBackground);
        fprintf('Plane starts @ %i ends @ %i\n',param.startZPlane,param.endZPlane);
        fprintf('Threshold tuning factor: SV %i MV %i\n',param.superVoxelThresholdTuningFactor,...
                                            param.megaVoxelThresholdTuningFactor);
        fprintf('Random training per Treatment %i\n',param.randTrainingPerTreatment);                                
        %%
        for iPlates = 1:numPlates
            % Read metadata file
            
            
            plateDirectory = plateDirectoryList{iPlates,:};
            plateName = regexpi(plateDirectory,'\\','split');
            plateName = plateName{1,2};
            %     metadatafilename = [plateDirectory '\metadatafile.xlsx'];
            metadatafilename = fullfile(plateDirectory,'metadatafile.txt');
            outputFileName = fullfile(plateDirectory,[plateName '_' outputPrefix '_output_' date '.txt']);
            outputWellFileName = fullfile(plateDirectory ,[plateName '_' outputPrefix '_Well_output_' date '.txt']);
            parameterFileName = fullfile(plateDirectory,[plateName '_' outputPrefix '_parameter_' date '.mat']);
            rawDataFileName = fullfile(plateDirectory ,[plateName '_' outputPrefix '_rawdata_output_' date '.txt']);
            
       
            [plateInfoTable,metaDataHeader,channelInfo] = getPlateInfoFromMetadatafile(metadatafilename,param,plateDirectory,exprIM);
            
       
            param.metaDataHeader = metaDataHeader;
            %     plateInfoTable = plateInfoTable(2:end,:);
            
            %     plateInfoTable = plateInfoTable(:,selHeader);
            fieldColNum = or(strcmpi(metaDataHeader,'Fields'),strcmpi(metaDataHeader,'Field'));
            stackColNum = or(strcmpi(metaDataHeader,'stacks'),strcmpi(metaDataHeader,'stack'));
            wellColNum = or(strcmpi(metaDataHeader,'wells'),strcmpi(metaDataHeader,'well'));
            imageIDColNum = strcmpi(metaDataHeader,'imageID');
            if(param.intensityNormPerTreatment)
                param.treatmentColNameForNormalization = strcmpi(metaDataHeader,...
                                                param.treatmentColNameForNormalization);
                param.grpIndicesForIntensityNormalization = getGroupIndices(plateInfoTable(:,...
                                    param.treatmentColNameForNormalization),unique(plateInfoTable(:,...
                                    param.treatmentColNameForNormalization)));
%                 param.treatmentColNameForNormalization_UniqueValues = unique(param.grpIndices);                            
            end
            param.numChannels = numel(channelInfo);
            param.channelNames = channelInfo;
            param = getTileInfo( [size(imread(plateInfoTable{1,1},'tiff')) numel(unique(plateInfoTable(:,stackColNum)))],...
                param );
            param.imageIDColNum = imageIDColNum;
            clear selHeader testImage
            
            
            allImageId = cell2mat(plateInfoTable(:,imageIDColNum));
            uniqueImageID = unique(allImageId);
            [randFieldID, treatmentValues] = getTrainingFields(plateInfoTable,param,'TreatmentSum');
%             randFieldID = getTrainingFields(plateInfoTable,param);
            param.randTrainingFields = numel(randFieldID);
            param.superVoxelPerField = floor(param.randTrainingSuperVoxel./param.randTrainingFields);
            fprintf('Plate : %s\n',plateDirectory);
            param.treatmentValues = treatmentValues;
            clear numRandImages
%                 re
            %% Get scaling factors across images:
            
%           Get Training images for intensity normalization
            
            
%             minChannel = zeros(numel(randFieldID),param.numChannels);
%             maxChannel = zeros(numel(randFieldID),param.numChannels);
%             
% %             param.trainingColforImageCategories
%             rsRandFieldID = randFieldID(randperm(numel(randFieldID),floor(numel(randFieldID))),:);
%             for i = 1:numel(rsRandFieldID)
%                 if(sum(allImageId == rsRandFieldID(i)) == 0)
%                     disp('Problem00');
%                     re
%                 end
%             end
%             cc = 0;
%             maxCount = (numel(rsRandFieldID).*(param.endZPlane - param.startZPlane +1).*param.numChannels);
%             fprintf('Finding Scaling factor.........................')
%             for iImages = 1:numel(rsRandFieldID)
%                 %     Linear scaling
%                 filenames = plateInfoTable(allImageId == rsRandFieldID(iImages),1:param.numChannels);
%                 filenames = filenames(param.zOffsetStart:end-param.zOffsetEnd,:);
%                 minval = zeros(size(filenames,1),param.numChannels);
%                 maxval = zeros(size(filenames,1),param.numChannels);
%                 for jStacks = 1:size(filenames,1)
%                     for kChannels  = 1:param.numChannels
%                         %                 fprintf('File : %s\n',filenames{jStacks,kChannels});
%                         IM = double(imread(filenames{jStacks,kChannels},'tiff'));
%                         minval(jStacks,kChannels) = min(IM(:));
%                         maxval(jStacks,kChannels) = max(IM(:));                        
%                         cc = cc+1;
%                         fprintf('\b\b\b\b\b\b\b\b%7.3f%%',cc*100/maxCount);
%                     end
%                 end
%                 if(isempty(minval))
%                    fprintf('@pheno3D')
%                 end
%                 minChannel(iImages,:) = min(minval);
%                 maxChannel(iImages,:) = max(maxval);
%             end
%             if(param.intensityNormPerTreatment)
%                 uTreat = unique(treatmentValues);
%                 param.lowerbound = zeros(numel(uTreat,1));
%                 param.upperbound = zeros(numel(uTreat,1));
%                 for i = 1:numel(uTreat)
%                     ii = strcmpi(treatmentValues,uTreat{i,:});
%                     param.lowerbound(i) = quantile(minChannel(ii),.01);
%                     param.upperbound(i) = quantile(maxChannel(ii),.99);
%                 end
%             else
% %                 param.lowerbound = min(minChannel);
% %                 param.upperbound = max(maxChannel);
%                 param.lowerbound = quantile(minChannel,.01);
%                 param.upperbound = quantile(maxChannel,.99);
%             end
            [ param ] = getScalingFactorforImages( metadata,allImageID,param );
%             close(h2);
            fprintf('\n');
            clear iImages jStacks kChannels IM cc minval maxval minChannel maxChannel maxCount
            %% Get intensity threshold
            if(~usePreviousParameterFile)
                param.correctshade = 0;
%                 load('\\mercury\ic200\_YASCP\160114_glutamate\referencefile.mat');
%                 param.allRef = allref;
%                 if(param.correctshade)
%                     param.allRef = param.allRef(param.xOffsetStart:(end - param.xOffsetEnd),param.yOffsetStart:(end - param.yOffsetEnd),:);
%                 end
                %         tStart = tic;
                
                intensityThreshold = nan(5000,param.numChannels);
                % intensityThreshold = zeros(numel(randFieldID),param.numChannels);
                startVal = 1;
%                 endVal = param.croppedZ;
                endVal = 1;
                fprintf('Entering Threshold........................');
                for iImages =  1:numel(randFieldID)
                    %             tImageAnal = tic;
                    ii  = allImageId == randFieldID(iImages);
                    iTmp = getIndividualChannelThreshold(plateInfoTable(ii,...
                        1:param.numChannels),param,ii);
%                     endVal = endVal + size(iTmp,1)
%                     intensityThreshold(startVal:endVal,:) = getIndividualChannelThreshold(plateInfoTable(allImageId == randFieldID(iImages),...
%                         1:param.numChannels),param);
                    intensityThreshold(startVal:endVal + size(iTmp,1)-1,:) = iTmp;
%                     startVal = startVal+param.croppedZ;
%                     endVal = endVal+param.croppedZ;
                    startVal = startVal + size(iTmp,1);
                    endVal = endVal + size(iTmp,1);
                    %             fprintf('Time taken for field %f\n',toc(tImageAnal));
                    fprintf('\b\b\b\b\b\b\b\b%7.3f%%',iImages*100./numel(randFieldID));
                end
                ii = isnan(intensityThreshold(:,1))==0;
                intensityThreshold = intensityThreshold(ii,:);
                param.intensityThreshold = quantile(intensityThreshold,param.intensityThresholdTuningFactor);
                %         toc(tStart);
               fprintf('\n');
                clear iImages intensityThreshold startVal endVal tImageAnal
            end
            
            clear tStart iImages startVal endVal
            %% Find pixel centers
            % warning off;
            if(~usePreviousParameterFile)
                param.randZForTraining = floor(param.croppedZ);
                pixelsForTraining = zeros(param.pixelsPerImage.*numel(randFieldID).*param.randZForTraining,param.numChannels);
                startVal = 1;
                endVal = param.pixelsPerImage.*param.randZForTraining;
                fprintf('Computing pixel bin centers............');
                for iImages = 1:numel(randFieldID)
                    ii = allImageId == randFieldID(iImages);
                    param.randZForTraining = floor(.5*sum(ii));
                    tmpInfoTable = plateInfoTable(ii,1:param.numChannels);
                    pixelsForTraining(startVal:endVal,:) = getTrainingPixels(tmpInfoTable,param,ii);
                    startVal = startVal + param.pixelsPerImage.*param.randZForTraining;
                    endVal = endVal + param.pixelsPerImage.*param.randZForTraining;
                    fprintf('\b\b\b\b\b\b\b\b%7.3f%%',iImages*100./numel(randFieldID));                    
                end
                fprintf('\n');
                pixelsForTraining = pixelsForTraining(sum(pixelsForTraining,2) > 0,:);
                fprintf('Before Sampling: %d  ',size(pixelsForTraining,1));
%                 figure;hist(pixelsForTraining(:,1));title('Before Sampling')
                pixelsForTraining = selectPixelsbyweights(pixelsForTraining);
%                 figure;hist(pixelsForTraining(:,1));title('After Sampling')
                fprintf('After Sampling: %d\n',size(pixelsForTraining,1));
                clear iImages jChannels tmp2 imageCount selBlocks startVal endVal tmpInfoTable tImageAnal;
                fprintf('Computing pixel bin centers\n');
                [ param.pixelBinCenters ] = getPixelBins( pixelsForTraining,param.numVoxelBins);
%                 disp('Competed computing voxel bin centers');
                clear channelBlockImage pixelsForTraining tmp pixelBinCenters;
            end
            clear tStart startVal endVal tmpInfoTable
            %% Find supervoxel centers
            % tielCount = 1;
            if(~usePreviousParameterFile)
                param.pixelBinCenterDifferences = dot(param.pixelBinCenters,param.pixelBinCenters,2)';
%                 disp('Starting computing super voxel bin centers');
                %         tStart = tic;
                tilesForTraining = [];
                fprintf('Computing supervoxel bin centers............');
                for iImages = 1:numel(randFieldID)
                    ii = allImageId == randFieldID(iImages);
                    tmpInfoTable = plateInfoTable(ii,1:param.numChannels);
                    [ superVoxelProfile,fgSuperVoxel ] = getTileProfiles( tmpInfoTable, param.pixelBinCenters, param,ii );
                    tmp = superVoxelProfile(fgSuperVoxel,:);
                    if(param.superVoxelPerField>size(tmp,1))
                        tilesForTraining = [tilesForTraining;tmp(:,:)];
                    else
                        selBlocks  = randperm(size(tmp,1),param.superVoxelPerField);
                        tilesForTraining = [tilesForTraining;tmp(selBlocks,:)];
                    end
                    %             fprintf('Time taken for field %f\n',toc(tImageAnal));
                    fprintf('\b\b\b\b\b\b\b\b%7.3f%%',iImages*100./numel(randFieldID));   
                    
                end
                fprintf('\n');
                param.supervoxelBincenters = getPixelBins( tilesForTraining,param.numSuperVoxelBins);
                clear tilesForTraining tmpInfoTable selBlocks tmp superVoxelProfile fgSuperVoxel
            end
            %% Get Mega voxels 9x9x9 supervoxels
            if(~usePreviousParameterFile)
                fprintf('Computing megavoxel bin centers............');
                megaVoxelforTraining = [];
                for iImages = 1:numel(randFieldID)
                    tmpInfoTable = plateInfoTable(allImageId == randFieldID(iImages),1:param.numChannels);
                    [ superVoxelProfile,fgSuperVoxel ] = getTileProfiles( tmpInfoTable, param.pixelBinCenters, param );
                    [megaVoxelProfile,fgMegaVoxel] = getMegaVoxelProfile(superVoxelProfile,fgSuperVoxel,param);
                    megaVoxelforTraining = [megaVoxelforTraining;megaVoxelProfile(fgMegaVoxel,:)];
                    fprintf('\b\b\b\b\b\b\b\b%7.3f%%',iImages*100./numel(randFieldID)); 
                end
                fprintf('\n');
                param.megaVoxelBincenters = getPixelBins( megaVoxelforTraining,param.numMegaVoxelBins);
%                 disp('Competed computing mega voxel bin centers');
                clear megaVoxelforTraining tmpInfoTable selBlocks tmp tileProfile fgSuperVoxel
            end
            % *************************** End of Training ***************************
            %% Get Image description based on megavoxel
            % clc;
            
            close all;
            disp('Started final analysis');
            % load('result_secondrun.mat');
            param.correctshade = 0;
            % load('referencefile.mat');
            % param.allRef = allRef;
            % if(param.correctshade)
            %     allRef = param.allRef(param.xOffsetStart:(end - param.xOffsetEnd),param.yOffsetStart:(end - param.yOffsetEnd),:);
            % end
            if(param.countBackground)
                dataHeaderMV = cell(1,size(param.numSuperVoxelBins+1 ,2));
                for i = 1:param.numSuperVoxelBins+1
                    dataHeaderMV{1,i} = ['SV' num2str(i)];
                end
                resultIM = zeros(numel(uniqueImageID),param.numMegaVoxelBins+1);
                resultRaw = zeros(numel(uniqueImageID),param.numMegaVoxelBins+1);
            else
                dataHeaderMV = cell(1,size(param.numSuperVoxelBins,2));
                for i = 1:param.numSuperVoxelBins
                    dataHeaderMV{1,i} = ['SV' num2str(i)];
                end
                resultIM = zeros(numel(uniqueImageID),param.numMegaVoxelBins);
                resultRaw = zeros(numel(uniqueImageID),param.numMegaVoxelBins);
            end
            
            
            
            metaIndexTmp = cell(numel(uniqueImageID),size(plateInfoTable,2));
            % resultTAS = zeros(numel(uniqueImageID),27*param.numChannels);
            resultTAS = zeros(numel(uniqueImageID),27*param.numVoxelBins);
%             h2 = waitbar(0,'','Name','Final image analysis') ;
            averageTime = zeros(numel(uniqueImageID),1);
            % tAnalysis = tic;
            fprintf('Analyzing images..................');
            for iImages = 1:numel(uniqueImageID)
                tImageAnal = tic;
                ii = allImageId == uniqueImageID(iImages);
                tmpInfoTable = plateInfoTable(ii,1:param.numChannels);
                [ superVoxelProfile,fgSuperVoxel,resultTAS(iImages,:) ] = getTileProfiles( tmpInfoTable, param.pixelBinCenters, param,ii );
                [megaVoxelProfile,fgMegaVoxel] = getMegaVoxelProfile(superVoxelProfile,fgSuperVoxel,param);
                [resultIM(iImages,:), resultRaw(iImages,:)] = getImageProfile(megaVoxelProfile,fgMegaVoxel,param);
                
                tmp = plateInfoTable(allImageId == uniqueImageID(iImages),:);
                metaIndexTmp(iImages,:) = tmp(1,:);tmp = tmp(1,1:end-1);
                
                %         Write Megavoxel data
                %         outputMVFilename = [plateDirectory '\' plateName '_' outputPrefix '_' tmp{1,4} '_MV_output_' date '.txt'];
%                 outputMVFilename = [plateDirectory '\' plateName '_' outputPrefix '_' tmp{1,strcmpi(metaDataHeader,'Treatment')} '_MV_output_' date '.txt'];
%                 if(exist(outputMVFilename,'file') == 0)
%                     writestr([outputMVFilename],[metaDataHeader(1,1:end-1) dataHeaderMV],'Overwrite');
%                 else
%                     writestr([outputMVFilename],[repmat(tmp,sum(fgMegaVoxel,1),1) cellstr(num2str([megaVoxelProfile(fgMegaVoxel,:)],'%f\t'))],'append');
%                 end
                
                %         resultTAS(iImages,:) = getCategoricalTASScores( categoricalImage, param.numVoxelBins );
%                 fprintf('Time for computation: %.2f\n',toc(tImageAnal));
                averageTime(iImages) = toc(tImageAnal);
%                 remTime = (numel(uniqueImageID) - iImages).*(mean(averageTime(1:iImages)));
%                 str = sprintf('Time remaining %.2f minutes',remTime/60);
%                 waitbar(iImages./numel(uniqueImageID),h2,str) ;
                %     resultTAS(iImages,:) = runTASWrapper(tmpInfoTable,param);
                %     fprintf('Completed %f\n',iImages/numel(uniqueImageID));
                fprintf('\b\b\b\b\b\b\b\b%7.3f%%',iImages*100./numel(uniqueImageID)); 
            end
            fprintf('\n');
            fprintf('Average time per field %7.3fs\n',mean(averageTime));
%             close(h2);
            clear averageTime remTime str;
            disp('Completed image level analysis....');
            %% Compute well level data
            disp('Computing well level data....');
            allWells = metaIndexTmp(:,wellColNum);
            uniqueWells = unique(allWells);
            if(param.countBackground)
                resultWells = zeros(numel(uniqueWells),param.numMegaVoxelBins+1);
            else
                resultWells = zeros(numel(uniqueWells),param.numMegaVoxelBins);
            end
            metadataWell = cell(numel(uniqueWells),size(metaIndexTmp,2));
            for iWells = 1:numel(uniqueWells)
                ii = strcmpi(allWells,uniqueWells{iWells,:});
                resultWells(iWells,:) = sum(resultRaw(ii,:),1);
                tmp = metaIndexTmp(ii,:);
                metadataWell(iWells,:) = tmp(1,:);
            end
            numFGMV = sum(resultWells,2);
            resultWells = bsxfun(@rdivide,resultWells,sum(resultWells,2));
            resultWells = [resultWells numFGMV];
            % fprintf('Total Time taken for all field %f\n',toc(tAnalysis));
            % Output Results
            disp('Writing to output file....');
            dataHeaderIM = cell(1,size(resultIM,2));
            for i = 1:size(resultIM,2)
                dataHeaderIM{1,i} = ['MV' num2str(i)];
            end
            if(param.computeTAS)
                resultTmp = [resultIM resultTAS];
                dataHeaderTAS = cell(1,size(resultTAS,2)); % Create Headers for Output
                catVal = 1;numNeigh = 1;
                for i = 1:size(resultTAS,2)
                    dataHeaderTAS{1,i} = ['TAS_' num2str(catVal) '_' num2str(numNeigh)];
                    if(numNeigh == 27)
                        numNeigh = 1;
                        catVal = catVal+1;
                    else
                        numNeigh = numNeigh+1;
                    end
                end
                outputHeader = [metaDataHeader(1,1:end-1) dataHeaderIM dataHeaderTAS];
                
            else
                resultTmp = [resultIM];
                outputHeader = [metaDataHeader(1,1:end-1) dataHeaderIM];
            end
            
            
            
            
            writestr([outputWellFileName],[metaDataHeader(1,1:end-1) dataHeaderIM {'NumFGMV'}],'Overwrite');
            writestr([outputWellFileName],[metadataWell(:,1:end-1) cellstr(num2str([resultWells],'%f\t'))],'append');
            writestr(outputFileName,outputHeader,'Overwrite');
            writestr(outputFileName,[metaIndexTmp(:,1:end-1) cellstr(num2str([resultTmp],'%f\t'))],'append');
            
            writestr(rawDataFileName,[metaDataHeader(1,1:end-1) dataHeaderIM],'Overwrite');
            writestr(rawDataFileName,[metaIndexTmp(:,1:end-1) cellstr(num2str([resultRaw],'%f\t'))],'append');
            save(parameterFileName,'param');
            
%             disp('done');
            
            % Clear variables
            
            clear i allWells uniqueWells iWells ii tmp numFGMV
            clear allImageId allref catVal categoricalImage fgMegaVoxel fgSuperVoxel filenames
            clear h2 iImages imageProfile megaVoxelProfile megaVoxelforTraining metadatafilename
            clear numNeigh outputFileName outputWellFileName plateDirectory plateInfoTable randFieldID
            clear rawProfile resultRaw rsRandFieldID superVoxelProfile tAnalysis tImageAnal tStart
            clear tmpInfoTable uniqueImageID
            disp('Cleared all variables');
            % return;
            % close(h1);
        end
    end
end
return;