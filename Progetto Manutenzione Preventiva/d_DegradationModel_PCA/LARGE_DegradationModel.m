%% STIMA RUL DEGRADATION MODEL - LARGE DATASET
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
TrainingData = datasetLargeData;
TestData = datasetLargeTest;

degradationModelFunction(TrainingData, TestData)
