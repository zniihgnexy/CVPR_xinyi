%% section C: pre-data processing

%
% 1:10 acrylic
% 11:20 black foam
% 21:30 car sponge
% 31:40 flour sack
% 41:50 kitchen sponge
% 51:60 steel vase
%

%
% Slection: car sponge & kitchen sponge
% try to find the classification pattern in two similar materials
%

data0 = load("./PR_CW_DATA_2021/F0_PVT.mat");
data1 = load("./PR_CW_DATA_2021/F1_PVT.mat");

zeroOneColumn = [zeros(10, 1); ones(10, 1)];

% Standardise Data
St_dataMatrix_F0 = (data0.dataMatrix_F0 - mean(data0.dataMatrix_F0)) ./ std(data0.dataMatrix_F0);
St_dataMatrix_F1 = (data1.dataMatrix_F1 - mean(data1.dataMatrix_F1)) ./ std(data1.dataMatrix_F1);

% two object within F0 and F1
% label = 0, car sponge
% label = 1, black foam

data0PV = [data0.dataMatrix_F0(21:30,1:2) zeros(10, 1);
    data0.dataMatrix_F0(51:60,1:2) ones(10, 1)];
data0PVX1 = data0PV(1:10,1:2);
data0PVX2 = data0PV(11:20,1:2);

data0PT = [data0.dataMatrix_F0(21:30,2:3) zeros(10, 1);
    data0.dataMatrix_F0(51:60,2:3) ones(10, 1)];
data0PTX1 = data0PT(1:10,1:2);
data0PTX2 = data0PT(11:20,1:2);

data0TV = [data0.dataMatrix_F0(21:30,1) data0.dataMatrix_F0(21:30,3) zeros(10, 1);
    data0.dataMatrix_F0(51:60,1) data0.dataMatrix_F0(51:60,3) ones(10, 1)];
% data preprocessing 2D
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

data0VPT = [data0.dataMatrix_F0(21:30,:) zeros(10, 1);
    data0.dataMatrix_F0(51:60,:) ones(10, 1);];
data0VPTX1 = data0VPT(1:10,1:3);
data0VPTX2 = data0VPT(11:20,1:3);
data1VPT = [data1.dataMatrix_F1(21:30,:) zeros(10, 1);
    data1.dataMatrix_F1(51:60,:) ones(10, 1)];
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
meanDiffBetween = (meanClass1 - meanClass2);
Sb = meanDiffBetween' * meanDiffBetween;

% eigen
[eigenVectors, eigenValues] = eig(inv(Sw) * Sb);
[~, maxIdx] = max(abs(diag(eigenValues)));
W = eigenVectors(:, maxIdx);

% projection
projectedData = St_combinedData * W;
direction = W - meanCombined;

step = 6.5;
point1 = [0,0,0] - step * W';
point2 = [0,0,0] + step * W';

figure(1);
for i = 1:size(data0PV, 1)
    if data0PV(i,3) == 0
        plot3(St_combinedData(i,1), St_combinedData(i,2),St_combinedData(i,3), 'b*'); hold on; % Blue star for class 0
    elseif data0PV(i,3) == 1
        plot3(St_combinedData(i,1), St_combinedData(i,2), St_combinedData(i,3), 'g*'); hold on; % Green star for class 1
    end
end

legend('Class 0', 'Class 1');
xlabel('Vibrations');
ylabel('Pressure');
zlabel('Temperature Change');
title('LDA Classification Results in PVT');
hold on;

plot3([point1(1,1),point2(1,1)], [point1(1,2),point2(1,2)],[point1(1,3),point2(1,3)],'k-'); % 'k-' 表示黑色实线

hold on;


% Assume that W is defined 
% Calculate the vector orthogonal to W
orthogonalVector = cross(W, [1; 0; 0]); 

% Normalise vectors for better visualisation
orthogonalVector = orthogonalVector / norm(orthogonalVector);

% Define the two points of the line through [0,0,0].
stepSize = 3;% Step length can be adjusted as required
orthPoint1 = -stepSize * orthogonalVector';
orthPoint2 = stepSize * orthogonalVector';

% Plotting orthogonal lines on existing diagrams
hold on;
plot3([orthPoint1(1), orthPoint2(1)], [orthPoint1(2), orthPoint2(2)], [orthPoint1(3), orthPoint2(3)], 'r-'); 

scatter3(0,0,0,"red");
Hyperplane = fill3([point1(1),orthPoint1(1),point2(1),orthPoint2(1)],[point1(2),orthPoint1(2),point2(2),orthPoint2(2)],[point1(3),orthPoint1(3),point2(3),orthPoint2(3)],"blue");
set(Hyperplane, 'FaceAlpha', 0.5);

grid on;

hold off;