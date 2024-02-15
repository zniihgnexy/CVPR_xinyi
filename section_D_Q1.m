%% k means clustering
% data pre-processing

load("./PR_CW_DATA_2021/F0_PVT.mat");
load("./PR_CW_DATA_2021/F1_PVT.mat");

standardizedDataCluster = (dataMatrix_F1(1:60, :) - mean(dataMatrix_F1(1:60, :))) ./ std(dataMatrix_F1(1:60, :));
meanData = mean(standardizedDataCluster);

centers = -2.5 + 4.*rand(6, 3);

% Disance metric options:
% dist_metric = ["Euclidean","Manhattan","Minkowski","Chebyshev","Cosine Distance"];

dist_metric = "Chebyshev";
Minkowski_P = 3; % only used in Minkowski distance calculation

colors = [[0 0.4470 0.7410], [0.8500 0.3250 0.0980], 'b', 'k', 'c',[0.6350 0.0780 0.1840]];
labels = {'Acrylic', 'Black Foam', 'Car Sponge', 'Flour Sack', 'Kitchen Sponge', 'Steel Vase'};


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

% Create an array to hold the scatter objects so we can use them when calling the legend function
scatterObjects = gobjects(length(labels), 1); 

figure;
for i = 1:length(labels)
    idxStart = (i-1)*10 + 1;
    idxEnd = i*10;
    scatterObjects(i) = scatter3(data_clustering(idxStart:idxEnd,1), data_clustering(idxStart:idxEnd,2), data_clustering(idxStart:idxEnd,3),36,colors(i) ,'filled', 'DisplayName', labels{i});
    hold on; 
end

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
    
    % For each distinct element, find their indexes
    for i = 1:length(unique_elements)
        element = unique_elements(i);
        index_list = find(label_cluster == element);
        centers(element,1) = (centers(element,1) + sum(data_clustering(index_list,1)))/size(index_list,1);
        centers(element,2) = (centers(element,2) + sum(data_clustering(index_list,2)))/size(index_list,1);
        centers(element,3) = (centers(element,3) + sum(data_clustering(index_list,3)))/size(index_list,1);
    end
    iter = iter + 1;
end

% Create an array to hold the scatter objects so we can use them when calling the legend function
scatterObjects_2 = gobjects(length(unique_elements), 1); 
labels = ["cluster 1", "cluster 2", "cluster 3", "cluster 4", "cluster 5", "cluster 6"];
labels_2 = ["center 1", "center 2", "center 3", "center 4", "center 5", "center 6"];
colors = [[0 0.4470 0.7410], [0.8500 0.3250 0.0980], 'b', 'k', 'c',[0.6350 0.0780 0.1840]];


figure;
% Plotting scatter plots, assigning colours and legends to each set of data
for i = 1:length(unique_elements)
    element = unique_elements(i);
    index_list = find(label_cluster == element);
    scatterObjects_2(i) = scatter3(data_clustering(index_list,1), data_clustering(index_list,2), data_clustering(index_list,3),36,colors(i), 'filled','DisplayName', labels{i});
    hold on; % Keep the current image to add more scatterplots on top of it
end

legend(scatterObjects_2, 'Location', 'best');

for i = 1:size(centers,1)
    scatter3(centers(i,1), centers(i,2), centers(i,3), 70, 'kp', 'MarkerFaceColor', 'black','DisplayName', labels_2{i});
end

title("F1 Cluster Processed by K-means in",dist_metric);
xlabel('Vibration');
ylabel('Pressure');
zlabel('Temperature');

