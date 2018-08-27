function [y]=Gauss(v,x)
y0=v(1);
A=v(2);
xc=v(3);
w=v(4);
y=y0+A*((sqrt(4.*log(2.))/(sqrt(pi)*w))*exp(-(4*log(2.)/w^2)*(x - xc).^2 ));
