function [pvals, evals] = addfit2(fitRes,dat,pvals,evals)

% add to previous fits
nP     = numel(fitRes(1).pvals);

pvals0 = zeros(nP,0);
evals0 = zeros(nP,0);

nDat = numel(fitRes);

for ii = 1:nDat
    if isempty(fitRes(ii).pvals)
        pvals0 = [pvals0 nan(nP,1)];
        evals0 = [evals0 nan(nP,1)];

    else
        pvals0 = [pvals0 fitRes(ii).pvals];
        evals0 = [evals0 fitRes(ii).evals];
    end
end

pvals0 = pvals0';
evals0 = evals0';


if nDat == 1
    Emax = repmat(max(get(dat,'x')),[1 size(pvals0,1)]);
    nDat = size(pvals0,1);
else
    for ii = 1:numel(dat)
        Emax(ii) = max(get(dat(ii),'x'));
    end
end


% remove peaks above the fit limit
for ii = 1:nDat
    idx = find(abs(pvals0(ii,7:3:18))>Emax(ii));
    if numel(idx) == 1
        pvals0(ii,7+3*(idx-1)+(0:2)) = nan;
        evals0(ii,7+3*(idx-1)+(0:2)) = nan;
    end
end

pvals(end+(1:nDat),1:nP) = pvals0;
evals(end+(1:nDat),1:nP) = evals0;

pvals = pvals';
evals = evals';


end