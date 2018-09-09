function y = BMeos(x,p)
% Birch-Murnaghan equation-of-state (Klotz, (13.5)) fitting function

B0  = p(1);
V0  = p(2);
B0p = p(3);
V   = x;
VpV = V0./V;

y = 3/2*B0*(VpV.^(7/3)-VpV.^(5/3)).*(1-3/4*(4-B0p).*(VpV.^(2/3)-1));

end