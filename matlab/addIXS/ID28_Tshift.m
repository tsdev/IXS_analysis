function data = ID28_Tshift(data,specfile,scan_numbers,state,analysers,T_shifts)

i=1;
for j=1:length(specfile)
    scan_nums=cell2mat(scan_numbers(j));
    for k=1:length(scan_nums)
        if true(state(i))
            structname=['data.' char(specfile(j)) '.scan' num2str(scan_nums(k))];         
        	for m=analysers
                eval([ structname '.DTs_prime(:,m) = ' structname '.DTs(:,m) - T_shifts(i,m);']);
            end
        end
        i=i+1;
    end
end