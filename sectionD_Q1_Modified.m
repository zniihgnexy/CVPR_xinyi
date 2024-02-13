%% k means clustering
% data pre-processing

standardizedDataCluster = (dataMatrix_F1(1:60, :) - mean(dataMatrix_F1(1:60, :))) ./ std(dataMatrix_F1(1:60, :));
meanData = mean(standardizedDataCluster);

centers = -2.5 + 4.*rand(6, 3);

% Disance metric options:
% dist_metric = ["Euclidean","Manhattan","Minkowski","Chebyshev","Cosine Distance"];

dist_metric = "Cosine Distance";
Minkowski_P = 3; % only used in Minkowski distance calculation

labels = ["acrylic", "black foam", "car sponge", "flour sack", "kitchen sponge", "steel vase"];

%% clustering calculation
% data_clustering = projection2DCluster(11:30,:);
data_clustering = standardizedDataCluster;
iter_size = size(data_clustering, 1);

label_1 = ones(10, 1);
label_2 = ones(10, 1)*2;
label_3 = ones(10, 1)*3;
label_4 = ones(10, 1)*4;
label_5 = ones(10, 1)*5;
label_6 = ones(10, 1)*6;

label = [label_1;label_2;label_3;label_4;label_5;label_6];

% 创建一个数组来保存scatter对象，这样我们可以在调用legend函数时使用它们
scatterObjects = gobjects(length(labels), 1); 

figure;
% 绘制散点图，为每组数据分配颜色和图例
for i = 1:length(labels)
    idxStart = (i-1)*10 + 1;
    idxEnd = i*10; % 假设 n 已正确定义，这里直接使用 i*10
    scatterObjects(i) = scatter3(data_clustering(idxStart:idxEnd,1), data_clustering(idxStart:idxEnd,2), data_clustering(idxStart:idxEnd,3), 'filled', 'DisplayName', labels{i});
    hold on; % 保持当前图像，以便在上面添加更多的散点图
end

% 添加图例
legend(scatterObjects, 'Location', 'best');
title("The Original Data Distribution in F1 PVT");
xlabel('Feature 1');
ylabel('Feature 2');
zlabel('Feature 3');
hold off;



max_iter = 1000;
iter = 0;

% For convergence check
prev_centers = zeros(size(centers));
distance = zeros(size(data_clustering, 1),size(centers,1));

condition = true;
while condition
    %%% condition check
    for i = 1:size(centers,1)
        conv_check1 = abs(centers(i,1) - prev_centers(i,1));
        conv_check2 = abs(centers(i,2) - prev_centers(i,2));
        conv_check3 = abs(centers(i,3) - prev_centers(i,3));
        if conv_check1 < 0.0001 || conv_check2 < 0.0001 ||conv_check3 < 0.0001 && iter <= max_iter
            condition = false;
        elseif iter > max_iter
            condition = false;
        else
            prev_centers(i,:) = centers(i,:);
            centers(i,:) = 0;
        end
    end

    %%% Iteration Start


    for k = 1:iter_size
        if dist_metric == "Euclidean"
            for i = 1:size(centers,1)
                distance(k,i) = sqrt((data_clustering(k,1) - prev_centers(i,1))^2 + (data_clustering(k,2) - prev_centers(i,2))^2 + (data_clustering(k,3) - prev_centers(i,3))^2);
            end
        elseif dist_metric == "Manhattan"
            for i = 1:size(centers,1)
                distance(k,i) = abs(data_clustering(k,1) - prev_centers(i,1)) + abs(data_clustering(k,2) - prev_centers(i,2)) + abs(data_clustering(k,3) - prev_centers(i,3));
            end
        elseif dist_metric == "Minkowski"
            for i = 1:size(centers,1)
                distance(k,i) = ((data_clustering(k,1) - prev_centers(i,1))^Minkowski_P + (data_clustering(k,2) - prev_centers(i,2))^Minkowski_P + (data_clustering(k,3) - prev_centers(i,3))^Minkowski_P)^(1/Minkowski_P);
            end
        elseif dist_metric == "Chebyshev"
            Minkowski_P = 10000000000;
            for i = 1:size(centers,1)
                distance(k,i) = ((data_clustering(k,1) - prev_centers(i,1))^Minkowski_P + (data_clustering(k,2) - prev_centers(i,2))^Minkowski_P + (data_clustering(k,3) - prev_centers(i,3))^Minkowski_P)^(1/Minkowski_P);
            end
        elseif dist_metric == "Cosine Distance"
            for i = 1:size(centers,1)
                sum1 = data_clustering(k,1)*prev_centers(i,1) + data_clustering(k,2)*prev_centers(i,2) + data_clustering(k,3)*prev_centers(i,3);
                 product = sqrt((data_clustering(k,1))^2 + (data_clustering(k,2)^2) + (data_clustering(k,3))^2) * sqrt((prev_centers(i,1))^2 + (prev_centers(i,2)^2) + (prev_centers(i,3))^2);
                distance(k,i) = 1 - (sum1 / product);
            end
        end
    end

    label_cluster = zeros(size(distance,1),1);
    for i = 1:size(distance,1)
        [minValue, linearIndex] = min(distance(i,:));
        label_cluster(i) = (linearIndex);
    end
    unique_elements = sort(unique(label_cluster));

%     new_labels = zeros(60,1);
    
    % 对于每个不同的元素，找到它们的索引
    for i = 1:length(unique_elements)
        element = unique_elements(i);
        index_list = find(label_cluster == element);
        centers(element,1) = (centers(element,1) + sum(data_clustering(index_list,1)))/size(index_list,1);
        centers(element,2) = (centers(element,2) + sum(data_clustering(index_list,2)))/size(index_list,1);
        centers(element,3) = (centers(element,3) + sum(data_clustering(index_list,3)))/size(index_list,1);
    end
    iter = iter + 1;
end

% 创建一个数组来保存scatter对象，这样我们可以在调用legend函数时使用它们
scatterObjects_2 = gobjects(length(unique_elements), 1); 
labels = ["cluster 1", "cluster 2", "cluster 3", "cluster 4", "cluster 5", "cluster 6"];
labels_2 = ["center 1", "center 2", "center 3", "center 4", "center 5", "center 6"];


figure;
% 绘制散点图，为每组数据分配颜色和图例
for i = 1:length(unique_elements)
    element = unique_elements(i);
    index_list = find(label_cluster == element);
    scatterObjects_2(i) = scatter3(data_clustering(index_list,1), data_clustering(index_list,2), data_clustering(index_list,3), 'filled','DisplayName', labels{i});
    hold on; % 保持当前图像，以便在上面添加更多的散点图
end

legend(scatterObjects_2, 'Location', 'best');

for i = 1:size(centers,1)
    scatter3(centers(i,1), centers(i,2), centers(i,3), 70, 'kp', 'MarkerFaceColor', 'black','DisplayName', labels_2{i});
end

% 添加图例
title("F1 Cluster Processed by K-means in",dist_metric);
xlabel('Vibration');
ylabel('Pressure');
zlabel('Temperature');

