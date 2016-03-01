function analyze_data(data, cell_size)
% Plots and prints information describing the dataset.
% Inputs:
%       data - table with records in NYC taxi dataset format
%       cell_size - size of decimal degree cell for analysis; default: 0.01

if nargin < 2, cell_size = 0.01; end
%% tips stats
figure;
quants = quantile(data.tip_amount, [.25 .50 .75 .95]);
hist(data.tip_amount(data.tip_amount<=quants(end)), 100)
xlabel('tip, $')
title('Histogram for tips (top 5% omitted)')
fprintf('%2.2f%% of trips end without tipping.\n', 100*mean(data.tip_amount==0));
fprintf('25%%: %2.2f, median: %2.2f, 75%%: %2.2f, 95%%: %2.2f\n', ...
    quants(1), quants(2), quants(3), quants(4));
fprintf('Big (10+) tips fraction: %2.2f%%.\n', 100*mean(data.tip_amount>=10));
[top_tips, top_tips_freqs] = get_top_vals(data.tip_amount(data.tip_amount>0), 5, 0.01);
fprintf('Top 5 tips cover %2.2f%% of data:\n', 100*sum(top_tips_freqs)/size(data, 1));
disp(top_tips);

%% percent tips
figure;
perc_quants = quantile(data.perc_tip, [.25 .50 .75 .95]);
hist(data.perc_tip(data.perc_tip<=perc_quants(end)), 100)
xlabel('tip, %')
title('Histogram for percent-tips (top 5% omitted)')
fprintf('25%%: %2.2f, median: %2.2f, 75%%: %2.2f, 95%%: %2.2f\n', ...
    perc_quants(1), perc_quants(2), perc_quants(3), perc_quants(4));
fprintf('Big (100+) tips fraction: %2.2f%%.\n', 100*mean(data.perc_tip>=100));
[top_tips, top_tips_freqs] = get_top_vals(data.perc_tip(data.perc_tip>0), 5, 1);
fprintf('Top 5 percent-tips cover %2.2f%% of data:\n', 100*sum(top_tips_freqs)/size(data, 1));
disp(top_tips);

%% spatial distributions for tips and sample size
figure;
[~, ~, nan_mask] = plot_coord_diagram(data, 'perc_tip', cell_size, cell_size, @(x)log10(length(x)));
title('Spatial distribution for log10 of sample size');
nan_mask = isnan(nan_mask); % nan_mask speed-ups further computations
figure;
plot_coord_diagram(data, 'perc_tip', cell_size, cell_size, @median, nan_mask);
figure;
plot_coord_diagram(data, 'tip_amount', cell_size, cell_size, @median, nan_mask);
figure;
plot_coord_diagram(data, 'perc_tip', cell_size, cell_size, @mean, nan_mask);
figure;
plot_coord_diagram(data, 'tip_amount', cell_size, cell_size, @mean, nan_mask);

%% hypothesis testing
figure;
pop_mean = mean(data.tip_amount);
% p-value for t-test: p = 1-tcdf((<x>-mu)/se)
pval_func = @(x)1-tcdf((mean(x)-pop_mean)/std(x)*sqrt(length(x)), length(x)-1);
plot_coord_diagram(data, 'tip_amount', cell_size, cell_size, pval_func, nan_mask, 50);
title('Spatial distribution for p-values of hypothesis\newlinethat mean(location tip) = mean(all tips)');
figure;
pop_mean = mean(data.perc_tip);
% p-value for mean(percent-tip) t-test
perc_pval_func = @(x)1-tcdf((mean(x)-pop_mean)/std(x)*sqrt(length(x)), length(x)-1);
plot_coord_diagram(data, 'perc_tip', cell_size, cell_size, perc_pval_func, nan_mask, 50);
title('Spatial distribution for p-values of hypothesis\newlinethat mean(location percent-tip) = mean(all percent-tips)');
figure;
pop_mean = 20;
% p-value for mean(percent-tip)=20 t-test
perc_pval_func = @(x)1-tcdf((mean(x)-pop_mean)/std(x)*sqrt(length(x)), length(x)-1);
plot_coord_diagram(data, 'perc_tip', cell_size, cell_size, perc_pval_func, nan_mask, 50);
title('Spatial distribution for p-values of hypothesis\newlinethat mean(location percent-tip) = 20%');

%%  perfect tipping
% perc_tip is perfect if it is round
plot_coord_diagram(data, 'perc_tip', cell_size, cell_size, ...
    @(x)100*mean(abs(x-round(x))<0.001), nan_mask);
title('Spatial distribution for percent of rides\newlinewhere client prefer perfect percent-tip');
% tip_amount is perfect if it is multiple of 0.25 or 0.2
plot_coord_diagram(data, 'tip_amount', cell_size, cell_size, ...
    @(x)100*mean(abs(4*x-round(4*x))<0.001 | abs(5*x-round(5*x))<0.001), nan_mask);
title('Spatial distribution for percent of rides\newlinewhere client prefer perfect tip sum');