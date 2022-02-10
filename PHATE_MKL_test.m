%% INFO
% Here we take th B matrix from the PHATE code (distances) and the, we
% compute a simmilarity matrix with exp(-b). We pass this as the kernels
% that use MKL.

clear all
%% Load example data
load Synthetic_velocities.mat

%% FEATURES
feature_1 = FEATURES{1,1}';
feature_2 = FEATURES{2,1}';
feature_3 = FEATURES{3,1}';
feature_4 = FEATURES{4,1}';


%% Pass FEATURES to PHATE to extract matrix U
% I specify the t param for speed reasons
% Also, feature it is not working when passing it to MKL bc it has NaN

[b1, ~] = phate_modified_igm(feature_1);
sim1 = exp(-b1);

[b2, ~] = phate_modified_igm(feature_2);
sim2 = exp(-b2);

%[b3, ~] = phate_modified_igm(feature_3, 't', 20); 
% sim3 = exp(-b3);

[b4, ~] = phate_modified_igm(feature_4);
sim4 = exp(-b4);

%% Create KERNELS matrix, each layer is one kernel, corresponding to a feature
KERNELS = zeros(3,100,100);
KERNELS(1,:,:) = sim1;
KERNELS(2,:,:) = sim2;
%KERNELS(3,:,:) = sim3;
KERNELS(3,:,:) = sim4;

%% Pass those matrix U ass if they were the kernels to MKL
[F_data,~,~] = mkl_modified_igm(KERNELS);

%% Represent data
% Dimensionality reduced space provided by MKL
figure('name','Dimensionality reduced space provided by MKL')
hold on
for iCluster = 1:5
    clustIdx = label==iCluster;
    plot3(F_data(clustIdx,1),F_data(clustIdx,2),F_data(clustIdx,3),'.','MarkerSize',30,...
       'DisplayName',sprintf('Group %i',iCluster));
end

legend('show');
grid on;
xlabel('Dimension 1'); ylabel('Dimension 2'); zlabel('Dimension 3'); 
title('Output space');
hold off; 





