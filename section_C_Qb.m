%% section C: pre-data processing

data0 = load("./PR_CW_DATA_2021/F0_PVT.mat");
data1 = load("./PR_CW_DATA_2021/F1_PVT.mat");

zeroOneColumn = [zeros(10, 1); ones(10, 1)];

% Standardise Data
St_dataMatrix_F0 = (data0.dataMatrix_F0 - mean(data0.dataMatrix_F0)) ./ std(data0.dataMatrix_F0);
St_dataMatrix_F1 = (data1.dataMatrix_F1 - mean(data1.dataMatrix_F1)) ./ std(data1.dataMatrix_F1);

% two object within F0 and F1
% label = 0, car sponge
% label = 1, black foam

data0PV = [data0.dataMatrix_F0(11:20,1:2) zeros(10, 1);
    data0.dataMatrix_F0(21:30,1:2) ones(10, 1)];
data0PVX1 = data0PV(1:10,1:2);
data0PVX2 = data0PV(11:20,1:2);

data0PT = [data0.dataMatrix_F0(11:30,2:3) zeroOneColumn];
data0PTX1 = data0PT(1:10,1:2);
data0PTX2 = data0PT(11:20,1:2);

data0TV = [data0.dataMatrix_F0(11:20,1) data0.dataMatrix_F0(11:20,3) zeros(10, 1);
    data0.dataMatrix_F0(21:30,1) data0.dataMatrix_F0(21:30,3) ones(10, 1)];
data0TVX1 = data0TV(1:10,1:2);
data0TVX2 = data0TV(11:20,1:2);

% 3D data PTV
data0VPT = [data0.dataMatrix_F0(11:30,:) zeroOneColumn];
data0VPTX1 = data0VPT(1:10,1:3);
data0VPTX2 = data0VPT(11:20,1:3);
data1VPT = [data1.dataMatrix_F1(11:30,:) zeroOneColumn];
data1VPTX1 = data1VPT(1:10,1:3);
data1VPTX2 = data1VPT(11:20,1:3);

% combine f1&f0， combined data is the full data with labels, using two
% objects
combinedData = [data0VPT; data1VPT];% with labels
combinedDataOnly = combinedData(:, 1:3);
labels = [zeros(size(data0VPTX1, 1), 1); ones(size(data0VPTX2, 1), 1);
    zeros(size(data1VPTX1, 1), 1); ones(size(data1VPTX2, 1), 1)]; 

%% multi-clasification based on LDA

% standarize
meanCombined = mean(combinedDataOnly);
class1Data = combinedData(labels == 0, 1:3);
class2Data = combinedData(labels == 1, 1:3);

% classes mean values
meanClass1 = mean(class1Data);
meanClass2 = mean(class2Data);

stdCombined = std(combinedDataOnly);
St_combinedData = (combinedDataOnly - meanCombined) ./ stdCombined;

% calculate Sw
Sw = zeros(3, 3);
Sw = Sw + cov(class1Data);
Sw = Sw + cov(class2Data);

% calculate Sb
meanDiffBetween = (meanClass1 - meanClass2)';
Sb = (meanDiffBetween * meanDiffBetween') * size(class1Data, 1);

% eigen
[eigenVectors, eigenValues] = eig(inv(Sw) * Sb);
[~, maxIdx] = max(abs(diag(eigenValues)));
W = eigenVectors(:, maxIdx);

% projection
projectedData = St_combinedData * W;

