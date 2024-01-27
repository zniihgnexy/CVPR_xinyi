%% k means clustering
% data pre-processing

standardizedDataCluster = (dataMatrix_F0(11:30, :) - mean(dataMatrix_F0(11:30, :))) ./ std(dataMatrix_F0(11:30, :));
meanData = mean(standardizedDataCluster);

covMatrixCluster = cov(dataMatrix_F0(11:30, :));
[eigenvectors, eigenvalues] = eig(covMatrixCluster);
% 
% L_eig_vec = [];
% for i = 1 : size(eigenvectors,2) 
%     if( eigenvalues(i,i)>1 )
%         L_eig_vec = [L_eig_vec eigenvectors(:,i)];
%     end
% end

projection2DCluster = standardizedDataCluster * eigenvectors(:,1:2);

%% clustering calculation
% data_clustering = projection2DCluster(11:30,:);
data_clustering = projection2DCluster;
iter_size = size(data_clustering, 1);
label = zeros(iter_size, 1);

max_iter = 1000;
iter = 0;

% Initialize centroids
center_x1 = rand;
center_y1 = rand;
center_x2 = rand;
center_y2 = rand;

% For convergence check
prev_center_x1 = 5;
prev_center_y1 = 5;
prev_center_x2 = -5;
prev_center_y2 = -5;

while iter < max_iter && ...
      (abs(center_x1 - prev_center_x1) > 0.001 || abs(center_y1 - prev_center_y1) > 0.001 || ...
       abs(center_x2 - prev_center_x2) > 0.001 || abs(center_y2 - prev_center_y2) > 0.001)
    
    prev_center_x1 = center_x1;
    prev_center_y1 = center_y1;
    prev_center_x2 = center_x2;
    prev_center_y2 = center_y2;

    center_x1 = 0;
    center_y1 = 0;
    center_x2 = 0;
    center_y2 = 0;

    center_num1 = 0;
    center_num2 = 0;

    for k = 1:iter_size
        distance1 = (data_clustering(k,1) - center_x1)^2 + (data_clustering(k,2) - center_y1)^2;
        distance2 = (data_clustering(k,1) - center_x2)^2 + (data_clustering(k,2) - center_y2)^2;

        if distance1 > distance2
            % class 2
            label(k) = 2;
            center_x2 = center_x2 + data_clustering(k,1);
            center_y2 = center_y2 + data_clustering(k,2);
            center_num2 = center_num2 + 1;
        else
            % class 1
            label(k) = 1;
            center_x1 = center_x1 + data_clustering(k,1);
            center_y1 = center_y1 + data_clustering(k,2);
            center_num1 = center_num1 + 1;
        end
    end

    if center_num1 > 0
        center_x1 = center_x1 / center_num1;
        center_y1 = center_y1 / center_num1;
    end

    if center_num2 > 0
        center_x2 = center_x2 / center_num2;
        center_y2 = center_y2 / center_num2;
    end

    iter = iter + 1;
end

% Plot the final results
figure;
hold on;
gscatter(data_clustering(:,1), data_clustering(:,2), label);
plot(center_x1, center_y1, 'kp', 'MarkerSize', 12, 'MarkerFaceColor', 'black');
plot(center_x2, center_y2, 'kp', 'MarkerSize', 12, 'MarkerFaceColor', 'black');
hold off;
