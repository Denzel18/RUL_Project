function [MeanErrorMeanResult, MeanErrorMedianResult, MeanErrorSDResult] = checkError(errorMeanTab, errorMedianTab, errorSDTab)
    
%% Error Mean Tab 
    SumErrorMean50 = 0; 
    SumErrorMean70 = 0; 
    SumErrorMean90 = 0; 
    for I=1:height(errorMeanTab)
        row = errorMeanTab{I};
        %row = row{1};
        SumErrorMean50 = SumErrorMean50 + row(1); 
        SumErrorMean70 = SumErrorMean70 + row(2); 
        SumErrorMean90 = SumErrorMean90 + row(3); 
    end 
    
    MeanErrorMean50 = SumErrorMean50/height(errorMeanTab); 
    MeanErrorMean70 = SumErrorMean70/height(errorMeanTab);
    MeanErrorMean90 = SumErrorMean90/height(errorMeanTab);

    MeanErrorMeanResult = [MeanErrorMean50, MeanErrorMean70, MeanErrorMean90]; 

    %% Error Median Tab 
    SumErrorMedian50 = 0; 
    SumErrorMedian70 = 0; 
    SumErrorMedian90 = 0; 
    for I=1:height(errorMeanTab)
        row = errorMedianTab{I};
        %row = row{1};
        SumErrorMedian50 = SumErrorMedian50 + row(1); 
        SumErrorMedian70 = SumErrorMedian70 + row(2); 
        SumErrorMedian90 = SumErrorMedian90 + row(3); 
    end 
    
    MeanErrorMedian50 = SumErrorMedian50/height(errorMeanTab); 
    MeanErrorMedian70 = SumErrorMedian70/height(errorMeanTab);
    MeanErrorMedian90 = SumErrorMedian90/height(errorMeanTab);
    
    MeanErrorMedianResult = [MeanErrorMedian50, MeanErrorMedian70, MeanErrorMedian90];
    
    %% Error SD Tab 
    SumErrorSD50 = 0; 
    SumErrorSD70 = 0; 
    SumErrorSD90 = 0; 
    
    for I=1:height(errorMeanTab)
        row = errorSDTab{I};
        %row = row{1};
        SumErrorSD50 = SumErrorSD50 + row(1); 
        SumErrorSD70 = SumErrorSD70 + row(2); 
        SumErrorSD90 = SumErrorSD90 + row(3); 
    end 
    
    MeanErrorSD50 = SumErrorSD50/height(errorMeanTab); 
    MeanErrorSD70 = SumErrorSD70/height(errorMeanTab);
    MeanErrorSD90 = SumErrorSD90/height(errorMeanTab);

    MeanErrorSDResult = [MeanErrorSD50, MeanErrorSD70, MeanErrorSD90];
end
