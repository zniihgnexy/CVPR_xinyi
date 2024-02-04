%% k means clustering
% data pre-processing

standardizedDataCluster = (dataMatrix_F0(1:50, :) - mean(dataMatrix_F0(1:50, :))) ./ std(dataMatrix_F0(1:50, :));
meanData = mean(standardizedDataCluster);

covMatrixCluster = cov(dataMatrix_F0(11:30, :));
[eigenvectors, eigenvalues] = eig(covMatrixCluster);

% Disance metric options:
% dist_metric = ["Euclidean","Manhattan","Minkowski","Chebyshev","Cos"];

dist_metric = "Cos";
Minkowski_P = 3; % only used in Minkowski distance calculation

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

% center_x1 = rand;
% center_y1 = rand;
% center_x2 = rand;
% center_y2 = rand;

centers = -2.5 + 4.*rand(size(data_clustering,1)/10, 2);

% For convergence check
prev_centers = zeros(size(centers));
distance = zeros(size(data_clustering, 1),size(centers,1));

% while iter < max_iter && ...
%       (abs(center_x1 - prev_center_x1) > 0.001 || abs(center_y1 - prev_center_y1) > 0.001 || ...
%        abs(center_x2 - prev_center_x2) > 0.001 || abs(center_y2 - prev_center_y2) > 0.001)
condition = true;
while condition
    %%% condition check
    for i = 1:size(centers,1)
%         conv_check = norm(centers(i, :) - prev_centers(i, :));
        conv_check1 = abs(centers(i,1) - prev_centers(i,1));
        conv_check2 = abs(centers(i,2) - prev_centers(i,2));
        if conv_check1 < 0.0001 || conv_check2 < 0.0001 && iter <= max_iter
            condition = false;
        elseif iter > max_iter
            condition = false;
        else
            prev_centers(i,:) = centers(i,:);
            centers(i,:) = 0;
        end
    end

    %%% Iteration Start

    center_num1 = 0;
    center_num2 = 0;

    for k = 1:iter_size
        if dist_metric == "Euclidean"
            for i = 1:size(centers,1)
                distance(k,i) = sqrt((data_clustering(k,1) - prev_centers(i,1))^2 + (data_clustering(k,2) - prev_centers(i,2))^2);
            end
        elseif dist_metric == "Manhattan"
            for i = 1:size(centers,1)
                distance(k,i) = abs(data_clustering(k,1) - prev_centers(i,1)) + abs(data_clustering(k,2) - prev_centers(i,2));
            end
        elseif dist_metric == "Minkowski"
            for i = 1:size(centers,1)
                distance(k,i) = ((data_clustering(k,1) - prev_centers(i,1))^Minkowski_P + (data_clustering(k,2) - prev_centers(i,2))^Minkowski_P)^(1/Minkowski_P);
            end
        elseif dist_metric == "Chebyshev"
            Minkowski_P = 10000000000;
            for i = 1:size(centers,1)
                distance(k,i) = ((data_clustering(k,1) - prev_centers(i,1))^Minkowski_P + (data_clustering(k,2) - prev_centers(i,2))^Minkowski_P)^(1/Minkowski_P);
            end
        elseif dist_metric == "Cos"
            for i = 1:size(centers,1)
                sum1 = data_clustering(k,1)*prev_centers(i,1) + data_clustering(k,2)*prev_centers(i,2);
                product = sqrt((data_clustering(k,1))^2 + (data_clustering(k,2)^2)) * sqrt((prev_centers(i,1))^2 + (prev_centers(i,2)^2));
                distance(k,i) = sum1/product + 1;
            end
        end
    end

    label_cluster = zeros(size(distance,1),1);
    for i = 1:size(distance,1)
        [minValue, linearIndex] = min(distance(i,:));
        label_cluster(i) = (linearIndex);
    end
    unique_elements = sort(unique(label_cluster));
    
    % 对于每个不同的元素，找到它们的索引
    for i = 1:length(unique_elements)
        element = unique_elements(i);
        index_list = find(label_cluster == element);
        centers(element,1) = (centers(element,1) + sum(data_clustering(index_list,1)))/size(index_list,1);
        centers(element,2) = (centers(element,2) + sum(data_clustering(index_list,2)))/size(index_list,1);
    end
    iter = iter + 1;
end

% Plot the final results
figure;
hold on;
gscatter(data_clustering(:,1), data_clustering(:,2), label_cluster);
for i = 1:size(centers,1)
    plot(centers(i,1), centers(i,2), 'kp', 'MarkerSize', 12, 'MarkerFaceColor', 'black');
end
hold off;
