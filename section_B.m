%%
% load the .mat file and turn the data into matrix for the calculation

% this is struct array
M = load('F0_PVF.mat');
M1 = struct2cell(M);
MatrixF0_PVT = cell2mat(M1);

%eigenvector
[V1, D1] = eig(MatrixF0_PVT);
norm1 = norm(MatrixF0_PVT*V - V*MatrixF0_PVT);