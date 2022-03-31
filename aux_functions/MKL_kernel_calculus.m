function [KERNELS] = MKL_kernel_calculus(FEATURES, options, resume, resume_iterations)

if ~exist('resume','var')
    resume = false;
end

if ~exist('resume_iterations','var')
    resume_iterations = 0;
end

if ~resume

    n_features = numel(FEATURES);
    N = size(FEATURES{1},2);

    if ~exist('options','var')
        options = [];
    end 
    
    %create default options
    if ~isfield(options, 'AffinityNN')
        options.AffinityNN = floor(sqrt(N)); %rule of thumb guess 
    end
    
    if ~isfield(options, 'NumberOfIterations')
        options.NumberOfIterations = 25;
    end
        
    %create default kernel types
    if ~isfield(options, 'Kernel')
        for i=1:numel(FEATURES)
            options.Kernel{i}.KernelType = 'exp_l2';
            options.Kernel{i}.Parameters = floor(sqrt(N)); %rule of thumb guess            
        end 
    end

    %% MKL ALGORITHM

    %%% To compute, or not, S_W_B and S_W_A using MEX files (faster
    %%% computation)
    computeMEX = 1; 

    %% Calculus of the Inputs

    %%% Compute Kernels
    disp('Kernels calculus...');
    KERNELS = zeros(n_features,N,N);
    K_var = zeros(1,length(n_features));
    parfor c=1:n_features 
        fprintf([num2str(c),' ']);
        tmpF = FEATURES{c}';
        tmpF2 = sort(tmpF,'ascend'); %%% For display purposes only
        tmpK = Kernel_Calculus(tmpF,options.Kernel{c}.KernelType, options.Kernel{c}.Parameters,1); %%% a single function only, remove "Kernel_Calculus"
        tmpK2 = Kernel_Calculus(tmpF2,options.Kernel{c}.KernelType, options.Kernel{c}.Parameters,1);
        KERNELS(c,:,:) = tmpK;
        KERNELS2(c,:,:) = tmpK2;
        K_var(c) = var( tmpK(:) );
    end   
end
end