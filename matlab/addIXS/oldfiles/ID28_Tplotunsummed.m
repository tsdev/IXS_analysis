function [hf,ha,hl]=ID28_Tplotunsummed(runs)

hf=figure;
set(hf,'Units','normalized','Position',[0.1 0.1 0.7 0.7]);

ha=zeros(length(runs),1);
hl=zeros(size(runs(1).Ts,2),1);


for i=1:length(runs)
    Ns_mean=repmat(mean(runs(i).Ns),size(runs(i).DTs,1),1);
    Ys=runs(i).Is.*Ns_mean./runs(i).Ns;
    Es=sqrt(runs(i).Is).*Ns_mean./runs(i).Ns;
    for j=1:size(runs(1).Ts,2)
        ha(i)=subplot(3,3,j);hl(i)=errorbar(runs(i).DTs(:,j),Ys(:,j),Es(:,j));
        colororder=[1 0 0; 0 0 1; 0 1 0; 0 1 1; 1 0 1];
        set(hl(i),'color',colororder(1+mod(i-1,6),:));
        hold on
    end
end
