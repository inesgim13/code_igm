function [p_final] = combine_potencies_normal_normalization_igm(potencies, K, iter, alpha)

n_features = length(potencies);
[m,n] = size(potencies{1,1});

% NORMALIZATION BY the variance
for i = 1 : n_features
    pot = potencies{i};
    normaliz = vecnorm(pot,1,2);
    potencies{i} = pot./normaliz;
end

for i = 1 : n_features
    % Find Dominate Set in each pot with K neighboors
    S{i} = FindDominateSet(potencies{i},round(K));
end

Psum = zeros(m,n); % Compute sum of all potencies matrix
for i = 1 : n_features
    Psum = Psum + potencies{i};
end


for ITER=1 : iter
    for i = 1 : n_features
        pot_0{i}=S{i}*(Psum - potencies{i})*S{i}'/(n_features-1);
    end
    for i = 1 : n_features
        potencies{i} = BOnormalized(pot_0{i},alpha);
    end
    Psum = zeros(m,n);
    for i = 1 : n_features
        Psum = Psum + potencies{i};
    end
%     
end

p_final= Psum/n_features;
p_final= p_final./repmat(sum(p_final,2),1,n);
p_final= (p_final +p_final'+eye(n))/2;
end

function W = BOnormalized(W,alpha)
    if nargin < 2
        alpha = 1;
    end
    normaliz = vecnorm(W,1,2);
    W = W./normaliz;
end

function newW = FindDominateSet(W,K)
    % Inputs are Pot an num of neighbors
    [m,n] = size(W);
    [~, IW1] = sort(W,2,'descend'); % Sort elements of each row and gets the index
    newW = zeros(m,n);
    temp = repmat((1:n)',1,K);
    I1 = (IW1(:,1:K)-1)*m+temp;
    newW(I1(:)) = W(I1(:));
    newW = newW./repmat(sum(newW,2),1,n);
    clear IW1;
    clear IW2;
    clear temp;
end