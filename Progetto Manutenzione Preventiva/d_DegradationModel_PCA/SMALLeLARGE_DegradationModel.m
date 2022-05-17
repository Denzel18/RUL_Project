%% STIMA RUL DEGRADATION MODEL - SMALL+LARGE DATASET
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Pulizia
close all;
clear;
clc;


%% LOAD DATASETS
load('../_data/Processed Datasets/AllDatasets.mat')
load('../_data/Processed Datasets/AllTestDatasets.mat');

% DATASET SMALL+LARGE
TrainingData = datasetLargeSmallData;
TestData = datasetSmallLargeTest;

degradationModelFunction(TrainingData, TestData)
