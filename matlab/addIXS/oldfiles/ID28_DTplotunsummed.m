function [hf,ha,hl]=ID28_DTplotunsummed(data,specfile,scan_numbers,analysers)

hf=figure;
set(hf,'Units','normalized','Position',[0.1 0.1 0.7 0.7]);

ha=zeros(length(scan_numbers),1);
hl=zeros(numel(analysers),1);


for i=1:length(scan_numbers)
    structname=['data.' specfile '.scan' num2str(scan_numbers(i))];
    eval(['num_epoints=size(' structname '.DTs,1);']);
    eval(['Ns_mean=repmat(mean(' structname '.Ns),num_epoints,1);']);
    eval(['Ys=' structname '.Is.*Ns_mean./' structname '.Ns;']);
    eval(['Es=sqrt(' structname '.Is).*Ns_mean./' structname '.Ns;']);
    for j=analysers
        
        eval(['ha(i)=subplot(3,3,j);hl(i)=errorbar(' structname '.DTs_prime(:,j),Ys(:,j),Es(:,j));']);
        colororder=[1 0 0; 0 0 1; 0 1 0; 0 1 1; 1 0 1];
        set(hl(i),'color',colororder(1+mod(i-1,6),:));
        hold on
    end
end

zoom on