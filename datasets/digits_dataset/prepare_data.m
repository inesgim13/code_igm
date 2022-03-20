clear all
clc
%% LOAD DATA
fou = importdata('mfeat-fou');
fac = importdata('mfeat-fac');
kar = importdata('mfeat-kar');
mor = importdata('mfeat-mor');
pix = importdata('mfeat-pix');
zer = importdata('mfeat-zer');

features = {fou, fac, kar, mor, pix, zer};
feat_names = {'fou', 'fac', 'kar', 'mor', 'pix', 'zer'};

labels = zeros(2000,1);
labels(201:400,1) = 1;
labels(401:600,1) = 2;
labels(601:800,1) = 3;
labels(801:1000,1) = 4;
labels(1001:1200,1) = 5;
labels(1201:1400,1) = 6;
labels(1401:1600,1) = 7;
labels(1601:1800,1) = 8;
labels(1801:2000,1) = 9;

save('digits_data.mat', 'features','labels', 'feat_names');