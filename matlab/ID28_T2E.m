function dE = ID28_T2E(Tmono,Tanal,Si_refl)
% converts the mono and ana temperatures into energy transfer in meV
%
% dE = ID28_T2E(Tmono,Tanal,Si_refl)
%
% Input:
%
% Tmono     Monochromator temperature in Celsius.
% Tanal     Analyser temperature in Celsius.
% Si_refl   Si reflection integer, (9,11,13, etc).
%
% Output:
%
% dE        Energy transfer in meV, has the same dimensions as Tmono and
%           Tanal.
%

% From Bergamin et al. J. Appl. Phys. 82 11 (1997)
% d_220 = 1.92015552(4) Angs at 22.5 C
% So lattice parameter for Si is sqrt(8)*d_220 = 5.4310200(1) Angs
% This means that
% a(DT) = a(0)*(1+alpha*DT+beta*DT^2);
% where DT is T(C)-22.5 C
% a(DT) is the lattice parameter of Si at DT
% a(0) is the lattice parameter of Si when DT=0, i.e. when T=22.5 C
% alpha = 2.581(2) x 10^{-6} 1/K
% beta = 0.008(2) x 10^{-6} 1/K^2

% Lattice parameter of Silicon at 22.5 C
Si_a=sqrt(8)*1.92015552;
% Bragg angle of monochromator
% angle taken from Verbeni et al. Rev. Sci. Inst. 79 083902 (2008)
angle=89.98;
% h = 6.62606896(33) e-34 Js (CODATA Value)
h=6.62606896;
% c = 299792458 m/s exactly as defined
c=2.99792458;
% e = 1.602176487(40)E-19 C (CODATA Value)
e=1.602176487;
% hc/(e*2*sin(angle)
constant=h*c*1e6/(e*2*sind(angle));
% d-spacing of monochromator if T = 22.5 C
d=Si_a/(sqrt(3)*Si_refl);

factor=constant/d;

T0    = 22.5;
alpha = 2.581e-6;
beta  = 0.008e-6;

% convert monoT values into units where T=0 when T = 22.5 C
dTmono = Tmono - T0;
% convert analT values into units where T=0 when T = 22.5 C
dTanal = Tanal - T0;
% calculate X-ray energies defined by temperatures of monochromator
monoE = factor./(1+alpha*dTmono+beta*dTmono.^2);
% calculate X-ray energies defined by temperatures of analysers
analE = factor./(1+alpha*dTanal+beta*dTanal.^2);
% find the difference between the two calculated energies
dE = monoE - analE;

end