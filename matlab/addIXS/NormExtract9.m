function data=NormExtract9(datafile,run_number)

% FUNCTION NormExtract9 converts a SPEC file into ascii files with the 
% correct format ready for summation . It takes as inputs a string defining
% the SPEC file which contains the data, and a number defining the run 
% which is to be extracted.
%
% ACWalters 20/11/09

% Example function call:
% runs=[4 6 8:17 23 69:70 82:84 87 210 212 223 227:229];
% data=NormExtract9('C:\Walters\GICs\ID28_Jul09\CaC6_ID28_July09\datafiles\CaC6_1',runs);
% data=NormExtract9('C:\Walters\GICs\ID28_Jul09\CaC6_ID28_July09\datafiles\CaC6_1',4);

% Extraction of all SPEC data using spec1d function
[alldata, datastr, com, head]=specdata(datafile,run_number);

% Reduction of alldata is done, as much of the information in the original
% SPEC file is unnecessary. Columns are selected as necessary.
for i=1:size(datastr,1)
    % Take I0
    if isequal(strtrim(datastr(i,:)),'izero EH1')
        data(:,1)=alldata(:,i);
    end
    % Take I1
    if isequal(strtrim(datastr(i,:)),'ione')
        data(:,2)=alldata(:,i);
    end
    % Take mono resistance and convert into temperature
    if isequal(strtrim(datastr(i,:)),'prem_ad5')
        data(:,3)=resistance2temp(alldata(:,i));
        T_mono = data(:,3);
    end
    % Take A1 resistance and convert into temperature
    if isequal(strtrim(datastr(i,:)),'prem_ad6')
        T_anal(:,1) = resistance2temp(alldata(:,i));
    end
    % Take A2 resistance and convert into temperature
    if isequal(strtrim(datastr(i,:)),'prem_ad7')
        T_anal(:,2) = resistance2temp(alldata(:,i));
    end
    % Take A3 resistance and convert into temperature
    if isequal(strtrim(datastr(i,:)),'prem_ad8')
        T_anal(:,3) = resistance2temp(alldata(:,i));
    end
    % Take A4 resistance and convert into temperature
    if isequal(strtrim(datastr(i,:)),'prem_ad9')
        T_anal(:,4) = resistance2temp(alldata(:,i));
    end
    % Take A5 resistance and convert into temperature
    if isequal(strtrim(datastr(i,:)),'prem_ad10')
        T_anal(:,5) = resistance2temp(alldata(:,i));
    end
    % Take A6 resistance and convert into temperature
    if isequal(strtrim(datastr(i,:)),'prema_ad13')
        T_anal(:,6) = resistance2temp(alldata(:,i));
    end
    % Take A7 resistance and convert into temperature
    if isequal(strtrim(datastr(i,:)),'prem_ad12')
        T_anal(:,7) = resistance2temp(alldata(:,i));
    end
    % Take A8 resistance and convert into temperature
    if isequal(strtrim(datastr(i,:)),'prema_ad14')
        T_anal(:,8) = resistance2temp(alldata(:,i));
    end
    % Take A9 resistance and convert into temperature
    if isequal(strtrim(datastr(i,:)),'prem_ad15')
        T_anal(:,9) = resistance2temp(alldata(:,i));
    end
    % Take A1 intensity
    if isequal(strtrim(datastr(i,:)),'deta1')
        data(:,13)=alldata(:,i);
    end
    % Take A2 intensity
    if isequal(strtrim(datastr(i,:)),'deta2')
        data(:,14)=alldata(:,i);
    end
    % Take A3 intensity
    if isequal(strtrim(datastr(i,:)),'deta3')
        data(:,15)=alldata(:,i);
    end
    % Take A4 intensity
    if isequal(strtrim(datastr(i,:)),'deta4')
        data(:,16)=alldata(:,i);
    end
    % Take A5 intensity
    if isequal(strtrim(datastr(i,:)),'deta5')
        data(:,17)=alldata(:,i);
    end
    % Take A6 intensity
    if isequal(strtrim(datastr(i,:)),'deta6')
        data(:,18)=alldata(:,i);
    end
    % Take A7 intensity
    if isequal(strtrim(datastr(i,:)),'deta7')
        data(:,19)=alldata(:,i);
    end
    % Take A8 intensity
    if isequal(strtrim(datastr(i,:)),'deta8')
        data(:,20)=alldata(:,i);
    end
    % Take A9 intensity
    if isequal(strtrim(datastr(i,:)),'deta9')
        data(:,21)=alldata(:,i);
    end
    % Take detsq
    if isequal(strtrim(datastr(i,:)),'detsq')
        data(:,22)=alldata(:,i);
    end
    % Take imirr
    if isequal(strtrim(datastr(i,:)),'Imirr')
        data(:,23)=alldata(:,i);
    end
end

% Subtract temperature of the analysers from the temperature of the
% monochromator, and put in output variable data
data(:,4:12) = T_anal - repmat(T_mono,1,9);