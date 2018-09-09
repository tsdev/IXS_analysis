function y = nlorbkgnorm(x,p)
% n-Lorentzian added plus linear background
% normalized to integral 1 for dx=1
% p = [ Amp Centre FWHM ... Ax B ]
%
% Convolution of multiple Lorentzians sum up the Gamma parameter 
%

nP    = numel(p)-2;
A     = p(1:3:nP);
x0    = p(2:3:nP);
gamma = p(3:3:nP)/2;


% background
y = p(end-1)*x + p(end);

for ii = 1:(nP/3)
    y = y + A(ii)/(pi*gamma(ii))./(1+((x-x0(ii))/gamma(ii)).^2);
end


end