%% question1
data1_1=load('E:\master-2\CVPR\CVPR\PR_CW_DATA_2021\acrylic_211_01_HOLD.mat');
data2_1=load('E:\master-2\CVPR\CVPR\PR_CW_DATA_2021\black_foam_110_01_HOLD.mat');
data3_1=load('E:\master-2\CVPR\CVPR\PR_CW_DATA_2021\car_sponge_101_01_HOLD.mat');
data4_1=load('E:\master-2\CVPR\CVPR\PR_CW_DATA_2021\flour_sack_410_01_HOLD.mat');
data5_1=load('E:\master-2\CVPR\CVPR\PR_CW_DATA_2021\kitchen_sponge_114_01_HOLD.mat');
data6_1=load('E:\master-2\CVPR\CVPR\PR_CW_DATA_2021\steel_vase_702_01_HOLD.mat');


% question 1: load the original files and show the data from the same graph
% in order to show the differences between different objects

figure(1)

% plot the F0Electrodes values of different objects. in each object, we
% take the average of electrodes
rowAverage = mean(data1_1.F0Electrodes, 1);
plot(rowAverage)
hold on;
rowAverage = mean(data2_1.F0Electrodes, 1);
plot(rowAverage)
hold on;
rowAverage = mean(data3_1.F0Electrodes, 1);
plot(rowAverage)
hold on;
rowAverage = mean(data4_1.F0Electrodes, 1);
plot(rowAverage)
hold on;
rowAverage = mean(data5_1.F0Electrodes, 1);
plot(rowAverage)
hold on;
rowAverage = mean(data6_1.F0Electrodes, 1);
plot(rowAverage)



figure(2)

% plot the F0pac values of different objects
% in each object, we take the average of electrodes
rowAverage = mean(data1_1.F0pac, 1);
plot(rowAverage)
hold on;
rowAverage = mean(data2_1.F0pac, 1);
plot(rowAverage)
hold on;
rowAverage = mean(data3_1.F0pac, 1);
plot(rowAverage)
hold on;
rowAverage = mean(data4_1.F0pac, 1);
plot(rowAverage)
hold on;
rowAverage = mean(data5_1.F0pac, 1);
plot(rowAverage)
hold on;
rowAverage = mean(data6_1.F0pac, 1);
plot(rowAverage) 

figure(3)

% plot the F0pdc values of different objects
plot(data1_1.F0pdc)
hold on;
plot(data2_1.F0pdc)
hold on;
plot(data3_1.F0pdc)
hold on;
plot(data4_1.F0pdc)
hold on;
plot(data5_1.F0pdc)
hold on;
plot(data6_1.F0pdc) 

figure(4)

% plot the F0tac values of different objects
plot(data1_1.F0tac)
hold on;
plot(data2_1.F0tac)
hold on;
plot(data3_1.F0tac)
hold on;
plot(data4_1.F0tac)
hold on;
plot(data5_1.F0tac)
hold on;
plot(data6_1.F0tac)

figure(5)

% plot the F0tdc values of different objects
plot(data1_1.F0tdc)
hold on;
plot(data2_1.F0tdc)
hold on;
plot(data3_1.F0tdc)
hold on;
plot(data4_1.F0tdc)
hold on;
plot(data5_1.F0tdc)
hold on;
plot(data6_1.F0tdc) 

%% question2

% start_time = 1;
% stop_time = 100;
time = 200; % 待修改的时间捕获

folderPath = pwd;
files = dir(fullfile(folderPath, '*.mat'));
name_F0 = {'F0pac', 'F0pdc', 'F0tac', 'F0tdc'};% 1: High Vibration 2: Low Pressure, 3:Temperature change 4:temperature
name_F1 = {'F1pac',  'F1pdc',  'F1tac', 'F1tdc'};
name_Electro_F0 = {'F0Electrodes'}; % Electrodes
name_Electro_F1 = {'F1Electrodes'}; % Electrodes

% 初始化数据矩阵
dataMatrix_F0 = [];
dataMatrix_F1 = [];
dataMatrix_elec_F0 = [];
dataMatrix_elec_F1 = [];

for i_name = 1:length(name_F0)
    tempData = []; % 临时存储当前变量的所有文件数据

    for i = 1:length(files)
        data = load(fullfile(folderPath, files(i).name));

        if isfield(data, name_F0{i_name})
            if strcmp(name_F0{i_name}, 'F0pac') % 检查是否是特殊处理的变量
                % 特殊处理 F0pac
                if size(data.(name_F0{i_name}), 1) >= 2 && size(data.(name_F0{i_name}), 2) >= time
                    tempData(end + 1) = data.(name_F0{i_name})(2, time);
                else
                    tempData(end + 1) = NaN;
                end
            else
                % 正常处理其他变量
                if length(data.(name_F0{i_name})) >= time
                    tempData(end + 1) = data.(name_F0{i_name})(time);
                else
                    tempData(end + 1) = NaN;
                end
            end
        end
    end

    % 将当前变量的数据添加到数据矩阵中
    dataMatrix_F0 = [dataMatrix_F0; tempData];
end

for i_name = 1:length(name_F1)
    tempData = []; % 临时存储当前变量的所有文件数据

    for i = 1:length(files)
        data = load(fullfile(folderPath, files(i).name));

        if isfield(data, name_F1{i_name})
            if strcmp(name_F1{i_name}, 'F1pac') % 检查是否是特殊处理的变量
                % 特殊处理 F0pac
                if size(data.(name_F1{i_name}), 1) >= 2 && size(data.(name_F1{i_name}), 2) >= time
                    tempData(end + 1) = data.(name_F1{i_name})(2, time);
                else
                    tempData(end + 1) = NaN;
                end
            else
                % 正常处理其他变量
                if length(data.(name_F1{i_name})) >= time
                    tempData(end + 1) = data.(name_F1{i_name})(time);
                else
                    tempData(end + 1) = NaN;
                end
            end
        end
    end

    % 将当前变量的数据添加到数据矩阵中
    dataMatrix_F1 = [dataMatrix_F1; tempData];
end

for i_name = 1:length(name_Electro_F0)
    tempData = []; % 临时存储当前变量的所有文件数据

    for i = 1:length(files)
        data = load(fullfile(folderPath, files(i).name));

        if isfield(data, name_Electro_F0{i_name})
            selectedData = data.(name_Electro_F0{i_name})(:, time); % 提取每一行在指定时间的数据
            tempData = [tempData; selectedData']; % 转换为行向量并添加到临时数据中
        end
    end

    % 将当前变量的数据添加到数据矩阵中
    dataMatrix_elec_F0 = [dataMatrix_elec_F0; tempData]; % 此处可能需要调整
end

for i_name = 1:length(name_Electro_F1)
    tempData = []; % 临时存储当前变量的所有文件数据

    for i = 1:length(files)
        data = load(fullfile(folderPath, files(i).name));

        if isfield(data, name_Electro_F1{i_name})
            selectedData = data.(name_Electro_F1{i_name})(:, time); % 提取每一行在指定时间的数据
            tempData = [tempData; selectedData']; % 转换为行向量并添加到临时数据中
        end
    end

    % 将当前变量的数据添加到数据矩阵中
    dataMatrix_elec_F1 = [dataMatrix_elec_F1; tempData]; % 此处可能需要调整
end

% 转置数据矩阵以匹配所需的60x4格式
dataMatrix_F0 = dataMatrix_F0';
dataMatrix_F1 = dataMatrix_F1';

% 保存数据
saveFilename = fullfile(folderPath, 'combined_F0.mat');
save(saveFilename, 'dataMatrix_F0');

saveFilename = fullfile(folderPath, 'combined_F1.mat');
save(saveFilename, 'dataMatrix_F1');

saveFilename = fullfile(folderPath, 'combined_Electro_F0.mat');
save(saveFilename, 'dataMatrix_elec_F0');

saveFilename = fullfile(folderPath, 'combined_Electro_F1.mat');
save(saveFilename, 'dataMatrix_elec_F1');

%% question3

% load the data after sampling

dataF0=load('E:\master-2\CVPR\CVPR\PR_CW_DATA_2021\F0_PVT.mat');
dataF1=load('E:\master-2\CVPR\CVPR\PR_CW_DATA_2021\F1_PVT.mat');
dataEl1=load('E:\master-2\CVPR\CVPR\PR_CW_DATA_2021\F0_Electrodes.mat');
dataEl2=load('E:\master-2\CVPR\CVPR\PR_CW_DATA_2021\F1_Electrodes.mat');

% question 1: load the generated files and show the data from the same graph
% in order to show the differences between different objects

% pressure, vibration, temperature
% pdc, pac, tdc

% object_list = {'acrylic_211_01_HOLD_','black_foam_110_01_HOLD_','car_sponge_101_01_HOLD_',
%    'flour_sack_410_01_HOLD_','kitchen_sponge_114_01_HOLD_','steel_vase_702_01_HOLD_'};

colRanges = [1:10; 11:20; 21:30; 31:40; 41:50; 51:60];

figure(6);

% Loop through the different column groups
for groupIdx = 1:size(colRanges, 1)
    groupData = dataF0(:, colRanges(groupIdx, :));
    scatter3(groupData(1, :), groupData(2, :), groupData(3, :), 50, 'filled', 'DisplayName', sprintf('Cols %d-%d', colRanges(groupIdx, 1), colRanges(groupIdx, end)));
    
    hold on;
end

xlabel('X-axis');
ylabel('Y-axis');
zlabel('Z-axis');

% legend('Location', 'Best');

% Title and grid
title('3D Scatter Plot with Different Colors for Column Groups');
grid on;

hold off;

% saveas(gcf, '3D_Scatter_Plot.png');
