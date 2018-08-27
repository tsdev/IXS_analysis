function bDat = ID28_importmulti(datf,numor,Si_refl,Tcorr,Icorr,toPlot)
% imports multiple combined files
%
% bDat = ID28_importmulti(datf,numor,Si_refl,Tcorr,toPlot)
%
% Input:
%
% datf      String, gives the location of the data file (.fourc file).
% numor     List of scan numbers to load.
% Si_refl   Integer, index of the Si refletion used for the data
%           collection. It determines the incident X-ray energy.
% Tcorr     Temperature corrections per analysers. Optional, default value
%           is zero.
% Icorr     Intensity corrections per analyser, multiplies the raw data.
%           Optional, default value is one.
% toPlot    If true, all loaded data will be plotted on a new figure.
%           Optional, default value is false.
%
% Output:
%
% bDat      Vector of spec1d objects containing the data.
%

% minimum value of the energy bin
dEmin = 0.7;
% number of detectors
nDet  = 9;
% maximum shift (number of temperature bins)
wWindow = 10;

if nargin < 6
    toPlot = false;
end

if nargin < 5
    Icorr = ones(1,9);
end

if nargin < 4
    Tcorr = zeros(1,9);
end

nDat = numel(numor);

% load data files
data = cell(1,nDat);

for ii = 1:nDat
    data{ii} = import_ID28(datf,numor(ii));
    % convert temperatures into energy transfer
    % apply temperature correction
    data{ii}.Tanal = bsxfun(@minus,data{ii}.Tanal,Tcorr(:)');
    data{ii}.E = ID28_T2E(repmat(data{ii}.Tmono,[1 9]),data{ii}.Tanal,Si_refl);
end


% find the longest data file (on det2)
nPoint = zeros(1,nDat);
for ii = 1:nDat
    nPoint(ii) = numel(data{ii}.I(:,2));
end

idxL = findmax(nPoint,1);
idxV = 1:nDat;
idxV(idxL)  = [];
idxV = [idxV idxL];
data = data(idxV);

if toPlot
    figure;
end

int  = cell(1,nDet);
dE   = cell(1,nDet);
M    = cell(1,nDet);
bDat = spec1d;
xshift = zeros(1,9);

% add up files on each detector
for ii = 1:nDet
    
    for jj = 1:nDat
        int{jj} = data{jj}.I(:,ii)';
        dE{jj} = data{jj}.E(:,ii)';
        M{jj}  = data{jj}.M';
        if jj == 1
            % shift temperatures
            ddE = (dE{1}(end)-dE{1}(1))/(numel(dE{1})-1);
        else
            ycorr = corrspec(int{1},int{jj});
            %xshift(jj) = ycorr.x(findmax(ycorr.z));
            centx = findmin(abs(dE{1}(end)-dE{jj}));
            sel = (abs(ycorr.x-ycorr.x(centx))<wWindow);
            ycorr.x = ycorr.x(sel);
            ycorr.z = ycorr.z(sel);
            
            xshift(jj) = findmax(ycorr.z,1)-wWindow;
            
            dE{jj} = dE{jj} + ycorr.x(findmax(ycorr.z))*ddE + dE{jj}(1) - dE{1}(1);
        end
        
    end
    
    % bin the data using quickbin
    tempDat = quickbin([dE{:}],[int{:}],[M{:}],dEmin);
    tempDat.y = tempDat.y*Icorr(ii);
    
    if toPlot
        % plot intensity vs temperature
        subplot(3,3,ii)
        box on
        for jj = 1:nDat
            plot(dE{jj},int{jj}./M{jj},'.-');
            hold on
        end
        plot(tempDat.x,tempDat.y,'o-','linewidth',2)
        title(num2str(max(xshift),'max x-shift: %d'))
    end
    
    tempDat.datafile = [datf '  det' num2str(ii)];
    tempDat.x_label = 'Energy Transfer (meV)';
    tempDat.y_label = 'Intensity (arb. units)';
    bDat(ii) = spec1d(tempDat);
    
end