function [y, name, pnames, pin] = ID28_specfun2(x,p,flag,fSel)
% creates elastic line, and arbitrary number of peaks
%
% y = ID28_specfun2(x,p)
%
% The function include a pseudovoigt interumental resolution convoluted
% with a finite lifetime for each line.
%
% Input:
%
% x     Input energy transfer values, positive is the energy loss side.
% p 	[x0 mu wG wL A0 wL0 x1 A1 wL1 ... xN AN wLN T BKG1]
%

if nargin==2 || nargin == 4
    if nargin == 2
        fSel = [];
    end
    
    p = p(:);
    
    % Boltzmann constant
    kB = 8.6173324e-2; % meV/K
    
    % number of inelastic lines
    nLine = (numel(p)-8)/3+1;
    if mod(nLine,1) ~= 0
        error('ID28_specfun:WrongInput','Wrong number of parameters!');
    end
    
    % position of the elastic line
    xE = p(1);
    % shift energy transfer values
    x = x - xE;
    % temperature
    T = p(end-1);
    
    % instrumental resolution
    mu = p(2);
    wG = p(3);
    wL = p(4);
    
    % peak parameters (xN=0 for the elastic line)
    xN  = [0 p(7:3:(end-2))'];
    AN  = p(5:3:(end-2))';
    wLN = p(6:3:(end-2))';
    
    % generate the elastic line
    y = ID28_peak(x,[xN(1) AN(1) mu wG wL wLN(1)]);
    
    % generate the lines
    for ii = 2:nLine
        if (isempty(fSel) || fSel == ii) && AN(ii)~=0
            
            % Stokes factor
            fStokes = exp(xN(ii)/(kB*T));
            
            % energy loss side at abs(x0)
            AStokes = AN(ii)*fStokes./(fStokes-1);
            
            
            y = y + ID28_peak(x,[xN(ii) AStokes mu wG wL wLN(ii)]);
            
            % energy gain side
            AAntiStokes = AN(ii)./(fStokes-1);
            y = y + ID28_peak(x,[-xN(ii) AAntiStokes mu wG wL wLN(ii)]);
        end
    end
    
    y = y + p(end);
    if any(isnan(y))
        
    end
    
else
    y=[];
    name='gaussian';
    pnames=repmat('Amplitude',[numel(p) 1]);
    if flag==1, pin=p; else pin = p; end
    if flag==2
        mf_msg('Click on peak');
        [cen, amp]=ginput(1);
        mf_msg('Click on width');
        [width, y]=ginput(1);
        width=abs(width-cen);
        mf_msg('Click on background');
        [~, bg]=ginput(1);
        amp=amp-bg;
        pin=[amp cen width bg];
    end
end

end