function [pvals, evals] = addfit(fitRes,dat,pvals,evals)

% add to previous fits
nP     = numel(fitRes(1).pvals);
pvals0 = [fitRes(:).pvals]';
evals0 = [fitRes(:).evals]';
Emax   = max(get(dat,'x'));

% remove peaks above the fit limit
for ii = 1:9
    idx = find(abs(pvals0(ii,7:3:18))>Emax);
    if numel(idx) == 1
        pvals0(ii,7+3*(idx-1)+(0:2)) = 0;
    end
end

pvals(end+(1:size(pvals0,1)),1:nP) = pvals0;
evals(end+(1:size(pvals0,1)),1:nP) = evals0;

end