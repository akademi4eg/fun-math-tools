function S = get_entropy_multi(p)

N = size(p, 1);
S = -sum(1/N*sum(p.*log(p+eps))+(N-sum(p)).*log(N-sum(p)+eps), 2);