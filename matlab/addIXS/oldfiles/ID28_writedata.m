function ID28_writedata(datadir,specfile,run_numbers,Xs_interp,Ys,Es,Is_sum,Ns_sum,Es_sum,filenamestem)

for j=1:size(Xs_interp,2)
    filename=[filenamestem '_A' num2str(j) '.dat'];
    dlmwrite(filename, [Xs_interp(:,j) Ys(:,j) Es(:,j) Xs_interp(:,j) Is_sum(:,j) Ns_sum(:,j) Es_sum(:,j)], 'delimiter', ' ','newline','pc');
end