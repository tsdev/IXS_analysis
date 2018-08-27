function Ts_interp = ID28_Tinterpolate(runs)
% FUNCTION ID28_Tinterpolate calculates an interpolated version of the
% temperature scale for summing the data
%
% Copyright, Andrew Walters, ID28 ESRF, 20th July 2010

% Go through all runs, finding the minimum and maximum values of T, as well
% as the minimum increment in T over the whole scan
for i=1:length(runs)
    T_min_array(i,:)=min(runs(i).Ts);
    T_max_array(i,:)=max(runs(i).Ts);
    DT_min_array(i,:) = min(diff(runs(i).Ts));
end

% Find the minimum and maximum values of T for all the scans to be summed, 
% as well as the minimum increment in T 
T_min=min(T_min_array);
T_max=max(T_max_array);
DT_min=min(DT_min_array);

% Find the length of the new interpolated T array for analyser 1
length_Ts_interp = length(T_min(1):DT_min(1):T_max(1));

% Initialise 2D array for all the interpolated T arrays for all the
% analysers
Ts_interp=zeros(length_Ts_interp,size(runs(1).Ts,2));
% Write new interpolated T arrays to Ts_interp
for j=1:size(runs(1).Ts,2)
        Ts_interp(:,j) = linspace(T_min(j),T_max(j),length_Ts_interp);
end