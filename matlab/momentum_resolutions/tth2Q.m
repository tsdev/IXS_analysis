function Q=tth2Q(tth,energy)

% TTH2Q: converts a two-theta angle (tth) in degrees into momentum transfer
% Q (in inverse angstroms). Requires incident energy to be given in keV.
%
% ACWalters Bonfire Night November 2009

lambda=6.626e-34*3e8./(energy*1e3*1.602e-19);
Q=(4*pi/lambda)*sind(tth/2)*1e-10;