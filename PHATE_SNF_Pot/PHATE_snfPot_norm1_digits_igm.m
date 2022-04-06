%% INFO
clear all
%% Load example data
load digits_data.mat

%% FEATURES
n_patients = size(labels,1);
n_features = size(features,2);

%% Pass FEATURES to PHATE to compute pots 2D
potencies = zeros(n_patients, n_patients, n_features);
kernels = zeros(n_patients, n_patients, n_features);
p_matrices = zeros(n_patients, n_patients, n_features);

for i=1:n_features
    [~, potencies(:,:,i), kernels(:,:,i), p_matrices(:,:,i)] = phate_modified_igm(features{1,i});  
end
%% Compute only one potency matrix: SNF style
pot = cell(1,n_features);
ks = cell(1,n_features);
p_mat = cell(1,n_features);
for i=1:n_features
    pot{i} = potencies(:,:,i);
    ks{i} = kernels(:,:,i);
    p_mat{i} = p_matrices(:,:,i);
end
%% Compute only one potency matrix: SNF style
pot_final = combine_potencies_normal_normalization_igm(pot, 20, 30, 0.00001);

%% We do the phate embedding
% I had to change the MMDS criterion bc of an error: 'Points in the configuration have co-located.  Try a different
% starting point, or use a different criterion.'
% Changed 'metricstress' criterion (Stress, normalized with the sum of squares
% of the dissimilarities) to 'metricsstress' (Squared Stress, normalized with the sum of
% 4th powers of the dissimilarities).

y_phate_2D = phate_embedding_igm(pot_final);


%% plot PHATE 2D
figure('name','Dimensionality reduced space provided by phate averaged')
cmap = colormap(turbo(10));
hold on
for iCluster = 1:10
    clustIdx = labels==(iCluster-1);
    scatter(y_phate_2D(clustIdx,1),y_phate_2D(clustIdx,2), [],cmap(iCluster,:),'filled');
end

legend('0','1','2','3','4','5','6','7','8','9');
grid on;
xlabel('Dimension 1'); ylabel('Dimension 2'); 
title('Output space');
hold off; 
%% We do the phate embedding 3D
% I had to change the MMDS criterion bc of an error: 'Points in the configuration have co-located.  Try a different
% starting point, or use a different criterion.'
% Changed 'metricstress' criterion (Stress, normalized with the sum of squares
% of the dissimilarities) to 'metricsstress' (Squared Stress, normalized with the sum of
% 4th powers of the dissimilarities).

y_phate_3D = phate_embedding_igm(pot_final, 'ndim', 3);


%% plot PHATE 3D
figure('name','Dimensionality reduced space provided by phate averaged')
cmap = colormap(turbo(10));
hold on
for iCluster = 1:10
    clustIdx = labels==(iCluster-1);
    scatter3(y_phate_3D(clustIdx,1),y_phate_3D(clustIdx,2),y_phate_3D(clustIdx,3), [],cmap(iCluster,:),'filled');
end

legend('0','1','2','3','4','5','6','7','8','9');
grid on;
xlabel('Dimension 1'); ylabel('Dimension 2'); zlabel('Dimension 3'); 
title('Output space');
hold off; 

%% SAVE DATA
save('PHATE_snfPot_digits_norm1_igm.mat','pot', 'ks','p_mat', 'pot_final','y_phate_2D','y_phate_3D');