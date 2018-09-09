function y = ngaussbkg3(x,p)
% n-Gauss added plus quadratic background
% normalized to amplitude 1
% p = [ Amp Centre FWHM ... Ax2 Bx C ]


sigma = p(3:3:(end-1))/sqrt(8*log(2));

nG = numel(p)/3-1;

y = p(end-2)*x.^2 + p(end-1)*x + p(end);

for ii = 1:nG
    y = y + p(3*ii-2) * exp(-0.5*((x-p(3*ii-1))/sigma(ii)).^2);
end

end
