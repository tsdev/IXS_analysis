function y = transition(x,p)
% transition function
%
% p = [L beta x0 y0]
%

y = sign(x-p(3)).*p(1).*abs(x-p(3)).^p(2) + p(4);

end