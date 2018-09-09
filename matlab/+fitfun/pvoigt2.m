function y = pvoigt2(x,p)
% 2 pseudovoigt conoluted
%
% y = pvoigt2(x,p)
%
% The x coordinate values has to be monotonically increasing.
%
% Input parameters:
%
% x     Coordinate values.
% p 	Function parameter values: p = [x0 A mu1 wG1 wL1 mu2 wG2 wL2],
%       where the indices denote the first and second pseudovoigt peak that
%       are convoluted together:
%           x0      Center of the convoluted peak.
%           A 	    Integrated intensity of the signal.
%           mu1,mu2	Mixing constant, mu = 1 for pure Lorentzian, mu = 0 for
%                   pure Gaussian.
%           wG1,wG2	FWHM value of the Gaussians.
%           wL1,wL2 Width of the Lorentzians.
%

% create new grid for convolution
% For Lorentzian function to get the right area better than 99%, we need
% 30*wL grid on both sides and at least 100 points.
% For Gaussian to get the right area better than 99%, we need 2 wG(FWHM)
% grid on both sides and at least 10 points.

% minimum number of points to calculate on each side of the peaks before
% the convolution
minP = 100;

x0  = p(1);
A   = p(2);
mu1 = p(3);
wG1 = p(4);
wL1 = p(5);
mu2 = p(6);
wG2 = p(7);
wL2 = p(8);

% minimum bin size of the data
dx = min(diff(x));

if dx == 0
    error('x coordinate values are non monotonic!')
end

% generate new grid for the convolution based on dx
% width of the convolution area
wW = max(abs([30*[wL1 wL2] 2*[wG1 wG2]]));
% distance between the peak center and furthest grid point
wD = max(abs(x0-x([1 end])));

% the convolution grid has to be the widest of the above 2
wC = max(wW,wD);
% add an extra point to avoid stupid edge effect and the necessity to
% extrapolate in the end
wC = wC + dx;

% check whether we have the necessary number of points on each side of the
% peaks before convolution
nP = wC/dx;

if nP < minP
    dx = wC/minP;
    nP = minP;
    %disp 'Too few points'
end

% check that dx is small enough compared to wG and wL
w1 = sqrt(wG1^2+wL1^2);
w2 = sqrt(wG2^2+wL2^2);

if w1 == 0
    y = fitfun.pvoigt(x,[x0 A mu2 wG2 wL2]);    
    return
elseif w2 == 0
    y = fitfun.pvoigt(x,[x0 A mu1 wG1 wL1]);
    return
end

dxLim = min([w1 w2])/2;
if dxLim == 0
    dxLim = 1;
end

if dx > dxLim
    dx = dxLim;
    nP = wC/dx;
end

% generate the convolution grid
xC = linspace(-wC-dx,wC+dx,2*nP+3);
%xC = -(wC+dx):dx:(wC+dx);

y1 = fitfun.pvoigt(xC,[0 1 mu1 wG1 wL1]);
y2 = fitfun.pvoigt(xC,[0 1 mu2 wG2 wL2]);

yC = fftshift(ifft(fft(y1).*fft(y2)));

% interpolate the signal into the original grid
y = A*interp1(xC,yC,x-x0)*dx;

% if false
%     figure;
%     plot(xC,yC)
%     hold on
%     plot(x,y/A/dx,'o-')
% end

end