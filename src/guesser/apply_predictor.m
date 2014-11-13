function out = apply_predictor(D, p)
% apply_predictor
%   Applies p predictor to D data.

% getting relevant index from data
ind = 1;
for j = 0:length(D)-1
    if D(j+1)
        ind = ind + 2^j;
    end
end
% estimating probability
out = p(2,ind)/sum(p(:, ind));