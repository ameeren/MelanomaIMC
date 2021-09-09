addpath('~/Github/MelanomaIMC/code/matlab_scripts/Lib');

% Main path for the all the data
mainPath = '/Volumes/bbvolume/server_homes/thoch/Git/MelanomaIMC/data/full_data/rna/'; 
maskPath = '~/Desktop/REDSEA_masks/';

% This is a csv file for your channel labels within
massDS = dataset('File',[mainPath,'/config/melanoma_1.06_rna.csv'],'Delimiter',',');

% This is where the FCS file output will go to
pathResults = '~/Desktop/REDSEA_test/';

% Select the channels that are expected to be expressed. Cells with minimal
% expression of at least one of these channels will be removed
clusterChannels = massDS.Target; % exclude elemental channels (here the 
% sample dataset does not contain 
[~, clusterChannelsInds] = ismember(clusterChannels,massDS.Target);

% boundaryMod determines the type of compensation done.
% 1:whole cell compensation
% 2:boundary compensation (default)
boundaryMod = 2;
% REDSEAChecker determines the type of compensation done.
% 0:only subtraction; 
% 1:subtraction and reinforcement (default)
REDSEAChecker = 1;

% for boundary compensation, needs to specify elementShape. 
% 1:Sudoku style, 2:Cross style
elementShape = 2;
% elementSize. How many pixels around the center to be considered for the
% elementShape, can be selected from 1-4.
% As a default, keep elementShape and elementSize as 2.
elementSize = 2;

% Select channels for REDSEA compensation. Surface markers are recommended
% boundary compensation codes
% selected channels to do the boundary compensation
normChannels = {'CD3';'T1_CXCL8';'T2_CCL22';'T3_CXCL12';'T4_CXCL10';'T5_CCL4';'T6_DapB';'T7_CCL18';'T8_CXCL13';'T9_CXCL9';'T10_CCL19';'T11_CCL8';'T12_CCL2'}; 
[~, normChannelsInds] = ismember(normChannels,massDS.Target);
channelNormIdentity = zeros(length(massDS.Target),1);
% Getting an array of flags for whether to compensate or not
for i = 1:length(normChannelsInds)
    channelNormIdentity(normChannelsInds(i)) = 1;
end

% Whether what to plot scatter to check the REDSEA result and effect,
% default=0 for not, 1 for plotting.
% Note that if multiple channels selected (in normChannels), to plot out all
% the sanity plots need long time.
plotSanityPlots = 0;

%%
mkdir(pathResults);

% loop through all images
files = dir(fullfile([mainPath, '/cpout'], '*_full_spillcor.tiff'));

cur_files = string(zeros(length(files), 1));
for f = 1:numel(files)
    cur_file = files(f).name;
    cur_file = erase(cur_file, '_full_spillcor.tiff');
    cur_files(f) = string(cur_file);
end


for x = 1:length(cur_files)
    cur_file_name = cur_files(x);

    clear countsNoNoise
    
    for i = 1:length(massDS.full)
        cur_img = imread(strcat(mainPath, 'cpout/', cur_file_name, '_full_spillcor.tiff'), i);
        cur_img = double(cur_img);
        countsNoNoise(:,:,i) = cur_img;
    end

    cur_mask = imread(strcat(maskPath, cur_file_name, '_ilastik_s2_Probabilities_equalized_cellmask.tiff'));
    labelNum = max(max(cur_mask));
    channelNum = length(massDS);
    stats = regionprops(cur_mask,'Area','PixelIdxList');
    countsReshape = reshape(countsNoNoise,size(countsNoNoise,1)*size(countsNoNoise,2),channelNum);

    data = zeros(labelNum,channelNum);
    dataScaleSize = zeros(labelNum,channelNum);
    cellSizes = zeros(labelNum,1);

    for i=1:labelNum
        currData = countsReshape(stats(i).PixelIdxList,:);
        data(i,1:channelNum) = sum(currData,1);
        dataScaleSize(i,1:channelNum) = sum(currData,1) / stats(i).Area;
        cellSizes(i) = stats(i).Area;
    end

    if boundaryMod == 1
        dataCompen = MIBIboundary_compensation_wholeCellSA(cur_mask,data,channelNormIdentity,REDSEAChecker);
    elseif boundaryMod == 2
        dataCompen = MIBIboundary_compensation_boundarySA(cur_mask,data,countsNoNoise,channelNormIdentity,elementShape,elementSize,REDSEAChecker);
    end
    dataCompenScaleSize = dataCompen./repmat(cellSizes,[1 channelNum]);

    outputPath = strcat(pathResults, cur_file_name,'/BM=',num2str(boundaryMod),'_RC=',num2str(REDSEAChecker),'_Shape=',num2str(elementShape),'_Size=',num2str(elementSize));
    mkdir(outputPath);

    % plot sanity scatter images
    if plotSanityPlots == 1
        pathSanityPlots = strcat(outputPath,'/sanityPlots/');
        mkdir(pathSanityPlots);
        MIBIboundary_compensation_plotting(dataScaleSize,dataCompenScaleSize,normChannels,normChannelsInds,pathSanityPlots);
    end   

    dataCompenScaleSize = array2table(dataCompenScaleSize, 'RowNames', string(1:labelNum), 'VariableNames', massDS.Target);
    dataScaleSize = array2table(dataScaleSize, 'RowNames', string(1:labelNum), 'VariableNames', massDS.Target);

    writetable(dataCompenScaleSize, strcat(outputPath,'/dataRedSeaScaled.csv'));
    writetable(dataScaleSize, strcat(outputPath,'/dataScaled.csv'));
    
end