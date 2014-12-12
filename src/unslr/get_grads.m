function [s, gW] = get_grads(W, data)

s = get_probs(W, data);
sfun = s.*(1-s).*(log(1-s+(s==1)) - log(s+(s==0)));
% sfun = s.*(1-s).*(log((1-s+(s==1))/mean(s)) - log((s+(s==0))/mean(1-s)));
gW = mean(bsxfun(@times, data, sfun), 2);
gW = gW.';