function helperEstimateRul(TimeRulEstimated, CI)
    % Tranform Array of cell in a cell array for Time Rul Estimated 
    for nFeature = 1:width(TimeRulEstimated)
        TimeRulEstimatedLocal{nFeature} = TimeRulEstimated{nFeature}; 
    end

    % Matrix Table with all Estimated RUL considering every features 
    MatrixTime = [TimeRulEstimatedLocal{1,1}...
        TimeRulEstimatedLocal{1,2}...
        TimeRulEstimatedLocal{1,3}...
        TimeRulEstimatedLocal{1,4}...
        TimeRulEstimatedLocal{1,5}...
    ]; 

    % Mean Features 
    for j = 1: height(MatrixTime)
        rowMatrix = MatrixTime(j,:); 
        meanTime(j,:) = mean(rowMatrix);
    end 

    %  Tranform Array of cell in a cell array for Confidence Interval 
    for nFeature = 1:width(TimeRulEstimated)
        CI_Local{nFeature} = CI{nFeature}; 
    end 

    % Matrix Table with all Confidence Interval (LOW)
    MatrixCILocalLow = [
        CI_Local{1,1}(:,1)...
        CI_Local{1,2}(:,1)...
        CI_Local{1,3}(:,1)...
        CI_Local{1,4}(:,1)...
        CI_Local{1,5}(:,1)...
    ]; 

    % Mean Features Inf Confidence Interval (LOW) 
    for j = 1: height(MatrixCILocalLow)
        rowMatrix = MatrixCILocalLow(j,:); 
        meanCILow(j,:) = mean(rowMatrix);
    end 

    % Matrix Table with all Confidence Interval (HIGH)
    MatrixCILocalHigh = [
        CI_Local{1,1}(:,2)...
        CI_Local{1,2}(:,2)...
        CI_Local{1,3}(:,2)...
        CI_Local{1,4}(:,2)...
        CI_Local{1,5}(:,2)...
    ]; 

    % Mean Features 
    for j = 1: height(MatrixCILocalHigh)
        rowMatrix = MatrixCILocalHigh(j,:); 
        meanCIHigh(j,:) = mean(rowMatrix);
    end 

    % Plot Results
    figure
    hold on
    plot(meanTime);
    plot(meanCILow, 'r');
    plot(meanCIHigh, 'r');
    xlabel('seconds')
    ylabel('Stima RUL')
    title('RUL media sulle 5 features')
    legend('Stima Rul', 'Intervallo di Confidenza Inf', 'Intervallo di Confidenza Sup')
end
