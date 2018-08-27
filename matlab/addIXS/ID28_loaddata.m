function data = ID28_loaddata(datadir,specfile,scan_numbers)
% FUNCTION ID28_loaddata loads data from runs defined in run_numbers in the
% SPEC file defined in datafile.
%
% Copyright, Andrew Walters, ID28 ESRF, 20th July 2010
for k=1:length(datadir)
    for i=1:length(specfile)
        scan_nums = cell2mat(scan_numbers(i));
        for j=1:length(scan_nums)
            tempdata = NormExtract9([char(datadir(k)) char(specfile(i))],scan_nums(j));

            eval(['data.' char(specfile(i)) '.scan' num2str(scan_nums(j)) '.Ts = tempdata(:,3);']);
            eval(['data.' char(specfile(i)) '.scan' num2str(scan_nums(j)) '.DTs = tempdata(:,4:12);']);
            eval(['data.' char(specfile(i)) '.scan' num2str(scan_nums(j)) '.DTs_prime = tempdata(:,4:12);']);
            eval(['data.' char(specfile(i)) '.scan' num2str(scan_nums(j)) '.Is = tempdata(:,13:21);']);
            eval(['data.' char(specfile(i)) '.scan' num2str(scan_nums(j)) '.Ns = repmat(tempdata(:,2),1,9);']);
        end
    end
end