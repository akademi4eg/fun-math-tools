function [acf, ci] = get_acf(data, num_lags)
% get_acf Gets sample autocorrelation.
%   data - input sample
%   num_lags - number of lags to preserve

% we will use 95% conidence intervals
conf = 0.05;
q = sqrt(2)*erfinv(2*(1-conf/2)-1);% corresponding quantile
ci = q/sqrt(length(data));
% it is well known that ACF is possible to calculate using two Fourier
% transforms.
acf = fft(data-mean(data));
acf = ifft(acf.*conj(acf));
acf = real(acf(1:num_lags)/acf(1));

if nargout == 0
    stem(0:num_lags-1, acf, 'b');
    hold on;
    plot([0 num_lags-1], [ci ci], 'r--');
    plot([0 num_lags-1], [-ci -ci], 'r--');
    title('Sample ACF');
    xlabel('lag');
end