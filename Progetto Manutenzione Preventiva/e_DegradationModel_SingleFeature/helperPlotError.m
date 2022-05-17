function helperPlotError(errorSDTab, errorMeanTab, errorMedianTab, error)

for nFeature = 1:width(errorSDTab)
    % TODO: si può anche togliere...
    errorMeanTabLocal{nFeature} = errorMeanTab{nFeature};
    errorMedianTabLocal{nFeature} = errorMedianTab{nFeature};
    errorSDTabLocal{nFeature} = errorSDTab{nFeature};
end

[MeanErrorMeanResult, MeanErrorMedianResult, MeanErrorSDResult] = checkError(errorMeanTabLocal', errorMedianTabLocal', errorSDTabLocal');
disp('Mean Error');
disp(MeanErrorMeanResult);
disp('Median Error');
disp(MeanErrorMedianResult);
disp('SD Error');
disp(MeanErrorSDResult);

% Plot the prediction error in a box plot to visualize the median, 25-75 quantile and outliers.

MatrixError50 = [error{1,1}(:,1)...
    error{1,2}(:,1)...
    error{1,3}(:,1)...
    error{1,4}(:,1)...
    error{1,5}(:,1)...
    ];

MatrixError70 = [error{1,1}(:,2)...
    error{1,2}(:,2)...
    error{1,3}(:,2)...
    error{1,4}(:,2)...
    error{1,5}(:,2)...
    ];

MatrixError90 = [error{1,1}(:,3)...
    error{1,2}(:,3)...
    error{1,3}(:,3)...
    error{1,4}(:,3)...
    error{1,5}(:,3)...
    ];

% Mean Error 50%
for j = 1: height(MatrixError50)
    rowMatrix = MatrixError50(j,:);
    meanError50(j,:) = mean(rowMatrix);
end

% Mean Error 70%
for j = 1: height(MatrixError70)
    rowMatrix = MatrixError70(j,:);
    meanError70(j,:) = mean(rowMatrix);
end

% Mean Error 90%
for j = 1: height(MatrixError90)
    rowMatrix = MatrixError90(j,:);
    meanError90(j,:) = mean(rowMatrix);
end

meanError = [meanError50 meanError70 meanError90];
figure
% error = [MeanErrorMeanResult; MeanErrorMedianResult; MeanErrorSDResult];
boxplot(meanError, 'Labels', {'50%', '70%', '90%'})
xlabel('Percentage of validation data used for RUL prediction')
ylabel('Prediction Error')
title('Prediction error using different percentages of each validation ensemble member')

% figure
figure
errorbar([50 70 90], MeanErrorMeanResult, MeanErrorSDResult, '-o', 'MarkerEdgeColor','r')
xlim([40, 100])
xlabel('Percentage of validation data used for RUL prediction')
ylabel('Prediction Error')
legend('Mean Prediction Error with 1 Standard Deviation Error bar', 'Location', 'south')
end

