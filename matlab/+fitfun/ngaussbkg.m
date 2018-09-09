function y = ngaussbkg(x,p)
% n-Gauss added plus linear background
% normalized to amplitude 1
% p = [ Amp Centre FWHM ... Ax B ]

if mod(numel(p)-2,3)
    error('ngaussbkg:WrongInput','Wrong number of paramters!')
end

sigma = p(3:3:end)/sqrt(8*log(2));

nG = floor(numel(p)/3);

y = p(end-1)*x + p(end);

for ii = 1:nG
    y = y + p(3*ii-2) * exp(-0.5*((x-p(3*ii-1))/sigma(ii)).^2);
end

end
