%%

openfig('~/Documents/structures/LiCrO2/ID28/colorfig.fig');
axis([0.98 1.66 0 75]);
nP = numel(fitRes(1).pvals);

pvals0 = pvals(end+(-8:0),1:nP);
evals0 = evals(end+(-8:0),1:nP);

pvals0(pvals0==0) = nan;
%pvals0(pvals0==max(pvals0(:)))=nan;
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
    title(sprintf('$\\chi^2=%5.3f$',fitRes(ii).chisq),'interpreter','latex')
end

swplot.subfigure(2,2,1)