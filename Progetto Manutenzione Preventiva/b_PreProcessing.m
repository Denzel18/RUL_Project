%% Pulizia
close all;
clear;
clc;


%% Training Data Preparation
datasetLargeSmallData = dataPre('_data/DFD Exported Feature/Large+Small_Feature.mat');
datasetLargeData = dataPre('_data/DFD Exported Feature/Large_Feature.mat');
datasetSmallData = dataPre('_data/DFD Exported Feature/Small_Feature.mat');

save('_data/Processed Datasets/AllDatasets.mat')


%% Pulizia
close all;
clear;
clc;

%% Validation Data Preparation
datasetSmallLargeTest = dataPre('_data/DFD Exported Feature/Large+Small_VAL_Feature.mat.mat');
datasetLargeTest = dataPre('_data/DFD Exported Feature/Large_VAL_Feature.mat');
datasetSmallTest = dataPre('_data/DFD Exported Feature/Small_VAL_Feature.mat.mat');

save('_data/Processed Datasets/AllTestDatasets.mat')