%% NORMAL MKL ON DIGITS DATASET
clear all
%% Load example data
load digits_data.mat

%% FEATURES
N = size(labels,1);
n_features = size(features,2);


FEATURES = cell(n_features, 1);

% Put it in the form of each feature with columns=n_patients, and the cell
% fmatrix with all features rows=n_features
for i=1:n_features
    feat = features{1,i};
    FEATURES{i} = feat';
end


%% DATA-SPECIFIC MKL

% Used to compute the kernel bandwidth, which is calculated feature-wise as the average
% of the pairwise Euclidean distances between each sample and its k-th nearest neighbour
KNN1 = round(N/2); 
%%% Number of neighbours used to define the global affinity matrix
KNN2 = round(N/2); 

% Vector with the feature kind for posterior assignment of the kernel
% type and parameters
    % kind = 1 --> Pattern
    % kind = 2 --> Continuous variable
    % kind = 3 --> Binary variable
    % kind = 4 --> Categorical (ordinal) variable
kind = ones(1,n_features);

for i = 1:n_features
    switch kind(i)
        case 1
            options.Kernel{i}.KernelType = 'exp_l2';
            options.Kernel{i}.Parameters = KNN1;
        case 2
            options.Kernel{i}.KernelType = 'exp_l2';
            options.Kernel{i}.Parameters = KNN1;
        case 3
            options.Kernel{i}.KernelType = 'binary';
            options.Kernel{i}.Parameters = N;
        case 4
            options.Kernel{i}.KernelType = 'ordinal';
            options.Kernel{i}.Parameters = N;
    end
end
options.AffinityNN = KNN2;

%% Unsupervised MKL for IG features
[F_data_digits,~,~] = MKL(FEATURES,options);

%% plot PHATE 3D
figure('name','Dimensionality reduced space provided by phate averaged')
hold on
for iCluster = 1:10
    clustIdx = labels()==(iCluster-1);
    scatter3(F_data_digits(clustIdx,1),F_data_digits(clustIdx,2),F_data_digits(clustIdx,3), 'filled');
end

legend('show');
grid on;
xlabel('Dimension 1'); ylabel('Dimension 2'); zlabel('Dimension 3'); 
title('Output space');
hold off; 