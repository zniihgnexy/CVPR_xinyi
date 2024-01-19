%%section B - 1
% a: covariance matrix, eigenvalues, and eigenvectors
covMatrix_F0 = cov(dataMatrix_F0);
% eigenvectors V, eigenvalues D
[eigenvectors, eigenvalues] = eig(covMatrix_F0);

disp('Eigenvectors:');
disp(eigenvectors);
disp('Eigenvalues:');
disp(diag(eigenvalues));

% b: Replot the Standardised data with the Principal components displayed

standardizedData = (dataMatrix_F0 - mean(dataMatrix_F0)) ./ std(dataMatrix_F0);
meanData = mean(standardizedData);

figure(1);
scatter3(standardizedData(:,1), standardizedData(:,2), standardizedData(:,3), 'filled');
title('Standardized Data with Principal Components');
xlabel('Variable 1');
ylabel('Variable 2');
zlabel('Variable 3');
hold on;

for i = 1:size(eigenvectors,2)
    vectorEndPoint = (meanData' + sqrt(eigenvalues(i,i)) * eigenvectors(:,i))/10;
    plot3([meanData(1) vectorEndPoint(1)], ...
          [meanData(2) vectorEndPoint(2)], ...
          [meanData(3) vectorEndPoint(3)], '->', 'LineWidth', 2);
end

hold off;

% c: Reduce the data to 2-dimensions and replot

L_eig_vec = [];
for i = 1 : size(eigenvectors,2) 
    if( eigenvalues(i,i)>1 )
        L_eig_vec = [L_eig_vec eigenvectors(:,i)];
    end
end

projection2D = standardizedData * eigenvectors(:,1:2);

figure(2);
scatter(projection2D(:,1), projection2D(:,2), 'filled');
title('2D Projection of the Data');
xlabel('First Principal Component');
ylabel('Second Principal Component');

% d:Show how the data is distributed across all principal components by plotting as separate 1D number lines.

projection1D_1 = standardizedData * eigenvectors(:,1);
figure(3);
scatter(projection1D_1, zeros(size(projection1D_1)), 'filled');
title('1D Projection onto the First Principal Component');
xlabel('First Principal Component');
ylabel('Value');

projection1D_2 = standardizedData * eigenvectors(:,2);
figure(4);
scatter(projection1D_2, zeros(size(projection1D_2)), 'filled');
title('1D Projection onto the Second Principal Component');
xlabel('Second Principal Component');
ylabel('Value');

projection1D_3 = standardizedData * eigenvectors(:,3);
figure(5);
scatter(projection1D_3, zeros(size(projection1D_3)), 'filled');
title('1D Projection onto the Third Principal Component');
xlabel('Third Principal Component');
ylabel('Value');

% e:Comment on your findings.

%% section B - 2
load(".\F0_Electro.mat");
load(".\F1_Electro.mat")

%%%%% Section B - 2 - a
% Assuming dataMatrix_elec_F0 and dataMatrix_elec_F1 are already loaded and standardized
% Standardised data with the Principal components displayed

standardizedData_F0 = (dataMatrix_elec_F0 - mean(dataMatrix_elec_F0)) ./ std(dataMatrix_elec_F0);
meanData_F0 = mean(standardizedData_F0);

standardizedData_F1 = (dataMatrix_elec_F1 - mean(dataMatrix_elec_F1)) ./ std(dataMatrix_elec_F1);
meanData_F1 = mean(standardizedData_F1);

% Calculate covariance matrices
covMatrix_F0 = cov(standardizedData_F0);
covMatrix_F1 = cov(standardizedData_F1);

% Perform eigenvalue decomposition
[eigenvectors_F0, eigenvalues_F0] = eig(covMatrix_F0, 'vector');
[eigenvectors_F1, eigenvalues_F1] = eig(covMatrix_F1, 'vector');

% Sort the eigenvectors by descending eigenvalues
[eigenvalues_F0, sortIdx_F0] = sort(eigenvalues_F0, 'descend');
eigenvectors_F0 = eigenvectors_F0(:, sortIdx_F0);

[eigenvalues_F1, sortIdx_F1] = sort(eigenvalues_F1, 'descend');
eigenvectors_F1 = eigenvectors_F1(:, sortIdx_F1);

% Project standardized data onto the PCA space to get the principal components
principleComponents_F0 = standardizedData_F0 * eigenvectors_F0;
principleComponents_F1 = standardizedData_F1 * eigenvectors_F1;

% Calculate the percentage of variance explained by each principal component for F0
variance_explained_F0 = eigenvalues_F0 / sum(eigenvalues_F0) * 100;
variance_explained_F1 = eigenvalues_F1 / sum(eigenvalues_F1) * 100;

figure;
plot(variance_explained_F0, '-o');
hold on;
plot(variance_explained_F1, '--');
grid on;
title('Scree Plot for Variance versus Principal Component');
xlabel('Principal Component');
ylabel('Variance Explained (%)');
legend("F0","F1")

%%%%% Section B - 2 - b

projection3D = standardizedData_F0 * eigenvectors_F0(:,1:3);

figure;
scatter3(projection3D(:,1), projection3D(:,2), projection3D(:,3), 'filled');
title('Standardized Data of Electrode');
xlabel('X Axis');
ylabel('Y Axis');
zlabel('Z Axis');
hold on;







