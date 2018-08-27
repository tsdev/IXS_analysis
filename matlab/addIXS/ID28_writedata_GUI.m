function ID28_writedata_GUI(datadir,specfile,scan_numbers,state,analysers,Xs,Ys,Es,Is_sum,Ns_sum,Es_sum,filename)

for_FIT28=zeros(size(Xs));
for j=analysers
%     filename=[filenamestem '_A' num2str(j) '.dat'];
    dlmwrite(filename, [Xs(:,j) Ys(:,j) Es(:,j) for_FIT28(:,j) Is_sum(:,j) Ns_sum(:,j) Es_sum(:,j)], 'delimiter', ' ','newline','pc');
%     arb_factor=1e6;
%     dlmwrite(filename, [Xs(:,j) Ys(:,j)*arb_factor Es(:,j)*arb_factor for_FIT28(:,j) Is_sum(:,j) Ns_sum(:,j) Es_sum(:,j)], 'delimiter', ' ','newline','pc');
end