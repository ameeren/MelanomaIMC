% Main path for the all the data
mainPath = '/Volumes/bbvolume/server_homes/thoch/Git/MelanomaIMC/data/full_data/rna/'; 

% This is a csv file for your channel labels within
massDS = dataset('File',[mainPath,'/config/melanoma_1.06_rna.csv'],'Delimiter',',');

% This is where the FCS file output will go to
pathResults = "~/Desktop/REDSEA_test/";

% Select the channels that are expected to be expressed. Cells with minimal
% expression of at least one of these channels will be removed
clusterChannels = massDS.Target; % exclude elemental channels (here the 
% sample dataset does not contain 
[~, clusterChannelsInds] = ismember(clusterChannels,massDS.Target);

% boundaryMod determines the type of compensation done.
% 1:whole cell compensation
% 2:boundary compensation (default)
boundaryMod = 1;
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
normChannels = {'CD3';'T8_CXCL13';'T1_CXCL8';'T2_CCL22';'T3_CXCL12';'T4_CXCL10';'T5_CCL4';'T7_CCL18'}; 
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
plotSanityPlots = 1;

%%
mkdir(pathResults);

for i = 1:length(massDS.full)
    cur_img = imread([mainPath, '/cpout/20190731_ZTMA256.1_slide2_TH_s1_p14_r1_a1_ac_full_spillcor.tiff'], i);
    cur_img = double(cur_img);
    countsNoNoise(:,:,i) = cur_img;
end

cur_mask = imread([mainPath, '/cpout/20190731_ZTMA256.1_slide2_TH_s1_p14_r1_a1_ac_ilastik_s2_Probabilities_equalized_cellmask.tiff']);
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
    dataCompen = MIBIboundary_compensation_wholeCellSA(newLmod,data,channelNormIdentity,REDSEAChecker);
elseif boundaryMod == 2
    dataCompen = MIBIboundary_compensation_boundarySA(newLmod,data,countsNoNoise,channelNormIdentity,elementShape,elementSize,REDSEAChecker);
end
dataCompenScaleSize = dataCompen./repmat(cellSizes,[1 channelNum]);

    
for p=1:1
    disp(['point',num2str(p)]);
    pointNumber = p;
    % load tiffs to recreate countsNoNoise
    for i=1:length(massDS.Label)
        t = imread([pathTiff, '/Point', num2str(pointNumber), '/', massDS.Label{i}, '.tiff']); %mind the .tif and .tiff
        d = double(t);
        % imshow(d)
        countsNoNoise(:,:,i) = d;
    end
        
    % load segmentation file
    load([pathTiff, '/Point', num2str(pointNumber), '/segmentationParams.mat']);
    labelNum = max(max(newLmod));
    channelNum = length(massDS);
    stats = regionprops(newLmod,'Area','PixelIdxList'); % Stats on cell size. Region props is DF with cell location by count
    countsReshape= reshape(countsNoNoise,size(countsNoNoise,1)*size(countsNoNoise,2),channelNum);
    
    % make a data matrix the size of the number of labels x the number of markers
    % Include one more marker for cell size
    data = zeros(labelNum,channelNum);
    dataScaleSize = zeros(labelNum,channelNum);
    cellSizes = zeros(labelNum,1);
    
    % for each label extract information
    for i=1:labelNum
        currData = countsReshape(stats(i).PixelIdxList,:);
        data(i,1:channelNum) = sum(currData,1);
        dataScaleSize(i,1:channelNum) = sum(currData,1) / stats(i).Area;
        cellSizes(i) = stats(i).Area;
    end
    
    %% do cell boundary compensation
    if boundaryMod == 1
        dataCompen = MIBIboundary_compensation_wholeCellSA(newLmod,data,channelNormIdentity,REDSEAChecker);
    elseif boundaryMod == 2
        dataCompen = MIBIboundary_compensation_boundarySA(newLmod,data,countsNoNoise,channelNormIdentity,elementShape,elementSize,REDSEAChecker);
    end
    dataCompenScaleSize = dataCompen./repmat(cellSizes,[1 channelNum]);

    % %% Add point number 
    % pointnum = double(repmat(p, 1, length(data))); 
    % pointnum = repelem(p, length(data),[1]);
    % data = [data, pointnum];
    % dataScaleSize = [dataScaleSize, pointnum];
    % dataCompen = [dataCompen, pointnum];
    % dataCompenScaleSize = [dataCompenScaleSize, pointnum];

    %%
    % get the final information only for the labels with 
    % 1.positive nuclear identity (cells)
    % 2.that have enough information in the clustering channels to be
    % clustered
    labelIdentityNew2 = labelIdentityNew([1:end-1]); % fix bug resulting from previous script
    sumDataScaleSizeInClusterChannels = sum(dataScaleSize(:,clusterChannelsInds),2);
    labelIdentityNew2(sumDataScaleSizeInClusterChannels<0.1) = 2;
    
    dataCells = data(labelIdentityNew2==1,:);
    dataScaleSizeCells = dataScaleSize(labelIdentityNew2==1,:);
    dataCompenCells = dataCompen(labelIdentityNew2==1,:);
    dataCompenScaleSizeCells = dataCompenScaleSize(labelIdentityNew2==1,:);

    labelVec=find(labelIdentityNew2==1);
    
    % get cell sizes only for cells
    cellSizesVec = cellSizes(labelIdentityNew2==1);

    dataL = [labelVec,cellSizesVec,dataCells,repmat(p,[length(labelVec) 1])];
    dataScaleSizeL = [labelVec,cellSizesVec,dataScaleSizeCells,repmat(p,[length(labelVec) 1])];
    dataCompenL = [labelVec,cellSizesVec,dataCompenCells,repmat(p,[length(labelVec) 1])];
    dataCompenScaleSizeL = [labelVec,cellSizesVec,dataCompenScaleSizeCells,repmat(p,[length(labelVec) 1])];

    % dataTransStdL = [labelVec,dataCellsTransStd];
    % dataScaleSizeTransStdL = [labelVec,dataScaleSizeCellsTransStd];
    % dataStdL = [labelVec,dataCellsStd];
    % dataScaleSizeStdL = [labelVec,dataScaleSizeCellsStd];

    % channelLabelsForFCS = ['cellLabelInImage';'cellSize';massDS.Label];
    channelLabelsForFCS = ['cellLabelInImage';'cellSize';massDS.Label;'PointNum'];
    
    %% output
    outputPath = [pathResults,'/Point',num2str(pointNumber),'/BM=',num2str(boundaryMod),'_RC=',num2str(REDSEAChecker),'_Shape=',num2str(elementShape),'_Size=',num2str(elementSize)];
    mkdir(outputPath);

    % plot sanity scatter images
    if plotSanityPlots == 1
        pathSanityPlots = [outputPath,'/sanityPlots/'];
        mkdir(pathSanityPlots);
        MIBIboundary_compensation_plotting(dataScaleSizeCells,dataCompenScaleSizeCells,normChannels,normChannelsInds,pathSanityPlots);
    end    
    
    % save fcs
    TEXT.PnS = channelLabelsForFCS;
    TEXT.PnN = channelLabelsForFCS;
    
    save([outputPath,'/cellData.mat'],'labelIdentityNew2','labelVec','cellSizesVec','dataCells','dataScaleSizeCells','dataCompenCells','dataCompenScaleSizeCells','channelLabelsForFCS');
    writeFCS([outputPath,'/dataFCS.fcs'],dataL,TEXT);
    writeFCS([outputPath,'/dataScaleSizeFCS.fcs'],dataScaleSizeL,TEXT);
    writeFCS([outputPath,'/dataRedSeaFCS.fcs'],dataCompenL,TEXT);
    writeFCS([outputPath,'/dataRedSeaScaleSizeFCS.fcs'],dataCompenScaleSizeL,TEXT);

    % writeFCS([outputPath,'/dataTransFCS.fcs'],dataTransL,TEXT);
    % writeFCS([outputPath,'/dataScaleSizeTransFCS.fcs'],dataScaleSizeTransL,TEXT);
    % writeFCS([outputPath,'/dataStdFCS.fcs'],dataStdL,TEXT);
    % writeFCS([outputPath,'/dataScaleSizeStdFCS.fcs'],dataScaleSizeStdL,TEXT);
    % writeFCS([outputPath,'/dataTransStdFCS.fcs'],dataTransStdL,TEXT);
    % writeFCS([outputPath,'/dataScaleSizeTransStdFCS.fcs'],dataScaleSizeTransStdL,TEXT);
end