function y = voigt_old(x,p)
% voigt     : Voigt
% function y = voigt(x,p)
%
% MFIT Voigt fitting function
% p = [ Amplitude Centre Gauss_FWHM Lorz_FWHM Background ]
%
% Signal integral is 1 using dx=1
%
% w1 = wG*sqrt(8*ln(2));
% w2 = 2*wL;
% y = fitfun.voigt(x,[A C w1 w2 B])
% gives a normalized signal (+/-6%):
% int(y*dx) = A
% w1 is the Gaussian FWHM
% w2 is the Lorentzian FWHM
% wG is the std. of the Gaussian 
% wL is the gamma parameter of the Lorentzian


% Author:  MZ <mzinkin@sghms.ac.uk> adapted from DFM
% Description:  Voigt

if numel(p) > 5
    N = p(6);
else
    N = 16;
end

b = -sqrt(log(2))/p(3);
a = b*p(4);
b = b*2*1i;
z = a + b*(x-p(2));

M  = 2*N; 
M2 = 2*M;
k  = (-M+1:1:M-1)';
L  = sqrt(N/sqrt(2));
tt = (L*tan(k*pi/M2)).^2;
f  = [0; exp(-tt).*(L^2+tt)];
a  = real(fft(fftshift(f)))/M2;
a  = flipud(a(2:N+1));
l  = L-z;
Z  = (L+z)./l;
pp = polyval(a,Z);
% ts correction for the integral to be unity
y  = p(5)+p(1)*real(2*pp ./l.^2+(1/sqrt(pi))*ones(size(z))./l)/p(3)/1.0645;

end