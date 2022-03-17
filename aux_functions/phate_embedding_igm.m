function Y = phate_embedding_igm(Pot, varargin)
npca = 100;
k = 5;
nsvd = 100;
n_landmarks = 2000;
ndim = 2;
t = [];
mds_method = 'mmds';
distfun = 'euclidean';
distfun_mds = 'euclidean';
pot_method = 'log';
K = [];
a = 40;
Pnm = [];
t_max = 100;
pot_eps = 1e-7;
gamma = 0.5;

% get input parameters
for i=1:length(varargin)
    % k for knn adaptive sigma
    if(strcmp(varargin{i},'k'))
       k = lower(varargin{i+1});
    end
    % a (alpha) for alpha decaying kernel
    if(strcmp(varargin{i},'a'))
       a = lower(varargin{i+1});
    end
    % diffusion time
    if(strcmp(varargin{i},'t'))
       t = lower(varargin{i+1});
    end
    % t_max for VNE
    if(strcmp(varargin{i},'t_max'))
       t_max = lower(varargin{i+1});
    end
    % Number of pca components
    if(strcmp(varargin{i},'npca'))
       npca = lower(varargin{i+1});
    end
    % Number of dimensions for the PHATE embedding
    if(strcmp(varargin{i},'ndim'))
       ndim = lower(varargin{i+1});
    end
    % Method for MDS
    if(strcmp(varargin{i},'mds_method'))
       mds_method =  varargin{i+1};
    end
    % Distance function for the inputs
    if(strcmp(varargin{i},'distfun'))
       distfun = lower(varargin{i+1});
    end
    % distfun for MDS
    if(strcmp(varargin{i},'distfun_mds'))
       distfun_mds =  lower(varargin{i+1});
    end
    % nsvd for spectral clustering
    if(strcmp(varargin{i},'nsvd'))
       nsvd = lower(varargin{i+1});
    end
    % n_landmarks for spectral clustering
    if(strcmp(varargin{i},'n_landmarks'))
       n_landmarks = lower(varargin{i+1});
    end
    % potential method: log, sqrt, gamma
    if(strcmp(varargin{i},'pot_method'))
       pot_method = lower(varargin{i+1});
    end
    % kernel
    if(strcmp(varargin{i},'kernel'))
       K = lower(varargin{i+1});
    end
    % kernel
    if(strcmp(varargin{i},'gamma'))
       gamma = lower(varargin{i+1});
    end
    % pot_eps
    if(strcmp(varargin{i},'pot_eps'))
       pot_eps = lower(varargin{i+1});
    end
end

if isempty(a) && k <=5
    disp '======================================================================='
    disp 'Make sure k is not too small when using an unweighted knn kernel (a=[])'
    disp(['Currently k = ' numstr(k) ', which may be too small']);
    disp '======================================================================='
end


PDX = squareform(pdist(Pot, distfun_mds));
tt_pdx = toc;
disp(['Computing potential distance took ' num2str(tt_pdx) ' seconds']);

% CMDS
disp 'Doing classical MDS'
tic;
Y = randmds(PDX, ndim);
tt_cmds = toc;
disp(['CMDS took ' num2str(tt_cmds) ' seconds']);

% MMDS
% I had to change 'metricstress' criterion (Stress, normalized with the sum of squares
% of the dissimilarities) to 'metricsstress' (Squared Stress, normalized with the sum of
% 4th powers of the dissimilarities).

if strcmpi(mds_method, 'mmds')
    tic;
    disp 'Doing metric MDS:'
    opt = statset('display','iter');
    Y = mdscale(PDX,ndim,'options',opt,'start',Y,'Criterion','metricsstress');
    tt_mmds = toc;
    disp(['MMDS took ' num2str(tt_mmds) ' seconds']);
end

% NMMDS
if strcmpi(mds_method, 'nmmds')
    tic;
    disp 'Doing non-metric MDS:'
    opt = statset('display','iter');
    Y = mdscale(PDX,ndim,'options',opt,'start',Y,'Criterion','stress');
    tt_nmmds = toc;
    disp(['NMMDS took ' num2str(tt_nmmds) ' seconds']);
end

if ~isempty(Pnm)
    % out of sample extension from landmarks to all points
    disp 'Out of sample extension from landmarks to all points'
    Y = Pnm * Y;
end

disp 'Done.'

end