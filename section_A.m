%% question1
data1_1=load('.\PR_CW_DATA_2021\acrylic_211_01_HOLD.mat');
data2_1=load('.\PR_CW_DATA_2021\black_foam_110_01_HOLD.mat');
data3_1=load('.\PR_CW_DATA_2021\car_sponge_101_01_HOLD.mat');
data4_1=load('.\PR_CW_DATA_2021\flour_sack_410_01_HOLD.mat');
data5_1=load('.\PR_CW_DATA_2021\kitchen_sponge_114_01_HOLD.mat');
data6_1=load('.\PR_CW_DATA_2021\steel_vase_702_01_HOLD.mat');

% colors = {'r', 'g', 'b', 'k', 'c', 'y'};
colors = {[0 0.4470 0.7410], [0.8500 0.3250 0.0980], [0.9290 0.6940 0.1250], [0.4940 0.1840 0.5560], [0.4660 0.6740 0.1880],[0.6350 0.0780 0.1840]};
displayNames = {'Acrylic', 'Black Foam', 'Car Sponge', 'Flour Sack', 'Kitchen Sponge', 'Steel Vase'}; % 定义显示名称列表
dataSets = {'data1_1', 'data2_1', 'data3_1', 'data4_1', 'data5_1', 'data6_1'};

% question 1: load the original files and show the data from the same graph
% in order to show the differences between different objects

% plot the F0Electrodes values of different objects. in each object, we
% take the average of electrodes
figure(1)
set(gcf, 'Position', [300, 200, 300, 150]);
% Plotting the data
field = 'F0Electrodes';
for i = 1:length(dataSets)
    dataSet = eval(dataSets{i});
    rowAverage = mean(dataSet.(field), 1);
    plot(rowAverage, 'DisplayName', displayNames{i}, 'Color', colors{i});
    hold on;
end
title('Average F0Electrodes Values for Different Objects');
% legend('show');
hold off;


% plot the F0pac values of different objects
% in each object, we take the average of electrodes
figure(2)
set(gcf, 'Position', [300, 200, 300, 150]);
% Plotting the data
field = 'F0pac';
for i = 1:length(dataSets)
    dataSet = eval(dataSets{i});
    rowAverage = mean(dataSet.(field), 1);
    plot(rowAverage, 'DisplayName', displayNames{i}, 'Color', colors{i});
    hold on;
end
title('Average F0pac Values for Different Objects');
% legend('show');

% plot the F0pdc values of different objects
figure(3)
set(gcf, 'Position', [300, 200, 300, 150]);
% Plotting the data
field = 'F0pdc';
for i = 1:length(dataSets)
    dataSet = eval(dataSets{i});
    plot(dataSet.(field), 'DisplayName', displayNames{i}, 'Color', colors{i});
    hold on;
end
title('F0pdc Values for Different Objects');
% legend('show');


% plot the F0tac values of different objects
figure(4)
set(gcf, 'Position', [300, 200, 300, 150]);
% Plotting the data
field = 'F0tac';
for i = 1:length(dataSets)
    dataSet = eval(dataSets{i});
    plot(dataSet.(field), 'DisplayName', displayNames{i}, 'Color', colors{i});
    hold on;
end
title('F0tac Values for Different Objects');
% legend('show');

figure(5)
set(gcf, 'Position', [300, 200, 300, 150]);
% Plotting the data
field = 'F0tdc';
for i = 1:length(dataSets)
    dataSet = eval(dataSets{i});
    plot(dataSet.(field), 'DisplayName', displayNames{i}, 'Color', colors{i});
    hold on;
end
title('F0tdc Values for Different Objects');
% legend('show');


%% question2

% start_time = 1;
% stop_time = 100;
time = 66; % the time we want to use for seperation

folderPath = './PR_CW_DATA_2021';
files = dir(fullfile(folderPath, '*.mat'));
% V, P, T
% vibration, pressure, temperature change
% pac, pdc, tac
name_F0 = {'F0pac', 'F0pdc', 'F0tac'};% 1: High Vibration 2: Low Pressure, 3:Temperature change 4:temperature
name_F1 = {'F1pac',  'F1pdc',  'F1tac'};
name_Electro_F0 = {'F0Electrodes'}; % Electrodes
name_Electro_F1 = {'F1Electrodes'}; % Electrodes

% Initialise the data matrix
dataMatrix_F0 = [];
dataMatrix_F1 = [];
dataMatrix_elec_F0 = [];
dataMatrix_elec_F1 = [];

for i_name = 1:length(name_F0)
    tempData = []; % Temporarily stores all file data for the current variable

    for i = 1:length(files)
        data = load(fullfile(folderPath, files(i).name));
        fprintf(files(i).name);
        fprintf("  ");

        if isfield(data, name_F0{i_name})
            if strcmp(name_F0{i_name}, 'F0pac') 
                % Special handling F0pac 
                if size(data.(name_F0{i_name}), 1) >= 2 && size(data.(name_F0{i_name}), 2) >= time
                    tempData(end + 1) = data.(name_F0{i_name})(2, time);
                else
                    tempData(end + 1) = NaN;
                end
            else
                % Normal processing of other variables
                if length(data.(name_F0{i_name})) >= time
                    tempData(end + 1) = data.(name_F0{i_name})(time);
                else
                    tempData(end + 1) = NaN;
                end
            end
        end
    end

    % Add the data of the current variable to the data matrix
    dataMatrix_F0 = [dataMatrix_F0; tempData];
end

for i_name = 1:length(name_F1)
    tempData = []; 

    for i = 1:length(files)
        data = load(fullfile(folderPath, files(i).name));

        if isfield(data, name_F1{i_name})
            if strcmp(name_F1{i_name}, 'F1pac') 
                if size(data.(name_F1{i_name}), 1) >= 2 && size(data.(name_F1{i_name}), 2) >= time
                    tempData(end + 1) = data.(name_F1{i_name})(2, time);
                else
                    tempData(end + 1) = NaN;
                end
            else
                if length(data.(name_F1{i_name})) >= time
                    tempData(end + 1) = data.(name_F1{i_name})(time);
                else
                    tempData(end + 1) = NaN;
                end
            end
        end
    end

    dataMatrix_F1 = [dataMatrix_F1; tempData];
end

for i_name = 1:length(name_Electro_F0)
    tempData = []; 

    for i = 1:length(files)
        data = load(fullfile(folderPath, files(i).name));

        if isfield(data, name_Electro_F0{i_name})
            selectedData = data.(name_Electro_F0{i_name})(:, time); % Extracts data for each row at the specified time
            tempData = [tempData; selectedData']; % Converted to row vectors and added to temporary data
        end
    end

    dataMatrix_elec_F0 = [dataMatrix_elec_F0; tempData]; 
end

for i_name = 1:length(name_Electro_F1)
    tempData = []; 

    for i = 1:length(files)
        data = load(fullfile(folderPath, files(i).name));

        if isfield(data, name_Electro_F1{i_name})
            selectedData = data.(name_Electro_F1{i_name})(:, time); 
            tempData = [tempData; selectedData']; 
        end
    end

    dataMatrix_elec_F1 = [dataMatrix_elec_F1; tempData]; 
end

dataMatrix_F0 = dataMatrix_F0';
dataMatrix_F1 = dataMatrix_F1';

% save data
saveFilename = fullfile(folderPath, 'F0_PVT.mat');
save(saveFilename, 'dataMatrix_F0');

saveFilename = fullfile(folderPath, 'F1_PVT.mat');
save(saveFilename, 'dataMatrix_F1');

saveFilename = fullfile(folderPath, 'F0_Electro.mat');
save(saveFilename, 'dataMatrix_elec_F0');

saveFilename = fullfile(folderPath, 'F1_Electro.mat');
save(saveFilename, 'dataMatrix_elec_F1');

%% question3

% load the data after sampling

dataF0=load('.\PR_CW_DATA_2021\F0_PVT.mat');
dataF1=load('.\PR_CW_DATA_2021\F1_PVT.mat');
%dataEl1=load('E:\master-2\CVPR\CVPR\F0_Electro.mat');
%dataEl2=load('E:\master-2\CVPR\CVPR\F1_Electro.mat');

% question 1: load the generated files and show the data from the same graph
% in order to show the differences between different objects

% pressure, vibration, temperature
% pdc, pac, tdc

figure(6);

x = dataMatrix_F0(:, 1);
y = dataMatrix_F0(:, 2);
z = dataMatrix_F0(:, 3);

scatter3(x(1:10), y(1:10), z(1:10), 30, colors{1}, 'filled', 'DisplayName', 'Acrylic');
hold on;
scatter3(x(11:20), y(11:20), z(11:20), 30, colors{2}, 'filled', 'DisplayName', 'Black Foam');
hold on;
scatter3(x(21:30), y(21:30), z(21:30), 30, colors{3}, 'filled', 'DisplayName', 'Car Sponge');
hold on;
scatter3(x(31:40), y(31:40), z(31:40), 30, colors{4}, 'filled', 'DisplayName', 'Flour Sack');
hold on;
scatter3(x(41:50), y(41:50), z(41:50), 30, colors{5}, 'filled', 'DisplayName', 'Kitchen Sponge');
hold on;
scatter3(x(51:end), y(51:end), z(51:end), 30, colors{6}, 'filled', 'DisplayName', 'Steel Vase');

xlabel('Vibration');
ylabel('Pressure');
zlabel('Temperature');
title('3D Scatter Plot for F0 Parameters');
legend('Location', 'best');
grid on;
hold off;

% saveas(gcf, '3D_Scatter_Plot.png');

figure(7);

x2 = dataMatrix_F1(:, 1);
y2 = dataMatrix_F1(:, 2);
z2 = dataMatrix_F1(:, 3);

scatter3(x2(1:10), y2(1:10), z2(1:10), 30, colors{1}, 'filled', 'DisplayName', 'Acrylic');
hold on;
scatter3(x2(11:20), y2(11:20), z2(11:20), 30, colors{2}, 'filled', 'DisplayName', 'Black Foam');
hold on;
scatter3(x2(21:30), y2(21:30), z2(21:30), 30, colors{3}, 'filled', 'DisplayName', 'Car Sponge');
hold on;
scatter3(x2(31:40), y2(31:40), z2(31:40), 30, colors{4}, 'filled', 'DisplayName', 'Flour Sack');
hold on;
scatter3(x2(41:50), y2(41:50), z2(41:50), 30, colors{5}, 'filled', 'DisplayName', 'Kitchen Sponge');
hold on;
scatter3(x2(51:end), y2(51:end), z2(51:end), 30, colors{6}, 'filled', 'DisplayName', 'Steel Vase');

xlabel('Vibration');
ylabel('Pressure');
zlabel('Temperature');
title('3D Scatter Plot for F1 Parameters');
legend('Location', 'best');
grid on;
hold off;
