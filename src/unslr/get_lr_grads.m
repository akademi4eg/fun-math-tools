function gW = get_lr_grads(W, data, t)

s = get_probs(W, data);
sfun = t.*(1-s) - (1-t).*s;% or sfun = t - s;
gW = mean(bsxfun(@times, data, sfun), 2);
gW = gW.';