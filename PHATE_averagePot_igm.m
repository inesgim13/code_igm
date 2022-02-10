%% INFO
%Without using MKL, we compute each P matrix corresponding to each feature
%and then, we are going to think that all of them are equally important
%Thus, we take the promdy of all of them, and compute the phate embedding

clear all
%% Load example data
load Synthetic_velocities.mat

%% FEATURES
feature_1 = FEATURES{1,1}';
feature_2 = FEATURES{2,1}';
feature_3 = FEATURES{3,1}';
feature_4 = FEATURES{4,1}';

%% Pass FEATURES to PHATE to compute pots 2D
% Also, feature it is not working when passing it to MKL bc it has NaN

[~, pot1] = phate_modified_igm(feature_1);

[~, pot2] = phate_modified_igm(feature_2);

%[~, pot3] = phate_modified_igm(feature_3, 't', 20); 

[~, pot4] = phate_modified_igm(feature_4);

%% Compute only one potency matrix: in this case, we consider all equally impotant
pot = (pot1 + pot2 + pot4)/3;

%% We do the phate embedding
% I had to change the MMDS criterion bc of an error: 'Points in the configuration have co-located.  Try a different
% starting point, or use a different criterion.'
% Changed 'metricstress' criterion (Stress, normalized with the sum of squares
% of the dissimilarities) to 'metricsstress' (Squared Stress, normalized with the sum of
% 4th powers of the dissimilarities).

y_phate_2D = phate_embedding_igm(pot);

%% plot PHATE 2D
figure;
scatter(y_phate_2D(:,1), y_phate_2D(:,2), 40,label, 'filled');
colormap(jet)
set(gca,'xticklabel',[]);
set(gca,'yticklabel',[]);
axis tight
xlabel 'PHATE1'
ylabel 'PHATE2'
drawnow


%% We do the phate embedding 3D
% I had to change the MMDS criterion bc of an error: 'Points in the configuration have co-located.  Try a different
% starting point, or use a different criterion.'
% Changed 'metricstress' criterion (Stress, normalized with the sum of squares
% of the dissimilarities) to 'metricsstress' (Squared Stress, normalized with the sum of
% 4th powers of the dissimilarities).

y_phate_3D = phate_embedding_igm(pot, 'ndim', 3);

%% plot PHATE 3D
figure;
scatter3(y_phate_3D(:,1), y_phate_3D(:,2), y_phate_3D(:,3),40, label, 'filled');
colormap(jet)
set(gca,'xticklabel',[]);
set(gca,'yticklabel',[]);
set(gca,'zticklabel',[]);
axis tight
xlabel 'PHATE1'
ylabel 'PHATE2'
zlabel 'PHATE3'
view([-15 20]);
drawnow