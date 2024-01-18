%%section B - 1
% a: covariance matrix, eigenvalues, and eigenvectors
covMatrix = cov(dataMatrix_F0);
% eigenvectors V, eigenvalues D
[eigenvectors, eigenvalues] = eig(covMatrix);

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