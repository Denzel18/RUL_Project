function newTableData = dataPre(dbName)
    load(dbName)
    newTableData = [];
    
    for i = 1:height(FeatureTable1)
        for j = 1:24
            if string(FeatureTable1(i,1).EnsembleID_) == "Member " + num2str(j, '%d')
                row_info = FeatureTable1(i, [3,4,5,6,7,8]);
                row_info.Properties.VariableNames = {'Time_Start', 'BandPower_DeltaPress', 'PeakAmp_DeltaPress', 'Mean_DeltaPress', 'PeakValue_DeltaPress', 'RMS_DeltaPress'};
                try
                    t = newTableData(j,:);
                    t{1,1} = [t{1,1}; row_info];
                    newTableData(j,:) = t;
                catch ME
                    newTableData = [newTableData; {row_info}];
                end
                break
            end
        end
    end
end