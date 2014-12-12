function W = init_weights(data, labels)

if nargin < 2 || isempty(labels)
    disp('Preinitialization via randomization.');
    W = randn(1, size(data, 1))/10;
else
    X = data(:, labels(:, 2));
    t = labels(:, 1)';
%     W = t*X'*pinv(X*X');
    disp('Training LR.');
    W = train_lr(X, t);
end