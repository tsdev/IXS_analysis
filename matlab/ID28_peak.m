function y = ID28_peak(x,p)
% p = [x0 A mu wG wL wL1]
% wL: Lorentzian FWHM = 2Gamma
% wG: Gauss FWHM

x0  = p(1);
A   = p(2);
mu  = p(3);
wG  = p(4);
wL  = p(5);
wL1 = p(6);

% w1 = wG*sqrt(8*ln(2));
% w2 = 2*wL;
%fitfun.voigt(x,[A/w1 C w1 w2 B])

yV = fitfun.voigt(x,[1 x0 wG wL1 0]);
yL = fitfun.nlorbkgnorm(x,[1 x0 wL+wL1 0 0]);
y  =  A*(mu*yL + (1-mu)*yV);

end