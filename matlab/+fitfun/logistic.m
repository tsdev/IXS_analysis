function y = logistic(x,p)
% logistic function
%
% p = [L k x0 y0]
%

y = p(1)./(1+exp(-p(2)*(x-p(3)))) + p(4);

end