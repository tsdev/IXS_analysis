function [y, ySep] = genspecfun(x,p)
% creates spectral function from convoluted pseudo voigt functions
%
% [y ySep] = genspecfun(x,p)
%
% Calculates spectral function at finite temperature including the Bose
% factor and also the elastic line (incoherent line).
%
% Input:
%
% x     Row (column) vector of coordinate values, typically energy
%       transfer, in that case positive is the particle creation side
%       (energy loss).
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
% Output:
%
% y     Vector with same dimensions as x, contains the calculated
%       profile.
% ySep  Matrix, that contains the separate profile of each peak-pair. If
%       the input is a row vector, the dimension is [N Nx], while if x is a
%       column vector: [Nx N]. Can be used to overplot the separate
%       profiles. Only calculated when a second output is requested.
%

T  = p(1);
x0 = p(2);

% number of inelastic lines
nLine = (numel(p)-1)/8;
if mod(nLine,1) ~= 0
    error('Wrong number of input parameters!');
end

if nLine == 0
    y = x*0;
    return
end

% calculate the elastic line
y = fitfun.pvoigt2(x,p(2:9));

if nargout > 1
    rVect = size(x,1) == 1;
    if rVect
        ySep = zeros(nLine, size(x,2));
        ySep(1,:) = y;
    else
        ySep = zeros(size(x,1),nLine);
        ySep(:,1) = y;
    end
end

% additional inelastic lines
for ii = 1:(nLine-1)
    
    xi   = abs(p(ii*8+2));
    Ai   = p(ii*8+3);
    
    if T ~= 0
        % Stokes factor
        fStokes = exp(xi./T);
        % energy loss side at abs(xi)
        Stokes = fStokes./(fStokes-1);
        yL = Ai*Stokes*fitfun.pvoigt2(x,[x0+xi 1 p(ii*8+(4:9))]);
        
        % energy gain side
        AntiStokes = 1./(fStokes-1);
        yL = yL + Ai*AntiStokes*fitfun.pvoigt2(x,[x0-xi 1 p(ii*8+(4:9))]);
        
    else
        % only the energy loss side is calculated
        yL = Ai*fitfun.pvoigt2(x,[xi+x0 1 p(ii*8+(4:9))]);

    end
    
    y = y + yL;
    
    if nargout > 1
        if rVect
            ySep(ii+1,:) = yL;
        else
            ySep(:,ii+1) = yL;
        end
    end
end

end