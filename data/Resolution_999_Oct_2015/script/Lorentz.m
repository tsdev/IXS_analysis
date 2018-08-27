function [y]=Lorentz(v,x)
y0=v(1);
A=v(2);
xc=v(3);
w=v(4);
y=y0+A*(2./pi)*(w*1./(4.*(x - xc).^2 + w^2));
%y=(1-mu)*(sqrt(4.*log(2.))/(sqrt(pi)*w))*exp(-(4*log(2.)/w^2)*(x - xc).^2 )
%y=mu*(w*1./(4.*(x - xc).^2 + w^2))