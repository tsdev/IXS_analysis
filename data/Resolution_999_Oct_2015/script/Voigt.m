function [y]=Voigt(v,t)

tic

y0=v(1);
A=v(2);
xc=v(3);
wL=v(4)/2;
wG=v(5)/2;

% Divisions by two made to make consistent with Voigt_v2, and to aid easy
% comparison with widths from other fitting routines
Integrale=zeros(length(t),1);

tstart=-10000;
tend=10000;

% t_dummy=tstart:tstep:tend;    

for i=1:length(t)
    t_prime=t(i);
    func = @(t_dummy)tempofunc(v,t_prime,t_dummy); 
    Integrale(i,1)=quad(func,tstart,tend,1e-10);
end

%y = y0 + (A*2*log(2)*wL)/(pi^1.5*wG^2)*Integrale;

y = y0 + A.*Integrale;

toc

function [y]=tempofunc(v,t_prime,t_dummy)

y0=v(1);
A=v(2);
xc=v(3);
wL=v(4);
wG=v(5);

% y=exp(-t.^2)./((sqrt(log(2))*wL/wG).^2+(sqrt(4*log(2))*(t-xc)./wG-t).^2);
y_gauss=exp(-((t_dummy.^2)./(2*(wG.^2))))./(wG*sqrt(2*pi));
y_lorentz=wL./(pi*((t_prime-xc-t_dummy).^2+wL^2));
y=y_gauss'.*y_lorentz';
