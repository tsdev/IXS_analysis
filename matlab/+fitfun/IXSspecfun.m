function [y, ySep] = IXSspecfun(x,p)
% creates spectral function for IXS scan
%
% [y ySep] = IXSspecfun(x,p)
%
% Calculates spectral function at finite temperature including the Bose
% factor and also the elastic line (incoherent line). Assumes pseudovoigt
% instrumental resolution function and energy units of meV and temperature
% units of K. Also a Lorentzian intrinsic lineshape is assumed for each
% peak.
%
% Input:
%
% x     Row (column) vector of coordinate values, typically energy
%       transfer, in that case positive is the particle creation side
%       (energy loss).
% p 	Input parametersin a row vector:
%           p = [T, mu wG wL,   x0 A0 wL0,...
%                               x1 A1 wL1,...
%                               ...
%                               xN AN wLN];
%       numerical indices denote the peak (0 is the incoherent
%       line), [mu wG wL] denote the instrumental resolution profile:
%           T       Temperature in Kelvin.
%           mu      Mixing constant for the instrumental resolution
%                   function, mu = 1 for pure Lorentzian, mu = 0 for
%                   pure Gaussian. It has to be within the range of [0 1].
%           wG      Width of the Gaussian component of the res. fun.
%           wL      Width of the Lorentzian component of the res. fun.
%           x0      Position of the incoherent line.
%           xi      Position of the inelastic peaks relative to the
%                   incoherent line x0.
%           Ai      Integrated intensity of the line.
%           wLi     intrinsic Lorentzian line width of the peak.
%
% Output:
%
% y     Vector with same dimensions as x, contains the calculated
%       profile.
% ySep  Matrix, that contains the separate profile of each peak-pair. If
%       the input is a row vector, the dimension is [N Nx], while if x is a
%       column vector: [Nx N]. Can be used to overplot the separate
%       profiles. Only calculated when a second output is requested.
%

% Boltzmann constant
kB = 8.6173324e-2; % meV/K

% convert temperature from K to meV
T = p(1)*kB;

% number of peaks
nLine = (numel(p)-4)/3;

if mod(nLine,1) ~= 0
    error('Wrong number of input parameters!');
end

if nLine == 0
    y = x*0;
    return
end

% instrument resolution
pInst = p(2:4);
pList = reshape(p(5:end),3,nLine)';

pGen = [pList(:,[1 2]) repmat(pInst(:)',[nLine 1]) ...
    ones(nLine,1) zeros(nLine,1) pList(:,3)]';

pGen = [T pGen(:)'];

if nargout == 1
    y = fitfun.genspecfun(x,pGen);
else
    [y, ySep] = fitfun.genspecfun(x,pGen);
end

end