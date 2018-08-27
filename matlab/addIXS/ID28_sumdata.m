function [data,Is_sum,Ns_sum,Es_sum,Ys,Es]=ID28_sumdata(data,specfile,scan_numbers,state,analysers,Xs_interp)
% FUNCTION ID28_sumdata sums ID28 data by interpolating the measured
% intensities onto a fixed temperature scale and then simply summing them
% up
%
% Copyright, Andrew Walters, ID28 ESRF, 20th July 2010

% Initialise summing arrays
Is_sum=zeros(size(Xs_interp));
Ns_sum=zeros(size(Xs_interp));

% Use intrinsic interp1 function within two FOR loops to create new
% interpolated intensities (Is_interp) and interpolated monitors
% (Ns_interp)
i=1;
for j=1:length(specfile)
    scan_nums=cell2mat(scan_numbers(j));
    for k=1:length(scan_nums)
        if true(state(i))
            structname=['data.' char(specfile(j)) '.scan' num2str(scan_nums(k))];         
        	for m=analysers
                eval([ structname '.Is_interp(:,m) = interp1(' structname '.Xs(:,m),' structname '.Is(:,m),Xs_interp(:,m),''linear'',0);']);
                eval([ structname '.Ns_interp(:,m) = interp1(' structname '.Xs(:,m),' structname '.Ns(:,m),Xs_interp(:,m),''linear'',0);']);
            end
            % Sum interpolated intensities and monitor values
            eval(['Is_sum=Is_sum+' structname '.Is_interp;']);
            eval(['Ns_sum=Ns_sum+' structname '.Ns_interp;']);
        end
        i=i+1;
    end
end

% calculate mean values of monitor for each analyser and copy the mean
% values for all values of temperature
% Ns_mean=repmat(mean(Ns_sum),size(Xs_interp,1),1);
% Normalise intensities so that normalised intensity has similar magnitude
% to unnormalised intensity using mean values of monitor
Ys=Is_sum./Ns_sum;
% Calculate errors on data by squarerooting the summed interpolated 
% intensities
Es_sum=sqrt(Is_sum);
% Scale calculated errors by multiplying the errors by the same factors
% that the intensities were multiplied by
Es=Es_sum./Ns_sum;