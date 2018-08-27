function [data,T_shifts] = ID28_fitelasticline(data,specfile,scan_numbers,data_number,analysers,T_shifts,xlim,ylim)
% Fits elastic line in dataset, using current limits on plot as limits on
% the data to be fitted
%
% Copyright, Andrew Walters, ID28 ESRF, 20th July 2010

state=zeros(1,length(cell2mat(scan_numbers)));
state(data_number)=1;

I_0=0.5*(sum(abs(ylim)));
CEN=0.5*(sum(xlim));
gamma=0.01;
eta=0.2;
back=ylim(1);
% back=0;

x0=[I_0 CEN gamma eta back];

i=1;
for j=1:length(specfile)
    scan_nums=cell2mat(scan_numbers(j));
    for k=1:length(scan_nums)        
        if true(state(i))
            structname=['data.' char(specfile(j)) '.scan' num2str(scan_nums(k))];         
            for m=analysers
                eval(['DTs=' structname '.DTs_prime(:,m);']);
                eval(['Is=' structname '.Is(:,m)./'  structname '.Ns(:,m);']);
                eval(['Es=' structname '.Is(:,m)./'  structname '.Ns(:,m);']);
                DTs_cut=DTs(find(xlim(1)<=DTs & DTs<=xlim(2)));
                Is_cut=Is(find(xlim(1)<=DTs & DTs<=xlim(2)));
                Es_cut=Es(find(xlim(1)<=DTs & DTs<=xlim(2)));
%                 options = optimset('LevenbergMarquardt','on','Display','notify','TolFun',1e-12); %matlab version 2010
                options = optimset('Display','notify','TolFun',1e-12);
                [x,resnorm,residual,exitflag,output,lambda,jacobian] = lsqcurvefit(@create_pseudovoigt,x0,DTs_cut,Is_cut,[0 -1e10 0.01 0 -1e10],[1e100 1e10 1.0 1 1e10],options);
                eval([structname '.I_fit(:,m) = create_pseudovoigt(x,' structname '.DTs_prime(:,m));']);
                T_shifts(i,m)=T_shifts(i,m)+x(2);
            end
        end
        i=i+1;
    end
end
