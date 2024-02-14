leaf = [5 10 15 20 25 30 35 40 45 50];
col = 'rbcmy';

load("./PR_CW_DATA_2021/Electro_projection3D_F0.mat");
load("./PR_CW_DATA_2021/Electro_projection3D_F1.mat");

projection3D = projection3D_F0;
%projection3D = projection3D_F1;

%%% data processing

train_data = [];
test_data = [];
train_labels = [];
test_labels = [];

labels = zeros(60,1);
for i = 1:6
    labels((i-1)*10+1:i*10)=i;
end

for i = 1:10:size(projection3D, 1)
    end_idx = min(i+9, size(projection3D, 1));
    batch = projection3D(i:end_idx, :);
    batch_labels = labels(i:end_idx); 
    num_rows = size(batch, 1);
    if num_rows == 10
        train_data = [train_data; batch(1:6, :)];
        test_data = [test_data; batch(7:10, :)];
        train_labels = [train_labels; batch_labels(1:6)]; 
        test_labels = [test_labels; batch_labels(7:10)]; 
    else
        split_point = ceil(num_rows*0.6);
        train_data = [train_data; batch(1:split_point, :)];
        test_data = [test_data; batch(split_point+1:end, :)];
        train_labels = [train_labels; batch_labels(1:split_point)]; 
        test_labels = [test_labels; batch_labels(split_point+1:end)]; 
    end
end

accuracy = [];

numTrials = 20; % 设置循环次数
accuracyMat = zeros(length(leaf), numTrials); % 初始化存储accuracy的矩阵


%%
for i = 1:length(leaf)
    baggedModel = TreeBagger(leaf(i), train_data, train_labels, 'OOBPredictorImportance', 'On');

    % c. Run the trained model with the test data and display a confusion matrix
    [Y_pred, ~] = predict(baggedModel, test_data);
    confMat = confusionmat(test_labels, str2double(Y_pred));

    figure; 
    confusionchart(confMat);
    xlabel('Predicted Class');
    ylabel('True Class');
    title('Confusion Matrix');

    % Calculate accuracy for this trial and leaf
    currentAccuracy = sum(diag(confMat)) / sum(confMat(:));
    accuracyMat(i, trial) = currentAccuracy; % Store accuracy
end
%%

for trial = 1:numTrials
    for i = 1:length(leaf)
        baggedModel = TreeBagger(leaf(i), train_data, train_labels, 'OOBPredictorImportance', 'On');

        % c. Run the trained model with the test data and display a confusion matrix
        [Y_pred, ~] = predict(baggedModel, test_data);
        confMat = confusionmat(test_labels, str2double(Y_pred));

        figure; 
        confusionchart(confMat);
        xlabel('Predicted Class');
        ylabel('True Class');
        title('Confusion Matrix');

        % Calculate accuracy for this trial and leaf
        currentAccuracy = sum(diag(confMat)) / sum(confMat(:));
        accuracyMat(i, trial) = currentAccuracy; % Store accuracy
    end
end

% Calculate and print the average accuracy for each leaf
averageAccuracy = mean(accuracyMat, 2); % Calculate mean across trials

for i = 1:length(leaf)
    fprintf('Leaf %d: Average Accuracy = %.2f%%\n', leaf(i), averageAccuracy(i) * 100);
end

fprintf('Overall accuracy: %.2f%%\n', accuracy * 100);

    view(baggedModel.Trees{25}, 'Mode', 'graph'); % Visualize the first tree
    view(baggedModel.Trees{30}, 'Mode', 'graph'); % Visualize the second tree