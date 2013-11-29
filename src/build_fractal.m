function build_fractal(L, d, m, n, it_dir, rands)
%% build_fractal Creates an image using algorithm similar to one used for Mandelbrot set creation. See http://www.albertostrumia.it/Fractals/FractalMatlab/Mand/mandel.m for example of code. That code has been used as a basis for this funciton.
% After sucessful execution of the funciton, you'll see a figure with resulted image. Also full-sized image will be saved to 'image.jpg' file.
% L - initial power in creation procedure (default: random integer between -7 and 1)
% d - number of colors in representation (default: 256)
% m - image width (default: 1680)
% n - image height (default: 1550)
% it_dir - direction of changes in power (default: 1, i.e. forward)
% rands - 3 numbers representing randomnes of the algorithm (default: [0.01, 0.01, 10])
iter_num = 10;
l = 2;
if nargin < 6
    rands = [0.01, 0.01, 10];
end
if nargin < 5
    it_dir = 1;
end
if nargin < 4
    n = 1550;
end
if nargin < 3
    m = 1680;
end
if nargin < 2
    d = 256;
end
if nargin < 1
    L = randi([-7, 1]);
end
x=linspace(-l,l,m);
y=linspace(-l,l,n);
[X,Y]=meshgrid(x,y);
C=X+1i*Y;
Z = zeros(size(C));
T = (1+rands(1)*randn(size(C)).*exp(rands(2)*1i*2*pi*randn(size(C))));
C = C.*T;
for it = 1:iter_num
    Z=Z.^(L+it_dir*it+rands(3)*randn)+C;
    Z(isnan(Z)) = C(isnan(Z));
end
W = exp(-abs(Z));
W(W<1e-10) = 0.1*max(W(:))*angle(Z(W<1e-10))/pi;
colormap(summer(d));
pcolor(W);
shading flat;
axis('square','equal','off');

Wsc = W-min(W(:));
Wsc = Wsc/max(Wsc(:));
rgb_data = ind2rgb(1+round(Wsc*(d-1)), summer(d));
imwrite(rgb_data, 'image.jpg');
