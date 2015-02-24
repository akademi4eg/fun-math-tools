function S = get_entropy(p)

S = -mean(p.*log(p+(p==0))+(1-p).*log(1-p+(p==1)), 2);