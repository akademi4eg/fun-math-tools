function data = get_all_data()
% get_all_data
%   Reads all data gathered so far. Output is a cell-array.
dirs = dir('data');
data = {};
for i = 1:length(dirs)
    if dirs(i).isdir || dirs(i).name(1)=='.', continue; end
    z = load(['data' filesep dirs(i).name], 'data');
    data{end+1} = z.data;%#ok<AGROW>
end