function data = temp2energy(data,specfile,scan_numbers,state,analysers,Si_refl)

% FUNCTION temp2energy converts the temperature difference between the 
% analysers and the monochromator into an energy transfer scale. The input
% array temp can be an array of any size containing temperatures in 
% Celsius. The energy array outputted will be of the same size.

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

Si_a=sqrt(8)*1.92015552;	% Lattice parameter of Silicon at 22.5 C
angle=89.98;	% Bragg angle of monochromator. 
                % angle taken from Verbeni et al. Rev. Sci. Inst. 79 083902 (2008)
h=6.62606896; % h = 6.62606896(33) e-34 Js (CODATA Value)
c=2.99792458; % c = 299792458 m/s exactly as defined
e=1.602176487; % e = 1.602176487(40) e-19 C (CODATA Value)
constant=h*c*1e6/(e*2*sind(angle)); % hc/(e*2*sin(angle)

d=Si_a/(sqrt(3)*Si_refl); % d-spacing of monochromator if T = 22.5
factor=constant/d; 

T0=22.5; 
alpha=2.581e-6;
beta=0.008e-6;

i=1;
for j=1:length(specfile)
    scan_nums=cell2mat(scan_numbers(j));
    for k=1:length(scan_nums)
        if true(state(i))
            structname=['data.' char(specfile(j)) '.scan' num2str(scan_nums(k))];         
        	for m=analysers
                % convert monoT values into units where T=0 when T = 22.5 C
                eval(['monoT=repmat(' structname '.Ts,1,9)-T0;']);
                % convert analT values into units where T=0 when T = 22.5 C
                eval(['analT=' structname '.DTs_prime+monoT;']);
                % calculate X-ray energies defined by temperatures of monochromator
                monoE = factor./(1+alpha*monoT+beta*monoT.^2);
                % calculate X-ray energies defined by temperatures of analysers
                analE = factor./(1+alpha*analT+beta*analT.^2);
                % find the difference between the two calculated energies
                eval([ structname '.Xs = monoE-analE;']);
            end
        end
        i=i+1;
    end
end

% Old sqwadd parameters
% Si_a=5.43102088;            % Lattice parameter of Silicon
% constant=12398.483903;      % h/(2*pi*c)
% angle=1.57044726094;        % angle of monochromator
% pf  = (2*Si_a/sqrt(3))*sin(angle);
% factor = 1000*constant/(pf/Si_refl);