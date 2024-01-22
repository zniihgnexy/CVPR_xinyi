%% section C
% question 1-a

data0 = load("./PR_CW_DATA_2021/F0_PVT.mat");
data1 = load("./PR_CW_DATA_2021/F1_PVT.mat");

zeroOneColumn = [zeros(10, 1); ones(10, 1)];

%Cindy Start
% Standardise Data
St_dataMatrix_F0 = (data0.dataMatrix_F0 - mean(data0.dataMatrix_F0)) ./ std(data0.dataMatrix_F0);
St_dataMatrix_F1 = (data1.dataMatrix_F1 - mean(data1.dataMatrix_F1)) ./ std(data1.dataMatrix_F1);
%Cindy Finish

% two object within F0 and F1
% label = 0, car sponge
% label = 1, black foam
data0V = [data0.dataMatrix_F0(11:30,1) zeroOneColumn];
data0P = [data0.dataMatrix_F0(11:30,2) zeroOneColumn];
data0T = [data0.dataMatrix_F0(11:30,3) zeroOneColumn];

data1V = [data1.dataMatrix_F1(11:30,1) zeroOneColumn];
data1P = [data1.dataMatrix_F1(11:30,2) zeroOneColumn];
data1T = [data1.dataMatrix_F1(11:30,3) zeroOneColumn];

data0PV = [data0.dataMatrix_F0(11:30,1:2) zeroOneColumn];
data0PVX1 = data0PV(1:10,1:2);
data0PVX2 = data0PV(11:20,1:2);

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

% get the value of w
% w = (Sw)^(-1)*(Mu1-Mu2)';

% LDA projection
invSw = inv(Sw);
invSw_by_SB = invSw * SB;

% get the projection vector
[eigenvectors, eigenvalues] = eig(invSw_by_SB);
W = eigenvectors(:,1);

% LDA model functions
ldaModel = fitcdiscr(features, labels);


%data for plot
st_data0PV = [St_dataMatrix_F0(11:30,1:2) zeroOneColumn];
st_data1PV = [St_dataMatrix_F1(11:30,1:2) zeroOneColumn];
%
% figure(1);
% for i = 1:size(data0PV, 1)
%     if data0PV(i,3) == 0
%         plot(data0PV(i,1), data0PV(i,2), 'b*'); hold on; % Blue star for class 0
%     elseif data0PV(i,3) == 1
%         plot(data0PV(i,1), data0PV(i,2), 'g*'); hold on; % Green star for class 1
%     end
% end
% hold off;

% Draw Hyperplane for LDA
direction = W - Mu(1:2);

step = 0.001; % adjust length of hyperplane
point1 = [0,0] - step * direction';
point2 = [0,0] + step * direction';

figure(1);
for i = 1:size(data0PV, 1)
    if data0PV(i,3) == 0
        plot(st_data0PV(i,1), st_data0PV(i,2), 'b*'); hold on; % Blue star for class 0
    elseif data0PV(i,3) == 1
        plot(st_data1PV(i,1), st_data1PV(i,2), 'g*'); hold on; % Green star for class 1
    end
end
hold on;


% gscatter(data0PV(:,1), data0PV(:,2), ldaResubPredict, 'bg', 'x*');
legend('Class 0', 'Class 1');
xlabel('Feature 1');
ylabel('Feature 2');
title('LDA Classification Results');
hold on;

plot([point1(1), point2(1)], [point1(2), point2(2)], 'k-', 'LineWidth', 2); % 'k-' 表示黑色实线

hold off;


% %% Another Algorithm: Could be deleted
% 
% % question 1-a
% 
% data0 = load("./PR_CW_DATA_2021/F0_PVT.mat");
% data1 = load("./PR_CW_DATA_2021/F1_PVT.mat");
% 
% zeroOneColumn = [zeros(10, 1); ones(10, 1)];
% 
% %Cindy Start
% % Standardise Data
% St_dataMatrix_F0 = (data0.dataMatrix_F0 - mean(data0.dataMatrix_F0)) ./ std(data0.dataMatrix_F0);
% St_dataMatrix_F1 = (data1.dataMatrix_F1 - mean(data1.dataMatrix_F1)) ./ std(data1.dataMatrix_F1);
% %Cindy Finish
% 
% % two object within F0 and F1
% % label = 0, car sponge
% % label = 1, black foam
% data0V = [data0.dataMatrix_F0(11:30,1) zeroOneColumn];
% data0P = [data0.dataMatrix_F0(11:30,2) zeroOneColumn];
% data0T = [data0.dataMatrix_F0(11:30,3) zeroOneColumn];
% 
% data1V = [data1.dataMatrix_F1(11:30,1) zeroOneColumn];
% data1P = [data1.dataMatrix_F1(11:30,2) zeroOneColumn];
% data1T = [data1.dataMatrix_F1(11:30,3) zeroOneColumn];
% 
% data0PV = [data0.dataMatrix_F0(11:30,1:2) zeroOneColumn];
% data0PVX1 = data0PV(1:10,1:2);
% data0PVX2 = data0PV(11:20,1:2);
% 
% features = data0PV(:,1:2);
% labels = zeroOneColumn;
% 
% W = LDA(features,labels);
% 
% %data for plot
% st_data0PV = [St_dataMatrix_F0(11:30,1:2) zeroOneColumn];
% st_data1PV = [St_dataMatrix_F1(11:30,1:2) zeroOneColumn];
% %
% % figure(1);
% % for i = 1:size(data0PV, 1)
% %     if data0PV(i,3) == 0
% %         plot(data0PV(i,1), data0PV(i,2), 'b*'); hold on; % Blue star for class 0
% %     elseif data0PV(i,3) == 1
% %         plot(data0PV(i,1), data0PV(i,2), 'g*'); hold on; % Green star for class 1
% %     end
% % end
% % hold off;
% 
% % Draw Hyperplane for LDA
% direction = W(e:end);
% 
% step = 0.001; % adjust length of hyperplane
% point1 = [0,0] - step * direction';
% point2 = [0,0] + step * direction';
% 
% figure(1);
% for i = 1:size(data0PV, 1)
%     if data0PV(i,3) == 0
%         plot(st_data0PV(i,1), st_data0PV(i,2), 'b*'); hold on; % Blue star for class 0
%     elseif data0PV(i,3) == 1
%         plot(st_data1PV(i,1), st_data1PV(i,2), 'g*'); hold on; % Green star for class 1
%     end
% end
% hold on;
% 
% 
% % gscatter(data0PV(:,1), data0PV(:,2), ldaResubPredict, 'bg', 'x*');
% legend('Class 0', 'Class 1');
% xlabel('Feature 1');
% ylabel('Feature 2');
% title('LDA Classification Results');
% hold on;
% 
% plot([point1(1), point2(1)], [point1(2), point2(2)], 'k-', 'LineWidth', 2); % 'k-' 表示黑色实线
% 
% hold off;
% 
% 
% %% LDA Function
% function W = LDA(Input,Target,Priors)
% 
% % Determine size of input data
% [n m] = size(Input);
% 
% % Discover and count unique class labels
% ClassLabel = unique(Target);
% k = length(ClassLabel);
% 
% % Initialize
% nGroup     = NaN(k,1);     % Group counts
% GroupMean  = NaN(k,m);     % Group sample means
% PooledCov  = zeros(m,m);   % Pooled covariance
% W          = NaN(k,m+1);   % model coefficients
% 
% if  (nargin >= 3)  PriorProb = Priors;  end
% 
% % Loop over classes to perform intermediate calculations
% for i = 1:k,
%     % Establish location and size of each class
%     Group      = (Target == ClassLabel(i));
%     nGroup(i)  = sum(double(Group));
%     
%     % Calculate group mean vectors
%     GroupMean(i,:) = mean(Input(Group,:));
%     
%     % Accumulate pooled covariance information
%     PooledCov = PooledCov + ((nGroup(i) - 1) / (n - k) ).* cov(Input(Group,:));
% end
% 
% % Assign prior probabilities
% if  (nargin >= 3)
%     % Use the user-supplied priors
%     PriorProb = Priors;
% else
%     % Use the sample probabilities
%     PriorProb = nGroup / n;
% end
% 
% % Loop over classes to calculate linear discriminant coefficients
% for i = 1:k,
%     % Intermediate calculation for efficiency
%     % This replaces:  GroupMean(g,:) * inv(PooledCov)
%     Temp = GroupMean(i,:) / PooledCov;
%     
%     % Constant
%     W(i,1) = -0.5 * Temp * GroupMean(i,:)' + log(PriorProb(i));
%     
%     % Linear
%     W(i,2:end) = Temp;
% end
% 
% % Housekeeping
% clear Temp
% 
% end
