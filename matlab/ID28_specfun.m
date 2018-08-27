function [y, name, pnames, pin] = ID28_specfun(x,p,flag,fSel)
% creates elastic line, and arbitrary number of pseudovoig profiles
%
% y = ID28_specfun(x,p)
%
% Input:
%
% x     Input energy transfer values, positive is the energy loss side.
% p 	[x0 A mu wG wL x1 A1 mu1 wG1 wL1 ... xN AN muN wGN wLN T]
%

if nargin==2 || nargin == 4
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
else
    y=[];
    name='gaussian';
    pnames=repmat('Amplitude',[numel(p) 1]);
    if flag==1, pin=p; else pin = p; end
    if flag==2
        mf_msg('Click on peak');
        [cen amp]=ginput(1);
        mf_msg('Click on width');
        [width y]=ginput(1);
        width=abs(width-cen);
        mf_msg('Click on background');
        [x bg]=ginput(1);
        amp=amp-bg;
        pin=[amp cen width bg];
    end
end

end