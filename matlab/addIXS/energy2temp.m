function runs = energy2temp(runs,Si_refl)

% FUNCTION temp2energy converts the temperature difference between the 
% analysers and the monochromator into an energy transfer scale. The input
% array temp can be an array of any size containing temperatures in 
% Celsius. The energy array outputted will be of the same size.

Si_a=5.43102088;            % Lattice parameter of Silicon
constant=12398.483903;      % h/(2*pi*c)
angle=1.57044726094;        % angle of monochromator

pf  = (2*Si_a/sqrt(3))*sin(angle);
factor = 1000*constant/(pf/Si_refl);

for i=1:length(runs)
    TsinC=runs(i).DTs+repmat(runs(i).Ts,1,size(runs(i).Ts,2));
    % energy = temp.*(2.581e-6+temp.*0.008e-6).*factor;
    runs(i).Xs = TsinC.*(2.221e-6+TsinC.*0.008e-6).*factor;
end

% DT=anaT(ih)-monoT(ih);
% 
% xx axis = alpha*dT integrated / 2.56e-6, with alpha thermal expansion;
% alpha=(-0.2019677e-6+0.94051e-8*T) K-1, with T in K
% dd1=anaT-DT-monoT;dd2=(anaT-DT).^2-monoT.^2;
% xx=(-0.2019677e-6.*dd1+0.5.*0.94051e-8.*dd2)./2.56e-6;
% 
% therms=[2.581 0.016;2.577 0.0091;2.531 0.0086; 2.5786501 0.0094051];
% for i=1:size(therms,1)
%     out(i,1)=therms(i,1)-(therms(i,2)*(273.15+22.5));
%     out(i,2)=therms(i,2)/2;
% end
% 
% therms=[2.581 0.016;2.577 0.0091;2.531 0.0086; 2.5786501 0.0094051];
% for i=1:size(therms,1)
%     out(i,1)=therms(i,1)-(therms(i,2)*22.5);
%     out(i,2)=therms(i,2)/2;
% end