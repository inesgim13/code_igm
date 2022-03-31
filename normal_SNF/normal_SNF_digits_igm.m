%% INFO

clear all
%% Load example data
load digits_data.mat

%% FEATURES
N = size(labels,1);
n_features = size(features,2);

%% Normalize data
W = cell(1,n_features);

for i=1:n_features
    feat = features{1,i};
    data = Standard_Normalization(feat);
    dist = dist2(data,data);
    W{i} = affinityMatrix(dist, 20, 0.00001);
end
%% Compute only one potency matrix: SNF style
pot_final = combine_potencies_igm(W, 20, 30, 0.00001);

%% We do the phate embedding
% I had to change the MMDS criterion bc of an error: 'Points in the configuration have co-located.  Try a different
% starting point, or use a different criterion.'
% Changed 'metricstress' criterion (Stress, normalized with the sum of squares
% of the dissimilarities) to 'metricsstress' (Squared Stress, normalized with the sum of
% 4th powers of the dissimilarities).

y_phate_2D = phate_embedding_igm(pot_final);


%% plot PHATE 2D
figure('name','Dimensionality reduced space provided by phate averaged')
hold on
for iCluster = 1:10
    clustIdx = labels==(iCluster-1);
    scatter(y_phate_2D(clustIdx,1),y_phate_2D(clustIdx,2), 'filled');
end

legend('show');
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
hold on
for iCluster = 1:10
    clustIdx = labels==(iCluster-1);
    scatter3(y_phate_3D(clustIdx,1),y_phate_3D(clustIdx,2),y_phate_3D(clustIdx,3), 'filled');
end

legend('show');
grid on;
xlabel('Dimension 1'); ylabel('Dimension 2'); zlabel('Dimension 3'); 
title('Output space');
hold off; 

%% SAVE DATA
save('normal_SNF_digits_igm.mat','W','pot_final','y_phate_2D','y_phate_3D');