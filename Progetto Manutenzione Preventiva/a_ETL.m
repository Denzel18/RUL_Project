%% Clear Environment
close all;
clc;
clear;


%% Import Dataset Training Small
full_table_train_small = [];
for i=1:12
    filename_ = "_data/PHME2020/Training/Small/Sample%s.csv";
    i_val = sprintf('%02d', i);
    filename = string(sprintf(filename_,i_val));
    delimiterIn = ',';
    headerlinesIn = 1;
    table = readtable(filename, 'HeaderLines',1, 'Format','auto');
    % create delta pressure variable
    table.Var5 = (table.Var3 - table.Var4);
    % change table properties names
    table.Properties.VariableNames = {'Time', 'FlowRate', 'UpPress', 'DownPress', 'DeltaPress'};

    % create time tables from columns
    tabletime1 = array2timetable(table.("FlowRate"),'VariableNames', {'FlowRate'}, 'RowTimes', seconds(table.("Time")));
    tabletime2 = array2timetable(table.("UpPress"),'VariableNames', {'UpPress'}, 'RowTimes', seconds(table.("Time")));
    tabletime3 = array2timetable(table.("DownPress"),'VariableNames', {'DownPress'}, 'RowTimes', seconds(table.("Time")));
    tabletime4 = array2timetable(table.("DeltaPress"),'VariableNames', {'DeltaPress'}, 'RowTimes', seconds(table.("Time")));

    % create full table
    full_table_train_small = [full_table_train_small; {tabletime1}, {tabletime2}, {tabletime3}, {tabletime4}];
end

%% lowpass filter training small
filtered_table_train_small = [];
fs = 10 ;
freq = 3 ;
for i=1:12
    row = full_table_train_small(i,:);
    row1 = array2timetable(lowpass(row{1}.FlowRate, freq ,fs),'VariableNames', {'FlowRate'}, 'TimeStep',seconds(0.1));
    row2 = array2timetable(lowpass(row{2}.UpPress, freq ,fs),'VariableNames', {'UpPress'}, 'TimeStep',seconds(0.1));
    row3 = array2timetable(lowpass(row{3}.DownPress, freq ,fs),'VariableNames', {'DownPress'}, 'TimeStep',seconds(0.1));
    row4 = array2timetable(lowpass(row{4}.DeltaPress, freq ,fs),'VariableNames', {'DeltaPress'}, 'TimeStep',seconds(0.1));
    filtered_table_train_small = [filtered_table_train_small; {row1},{row2}, {row3}, {row4}];
end

%% Clipping Signal first 16second  & delta press > 22 (SMALL)
tab_train_small_filtered_clipped = [];
for i=1:12
    row = filtered_table_train_small(i,:);
    %clipping signal delta press > 22
    TABLE_TEST = row{4}(row{4}.("DeltaPress") > 22,:);
    row{1}(row{1}.Time >= TABLE_TEST.Time(1,1), :) = [];
    row{2}(row{2}.Time >= TABLE_TEST.Time(1,1), :) = [];
    row{3}(row{3}.Time >= TABLE_TEST.Time(1,1), :) = [];
    row{4}(row{4}.Time >= TABLE_TEST.Time(1,1), :) = [];

    %clipping signal before 16 seconds
    row{1}(row{1}.Time < seconds(16), :) = [];
    row{2}(row{2}.Time < seconds(16), :) = [];
    row{3}(row{3}.Time < seconds(16), :) = [];
    row{4}(row{4}.Time < seconds(16), :) = [];

    %shifting signal to zero
    row{1}.Time = row{1}.Time - seconds(16);
    row{2}.Time = row{2}.Time - seconds(16);
    row{3}.Time = row{3}.Time - seconds(16);
    row{4}.Time = row{4}.Time - seconds(16);
    tab_train_small_filtered_clipped = [tab_train_small_filtered_clipped; {row{1}}, {row{2}}, {row{3}}, {row{4}}];
end
%% Import Dataset Training Large
full_table_train_large = [];
for i=33:44
    filename_ = "_data/PHME2020/Training/Large/Sample%s.csv";
    i_val = sprintf('%02d', i);
    filename = string(sprintf(filename_,i_val));
    delimiterIn = ',';
    headerlinesIn = 1;
    table = readtable(filename, 'HeaderLines',1, 'Format','auto');
    % create delta pressure variable
    table.Var5 = (table.Var3 - table.Var4);
    % change table properties names
    table.Properties.VariableNames = {'Time', 'FlowRate', 'UpPress', 'DownPress', 'DeltaPress'};

    % create time tables from columns
    tabletime1 = array2timetable(table.("FlowRate"),'VariableNames', {'FlowRate'}, 'RowTimes', seconds(table.("Time")));
    tabletime2 = array2timetable(table.("UpPress"),'VariableNames', {'UpPress'}, 'RowTimes', seconds(table.("Time")));
    tabletime3 = array2timetable(table.("DownPress"),'VariableNames', {'DownPress'}, 'RowTimes', seconds(table.("Time")));
    tabletime4 = array2timetable(table.("DeltaPress"),'VariableNames', {'DeltaPress'}, 'RowTimes', seconds(table.("Time")));

    % create full table
    full_table_train_large = [full_table_train_large; {tabletime1}, {tabletime2}, {tabletime3}, {tabletime4}];
end

%% lowpass filter training large
filtered_table_train_large = [];
fs = 10 ;
freq = 3 ;
for i=1:12
    row = full_table_train_large(i,:);
    row1 = array2timetable(lowpass(row{1}.FlowRate, freq ,fs),'VariableNames', {'FlowRate'}, 'TimeStep',seconds(0.1));
    row2 = array2timetable(lowpass(row{2}.UpPress, freq ,fs),'VariableNames', {'UpPress'}, 'TimeStep',seconds(0.1));
    row3 = array2timetable(lowpass(row{3}.DownPress, freq ,fs),'VariableNames', {'DownPress'}, 'TimeStep',seconds(0.1));
    row4 = array2timetable(lowpass(row{4}.DeltaPress, freq ,fs),'VariableNames', {'DeltaPress'}, 'TimeStep',seconds(0.1));
    filtered_table_train_large = [filtered_table_train_large; {row1},{row2},{row3}, {row4}];
end

%% Clipping Signal first 16second  & delta press > 22 (LARGE)
tab_train_large_filtered_clipped = [];
for i=1:12
    row = filtered_table_train_large(i,:);
    %clipping signal delta press > 22
    TABLE_TEST = row{4}(row{4}.("DeltaPress") > 22,:);
    row{1}(row{1}.Time >= TABLE_TEST.Time(1,1), :) = [];
    row{2}(row{2}.Time >= TABLE_TEST.Time(1,1), :) = [];
    row{3}(row{3}.Time >= TABLE_TEST.Time(1,1), :) = [];
    row{4}(row{4}.Time >= TABLE_TEST.Time(1,1), :) = [];

    %clipping signal before 16 seconds
    row{1}(row{1}.Time < seconds(16), :) = [];
    row{2}(row{2}.Time < seconds(16), :) = [];
    row{3}(row{3}.Time < seconds(16), :) = [];
    row{4}(row{4}.Time < seconds(16), :) = [];

    %shifting signal to zero
    row{1}.Time = row{1}.Time - seconds(16);
    row{2}.Time = row{2}.Time - seconds(16);
    row{3}.Time = row{3}.Time - seconds(16);
    row{4}.Time = row{4}.Time - seconds(16);
    tab_train_large_filtered_clipped = [tab_train_large_filtered_clipped; {row{1}}, {row{2}}, {row{3}}, {row{4}}];
end
%% Import Dataset Validation Small
full_table_val_small = [];
for i=13:16
    filename_ = "_data/PHME2020/Validation/Small/Sample%s.csv";
    i_val = sprintf('%02d', i);
    filename = string(sprintf(filename_,i_val));
    delimiterIn = ',';
    headerlinesIn = 1;
    table = readtable(filename, 'HeaderLines',1, 'Format','auto');
    % create delta pressure variable
    table.Var5 = (table.Var3 - table.Var4);
    % change table properties names
    table.Properties.VariableNames = {'Time', 'FlowRate', 'UpPress', 'DownPress', 'DeltaPress'};
    % create time tables from columns
    tabletime1 = array2timetable(table.("FlowRate"),'VariableNames', {'FlowRate'}, 'RowTimes', seconds(table.("Time")));
    tabletime2 = array2timetable(table.("UpPress"),'VariableNames', {'UpPress'}, 'RowTimes', seconds(table.("Time")));
    tabletime3 = array2timetable(table.("DownPress"),'VariableNames', {'DownPress'}, 'RowTimes', seconds(table.("Time")));
    tabletime4 = array2timetable(table.("DeltaPress"),'VariableNames', {'DeltaPress'}, 'RowTimes', seconds(table.("Time")));
    % create full table
    full_table_val_small = [full_table_val_small; {tabletime1}, {tabletime2}, {tabletime3}, {tabletime4}];
end


%% lowpass filter validation small
filtered_table_val_small = [];
fs = 10 ;
freq = 3 ;
for i=1:4
    row = full_table_val_small(i,:);
    row1 = array2timetable(lowpass(row{1}.FlowRate, freq ,fs),'VariableNames', {'FlowRate'}, 'TimeStep',seconds(0.1));
    row2 = array2timetable(lowpass(row{2}.UpPress, freq ,fs),'VariableNames', {'UpPress'}, 'TimeStep',seconds(0.1));
    row3 = array2timetable(lowpass(row{3}.DownPress, freq ,fs),'VariableNames', {'DownPress'}, 'TimeStep',seconds(0.1));
    row4 = array2timetable(lowpass(row{4}.DeltaPress, freq ,fs),'VariableNames', {'DeltaPress'}, 'TimeStep',seconds(0.1));
    filtered_table_val_small = [filtered_table_val_small; {row1},{row2}, {row3}, {row4}];
end
%% Clipping Signal first 16second  & delta press > 22 (Validation Small)
tab_val_small_filtered_clipped = [];
for i=1:4
    row = filtered_table_val_small(i,:);
    %clipping signal delta press > 22
    TABLE_TEST = row{4}(row{4}.("DeltaPress") > 22,:);
    row{1}(row{1}.Time >= TABLE_TEST.Time(1,1), :) = [];
    row{2}(row{2}.Time >= TABLE_TEST.Time(1,1), :) = [];
    row{3}(row{3}.Time >= TABLE_TEST.Time(1,1), :) = [];
    row{4}(row{4}.Time >= TABLE_TEST.Time(1,1), :) = [];

    %clipping signal before 16 seconds
    row{1}(row{1}.Time < seconds(16), :) = [];
    row{2}(row{2}.Time < seconds(16), :) = [];
    row{3}(row{3}.Time < seconds(16), :) = [];
    row{4}(row{4}.Time < seconds(16), :) = [];

    %shifting signal to zero
    row{1}.Time = row{1}.Time - seconds(16);
    row{2}.Time = row{2}.Time - seconds(16);
    row{3}.Time = row{3}.Time - seconds(16);
    row{4}.Time = row{4}.Time - seconds(16);
    tab_val_small_filtered_clipped = [tab_val_small_filtered_clipped; {row{1}}, {row{2}}, {row{3}}, {row{4}}];
end



%% Import Dataset Validation Large
full_table_val_large = [];
for i=45:48
    filename_ = "_data/PHME2020/Validation/Large/Sample%s.csv";
    i_val = sprintf('%02d', i);
    filename = string(sprintf(filename_,i_val));
    %disp(filename);
    %disp(i_val)
    delimiterIn = ',';
    headerlinesIn = 1;
    table = readtable(filename, 'HeaderLines',1, 'Format','auto');
    % create delta pressure variable
    table.Var5 = (table.Var3 - table.Var4);
    % change table properties names
    table.Properties.VariableNames = {'Time', 'FlowRate', 'UpPress', 'DownPress', 'DeltaPress'};
    % create time tables from columns
    tabletime1 = array2timetable(table.("FlowRate"),'VariableNames', {'FlowRate'}, 'RowTimes', seconds(table.("Time")));
    tabletime2 = array2timetable(table.("UpPress"),'VariableNames', {'UpPress'}, 'RowTimes', seconds(table.("Time")));
    tabletime3 = array2timetable(table.("DownPress"),'VariableNames', {'DownPress'}, 'RowTimes', seconds(table.("Time")));
    tabletime4 = array2timetable(table.("DeltaPress"),'VariableNames', {'DeltaPress'}, 'RowTimes', seconds(table.("Time")));
    % create full table
    full_table_val_large = [full_table_val_large; {tabletime1}, {tabletime2}, {tabletime3}, {tabletime4}];
end

%% lowpass filter validation large
filtered_table_val_large = [];
fs = 10 ;
freq = 3 ;
for i=1:4
    row = full_table_val_large(i,:);
    row1 = array2timetable(lowpass(row{1}.FlowRate, freq ,fs),'VariableNames', {'FlowRate'}, 'TimeStep',seconds(0.1));
    row2 = array2timetable(lowpass(row{2}.UpPress, freq ,fs),'VariableNames', {'UpPress'}, 'TimeStep',seconds(0.1));
    row3 = array2timetable(lowpass(row{3}.DownPress, freq ,fs),'VariableNames', {'DownPress'}, 'TimeStep',seconds(0.1));
    row4 = array2timetable(lowpass(row{4}.DeltaPress, freq ,fs),'VariableNames', {'DeltaPress'}, 'TimeStep',seconds(0.1));
    filtered_table_val_large = [filtered_table_val_large; {row1},{row2}, {row3}, {row4}];
end
%% Clipping Signal first 16second  & delta press > 22 (Validation Large)
tab_val_large_filtered_clipped = [];
for i=1:4
    row = filtered_table_val_large(i,:);
    %clipping signal delta press > 22
    TABLE_TEST = row{4}(row{4}.("DeltaPress") > 22,:);
    row{1}(row{1}.Time >= TABLE_TEST.Time(1,1), :) = [];
    row{2}(row{2}.Time >= TABLE_TEST.Time(1,1), :) = [];
    row{3}(row{3}.Time >= TABLE_TEST.Time(1,1), :) = [];
    row{4}(row{4}.Time >= TABLE_TEST.Time(1,1), :) = [];

    %clipping signal before 16 seconds
    row{1}(row{1}.Time < seconds(16), :) = [];
    row{2}(row{2}.Time < seconds(16), :) = [];
    row{3}(row{3}.Time < seconds(16), :) = [];
    row{4}(row{4}.Time < seconds(16), :) = [];

    %shifting signal to zero
    row{1}.Time = row{1}.Time - seconds(16);
    row{2}.Time = row{2}.Time - seconds(16);
    row{3}.Time = row{3}.Time - seconds(16);
    row{4}.Time = row{4}.Time - seconds(16);
    tab_val_large_filtered_clipped = [tab_val_large_filtered_clipped; {row{1}}, {row{2}}, {row{3}}, {row{4}}];
end

%% create union clipped_filtered (train-small + train-large)
full_table_train_clipped_filtered_small_large = [tab_train_small_filtered_clipped; tab_train_large_filtered_clipped];

%% create union clipped_filtered (val-small + val-large)
full_table_val_clipped_filtered_small_large = [tab_val_small_filtered_clipped; tab_val_large_filtered_clipped];
