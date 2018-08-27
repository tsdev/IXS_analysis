function ID28_DTplotunsummed_GUI(data,specfile,scan_numbers,state,analysers,axis_handle)
% Plots out data on temperature X axis, without summing data
%
% Copyright, Andrew Walters, ID28 ESRF, 20th July 2010

hl=zeros(length(cell2mat(scan_numbers)),1);
set(axis_handle,'NextPlot','replace')
        
i=1;
for j=1:length(specfile)    
    scan_nums=cell2mat(scan_numbers(j));
    for k=1:length(scan_nums)
        if true(1,state(i))
            structname=['data.' char(specfile(j)) '.scan' num2str(scan_nums(k))];         
            for m=analysers
                eval(['Ys=' structname '.Is./' structname '.Ns;']);
                eval(['Es=sqrt(' structname '.Is)./' structname '.Ns;']);
                eval(['hl(i)=errorbar_ACW(axis_handle,' structname '.DTs_prime(:,m),Ys(:,m),Es(:,m));']);
                colororder=[1 0 0; 0 0 1; 0 1 0; 0 1 1; 1 0 1];
                set(hl(i),'color',colororder(1+mod(i-1,5),:),'linewidth',0.5);
                set(axis_handle,'NextPlot','add')
            end
        end
        i=i+1;
    end
end

xlabel(axis_handle,'DeltaT (K)','interpreter','latex','fontsize',16);
eval(['ylabel(axis_handle,''Analyzer ' num2str(analysers) ' Intensity/ione'',''interpreter'',''latex'',''fontsize'',16);']);
set(axis_handle,'NextPlot','replace')

zoom on

