function create_animated_map(data, filename)
% [DRAFT] Creates an animated map of rides for a dataset and stores it
% in GIF format.
% Inputs:
%   data - table in NYC dataset format
%   filename - path to save an animation (GIF file)

st = 1;
min_date = min(data.tpep_pickup_datetime);
max_date = max(data.tpep_pickup_datetime);
min_long = min(data.pickup_longitude);
min_lat = min(data.pickup_latitude);
for D = datetime(min_date.Year, min_date.Month, min_date.Day):datetime(max_date.Year, max_date.Month, max_date.Day)
    disp(D);
    % get slice of data
    inds = data.tpep_pickup_datetime >= D & data.tpep_pickup_datetime < D+1;
    sdata = data(inds, :);
    x = sdata.pickup_longitude;
    y = sdata.pickup_latitude;
    x = round(10000*(x-min_long))+1;
    y = round(10000*(y-min_lat))+1;
    % count rides
    [~, inds] = unique([x,y], 'rows');
    vals = zeros(length(inds), 1);
    for i = 1:length(vals)
        vals(i) = sum(x==x(inds(i)) & y==y(inds(i)));
    end
    % draw a map
    % TODO replace empirical 4000 with calculated max size
    map = sparse(x(inds),y(inds),vals, 4000, 4000);
    M = parula(64);
    Z = round(log(1+map)/log(max(map(:))+1)*(size(M, 1)-1))+1;
    % save to image
    % TODO automatically precalculate a good candidate for zoom
    if st
        imwrite(Z(500:3500, 3000:-1:500)', M, filename, 'gif',...
            'Loopcount', Inf, 'DelayTime', 0.2);
        st = 0;
    else
        imwrite(Z(500:3500, 3000:-1:500)', M, filename, 'gif',...
            'WriteMode', 'append', 'DelayTime', 0.2);
    end
end