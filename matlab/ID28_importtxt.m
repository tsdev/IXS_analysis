function [dat, tStr, lStr,found] = ID28_importtxt(T,Q,det,Icorr)
% imports ID28 data that is already converted
%
% [dat, tStr, lStr] = ID28_importtxt(T,Q,det,Icorr)
%
% Input:
%
% T         Vector, list of sample temperatures to load.
% Q         Vector, list of Q points to load.
% det       Vector, list of detectors to load.
% Icorr     Intensity correction factors for each detector. Optional,
%           default is one.
%
% Output:
%
% dat       Vector of spec1d files.
% tStr      Automatically generated title string for plotting the data.
% lStr      Automatically generated legend for plotting the data
%

if nargin < 4
    Icorr = ones(1,9);
end

nT = numel(T);
nQ = numel(Q);
nD = numel(det);
N  = max([nT nQ nD]);

if nT > nQ && nT > nD
    Q   = repmat(Q,size(T));
    det = repmat(det,size(T));
    tStr = sprintf('Q = (%4.2f,%4.2f,0), det%d',Q(1),Q(1),det(1));
    lStr = num2str(T','T = %d K');
elseif nQ > nT && nQ > nD
    T   = repmat(T,size(Q));
    det = repmat(det,size(Q));
    tStr = sprintf('T = %d K, det%d',T(1),det(1));
    lStr = num2str(Q','QK = %4.2f');
elseif nD > nT && nD > nQ
    T = repmat(T,size(det));
    Q = repmat(Q,size(det));
    tStr = sprintf('Q = (%4.2f,%4.2f,0), T = %d K',Q(1),Q(1),T(1));
    lStr = num2str(det','det%d');
else
    tStr = sprintf('Q = (%4.2f,%4.2f,0), T = %d K, det%d',Q(1),Q(1),T(1),det(1));
    lStr = '';
end

dat = spec1d;
found = false(1,N);

for ii = 1:N
    Q1 = floor(Q(ii));
    Q2 = (Q(ii)-Q1)*100;
    if mod(Q2,10) == 0
        fname = sprintf('LiCrO_%dK_%dp%d_2_A%d.dat',T(ii),Q1,round(Q2/10),det(ii));
    else
        fname = sprintf('LiCrO_%dK_%dp%02d_2_A%d.dat',T(ii),Q1,round(Q2),det(ii));
    end
    
    
    try
        datm = importdata(fname);
        found(ii) = true;
    catch
        warning('File cannot be found: T = %d K, Q = %4.2f, det = %d',T(ii),Q(ii),det(ii));
        continue
    end
    
    dats.x = datm(:,1);
    dats.y = datm(:,2)*Icorr(det(ii));
    dats.e = datm(:,3)*Icorr(det(ii));
    dats.x_label = 'Energy Transfer (meV)';
    dats.y_label = 'Intensity (arb. units)';
    dat(ii) = spec1d(dats);
end

dat  = dat(found);
tStr = tStr(found);
lStr = lStr(found);

end