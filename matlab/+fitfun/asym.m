function y = asym(x,p)
% p = [AmpGl AmpLl wGl wLl wGr Center Ax B ]

AGl = p(1);
ALl = p(2);
AGr = AGl+ALl;


wGl = p(3);
wLl = p(4);
wGr = p(5);

x0 = p(6);

A  = p(7);
B  = p(8);

xL = x(x<x0)-x0;
xR = x(x>=x0)-x0;


y = [(ALl./(1+(xL/wLl).^2) + AGl*exp(-(xL/2/wGl).^2)); AGr*exp(-(xR/2/wGr).^2)] + A*x + B;


end