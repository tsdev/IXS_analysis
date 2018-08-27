function filename = ID28_make_filename(specfile,scan_numbers,state,analysers)
% FUNCTION ID28_make_filename makes suggested filename for data based on
% scan numbers and SPEC filename
%
% Copyright, Andrew Walters, ID28 ESRF, 20th July 2010

i=1;
filenamestem=[];
filename=[];
for m=analysers
    for j=1:length(specfile)
        filenamestem=[filenamestem char(specfile(j))];
        scan_nums=cell2mat(scan_numbers(j));
        for k=1:length(scan_nums)
            if true(1,state(i))        
                filenamestem=[filenamestem '_' num2str(scan_nums(k))];
            end
            i=i+1;
        end
    end
    filename=[filenamestem '_A' num2str(m) '.dat'];
end