function y = genspecfun(x,p)
% creates spectral function from convoluted pseudo voigt functions
%
% y = genspecfun(x,p)
%
% Calculates spectral function at finite temperature including the Bose
% factor and also the elastic line (incoherent line).
%
% Input:
%
% x     Coordinate values, typically energy transfer, in that case positive
%       is the particle creation side (energy loss).
% p 	Input parametersin a row vector:
%           p = [T, x0 A0 mu0A wG0A wL0A,mu0B wG0B wL0B,...
%                   x1 A1 mu1A wG1A wL1A mu1B wG1B wL1B,...
%                   x2 A2 mu2A wG2A wL2A mu2B wG2B wL2B,...
%                   ...
%                   xN AN muNA wGNA wLNA muNB wGNB wLNB];
%       numerical indices denote the peak (0 is the incoherent
%       line) and A,B denote the 2 constituent lineshapes (typically A is
%       the instrument resolution, B is the intrinsic line shape of the
%       excitation):
%           T       Unitless temperature (in units of the x-axis).
%           x0      Position of the incoherent line
%           xi      Position of the inelastic peaks relative to the
%                   incoherent line x0.
%           Ai      Integrated intensity of the line.
%           mui     Mixing constant, mu = 1 for pure Lorentzian, mu = 0 for
%                   pure Gaussian. It has to be within the range of [0 1].
%           wGi     FWHM value of the Gaussian line.
%           wLi     Width of the Lorentzian line.
%
%
%       [x0 A mu wG wL x1 A1 mu1 wG1 wL1 ... xN AN muN wGN wLN T]
%

T  = p(1);
x0 = p(2);

if nargin == 2
    fSel = [];
end

% Boltzmann constant
kB = 8.6173324e-2; % meV/K

% number of inelastic lines
nLine = (numel(p)-6)/5;
if mod(nLine,1) ~= 0
    error('ID28_specfun:WrongInput','Wrong number of parameters!');
end

% position of the elastic line
xE = p(1);
% shift energy transfer values
x = x - xE;
% temperature
T = p(end);

% elastic line
pE = p(2:5);
if isempty(fSel) || fSel == 1
    y = ID28_pseudovoigt(x,[0 pE(:)']);
else
    y = x*0;
end

% additional inelastic lines
for ii = 1:nLine
    if isempty(fSel) || fSel == (ii+1)
        x0 = abs(p((ii-1)*5+6));
        A  = p((ii-1)*5+7);
        mu = p((ii-1)*5+8);
        wG = p((ii-1)*5+9);
        wL = p((ii-1)*5+10);
        
        % Stokes factor
        fStokes = exp(x0/(kB*T));
        
        % energy loss side at abs(x0)
        AStokes = A*fStokes./(fStokes-1);
        y = y + ID28_pseudovoigt(x,[x0 AStokes mu wG wL]);
        
        % energy gain side
        AAntiStokes = A./(fStokes-1);
        y = y + ID28_pseudovoigt(x,[-x0 AAntiStokes mu wG wL]);
    end
end

end