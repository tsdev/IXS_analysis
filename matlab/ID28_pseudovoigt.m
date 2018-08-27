function y = ID28_pseudovoigt(x,p)
% p = [x0 A mu wG wL]

x0 = p(1);
A  = p(2);
mu = p(3);
wG = p(4);
wL = p(5);

yL =  (2*A/pi)*(wL./(4*(x-x0).^2+wL^2));
yG = A*sqrt(4*log(2)/pi)*(1/wG)*exp(-((4*log(2))./(wG^2)).*(x-x0).^2);

y  =  mu*yL + (1-mu)*yG;

end