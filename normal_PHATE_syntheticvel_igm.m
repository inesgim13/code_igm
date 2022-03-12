%% INFO% Here we don't care about the features, just take the whole velocity% curves as one and run normal phate.%% LOAD DATA% We will take the velocities curves --> curves & the labelsload('Synthetic_velocities.mat','curves', 'label') % As we are going to run PHATE, this method takes the input matrix as% follows:    % The rows are different cells    % The columns are the different gens% Thus, we transpose the input matrix so as to:    % The rows are the different subjects    % The columns are the different points in the curveinput_matrix = curves';%% RUN 2D-PHATE[Y_2D, P_2D, K_2D] = phate(input_matrix);%% plot PHATE 2Dfigure('name','Dimensionality reduced space provided by phate averaged')hold onfor iCluster = 1:5    clustIdx = label==iCluster;    scatter(Y_2D(clustIdx,1),Y_2D(clustIdx,2), 'filled');endlegend('show');grid on;xlabel('Dimension 1'); ylabel('Dimension 2'); title('Output space');hold off; %% RUN 3D-PHATE[Y_3D, P_3D, K_3D] = phate(input_matrix, 'ndim', 3);%% plot PHATE 3Dfigure('name','Dimensionality reduced space provided by phate averaged')hold onfor iCluster = 1:5    clustIdx = label==iCluster;    scatter3(Y_3D(clustIdx,1),Y_3D(clustIdx,2),Y_3D(clustIdx,3), 'filled');endlegend('show');grid on;xlabel('Dimension 1'); ylabel('Dimension 2'); zlabel('Dimension 3'); title('Output space');hold off; %% SAVE DATAsave('normal_PHATE_syntheticvel_igm.mat','Y_2D', 'P_2D', 'K_2D','Y_3D', 'P_3D', 'K_3D');