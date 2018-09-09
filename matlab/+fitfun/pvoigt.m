function y = pvoigt(x,p)
% pseudovoigt function
%
% y = pvoigt(x,p)
%
% The Gaussian and Lorentzian functions are normalized to amplitude 1
% before the mixing.
%
% Input parameters:
%
% x     Coordinate values.
% p 	Function parameter values: p = [x0 A mu wG wL], where:
%           x0      Center of the peak.
%           A       Amplitude of the signal.
%           mu      Mixing constant, mu = 1 for pure Lorentzian, mu = 0 for
%                   pure Gaussian. It has to be within the range of [0 1].
%           wG      FWHM value of the Gaussian, has to be positive.
%           wL      Width of the Lorentzian has to be positive.
%

x0 = p(1);
A  = p(2);
mu = p(3);
wG = p(4);
wL = p(5);

if mu < 0 || mu > 1
    error('Mixing constant has to be within the [0 1] range!')
end

if wG < 0 || wL < 0
    error('The width of Lorentzian and Gaussian has to be positive!')
end

if mu == 1
    y = (2*A/pi)*(wL./(4*(x-x0).^2+wL^2));
    return
elseif mu == 0
    y = A*sqrt(4*log(2)/pi)*(1/wG)*exp(-((4*log(2))./(wG^2)).*(x-x0).^2);
    return
end

yL = (2/pi)*(wL./(4*(x-x0).^2+wL^2));
yG = sqrt(4*log(2)/pi)*(1/wG)*exp(-((4*log(2))./(wG^2)).*(x-x0).^2);
%y  =  mu*yL + (1-mu)*yG;
y  =  A*(mu*yL/max(yL) + (1-mu)*yG/max(yG));

end