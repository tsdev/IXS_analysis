function filenamestem = ID28_make_filenamestem(specfile,scan_numbers,state,analysers)

i=1;
filenamestem=[];
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
    filenamestem=[filenamestem '_A' m];
end