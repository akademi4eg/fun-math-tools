function [xb, yb, grid_coord, sample_size] = plot_coord_diagram(data,...
    fieldname, nlat_step, nlong_step, aggregator, nan_mask, len_limit)
% Plots spatial distribution on the map and returns data from the plot.
% Data contains NaNs where sample size is too small.
% Inputs:
%   data - table in NYC taxi dataset format
%   fieldname - quantity for analysis: 'perc_tip' or 'tip_amount'
%   nlat_step - cell size for latitude (e.g. 0.01)
%   nlong_step - cell size for longitude (e.g. 0.01)
%   aggregator - function to apply to each sample (e.g. @mean)
%   nan_mask - optional mask-matrix with trues for cells with sufficient
%              sample size
%   len_limit - minimal sample size to analyze; default: 20
% Outputs:
%   xb - array of ticks for latitudes
%   yb - array of ticks for longitudes
%   grid_coord - matrix with results of data grouping
%   sample_size - matrix with sample sizes for elements in grid_coord

xb = min(data.pickup_latitude):nlat_step:max(data.pickup_latitude);
yb = min(data.pickup_longitude):nlong_step:max(data.pickup_longitude);
grid_coord = zeros(length(xb), length(yb));
sample_size = zeros(length(xb), length(yb));
xb(end+1) = Inf;
yb(end+1) = 0;
if nargin < 7
    len_limit = 20;
end
h = waitbar(0, 'Processing data...');
for i = 1:length(xb)-1
    for j = 1:length(yb)-1
        if nargin > 5 && nan_mask(i, j)
            grid_coord(i, j) = NaN;
        else
            inds = data.pickup_latitude>=xb(i) & data.pickup_latitude<xb(i+1) ...
                & data.pickup_longitude>=yb(j) & data.pickup_longitude<yb(j+1);
            sample_size(i, j) = sum(inds);
            if sample_size(i, j) < len_limit
                grid_coord(i, j) = NaN;
            else
                grid_coord(i, j) = aggregator(data{inds, fieldname});
            end
        end
        waitbar((i*(length(yb)-1)+j)/(length(yb)-1)/(length(xb)-1), h,...
            [num2str(i) '/' num2str(length(xb)-1) ' ' num2str(j) '/' num2str(length(yb)-1)]);
    end
end
close(h);

xb = xb(1:end-1);
yb = yb(1:end-1);
nan_mask = isnan(grid_coord);
stx = find(~all(nan_mask, 2), 1);
stx = max(1, stx - 2);
enx = find(~all(nan_mask, 2), 1, 'last');
enx = min(size(grid_coord, 1), enx + 2);
sty = find(~all(nan_mask, 1), 1);
sty = max(1, sty - 2);
eny = find(~all(nan_mask, 1), 1, 'last');
eny = min(size(grid_coord, 2), eny + 2);
pcolor(yb(sty:eny), xb(stx:enx), grid_coord(stx:enx, sty:eny));
hold on
map = imread('data/nyc-map.png');
map = double(rgb2gray(map));
cutoff = 100;
map = uint8(max(0, (map-cutoff)/(max(map(:))-cutoff))*255); % increase contrast
map = repmat(map, 1, 1, 3);
him = imagesc([-74.1, -73.7], [40.9, 40.55], map);
ax = gca;
ax.YDir = 'normal';
set(gcf,'renderer','OpenGL');
alpha(him, 0.6);
axis([yb(sty), yb(eny), xb(stx), xb(enx)]);
shading flat
colormap jet
colorbar
xlabel('pickup latitude');
ylabel('pickup longitude');
title(['Spatial distribution for ' func2str(aggregator) '(' strrep(fieldname, '_', '\_') ')']);