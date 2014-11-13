function p = get_predictors(data, ord, p)
% get_predictors
%   Estimates distribution from data.

% initialization to have 50% probability as a default case
if nargin < 3
    p = ones(2, 2^ord);
end
for i = 1:length(data)-ord
    D = data(i:i+ord);
    % calculate index
    ind = 1;
    for j = 0:length(D)-2
        if D(j+1)
            ind = ind + 2^j;
        end
    end
    % update distribution
    p(D(end)+1, ind) = p(D(end)+1, ind) + 1;
end