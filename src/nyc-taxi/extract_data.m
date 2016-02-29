function data = extract_data(filename)
% Reads NYC taxi data.
%   Inputs:
%       filename - path to CSV with data
%   Outputs:
%       data - a table with parsed contents

%% load data
data = readtable(filename, 'Format', ...
    '%u %D %D %u %f %f %f %u %s %f %f %u %f %f %f %f %f %f %f');
fields_mask = true(size(data.Properties.VariableNames));
rec_num = size(data, 1);
fprintf('Loaded %d records.\n', size(data, 1));
%% skip records with invalid location
ny_lat = [40.55, 40.9];
ny_long = [-73.7, -74.1];
keep_inds = data.dropoff_latitude>=ny_lat(1) & data.dropoff_longitude<=ny_long(1) ...
    & data.pickup_latitude>=ny_lat(1) & data.pickup_longitude<=ny_long(1);
keep_inds = keep_inds & data.dropoff_latitude<=ny_lat(2) & data.dropoff_longitude>=ny_long(2) ...
    & data.pickup_latitude<=ny_lat(2) & data.pickup_longitude>=ny_long(2);
data = data(keep_inds, :);
fprintf('Skipped %d records with invalid or too far pickup/dropoff locations.\n', rec_num-size(data, 1));
%% skip records with negative tips
rec_num = size(data, 1);
keep_inds = data.tip_amount>=0;
data = data(keep_inds, :);
fprintf('Skipped %d records with negative tip amount.\n', rec_num-size(data, 1));
%% leave only credit cards
cc_inds = data.payment_type==1;
cc_recs_num = sum(cc_inds);
fprintf('Keeping %d (%2.2f%%) records with credit card payment type.\n', ...
    cc_recs_num, 100*cc_recs_num/size(data, 1));
data = data(cc_inds, :);
fields_mask = fields_mask & ~strcmp(data.Properties.VariableNames, 'payment_type');
%% remove extra fields
data = data(:, fields_mask);
%% add perc_tips field
rec_num = size(data, 1);
data{:, 'perc_tip'} = 100*data.tip_amount./(data.total_amount-data.tip_amount);
% remove records with invalid tips
data = data(~isnan(data.perc_tip) & ~isinf(data.perc_tip) & data.perc_tip<200, :);
fprintf('Skipped %d records with invalid total or tip amounts.\n', rec_num-size(data, 1));