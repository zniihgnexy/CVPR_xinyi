leaf = [5 10 20 50 100];
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

for i=1:length(leaf)
    baggedModel = TreeBagger(leaf(i), train_data,train_labels , 'OOBPredictorImportance', 'On');
    
    view(baggedModel.Trees{1}, 'Mode', 'graph'); % Visualize the first tree
    view(baggedModel.Trees{2}, 'Mode', 'graph'); % Visualize the second tree
    
    % c. Run the trained model with the test data and display a confusion matrix
    [Y_pred, scores] = predict(baggedModel, test_data);
    confMat = confusionmat(test_labels, str2double(Y_pred));
    figure; 
    confusionchart(confMat);
    xlabel('Predicted Class');
    ylabel('True Class');
    title('Confusion Matrix');
    
    % Calculate and print overall accuracy
    accuracy = [accuracy,sum(diag(confMat)) / sum(confMat(:))];
    fprintf('Overall accuracy: %.2f%%\n', accuracy * 100);

end