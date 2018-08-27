function [Xs,Ys,Es]=ID28_Eplotsummed_GUI(analysers,Xs_interp,Ys_norm,Es_norm,axis_handle)
% Plots out data on energy transfer X axis, after summing data
%
% Copyright, Andrew Walters, ID28 ESRF, 20th July 2010

hl=zeros(numel(analysers));
set(axis_handle,'NextPlot','replace')

for m=analysers
    hl(m)=errorbar_ACW(axis_handle,Xs_interp(:,m),Ys_norm(:,m),Es_norm(:,m));
    set(hl(m),'color',[0 0 0],'linewidth',0.5);
    set(axis_handle,'NextPlot','add')
end

Xs=Xs_interp;
Ys=Ys_norm;
Es=Es_norm;

xlabel(axis_handle,'DeltaE (meV)','interpreter','latex','fontsize',16);
eval(['ylabel(axis_handle,''Analyzer ' num2str(analysers) ' Intensity/ione'',''interpreter'',''latex'',''fontsize'',16);']);
set(axis_handle,'NextPlot','replace')

zoom on