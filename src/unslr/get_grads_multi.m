function [s, gW] = get_grads_multi(W, data)

s = get_probs(W, data);
N = size(s, 1);
sfun = 1/N*s.*(1-s).*(log(N-repmat(sum(s), N, 1)+eps) - log(s+eps));
% sfun = s.*(1-s).*(log((1-s+(s==1))/mean(s)) - log((s+(s==0))/mean(1-s)));
gW = zeros(size(W));
for i = 1:size(sfun, 1)
    gW(i, :) = mean(bsxfun(@times, data, sfun(i, :)), 2)';
end