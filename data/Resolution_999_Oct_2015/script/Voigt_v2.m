function [y]=Voigt_v2(v,t)

% Written by AC Walters 17/07/09, but taken from MZinkin's code from MFit,
% adapted from DFMcMorrow's code
% tic

y0=v(1);
A=v(2);
xc=v(3);
wL=v(4);
wG=v(5);

N = 16;

b = -sqrt(log(2))/wG;

a = b*wL;

b = b*2*i;

z = a + b*(t-xc);

M=2*N; M2=2*M; k=[-M+1:1:M-1]';

L=sqrt(N/sqrt(2));

tt=(L*tan(k*pi/M2)).^2;

f=[0; exp(-tt).*(L^2+tt)];

a=real(fft(fftshift(f)))/M2;

a=flipud(a(2:N+1));

l=L-z;

Z=(L+z)./l;

pp=polyval(a,Z);

y=y0+A*real(2*pp ./l.^2+(1/sqrt(pi))*ones(size(z)) ./l);

% toc