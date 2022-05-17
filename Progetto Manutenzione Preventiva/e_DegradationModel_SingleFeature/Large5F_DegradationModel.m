%% Pulizia
close all;
clear;
clc;

w = warning ('off','all');

load('../_data/Processed Datasets/AllDatasets.mat')
load('../_data/Processed Datasets/AllTestDatasets.mat');


%% DATASET LARGE
TrainingData = datasetLargeData;
TestData = datasetLargeTest;
%% CALCOLO RESULTS
for nFeature = 1:5
    [errorSDTab{nFeature}, errorMeanTab{nFeature}, ...
        errorMedianTab{nFeature}, TimeRulEstimated{nFeature}, CI{nFeature}, error{nFeature}] = ...
    degradationModelFunction(TrainingData, TestData, nFeature); 
end

load('TEST_DATA')
%% Calcolo Errori 
helperPlotError(errorSDTab,errorMeanTab, errorMedianTab, error);

%% Stima RUL 
helperEstimateRul(TimeRulEstimated, CI); 