%% section C
% question 1-a

data0 = load("./PR_CW_DATA_2021/F0_PVT.mat");
data1 = load("./PR_CW_DATA_2021/F1_PVT.mat");

zeroOneColumn = [zeros(10, 1); ones(10, 1)];

% data0V = [data0.dataMatrix_F0(11:30,1) zeroOneColumn];
% data0P = [data0.dataMatrix_F0(11:30,2) zeroOneColumn];
% data0T = [data0.dataMatrix_F0(11:30,3) zeroOneColumn];
% 
% data1V = [data1.dataMatrix_F1(11:30,1) zeroOneColumn];
% data1P = [data1.dataMatrix_F1(11:30,2) zeroOneColumn];
% data1T = [data1.dataMatrix_F1(11:30,3) zeroOneColumn];

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

features = data0PV(:,1:2);
lalbels = zeroOneColumn;

% mean values
Mu = mean(data0PV);
Mu1 = mean(data0PVX1);
Mu2 = mean(data0PVX2);

% covariance matrix
S1 = cov(data0PVX1 - Mu1);
S2 = cov(data0PVX2 - Mu2);
Sw = S1 + S2;

SB = (Mu1-Mu2)*(Mu1-Mu2)';

% get the value of w
% w = (Sw)^(-1)*(Mu1-Mu2)';

% LDA projection
invSw = inv(Sw);
invSw_by_SB = invSw * SB;

% get the projection vector
[eigenvectors, eigenvalues] = eig(invSw_by_SB);
W = eigenvectors(:,1);

% LDA model functions
ldaModel = fitcdiscr(features, lalbels);

figure(1);
% for i = 1:size(data0PV, 1)
%     if data0PV(i,3) == 0
%         plot(data0PV(i,1), data0PV(i,2), 'b*'); hold on; % Blue star for class 0
%     elseif data0PV(i,3) == 1
%         plot(data0PV(i,1), data0PV(i,2), 'g*'); hold on; % Green star for class 1
%     end
% end
% hold off;

gscatter(data0PV(:,1), data0PV(:,2), ldaResubPredict, 'bg', 'x*');
legend('Class 0', 'Class 1');
xlabel('Feature 1');
ylabel('Feature 2');
title('LDA Classification Results');
hold on;

% plot the classification line
start_point = (Mu*W'*(-2));
end_point = (Mu*W'*(2));
plot(start_point, end_point, "b-");

hold off;