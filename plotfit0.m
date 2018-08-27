%%

openfig('~/Documents/structures/LiCrO2/ID28/colorfig.fig');

nP = numel(fitRes(1).pvals);
pvals0 = zeros(9,20);
evals0 = zeros(9,20);

pvals0(1:9,1:nP) = [fitRes(:).pvals]';

pvals0(pvals0==0) = nan;
pvals0(pvals0==max(pvals0(:)))=nan;
hold on
for ii = 7:3:18
    errorbar(Qp(1,:),pvals0(:,ii)',pvals0(:,ii+2)','ok','linewidth',3)
    hold on
end


%%

figure
for ii = 1:9
    subplot(3,3,ii)
    plot(datfit0(ii),'semilogy',1);
    ylim auto
end

swplot.subfigure(2,2,1)