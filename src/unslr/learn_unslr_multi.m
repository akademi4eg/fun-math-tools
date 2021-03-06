function [p, W, means, stds, keep_inds] = learn_unslr_multi(data, N)

max_iter = 100;
alpha = 0.1;
min_diff = 0.01;
disp_fact = 10;

[data, keep_inds, means, stds] = preprocess_data(data);
W = randn(N, size(data, 1))/10;
disp('Starting unsupervised part.');
i = 1;
old_ll = Inf;
p = get_probs(W, data);
ll = get_entropy_multi(p);
fprintf('Iteration #%d\n', 0);
fprintf('--log-entropy: %2.3f\n', ll);
while i < max_iter
    if mod(i, disp_fact)==0
        fprintf('Iteration #%d\n', i);
        if old_ll-ll < min_diff
            break;
        end
    end
    
    [old_p, gW] = get_grads_multi(W, data);
    W = W - alpha*gW;
    p = get_probs(W, data);
    dist = mean((old_p(:)>0.5)~=(p(:)>0.5));
    ll = get_entropy_multi(p);
    
    if mod(i, disp_fact)==0
        fprintf('--log-entropy: %2.3f, dist: %2.2f%%\n', ll, 100*dist);
        old_ll = ll;
    end
    i = i+1;
    save('cur_lr.mat', 'W', 'means', 'stds', 'keep_inds', 'p');
end
fprintf('Results after %d iterations. log-entropy: %2.3f, dist: %2.2f%%\n', i-1, ll, 100*dist);
figure(123);
subplot(311),hist(p', 50);
subplot(312),stem(smooth(p(1, :)-0.5, 100));
subplot(313),imagesc(W);colorbar;