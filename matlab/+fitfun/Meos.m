function y = Meos(x,p)
% Murnaghan equation-of-state (Klotz, (13.3)) fitting function

B0  = p(1);
V0  = p(2);
B0p = p(3);
V   = x;
VpV = V0./V;

y = B0/B0p*(VpV.^B0p-1);

end