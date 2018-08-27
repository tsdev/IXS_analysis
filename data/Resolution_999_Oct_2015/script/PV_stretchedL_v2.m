function [y]=PV_stretchedL(v,x)
y0=v(1);
A=v(2);
mu=v(3);
xc=v(4);
wL=v(5);
wG=v(6);
ex=v(7);
y=y0+A*(mu*(2./pi)*(wL*1./(4.*abs((x - xc).^ex) + abs(wL^ex)))+(1-mu)*(sqrt(4.*log(2.))/(sqrt(pi)*wG))*exp(-(4*log(2.)/wG^2)*(x - xc).^2 ));
%y_gaussian=(1-mu)*(sqrt(4.*log(2.))/(sqrt(pi)*w))*exp(-(4*log(2.)/w^2)*(x - xc).^2 )
%y_lorentzian=mu*(w*1./(4.*(x - xc).^2 + w^2))
