function similarityModelFunction(trainData, validationData)

%% PARAMETERS
% opengl software
rng('default')  % To make sure the results are repeatable
% variable names
varNames = string(trainData{1}.Properties.VariableNames);
% time variable is the "Time_Start" variable
timeVariable = varNames{1};
% feature variables
dataVariables = varNames(2:end);
% number of training samples
nsampleTrain = height(trainData);
% number of test samples
nsampleVal = height(validationData);


%% REMOVE NaN VALUES
% Remove rows with NaN values from train set
for I=1:height(trainData)
    trainDataTmp = trainData{I};
    trainDataTmp(any(ismissing(trainDataTmp),2), :) = [];
    trainData{I} = trainDataTmp;
end

% Remove rows with NaN values from validation set
for I=1:height(validationData)
    validationDataTmp = validationData{I};
    validationDataTmp(any(ismissing(validationDataTmp),2), :) = [];
    validationData{I} = validationDataTmp;
end


%% Construct Health Indicator
for j=1:numel(trainData)
    data = trainData{j};
    rul = max(data.Time_Start)-data.Time_Start;
    data.health_condition = rul / max(rul);
    trainData{j} = data;
end
% Plot Health Indicator
figure
helperPlotEnsemble(trainData, timeVariable, "health_condition", nsampleTrain)


%% Now fit a linear regression model of Health Condition
trainDataUnwrap = vertcat(trainData{:});
% get feature variables in X
X = trainDataUnwrap{:, cellstr(dataVariables)};
% get health condition in y
y = trainDataUnwrap.health_condition;
regModel = fitlm(X,y);
bias = regModel.Coefficients.Estimate(1)
weights = regModel.Coefficients.Estimate(2:end)

% Construct a single health indicator by multiplying the sensor measurements with their associated weights
trainDataFused = cellfun(@(data) degradationSensorFusion(data, dataVariables, weights), trainData, ...
    'UniformOutput', false);

% Plot training data
figure
helperPlotEnsemble(trainDataFused, [], 1, nsampleTrain)
xlabel('Time')
ylabel('Health Indicator')
title('Training Data')


%% Apply same operations to validation data
validationDataFused = cellfun(@(data) degradationSensorFusion(data, dataVariables, weights), validationData, ...
    'UniformOutput', false);

% Plot validation data
figure
helperPlotEnsemble(validationDataFused, [], 1, nsampleVal)
xlabel('Time')
ylabel('Health Indicator')
title('Validation Data')


%% Build Similarity RUL Model
mdl = residualSimilarityModel(...
    'Method', 'poly2',...
    'Distance', 'absolute',...
    'NumNearestNeighbors', height(trainData),...
    'Standardize', 1);

fit(mdl, trainDataFused);


%% Performance Evaluation
breakpoint = [0.5, 0.7, 0.9];
validationDataTmp = validationDataFused{2}; % use one validation data for illustration

% Use the validation data before the first breakpoint, which is 50% of the lifetime.
bpidx = 1;
validationDataTmp50 = validationDataTmp(1:ceil(end*breakpoint(bpidx)),:);
trueRUL = length(validationDataTmp) - length(validationDataTmp50);
[estRUL, ciRUL, pdfRUL] = predictRUL(mdl, validationDataTmp50);
% Visualize the validation data truncated at 50% and its nearest neighbors.
figure
compare(mdl, validationDataTmp50);

% Visualize the estimated RUL compared to the true RUL and the probability distribution of the estimated RUL.
figure
helperPlotRULDistribution(trueRUL, estRUL, pdfRUL, ciRUL)


% Use the validation data before the second breakpoint, which is 70% of the lifetime.
bpidx = 2;
validationDataTmp70 = validationDataTmp(1:ceil(end*breakpoint(bpidx)), :);
trueRUL = length(validationDataTmp) - length(validationDataTmp70);
[estRUL,ciRUL,pdfRUL] = predictRUL(mdl, validationDataTmp70);

figure
compare(mdl, validationDataTmp70);

% Visualize the estimated RUL compared to the true RUL and the probability distribution of the estimated RUL.
figure
helperPlotRULDistribution(trueRUL, estRUL, pdfRUL, ciRUL)


% Use the validation data before the third breakpoint, which is 90% of the lifetime.
bpidx = 3;
validationDataTmp90 = validationDataTmp(1:ceil(end*breakpoint(bpidx)), :);
trueRUL = length(validationDataTmp) - length(validationDataTmp90);
[estRUL,ciRUL,pdfRUL] = predictRUL(mdl, validationDataTmp90);

figure
compare(mdl, validationDataTmp90);

% Visualize the estimated RUL compared to the true RUL and the probability distribution of the estimated RUL.
figure
helperPlotRULDistribution(trueRUL, estRUL, pdfRUL, ciRUL)


%% Now repeat the same evaluation procedure for the WHOLE validation dataset and compute the error between estimated RUL and true RUL for each breakpoint.
numValidation = length(validationDataFused);
numBreakpoint = length(breakpoint);
error = zeros(numValidation, numBreakpoint);

for dataIdx = 1:numValidation
    tmpData = validationDataFused{dataIdx};
    for bpidx = 1:numBreakpoint
        tmpDataTest = tmpData(1:ceil(end*breakpoint(bpidx)), :);
        trueRUL = length(tmpData) - length(tmpDataTest);
        [estRUL, ~, ~] = predictRUL(mdl, tmpDataTest);
        error(dataIdx, bpidx) = estRUL - trueRUL;
    end
end

% Visualize the histogram of the error for each breakpoint together with its probability distribution.
[pdf50, x50] = ksdensity(error(:, 1));
[pdf70, x70] = ksdensity(error(:, 2));
[pdf90, x90] = ksdensity(error(:, 3));

figure
ax(1) = subplot(3,1,1);
hold on
histogram(error(:, 1), 'BinWidth', 5, 'Normalization', 'pdf')
plot(x50, pdf50)
hold off
xlabel('Prediction Error')
title('RUL Prediction Error using first 50% of each validation ensemble member')

ax(2) = subplot(3,1,2);
hold on
histogram(error(:, 2), 'BinWidth', 5, 'Normalization', 'pdf')
plot(x70, pdf70)
hold off
xlabel('Prediction Error')
title('RUL Prediction Error using first 70% of each validation ensemble member')

ax(3) = subplot(3,1,3);
hold on
histogram(error(:, 3), 'BinWidth', 5, 'Normalization', 'pdf')
plot(x90, pdf90)
hold off
xlabel('Prediction Error')
title('RUL Prediction Error using first 90% of each validation ensemble member')
linkaxes(ax)

% Plot the prediction error in a box plot to visualize the median, 25-75 quantile and outliers.
figure
boxplot(error, 'Labels', {'50%', '70%', '90%'})
ylabel('Prediction Error')
title('Prediction error using different percentages of each validation ensemble member')


% Compute and visualize the mean and standard deviation of the prediction error.
errorMean = mean(error)
errorMedian = median(error)
errorSD = std(error)

figure
errorbar([50 70 90], errorMean, errorSD, '-o', 'MarkerEdgeColor','r')
xlim([40, 100])
xlabel('Percentage of validation data used for RUL prediction')
ylabel('Prediction Error')
legend('Mean Prediction Error with 1 Standard Deviation Eror bar', 'Location', 'south')
end