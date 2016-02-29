function [modes, freqs] =  get_top_vals(data, num, step)
% Rounds _data_ to closest multiple of _step_ and returns
%   _num_ modes with frequencies.
% Inputs:
%   data - array of numbers
%   num - number of modes to return
%   step - step of values in data
% Outputs:
%   modes - array of most frequent values
%   freqs - frequencies for modes

[freqs, modes] = histcounts(data, 0:step:max(data));
num = min(num, length(modes));
[~, inds] = sort(-freqs);
modes = modes(inds(1:num));
freqs = freqs(inds(1:num));