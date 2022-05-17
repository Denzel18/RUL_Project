%% STIMA RUL SIMILARITY MODEL - LARGE DATASET
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Pulizia
close all;
clear;
clc;


%% LOAD DATASETS
load('../_data/Processed Datasets/AllDatasets.mat')
load('../_data/Processed Datasets/AllTestDatasets.mat');

% DATASET LARGE
trainData = datasetLargeData;
validationData = datasetLargeTest;

similarityModelFunction(trainData, validationData);
