function [y, name, pnames, pin] = poly(x,p, ~)
% fitting polynomial function
%
% For numel(p) == N:
% y = p(1)*X^(N-1) + p(2)*X^(N-2) + ... p(end-1)*X + p(end)
%

if nargin==2
    y = polyval(p,x);
else
    y = [];
    name = 'fitfun.poly';
    pnames = char('A','B','C','D');
    if flag==1
        pin=[0 0 1];
    else
        pin = p;
    end
    
end

end