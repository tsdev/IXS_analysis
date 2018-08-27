function [hf_Esummed,ha_Esummed,hl_Esummed]=ID28_Eplotsummed(analysers,Xs_interp,Ys_norm,Es_norm)

ha_Esummed=zeros(size(Xs_interp,2),1);

hf_Esummed=figure;
set(hf_Esummed,'Units','normalized','Position',[0.1 0.1 0.7 0.7]);

for j=analysers
	ha_Esummed(j)=subplot(3,3,j);hl_Esummed=errorbar(Xs_interp(:,j),Ys_norm(:,j),Es_norm(:,j));
	set(hl_Esummed,'color',[0 0 0],'linewidth',2);
	hold on
end