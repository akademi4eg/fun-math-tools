function W = train_lr(data, t)

max_iter = 20;
min_diff = 0.01;
alpha = 0.1;

W = init_weights(data);

i = 1;
old_ll = Inf;
p = get_probs(W, data);
ll = get_logll(p, t);
fprintf('Iteration #%d\n', 0);
fprintf('--log-likelihood: %2.3f\n', ll);
while i < max_iter
    fprintf('Iteration #%d\n', i);
    
    gW = get_lr_grads(W, data, t);
    W = W + alpha*gW;
    p = get_probs(W, data);
    dist = mean((p>0.5)~=(t>0.5));
    ll = get_logll(p, t);
    
    fprintf('--log-likelihood: %2.3f, errors: %2.2f%%\n', ll, 100*dist);
    if old_ll-ll < min_diff
        break;
    end
    old_ll = ll;
    i = i+1;
    save('init_lr.mat', 'W');
end
fprintf('Results after %d iterations: log-likelihood: %2.3f, errors: %2.2f%%\n', i, ll, 100*dist);