function ID28_plotfit(data,specfile,scan_numbers,data_number,analysers,axis_handle)
% FUNCTION ID28_plotfit plots the best fit to the elastic line
%
% Copyright, Andrew Walters, ID28 ESRF, 20th July 2010

state=zeros(1,length(cell2mat(scan_numbers)));
state(data_number)=1;

i=1;
for j=1:length(specfile)
    scan_nums=cell2mat(scan_numbers(j));
    for k=1:length(scan_nums)
        if true(state(i))
            structname=['data.' char(specfile(j)) '.scan' num2str(scan_nums(k))];         
        	for m=analysers
                set(axis_handle,'NextPlot','add')
                eval(['hl=plot(axis_handle,' structname '.DTs_prime(:,m),'  structname '.I_fit(:,m));']);
                set(hl,'color','blue','linewidth',3);
                set(axis_handle,'NextPlot','replace')
            end
        end
        i=i+1;
    end
end