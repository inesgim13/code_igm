%% INFO
clc
clear all
%% LOAD DATA
% We will take the velocities curves --> curves & the labels
load('predictAF.mat','ClinParams') 
load('ClinParams_continuous.mat')
load('prueba.mat')
% As we are going to run PHATE, this method takes the input matrix as
% follows:
    % The rows are different cells
    % The columns are the different gens
% Thus, we transpose the input matrix so as to:
    % The rows are the different subjects
    % The columns are the different points in the curve

labels = ClinParams(:,1);
groups = ClinParams(:,2);

%% Create features matrix
n_patients = size(ClinParams,1);
n_features = size(ClinParams11,2);

features = cell(1,n_features);
for i=1:n_features
    features{1,i} = ClinParams11(:,i);
end

clear ClinParams i
%% Pass FEATURES to PHATE to compute pots 2D
% Create empty matrices to sava data
potencies = zeros(n_patients, n_patients, n_features);
kernels = zeros(n_patients, n_patients, n_features);
p_matrices = zeros(n_patients, n_patients, n_features);

for i=1:n_features
    [~, potencies(:,:,i), kernels(:,:,i), p_matrices(:,:,i)] = phate_modified_igm(features{1,i}, 't', 25);  
end

%% Compute only one potency matrix: SNF style
pot = cell(1,n_features);
for i=1:n_features
    pot{i} = potencies(:,:,i);
end

%%
pot_final = combine_potencies_igm(pot, 20, 30, 0.00001);

%% RUN 2D-PHATE
[Y_2D, P_2D, K_2D] = phate(input_matrix);

%% plot PHATE 2D
figure('name','Dimensionality reduced space provided by phate averaged')
hold on
for iCluster = 1:5
    clustIdx = label==iCluster;
    scatter(Y_2D(clustIdx,1),Y_2D(clustIdx,2), 'filled');
end

legend('show');
grid on;
xlabel('Dimension 1'); ylabel('Dimension 2'); 
title('Output space');
hold off; 

%% RUN 3D-PHATE
[Y_3D, P_3D, K_3D] = phate(input_matrix, 'ndim', 3);

%% plot PHATE 3D
figure('name','Dimensionality reduced space provided by phate averaged')
hold on
for iCluster = 1:5
    clustIdx = label==iCluster;
    scatter3(Y_3D(clustIdx,1),Y_3D(clustIdx,2),Y_3D(clustIdx,3), 'filled');
end

legend('show');
grid on;
xlabel('Dimension 1'); ylabel('Dimension 2'); zlabel('Dimension 3'); 
title('Output space');
hold off; 

%% SAVE DATA
save('normal_PHATE_syntheticvel_igm.mat','Y_2D', 'P_2D', 'K_2D','Y_3D', 'P_3D', 'K_3D');