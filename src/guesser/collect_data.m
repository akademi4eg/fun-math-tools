function data = collect_data(fname)
% collect data
%   Collects data from user and stores in data/'fname'.mat path.

data = [];
% collect data while we get 0 or 1 as input.
while true
    in = input('Enter next number:');
    if isempty(in) || (in ~= 0 && in ~= 1), break; end
    data(end+1) = in;%#ok<AGROW>
    clc;
end
% save and display stats
save(['data' filesep fname], 'data');
disp(['Saved ' num2str(length(data)) ' records.']);