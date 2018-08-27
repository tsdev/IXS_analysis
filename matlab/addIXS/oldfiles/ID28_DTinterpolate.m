function DTs_interp = ID28_DTinterpolate(runs)
% Go through all runs, finding the minimum and maximum values of T, as well
% as the minimum increment in T over the whole scan
%
% Copyright, Andrew Walters, ID28 ESRF, 20th July 2010
for i=1:length(runs)
    DT_min_array(i,:)=min(runs(i).DTs);
    DT_max_array(i,:)=max(runs(i).DTs);
    DDT_min_array(i,:) = min(diff(runs(i).DTs));
end

% Find the minimum and maximum values of T for all the scans to be summed, 
% as well as the minimum increment in T 
DT_min=min(DT_min_array);
DT_max=max(DT_max_array);
DDT_min=min(DDT_min_array);

% Find the length of the new interpolated T array for analyser 1
length_DTs_interp = length(DT_min(1):DDT_min(1):DT_max(1));

% Initialise 2D array for all the interpolated T arrays for all the
% analysers
DTs_interp=zeros(length_DTs_interp,size(runs(1).DTs,2));
% Write new interpolated T arrays to Ts_interp
for j=1:size(runs(1).Ts,2)
        DTs_interp(:,j) = linspace(DT_min(j),DT_max(j),length_DTs_interp);
end