function newdat = import_ID28(datf,numor)
% imports a single ID28 energy scan from a .fourc dat file
%
% data = import_ID28(datf,numor)
%
% Input:
%
% datf      Path to the data file with .fourc extension.
% numor     Scan number in the data file.
%
% Output:
%
% data      Structure with following fields:
%               dT  nPoint x nDet matrix with the demperature differences
%                   between analysers and monochromator.
%               I   Counts per detector, matrix with same dimensions as dT.
%               M   Monitor (ione), column vector with nPoint elements.
%

% Extraction of all SPEC data using spec1d function
[alldata, datastr, ~, ~] = specdata(datf,numor);

selHeader = {'izero EH1' 'ione' 'prem_ad5' 'prem_ad6' 'prem_ad7' 'prem_ad8'...
    'prem_ad9' 'prem_ad10' 'prema_ad13' 'prem_ad12' 'prema_ad14' 'prem_ad15'...
    'deta1' 'deta2' 'deta3' 'deta4' 'deta5' 'deta6' 'deta7' 'deta8' 'deta9'...
    'detsq' 'Imirr'};

dStr = cellstr(datastr);
idxHeader = zeros(1,numel(selHeader));
for ii = 1:numel(selHeader)
    fidx = find(strcmp(dStr,selHeader{ii}));
    idxHeader(ii) = fidx;
end

% select only the corresponding data columns
dat = alldata(:,idxHeader);

Tanal = resistance2temp(dat(:,4:12));
Tmono = resistance2temp(dat(:,3));

% Subtract temperature of the analysers from the temperature of the
% monochromator, and put in output variable data
dat(:,4:12) = Tanal - repmat(Tmono,1,9);

% rename the new header to deltat
%selHeader(4:12) = cellstr(num2str((1:9)','dT_A%d'));

newdat.dT = dat(:,4:12);
newdat.I  = dat(:,13:21);
% use Ione as monitor
newdat.M  = dat(:,2);
newdat.Tmono = Tmono;
newdat.Tanal = Tanal;
end

function t_si=resistance2temp(r_si)
% converts a resistance measurement of a thermistor into a temperature
%
% t_si=resistance2temp(r_si)
%
% FUNCTION resistance2temp converts a resistance measurement of a
% thermistor into a temperature (in K) using an analytical expression with
% known parameters
%
% ACWalters 20/11/09

% Fixed parameters used in calculation
c = 0.001130065;
g = 0.0002405245;
e = 0.0000001089848;
f = -266.5;

% Calculation of temperature
t_si=f+1./(c+(g*log(r_si)+e*(log(r_si).^3)));

end

function [data, datastr, com, head]=specdata(filename, scan)
%
%function [data, datastr, com, head]=specdata(filename, scan)
%
% This function enables to load SPEC scan data
%
% MZ 8.3.95
% DFM 30.9.95
% EF 4.9.97

data=[]; datastr=''; com = ''; head = '';

if ~exist('scan') scan=[]; end
if isempty(scan)
    scan=1;
    disp('Warning : SPECdata : no scan number precised : using scan #1');
end

%---- Read through data file to find right scan number (uses ffind mex file)
fpos=ffind(filename,['#S ' num2str(scan) ' ']);
if fpos<0
    errordlg(['Scan ' num2str(scan) ' not found'],'Spec data load error:')
    return
end

fid=fopen(filename);
for i=1:length(fpos)
    fseek(fid,fpos(i),'bof');
    com=fgets(fid); % This line contains the scan command issued
    
    %---- Read column headers ---------------------------------
    t='zz';
    while strcmp(t,'#L') == 0
        r=fgetl(fid);
        if (length(r) > 1) t=r(1:2); end
    end
    head=['  ' r(4:max(size(r))) '  '];
    
    %-----Read data -------------------------------------------
    data=[];
    r=fgets(fid);
    while (max(size(r))>2 & r(1)~='#')
        a=sscanf(r,'%g');
        data=[data ; a'];
        r=fgets(fid);
    end
    fclose(fid);
    
    %----- Write column headers to a matrix -----------------------
    
    K=findstr(head,'  ');
    datastr=[];
    for i=1:length(K)-1
        datastr=strvcat(datastr, fliplr(deblank(fliplr(deblank(head(1,K(i)+1:K(i+1)-1))))));
    end
end

end