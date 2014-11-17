function models = run_test(is_rand, is_stoch)
% run_test
%   Runs test on data. Returns models tried.

% by default estimate the distribution and do no stochastization
if nargin < 1
    is_rand = false;
end
if nargin < 2
    is_stoch = false;
end
data = get_all_data();
% use up to 5 steps of memory
max_ord = 7;
models = cell(max_ord, 1);
for ord = 1:max_ord
    all_Z = [];
    all_Z2 = [];
    if is_rand
        % randomize distribution
        p = randi(100, [2, 2^ord]);
    else
        % try to get estimate of distribution using half of data
        p = ones(2, 2^ord);
        for i = 1:ceil(length(data)/2)
            p = get_predictors(data{i}, ord, p);
        end
    end
    models{ord} = p;
    % run test on second half of data
    for j = 1+ceil(length(data)/2):length(data)
        Z = data{j}(ord+1:end);
        Z2 = Z;
        for i = 1:length(Z)
            Z2(i) = apply_predictor(data{j}(i:i+ord-1), p);
        end
        all_Z = [all_Z, Z];%#ok<AGROW>
        all_Z2 = [all_Z2, Z2];%#ok<AGROW>
    end
    % count errors
    if is_stoch
        % randomize outputs given probabilities
        out = rand(size(all_Z2))<all_Z2;
    else
        % estimate optimal threshold
        [a, b, t] = roc(all_Z, all_Z2);
        [~, t_ind] = min(a.^2+(1-b).^2);
        t = t(t_ind);
        out = (all_Z2>=t);
    end
    errs = sum(all_Z~=out);
    if errs > length(all_Z)/2
        errs = sum(all_Z~=(1-out));
    end
    % display stats
    fprintf('%d-step memory: %d/%d errors (%1.2f%%)', ord, errs, length(all_Z),...
            100*errs/length(all_Z));
    fprintf(', CI: %1.2f%%', 100*1.96*sqrt(std(all_Z)/length(all_Z)));
    fprintf(', chance at least %1.2f%%\n', 100/2^(ord+1));
end