%% STIMA RUL DEGRADATION MODEL - SMALL+LARGE DATASET
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
TrainingData = datasetData(training(cv, 1));
TestData = datasetData(test(cv, 1));

degradationModelFunction(TrainingData, TestData)
