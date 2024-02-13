%%section B - 1
folderPath = './PR_CW_DATA_2021';
%Data Read

load("./PR_CW_DATA_2021/F0_PVT.mat");
load("./PR_CW_DATA_2021/F1_PVT.mat");

% a: covariance matrix, eigenvalues, and eigenvectors
covMatrix_F0 = cov(dataMatrix_F0);
covMatrix_F1 = cov(dataMatrix_F1);
% eigenvectors V, eigenvalues D
[eigenvectors, eigenvalues] = eig(covMatrix_F0);
[eigenvectors_F1, eigenvalues_F1] = eig(covMatrix_F1);

disp('Eigenvectors:');
disp(eigenvectors);
disp('Eigenvalues:');
disp(diag(eigenvalues));

disp('Eigenvectors_F1:');
disp(eigenvectors_F1);
disp('Eigenvalues_F1:');
disp(diag(eigenvalues_F1));
labels = ["acrylic", "black foam", "car sponge", "flour sack", "kitchen sponge", "steel vase"];
%% b: Replot the Standardised data with the Principal components displayed

standardizedData = (dataMatrix_F0 - mean(dataMatrix_F0)) ./ std(dataMatrix_F0);
meanData = mean(standardizedData);

figure(1);
for i = 1:length(standardizedData(:,1))/10
    idxStart = (i-1)*10 + 1;
    idxEnd = i*10;
    scatterObjects_Qb1(i) = scatter3(standardizedData(idxStart:idxEnd,1), standardizedData(idxStart:idxEnd,2), standardizedData(idxStart:idxEnd,3), 'filled', 'DisplayName', labels(i));
    hold on; % 保持当前图像，以便在上面添加更多的散点图
end

% scatter3(standardizedData(:,1), standardizedData(:,2), standardizedData(:,3), 'filled');
title('Standardized Data with Principal Components');
legend(scatterObjects_Qb1, 'Location', 'best');
xlabel('Vibration');
ylabel('Pressure');
zlabel('Temperature');
hold on;


for i = 1:size(eigenvectors,2)
%     vectorEndPoint = (meanData' + sqrt(eigenvalues(i,i)) * eigenvectors(:,i))/10;
    vectorEndPoint = (meanData' + 10 * eigenvectors(:,i))/10;
    plot3([meanData(1) vectorEndPoint(1)], ...
          [meanData(2) vectorEndPoint(2)], ...
          [meanData(3) vectorEndPoint(3)], '->', 'LineWidth', 2);
end

hold off;

% c: Reduce the data to 2-dimensions and replot

L_eig_vec = [];
for i = 1 : size(eigenvectors,2) 
    if( eigenvalues(i,i)>1 )
        L_eig_vec = [L_eig_vec eigenvectors(:,i)];
    end
end

projection2D = standardizedData * eigenvectors(:,1:2);

figure(2);
for i = 1:length(standardizedData(:,1))/10
    idxStart = (i-1)*10 + 1;
    idxEnd = i*10;
    scatterObjects_Qb2(i) = scatter(projection2D(idxStart:idxEnd,1), projection2D(idxStart:idxEnd,2), 'filled','DisplayName', labels(i));
    hold on; % 保持当前图像，以便在上面添加更多的散点图
end

% scatter(projection2D(:,1), projection2D(:,2), 'filled');
legend(scatterObjects_Qb2, 'Location', 'best');
title('2D Projection of the Data');
xlabel('First Principal Component');
ylabel('Second Principal Component');

% d:Show how the data is distributed across all principal components by plotting as separate 1D number lines.

projection1D_1 = standardizedData * eigenvectors(:,1);
figure(3);

for i = 1:length(standardizedData(:,1))/10
    idxStart = (i-1)*10 + 1;
    idxEnd = i*10;
    scatter(projection1D_1(idxStart:idxEnd), zeros(10,1), 'filled','DisplayName', labels(i));
    hold on; % 保持当前图像，以便在上面添加更多的散点图
end

% scatter(projection1D_1, zeros(size(projection1D_1)), 'filled');
legend('Location', 'best');
title('1D Projection onto the First Principal Component');
xlabel('First Principal Component');
ylabel('Value');

projection1D_2 = standardizedData * eigenvectors(:,2);
figure(4);

for i = 1:length(standardizedData(:,1))/10
    idxStart = (i-1)*10 + 1;
    idxEnd = i*10;
    scatter(projection1D_2(idxStart:idxEnd), zeros(10,1), 'filled','DisplayName', labels(i));
    hold on; % 保持当前图像，以便在上面添加更多的散点图
end

legend('Location', 'best');
title('1D Projection onto the Second Principal Component');
xlabel('Second Principal Component');
ylabel('Value');



projection1D_3 = standardizedData * eigenvectors(:,3);
figure(5);

for i = 1:length(standardizedData(:,1))/10
    idxStart = (i-1)*10 + 1;
    idxEnd = i*10;
    scatter(projection1D_3(idxStart:idxEnd), zeros(10,1), 'filled','DisplayName', labels(i));
    hold on; % 保持当前图像，以便在上面添加更多的散点图
end

legend('Location', 'best');
title('1D Projection onto the Third Principal Component');
xlabel('Third Principal Component');
ylabel('Value');

% e:Comment on your findings.

%% section B - 2
load("./PR_CW_DATA_2021/F0_Electro.mat");
load("./PR_CW_DATA_2021/F1_Electro.mat")

%%%%% Section B - 2 - a
% Assuming dataMatrix_elec_F0 and dataMatrix_elec_F1 are already loaded and standardized
% Standardised data with the Principal components displayed

standardizedData_F0 = (dataMatrix_elec_F0 - mean(dataMatrix_elec_F0)) ./ std(dataMatrix_elec_F0);
meanData_F0 = mean(standardizedData_F0);

standardizedData_F1 = (dataMatrix_elec_F1 - mean(dataMatrix_elec_F1)) ./ std(dataMatrix_elec_F1);
meanData_F1 = mean(standardizedData_F1);

% Calculate covariance matrices
covMatrix_F0 = cov(standardizedData_F0);
covMatrix_F1 = cov(standardizedData_F1);

% Perform eigenvalue decomposition
[eigenvectors_F0, eigenvalues_F0] = eig(covMatrix_F0, 'vector');
[eigenvectors_F1, eigenvalues_F1] = eig(covMatrix_F1, 'vector');

% Sort the eigenvectors by descending eigenvalues
[eigenvalues_F0, sortIdx_F0] = sort(eigenvalues_F0, 'descend');
eigenvectors_F0 = eigenvectors_F0(:, sortIdx_F0);

[eigenvalues_F1, sortIdx_F1] = sort(eigenvalues_F1, 'descend');
eigenvectors_F1 = eigenvectors_F1(:, sortIdx_F1);

% Project standardized data onto the PCA space to get the principal components
principleComponents_F0 = standardizedData_F0 * eigenvectors_F0;
principleComponents_F1 = standardizedData_F1 * eigenvectors_F1;

% Calculate the percentage of variance explained by each principal component for F0
variance_explained_F0 = eigenvalues_F0 / sum(eigenvalues_F0) * 100;
variance_explained_F1 = eigenvalues_F1 / sum(eigenvalues_F1) * 100;

figure;
plot(variance_explained_F0, '-o');
hold on;
plot(variance_explained_F1, '--');
grid on;
title('Scree Plot for Variance versus Principal Component');
xlabel('Principal Component');
ylabel('Variance Explained (%)');
legend("F0","F1")

%% Section B - 2 - b - F0
projection3D_F0 = standardizedData_F0 * eigenvectors_F0(:,1:3);
projection2D_electro = standardizedData_F0 * eigenvectors_F0(:,1:2);

figure;
% 假设projection3D是你的数据点矩阵
n = size(projection3D_F0, 1); % 数据点的总数

% 创建颜色数组，每10个点一个颜色
colors = jet(ceil(n/10)); % 使用jet颜色图，根据组数生成颜色

% 标签数组
labels = ["acrylic", "black foam", "car sponge", "flour sack", "kitchen sponge", "steel vase"];
% 创建一个数组来保存scatter对象，这样我们可以在调用legend函数时使用它们
scatterObjects = gobjects(length(labels), 1); 

% 绘制散点图，为每组数据分配颜色和图例
for i = 1:length(labels)
    idxStart = (i-1)*10 + 1;
    idxEnd = min(i*10, n);
    scatterObjects(i) = scatter3(projection3D_F0(idxStart:idxEnd,1), projection3D_F0(idxStart:idxEnd,2), projection3D_F0(idxStart:idxEnd,3), ...
        36, colors(i,:), 'filled', 'DisplayName', labels(i));
    hold on; % 保持当前图像，以便在上面添加更多的散点图
end

title('Standardized Data of Electrode');
xlabel('X Axis');
ylabel('Y Axis');
zlabel('Z Axis');
legend(scatterObjects, 'Location', 'best'); % 使用scatter对象数组来创建图例
hold off; % 释放图像

saveFilename = fullfile(folderPath, 'Electro_projection3D_F0.mat');
save(saveFilename, 'projection3D_F0');

%% Section B - 2 - b - F0
projection3D_F1 = standardizedData_F1 * eigenvectors_F1(:,1:3);
projection2D_electro = standardizedData_F1 * eigenvectors_F1(:,1:2);

figure;
% 假设projection3D是你的数据点矩阵
n = size(projection3D_F1, 1); % 数据点的总数

% 创建颜色数组，每10个点一个颜色
colors = jet(ceil(n/10)); % 使用jet颜色图，根据组数生成颜色

% 标签数组
% 创建一个数组来保存scatter对象，这样我们可以在调用legend函数时使用它们
scatterObjects = gobjects(length(labels), 1); 

% 绘制散点图，为每组数据分配颜色和图例
for i = 1:length(labels)
    idxStart = (i-1)*10 + 1;
    idxEnd = min(i*10, n);
    scatterObjects(i) = scatter3(projection3D_F1(idxStart:idxEnd,1), projection3D_F1(idxStart:idxEnd,2), projection3D_F1(idxStart:idxEnd,3), ...
        36, colors(i,:), 'filled', 'DisplayName', labels(i));
    hold on; % 保持当前图像，以便在上面添加更多的散点图
end

title('Standardized Data of Electrode');
xlabel('X Axis');
ylabel('Y Axis');
zlabel('Z Axis');
legend(scatterObjects, 'Location', 'best'); % 使用scatter对象数组来创建图例
hold off; % 释放图像

saveFilename = fullfile(folderPath, 'Electro_projection3D_F1.mat');
save(saveFilename, 'projection3D_F1');





