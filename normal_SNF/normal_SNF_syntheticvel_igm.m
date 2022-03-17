%%
clear all
%% Load example data
load Synthetic_velocities.mat

%% FEATURES
feature_1 = FEATURES{1,1}';
feature_2 = FEATURES{2,1}';
feature_3 = FEATURES{3,1}';
feature_4 = FEATURES{4,1}';

label = label';
%% First, set all the parameters.
K = 100/5;%number of neighbors, usually (10~30)
alpha = 0.5; %hyperparameter, usually (0.3~0.8)
T = 20; %Number of Iterations, usually (10~20)

%% Normalize data
Data1 = Standard_Normalization(feature_1);
Data2 = Standard_Normalization(feature_2);
Data3 = Standard_Normalization(feature_3);
Data4 = Standard_Normalization(feature_4);

%% Calculate the pair-wise distance; If the data is continuous, we recommend to use the function "dist2" as follows;
%if the data is discrete, we recommend the users to use chi-square distance
Dist1 = dist2(Data1,Data1);
Dist2 = dist2(Data2,Data2);
Dist3 = dist2(Data3,Data3);
Dist4 = dist2(Data4,Data4);

%% Construct similarity graphs
W1 = affinityMatrix(Dist1, K, alpha);
W2 = affinityMatrix(Dist2, K, alpha);
W3 = affinityMatrix(Dist3, K, alpha);
W4 = affinityMatrix(Dist4, K, alpha);

%% Display clusters.
displayClusters(W1,label);
displayClusters(W2,label);
displayClusters(W3,label);
displayClusters(W4,label);

%% Fusing all the graphs
% then the overall matrix can be computed by similarity network fusion(SNF):
W = SNF({W1,W2, W3, W4}, K, T);
%With this unified graph W of size n x n, you can do either spectral clustering or Kernel NMF.  
%% for example, spectral clustering
C = 5;%%%number of clusters
group = SpectralClustering(W,C);%%%the final subtypes information

% you can evaluate the goodness of the obtained clustering results by calculate Normalized mutual information (NMI): 
% if NMI is close to 1, it indicates that the obtained clustering is very close to the "true" cluster information; 
% if NMI is close to 0, it indicates the obtained clustering is not similar to the "true" cluster information.
displayClusters(W,group);

SNFNMI = Cal_NMI(group, label);

%%%you can also find the concordance between each individual network and the fused network
ConcordanceMatrix = Concordance_Network_NMI({W,W1,W2,W3,W4},C);


%% SAVE DATA
save('normal_SNF_syntheticvel_igm.mat', 'W1','W2','W3','W4','W','SNFNMI', 'ConcordanceMatrix', 'group');


