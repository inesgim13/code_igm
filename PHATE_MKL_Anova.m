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

%% GAUSSIAN KERNEL (Different std for each row)
d=10;
[b1, ~] = phate_modified_igm(feature_1);
sigma1 = std(feature_1, 0, 2);
sim1 = exp(-sigma1.*b1).^d;

[b2, ~] = phate_modified_igm(feature_2);
sigma2 = std(feature_2, 0, 2);
sim2 = exp(-sigma2.*b2).^d;

[b4, ~] = phate_modified_igm(feature_4);
sigma4 = std(feature_4, 0, 2);
sim4 = exp(-sigma4.*b4).^d;
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