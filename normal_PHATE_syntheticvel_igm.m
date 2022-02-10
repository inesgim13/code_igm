%% INFO
% Here we don't care about the features, just take the whole velocity
% curves as one and run normal phate.

%% LOAD DATA
% We will take the velocities curves --> curves & the labels
load('Synthetic_velocities.mat','curves', 'label') 

% As we are going to run PHATE, this method takes the input matrix as
% follows:
    % The rows are different cells
    % The columns are the different gens
% Thus, we transpose the input matrix so as to:
    % The rows are the different subjects
    % The columns are the different points in the curve
input_matrix = curves';
%% RUN 2D-PHATE
[Y_2D] = phate(input_matrix);

%% plot PHATE 2D
figure;
scatter(Y_2D(:,1), Y_2D(:,2), 40,label, 'filled');
colormap(jet)
set(gca,'xticklabel',[]);
set(gca,'yticklabel',[]);
axis tight
xlabel 'PHATE1'
ylabel 'PHATE2'
drawnow

%% RUN 3D-PHATE
[Y_3D] = phate(input_matrix, 'ndim', 3);

%% plot PHATE 3D
figure;
scatter3(Y_3D(:,1), Y_3D(:,2), Y_3D(:,3),40, label, 'filled');
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

