function [Xs,Is_sum,Ns_sum,Es_sum,Ys,Es]=ID28_Eplotunsummed(data,specfile,scan_numbers,state,analysers,axis_handle)
% Plots out data on energy transfer X axis, without summing data
%
% Copyright, Andrew Walters, ID28 ESRF, 20th July 2010

hl=zeros(numel(analysers));
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
                % if intensity equals zero, then error defined as if there
                % is one count (to avoid fitting problems in FIT28)
                eval(['Es(Ys==0)=1./' structname '.Ns(Ys==0);']);
                eval(['Is_sum=' structname '.Is;']);
                eval(['Ns_sum=' structname '.Ns;']);
                eval(['Es_sum=sqrt(' structname '.Is);']);
                eval(['hl(m)=errorbar_ACW(axis_handle,' structname '.Xs(:,m),Ys(:,m),Es(:,m));']);

                set(hl(m),'color',[0 0 0],'linewidth',0.5);
                set(axis_handle,'NextPlot','add')
            end
        end
        i=i+1;
    end
end

eval(['Xs=' structname '.Xs;']);
                
xlabel(axis_handle,'$\Delta$E (meV)','interpreter','latex','fontsize',16);
eval(['ylabel(axis_handle,''Analyzer ' num2str(analysers) ' Intensity/ione'',''interpreter'',''latex'',''fontsize'',16);']);
set(axis_handle,'NextPlot','replace')
    
zoom on