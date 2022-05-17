%% STIMA RUL DEGRADATION MODEL - SMALL DATASET
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Pulizia
close all;
clear;
clc;


%% LOAD DATASETS
load('../_data/Processed Datasets/AllDatasets.mat')
load('../_data/Processed Datasets/AllTestDatasets.mat');

% DATASET SMALL
TrainingData = datasetSmallData;
TestData = datasetSmallTest;

degradationModelFunction(TrainingData, TestData)
