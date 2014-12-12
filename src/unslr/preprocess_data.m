function [data, keep_inds, means, stds] = preprocess_data(data, keep_inds, means, stds)

if nargin < 2
    means = mean(data, 2);
    stds = std(data, [], 2);
    keep_inds = stds>0;
    means = means(keep_inds);
    stds = stds(keep_inds);
    fprintf('After preprocessing %d of %d features remained.\n', sum(keep_inds), size(data, 1));
end
data = data(keep_inds, :);
data = bsxfun(@minus, data, means);
data = bsxfun(@times, data, 1./stds);
data = [ones(1, size(data, 2));data];