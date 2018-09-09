function y = critical(x,p)
% critical exponent
%
% p = [A beta x0 y0]
%

dx = x-p(3);
y = p(1)*abs(dx).^p(2).*(dx<0);

end