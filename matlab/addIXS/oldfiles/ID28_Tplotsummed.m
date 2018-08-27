function hl_Tsummed=ID28_Tplotsummed(hf,runs)

hl_Tsummed=zeros(size(runs(1).Ts,2),1);
figuresize=get(hf,'Position');

for j=1:size(runs(1).Ts,2)
    for i=1:length(runs)
        subplot(3,3,j);hl_Tsummed(i)=errorbar(runs(i).Ts(:,j),runs(i).Is(:,j)./runs(i).Ns(:,j),sqrt(runs(i).Is(:,j))./runs(i).Ns(:,j));
        colororder=[1 0 0; 0 0 1; 0 1 0; 0 1 1; 1 0 1];
        set(hl_Tsummed(i),'color',colororder(1+mod(i-1,6),:));
        hold on
    end
end
