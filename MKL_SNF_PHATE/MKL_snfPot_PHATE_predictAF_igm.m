%% INFO
clear all
%% Load example data
load('predictAF.mat','ClinParams') 

labels = ClinParams(:,1);
groups = ClinParams(:,2);
features = ClinParams(:,3:end);
%% FEATURES
N = size(labels,1);
n_features = size(features,2);

FEATURES = cell(n_features, 1);

% Put it in the form of each feature with columns=n_patients, and the cell
% fmatrix with all features rows=n_features
for i=1:n_features
    feat = features(:,i);
    FEATURES{i} = feat';
end

%% DATA-SPECIFIC MKL
KNN1 = round(N/2); 
KNN2 = round(N/2); 
kind = 2*ones(1,n_features);
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
%% COMPUTE KERNELS
KERNELS = MKL_kernel_calculus(FEATURES, options);
%% TRANSFORM KERNELS INTO CELL
k = cell(1, n_features);

for i=1:n_features
    k{i} = reshape(KERNELS(i,:,:), [N,N]);
end
%% Compute only one potency matrix: SNF style
pot_final = combine_potencies_igm(k,20, 30, 0.00001);

%% We do the phate embedding

y_phate_2D = phate_embedding_igm(pot_final);

%% plot PHATE 2D
figure('name','Dimensionality reduced space provided by phate averaged')
hold on
for iCluster = 1:4
    clustIdx = groups==(iCluster);
    scatter(y_phate_2D(clustIdx,1),y_phate_2D(clustIdx,2), 'filled');
end

legend('show');
grid on;
xlabel('Dimension 1'); ylabel('Dimension 2'); 
title('Output space');
hold off; 
%% We do the phate embedding 3D

y_phate_3D = phate_embedding_igm(pot_final, 'ndim', 3);

 
%% plot 3d
figure('name','Dimensionality reduced space provided by phate averaged')
hold on
for iCluster = 1:4
    clustIdx = groups==(iCluster);
    scatter3(y_phate_3D(clustIdx,1),y_phate_3D(clustIdx,2),y_phate_3D(clustIdx,3), 'filled');
end

legend('show');
grid on;
xlabel('Dimension 1'); ylabel('Dimension 2'); zlabel('Dimension 3'); 
title('Output space');
hold off; 

%% SAVE DATA
save('MKL_snfPot_PHATE_predictAF_igm.mat','k','pot_final','y_phate_2D','y_phate_3D');