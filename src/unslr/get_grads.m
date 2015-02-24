function [s, gW] = get_grads(W, data)

s = get_probs(W, data);
l_expr = s./(1-s).*mean(1-s)./mean(s);
l_expr(isnan(l_expr) | l_expr == 0 | isinf(l_expr)) = 1;
sfun = s.*(1-s).*log(l_expr);
gW = mean(bsxfun(@times, data, sfun), 2);
gW = gW.';