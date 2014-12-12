function S = get_entropy(p)

S = -sum(p.*log(p+(p==0))+(1-p).*log(1-p+(p==1)), 2);
% S = sum(p.*log((p+(p==0))/mean(p))+(1-p).*log((1-p+(p==1))/mean(1-p)), 2);