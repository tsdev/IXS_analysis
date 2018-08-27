function hl_DTsummed=ID28_DTplotsummed(hf,runs)

hl_DTsummed=zeros(size(runs(1).Ts,2),1);
figuresize=get(hf,'Position');

for j=1:size(runs(1).DTs,2)
    for i=1:length(runs)
        subplot(3,3,j);hl_DTsummed(i)=errorbar(runs(i).DTs(:,j),runs(i).Is(:,j)./runs(i).Ns(:,j),sqrt(runs(i).Is(:,j))./runs(i).Ns(:,j));
        colororder=[1 0 0; 0 0 1; 0 1 0; 0 1 1; 1 0 1];
        set(hl_DTsummed(i),'color',colororder(1+mod(i-1,6),:));
        hold on
    end
end
