function [p_final] = combine_potencies_igm(potencies, K, iter, alpha)

n_features = length(potencies);
[m,n] = size(potencies{1});


for i = 1 : n_features
    % Divide each entry by the sum of the row it pertains (normalize)
    potencies{i} = potencies{i}./repmat(sum(potencies{i},2),1,n);
    % Promedy of that pot with itself tranposed
    potencies{i} = (potencies{i} + potencies{i}')/2;
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
    W = W+alpha*eye(length(W));
    W = (W +W')/2;
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