function degradationModelFunction(TrainingData, TestData)

%% PARAMETERS
%opengl software;
nTrain = height(TrainingData);
nTest = height(TestData);
timeUnit = 'seconds';
threshold=[];
durations = [];
Fs = 1;


%% DELETE ALL NaN VALUES FROM DATASETS
for i = 1:height(TrainingData)
    TrainingData{i, 1}(any(ismissing(TrainingData{i, 1}),2), :) = [];
end
for i = 1:height(TestData)
    TestData{i, 1}(any(ismissing(TestData{i, 1}),2), :) = [];
end


%% CALCULATE HEALTH INDICATOR
FullDataset = [TrainingData; TestData];

for I = 1:height(FullDataset)
    featureTable = table2timetable(FullDataset{I});
    variableNames = featureTable.Properties.VariableNames;
    featureTableSmooth = varfun(@(x) movmean(x, [5 0]), featureTable);
    featureTableSmooth.Properties.VariableNames = variableNames;

    % NORMALIZZAZIONE DATI
    meanData = mean(featureTableSmooth{:,:});
    sdData = std(featureTableSmooth{:,:});
    dataNormalized = (featureTableSmooth{:,:} - meanData)./sdData;
    coef = pca(dataNormalized);

    PCA1 = (featureTableSmooth{:,:} - meanData) ./ sdData * coef(:, 1);

    % HEALTH INDICATOR
    healthIndicator = PCA1;
    healthIndicator = healthIndicator - healthIndicator(1);
    
    disp(healthIndicator)
    durations(I) = height(FullDataset{I});
    threshold(I) = healthIndicator(end-1);
    FullDataset{I} = table2timetable(array2table(healthIndicator), "SampleRate", Fs);
end

% Update Training/Test Sets with the HEALTH INDICATOR
TrainingData = FullDataset(1:nTrain);
TestData = FullDataset(nTrain + 1:end);

% Calculate Threshold (minimum value of threasholds in the dataset)
threshold = min(threshold);
thresholdDur = max(durations);

%% PLOT TRAINING DATA
figure;
hold on
title('TRAINING DATA')
for i = 1:height(TrainingData)
    plot(TrainingData{i, 1}.Time, TrainingData{i,1}.healthIndicator)
end
xlabel('Time [s]');
ylabel('Condition Indicator');
% legend
% PLOT SOGLIA
plot(0:1:thresholdDur-1, threshold*ones(1,thresholdDur));
hold off;


%% PLOT TEST DATA
figure;
hold on
title('TEST DATA')
for i = 1:height(TestData)
    plot(TestData{i, 1}.Time, TestData{i,1}.healthIndicator)
end
xlabel('Time [s]');
ylabel('Condition Indicator');
% legend
% SOGLIA
plot(0:1:thresholdDur-1, threshold*ones(1,thresholdDur));
hold off;


%% STIMA RUL TEST SET (BREAKPOINTS)
breakpoint = [0.5, 0.7, 0.9];
numBreakpoint = length(breakpoint);
error = zeros(nTest, numBreakpoint);
for j=1:nTest
    % Addestramento di un modello di degradazione
    mdl = exponentialDegradationModel('LifeTimeUnit', 'seconds', 'SlopeDetectionLevel', 0.01);
    % fit model
    fit(mdl, TrainingData, 'Time', 'healthIndicator');
    CurrentTestData = TestData{j};
    for bpidx = 1:numBreakpoint
        tmpDataTest = CurrentTestData(1:ceil(end*breakpoint(bpidx)), :);
        trueRUL = height(CurrentTestData) - height(tmpDataTest);
        update(mdl, tmpDataTest(end,:))
        [estRUL, ~] = predictRUL(mdl, tmpDataTest(end,:), threshold);
        error(j, bpidx) = time2num(estRUL) - trueRUL;
    end
end

%% Stima online della RUL (FOR EACH TEST DATA SAMPLE)
for j=1:nTest
    % Addestramento di un modello di degradazione
    mdl = exponentialDegradationModel('LifeTimeUnit', 'seconds', 'SlopeDetectionLevel', 0.01);
    % fit model
    fit(mdl, TrainingData, 'Time', 'healthIndicator');

    % Set Current Test Data Sample
    CurrentTestData = TestData{j};
    % Size of current test data sample
    N = size(CurrentTestData, 1);
    EstRUL = seconds(zeros(N, 1));
    CI = seconds(zeros(N, 2)); % abbiamo due parametri, beta e theta. rappresenta estremo inferiore e superiore all'interno del quale c'è la stima della RUL
    ModelParameters = zeros(N, 3); % Theta, Beta e Rho
    for t = 1:N
        CurrentDataSample = CurrentTestData(t,:);
        update(mdl, CurrentDataSample)
        ModelParameters(t,:) = [mdl.Theta mdl.Beta mdl.Rho];
        if ~isempty(mdl.SlopeDetectionInstant)
            [EstRUL(t), CI(t,:)] = predictRUL(mdl, CurrentDataSample, threshold);
        end
    end

    %% Plot stima RUL e intervalli di confidenza
    Time = seconds(1:N)';
    tStart = mdl.SlopeDetectionInstant;
    figure
    %plot(Time, EstRUL, 'b.-', Time, CI, 'r', (tStart+seconds(1)), EstRUL(time2num(tStart)+1), 'g*')
    plot(Time, EstRUL, 'b.-', Time, CI, 'r', (tStart+seconds(1)), EstRUL(ceil(time2num(tStart)+1)), 'g*')
    title('Stima della RUL istante t')
    xlabel('t')
    ylabel('Stima RUL')
    legend('Stima RUL', 'Intervallo confidenza sup.', 'Intervallo confidenza inf.', 'Momento attivazione stima')
end

%% PLOT ERROR OF WHOLE TEST SET
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
legend('Mean Prediction Error with 1 Standard Deviation Error bar', 'Location', 'south')

end