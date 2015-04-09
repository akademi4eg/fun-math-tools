function [W, Ws, U, S, X, dists, distf] = pca_pretrain(X, t, K, U, S)

means = mean(X, 2);
stds = std(X, 0, 2);
m = size(X, 2);
X = (X - means*ones(1, m)) ./ (stds*ones(1, m));
X(isnan(X)) = 0;
if nargin < 4
    C = 1/m * (X * X');
    [U, S] = svd(C);
    S = diag(S);
    S = cumsum(S)/sum(S);
end
U = U.';
Z = U(1:K, :) * X;
Z = [Z;ones(1, length(t))];
[Ws, dists] = train_lr(Z, t, 50);
Wf = zeros(1, size(X, 1));
Wf(1:length(Ws)-1) = Ws(1:end-1);
Wf = Wf*U;
Wf(end+1) = Ws(end);
X = [X;ones(1, length(t))];
[W, distf] = train_lr(X, t, 10, Wf);