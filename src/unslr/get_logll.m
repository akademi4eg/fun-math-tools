function ll = get_logll(p, t)

ll = mean(t.*log(p+(p==0)) + (1-t).*log(1-p+(p==1)));