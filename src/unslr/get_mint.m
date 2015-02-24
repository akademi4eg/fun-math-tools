function I = get_mint(p)

avg_p = mean(p);
Ht = avg_p*log(avg_p) + (1-avg_p)*log(1-avg_p);
I = Ht - get_entropy(p);