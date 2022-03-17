%% INFO

clear all
%% Load example data
load Synthetic_velocities.mat

%% FEATURES
feature_1 = FEATURES{1,1}';
feature_2 = FEATURES{2,1}';
feature_3 = FEATURES{3,1}';
feature_4 = FEATURES{4,1}';

%% Pass FEATURES to PHATE to compute pots 2D


[~, pot1, K1, P1] = phate_modified_igm(feature_1);

[~, pot2, K2, P2] = phate_modified_igm(feature_2);

%[~, pot3] = phate_modified_igm(feature_3, 't', 20); 

[~, pot4, K4, P4] = phate_modified_igm(feature_4);

%% Compute only one potency matrix: SNF style
potencies = {pot1, pot2, pot4};
pot = combine_potencies_igm(potencies, 20, 30, 0.00001);
%% We do the phate embedding
% I had to change the MMDS criterion bc of an error: 'Points in the configuration have co-located.  Try a different
% starting point, or use a different criterion.'
% Changed 'metricstress' criterion (Stress, normalized with the sum of squares
% of the dissimilarities) to 'metricsstress' (Squared Stress, normalized with the sum of
% 4th powers of the dissimilarities).

y_phate_2D = phate_embedding_igm(pot);


%% plot PHATE 2D
figure('name','Dimensionality reduced space provided by phate averaged')
hold on
for iCluster = 1:5
    clustIdx = label==iCluster;
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

y_phate_3D = phate_embedding_igm(pot, 'ndim', 3);


%% plot PHATE 3D
figure('name','Dimensionality reduced space provided by phate averaged')
hold on
for iCluster = 1:5
    clustIdx = label==iCluster;
    scatter3(y_phate_3D(clustIdx,1),y_phate_3D(clustIdx,2),y_phate_3D(clustIdx,3), 'filled');
end

legend('show');
grid on;
xlabel('Dimension 1'); ylabel('Dimension 2'); zlabel('Dimension 3'); 
title('Output space');
hold off; 

%% SAVE DATA
save('PHATE_snfPot_igm.mat','pot1', 'K1','pot2', 'K2','pot4', 'K4', 'pot', 'y_phate_2D','y_phate_3D');