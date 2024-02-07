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
data0VPT = [data0.dataMatrix_F0(11:30,:) zeroOneColumn];
data0VPTX1 = data0VPT(1:10,1:3);
data0VPTX2 = data0VPT(11:20,1:3);

%% question A-1: Pressure vs Vibration

features = data0PV(:,1:2);
labels = zeroOneColumn;

% mean values
Mu = mean(data0PV);
Mu1 = mean(data0PVX1);
Mu2 = mean(data0PVX2);

% covariance matrix
S1 = cov(data0PVX1 - Mu1);
S2 = cov(data0PVX2 - Mu2);
Sw = S1 + S2;

SB = (Mu1-Mu2)*(Mu1-Mu2)';

% LDA projection
invSw = inv(Sw);
invSw_by_SB = invSw * SB;

% get the projection vector
[eigenvectors1, eigenvalues1] = eig(invSw_by_SB);
W = eigenvectors1(:,1);

% LDA model functions
% ldaModel = fitcdiscr(features, labels);

%data for plot
st_data0PV = [St_dataMatrix_F0(11:30,1:2) zeroOneColumn];
st_data1PV = [St_dataMatrix_F1(11:30,1:2) zeroOneColumn];

% Draw Hyperplane for LDA
direction = W - Mu(1:2);

step = 0.001; % adjust length of hyperplane
point1 = [0,0] - step * direction';
point2 = [0,0] + step * direction';

figure(1);
for i = 1:size(data0PV, 1)
    if data0PV(i,3) == 0
        plot(st_data0PV(i,1), st_data0PV(i,2), 'bo'); hold on;
    elseif data0PV(i,3) == 1
        plot(st_data0PV(i,1), st_data0PV(i,2), 'go'); hold on;
    end
end
hold on;

% gscatter(data0PV(:,1), data0PV(:,2), ldaResubPredict, 'bg', 'x*');
% legend('Class 0', 'Class 1');
xlabel('Pressure');
ylabel('Vibration');
title('LDA Classification Results in Pr vs Vib');
hold on;

plot([point1(1), point2(1)], [point1(2), point2(2)], 'k-', 'LineWidth', 2);

hold off;

%% question A-2: Pressure vs Temperature Change

features = data0PT(:,1:2);
labels = zeroOneColumn;

% mean values
Mu = mean(data0PT);
Mu1 = mean(data0PTX1);
Mu2 = mean(data0PTX2);

% covariance matrix
S1 = cov(data0PTX1 - Mu1);
S2 = cov(data0PTX2 - Mu2);
Sw = S1 + S2;

SB = (Mu1-Mu2)*(Mu1-Mu2)';

% LDA projection
invSw = inv(Sw);
invSw_by_SB = invSw * SB;

% get the projection vector
[eigenvectors2, eigenvalues2] = eig(invSw_by_SB);
W = eigenvectors2(:,1);

% LDA model functions
% ldaModel = fitcdiscr(features, labels);

%data for plot
st_data0PT = [St_dataMatrix_F0(11:30,[2,3]) zeroOneColumn];
st_data1PT = [St_dataMatrix_F1(11:30,[2,3]) zeroOneColumn];

% Draw Hyperplane for LDA
direction = W - Mu(1:2);

step = 0.001; % adjust length of hyperplane
point1 = [0,0] - step * direction';
point2 = [0,0] + step * direction';

figure(2);
for i = 1:size(data0PV, 1)
    if data0PV(i,3) == 0
        plot(st_data0PT(i,1), st_data0PT(i,2), 'bo'); hold on; % Blue star for class 0
    elseif data0PV(i,3) == 1
        plot(st_data0PT(i,1), st_data0PT(i,2), 'go'); hold on; % Green star for class 1
    end
end
hold on;

% gscatter(data0PV(:,1), data0PV(:,2), ldaResubPredict, 'bg', 'x*');
% legend('Class 0', 'Class 1');
xlabel('Pressure');
ylabel('Temperature Change');
title('LDA Classification Results in Pr vs Temp');
hold on;

plot([point1(1), point2(1)], [point1(2), point2(2)], 'k-', 'LineWidth', 2); % 'k-' 表示黑色实线

hold off;

%% question A-3: Temperature Change vs Vibration

features = data0TV(:,1:2);
lalbels = zeroOneColumn;

% mean values
Mu = mean(data0TV);
Mu1 = mean(data0TVX1);
Mu2 = mean(data0TVX2);

% covariance matrix
S1 = cov(data0TVX1 - Mu1);
S2 = cov(data0TVX2 - Mu2);
Sw = S1 + S2;

SB = (Mu1-Mu2)*(Mu1-Mu2)';

% LDA projection
invSw = inv(Sw);
invSw_by_SB = invSw * SB;

% get the projection vector
[eigenvectors3, eigenvalues3] = eig(invSw_by_SB);
W = eigenvectors3(:,1);

% LDA model functions
% ldaModel = fitcdiscr(features, labels);

%data for plot
st_data0TV = [St_dataMatrix_F0(11:30,[1,3]) zeroOneColumn];
st_data1TV = [St_dataMatrix_F1(11:30,[1,3]) zeroOneColumn];

% Draw Hyperplane for LDA
direction = W - Mu(1:2);

step = 0.001; % adjust length of hyperplane
point1 = [0,0] - step * direction';
point2 = [0,0] + step * direction';

figure(3);
for i = 1:size(data0PV, 1)
    if data0PV(i,3) == 0
        plot(st_data0TV(i,1), st_data0TV(i,2), 'bo'); hold on; % Blue star for class 0
    elseif data0PV(i,3) == 1
        plot(st_data0TV(i,1), st_data0TV(i,2), 'go'); hold on; % Green star for class 1
    end
end
hold on;

% gscatter(data0PV(:,1), data0PV(:,2), ldaResubPredict, 'bg', 'x*');
% legend('Class 0', 'Class 1');
xlabel('Vibration');
ylabel('Temperature Change');
title('LDA Classification Results in Vib vs Temp');
hold on;

plot([point1(1), point2(1)], [point1(2), point2(2)], 'k-', 'LineWidth', 2); % 'k-' 表示黑色实线

hold off;
