%% STIMA RUL SIMILARITY MODEL - SMALL+LARGE DATASET
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Pulizia
close all;
clear;
clc;


%% LOAD DATASETS
load('../_data/Processed Datasets/AllDatasets.mat')

% DATASET SMALL+LARGE
datasetData = datasetLargeSmallData;

numEnsemble = length(datasetData);
numFold = 7;
cv = cvpartition(numEnsemble, 'KFold', numFold);
trainData = datasetData(training(cv, 1));
validationData = datasetData(test(cv, 1));

similarityModelFunction(trainData, validationData);
