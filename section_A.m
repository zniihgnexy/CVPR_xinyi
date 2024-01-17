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

start_time = 1;
stop_time = 100;

folderPath = 'E:\master-2\CVPR\CVPR\PR_CW_DATA_2021';
files = dir(fullfile(folderPath, '*.mat')); % 获取所有.mat文件
name_list = {'F0Electrodes','F1Electrodes'};

for i_name = 1:length(name_list)
savedVariables = {}; % 用于存储所有生成的变量名
    for i = 1:length(files)
        % 提取文件名（不包含扩展名）
        [~, baseFileName, ~] = fileparts(files(i).name);
        % 生成变量名
        variableName = sprintf('%s_%s', baseFileName, name_list{i_name});
        % 加载数据
        data = load(fullfile(folderPath, files(i).name)); 
        % 检查是否存在特定变量
        if isfield(data, name_list{i_name})
            % 读取并存储数据
            eval([variableName ' = data.' name_list{i_name} '(:, start_time:stop_time);']);
            savedVariables{end + 1} = variableName;
        end
    end

    if ~isempty(savedVariables)
        saveFilename = fullfile(folderPath, ['combined_' name_list{i_name} '.mat']);
        save(saveFilename, savedVariables{:});
    end
end

%% question3

% load the data after sampling

data1=load('E:\master-2\CVPR\CVPR\PR_CW_DATA_2021\combined_F0Electrodes.mat');
data2=load('E:\master-2\CVPR\CVPR\PR_CW_DATA_2021\combined_F1Electrodes.mat');

% question 1: load the generated files and show the data from the same graph
% in order to show the differences between different objects

figure(6)

% plot the F0Electrodes values of different objects. 
% in each object, we take the average of electrodes
plot(data1.acrylic_211_01_HOLD_F0Electrodes)
hold on;
plot(data2.acrylic_211_01_HOLD_F1Electrodes)
hold on;
