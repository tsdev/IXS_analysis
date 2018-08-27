function [y]=PV(v,x)
y0=v(1);
A=v(2);
mu=v(3);
xc=v(4);
w=v(5);
y=y0+A*(mu*(2./pi)*(w*1./(4.*(x - xc).^2 + w^2))+(1-mu)*(sqrt(4.*log(2.))/(sqrt(pi)*w))*exp(-(4*log(2.)/w^2)*(x - xc).^2 ));
%y_gaussian=(1-mu)*(sqrt(4.*log(2.))/(sqrt(pi)*w))*exp(-(4*log(2.)/w^2)*(x - xc).^2 )
%y_lorentzian=mu*(w*1./(4.*(x - xc).^2 + w^2))

% Identical definition to that in H. Sinn et al, 
% Nuclear Instruments and Methods in Physics Research A 467-468 (2001) 1545-1548