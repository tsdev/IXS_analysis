function t_si=resistance2temp(r_si)

% FUNCTION resistance2temp converts a resistance measurement of a
% thermistor into a temperature (in K) using an analytical expression with
% known parameters
%
% ACWalters 20/11/09

% Fixed parameters used in calculation
c = 0.001130065;
g = 0.0002405245;
e = 0.0000001089848;
f = -266.5;

% Calculation of temperature
t_si=f+1./(c+(g*log(r_si)+e*(log(r_si).^3)));

end