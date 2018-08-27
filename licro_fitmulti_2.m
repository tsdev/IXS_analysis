%% ID28 logbook for LiCrO2

% switch on spec1d
s1d on
datf = '~/Documents/structures/LiCrO2/ID28/data/combined';
addpath(genpath('/Users/tothsa/Documents/structures/LiCrO2/ID28/matlab'))

cd(datf)
addpath('../../matlab')
col = 'rgbmcykrgbk';
detOrder = [1 6 2 7 3 8 4 9 5];

Icorr = [2.024 1.285 1.1359 1 1.2547 2.6693 3.0843 1.5445 1.916];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% FITTING
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% incident and scattered beam vectors
lambda = 0.6968; % Angstrom
% order of detectors
anai  = [1 6 2 7 3 8 4 9 5];

% scale with lattice parameters
licro = spinw('~/Documents/structures/LiCrO2/LiCrO2.cif');

% resolution parameters:
load('res0.mat')
pvals = zeros(0,20);
evals = zeros(0,20);
Qlist = [];

% lattice parameter calibration for low temperature
tth006 = 16.77;
Q006   = 4*pi/lambda*sind(tth006/2);
tth110 = 27.868;
Q110   = 4*pi/lambda*sind(tth110/2);
a = licro.abc(1)*norm([1 1 0]*licro.rl)/Q110;
c = licro.abc(3)*norm([0 0 6]*licro.rl)/Q006;
licro.lattice.lat_const = [a a c];
Q110 = norm([1 1 0]*licro.rl);
Q001 = norm([0 0 1]*licro.rl);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% fit Q = (1.16,1.16,0)+D scans at 5 K

q1 = 7/6;
% scattering angle
tth = 2*asind(norm([q1 q1 0]*licro.rl)*lambda/4/pi);

% experimental scattering angle
%tth = 32.5601;
% momentum transfer in A^-1
Q = ID28_momentum(tth,lambda);
Qp = bsxfun(@rdivide,Q',[Q110 Q001 1]);
Qp = Qp(:,[1 1 2])';

% Q values in rlu
Qp = Qp(:,anai);

T   = 5;
Q   = 1.16;
detId = 1:9;
dat0 = ID28_importtxt(T,Q,detId,Icorr);
dat = dat0(anai);

peak0      = [];
peak0(1,:) = [20 2e-3 0.1, 30 2e-3 0.1,0 0 0,0 0 0];
peak0(2,:) = [18 2e-3 2.0, 35 2e-3 2.0,0 0 0,0 0 0];
peak0(3,:) = [18 2e-3 2.0, 35 2e-3 2.0,0 0 0,0 0 0];
peak0(4,:) = [18 2e-3 2.0, 35 2e-3 2.0,0 0 0,0 0 0];
peak0(5,:) = [18 2e-3 2.0, 35 2e-3 2.0,0 0 0,0 0 0];
peak0(6,:) = [18 2e-3 2.0, 40 2e-3 2.0,45 2e-3 2.0,0 0 0];
peak0(7,:) = [38 2e-3 2.0, 45 2e-3 2.0,0 0 0,0 0 0];
peak0(8,:) = [40 2e-3 2.0, 45 2e-3 2.0,0 0 0, 0 0 0];
peak0(9,:) = [40 2e-3 2.0, 45 2e-3 2.0,0 0 0,0 0 0];

% peak labels
lab0 = cell(1,size(peak0,2));
for ii = 1:size(peak0,2)/3
    lab0(3*(ii-1)+(1:3)) = cellfun(@(C)num2str(ii,[C '%d']),{'x' 'A' 'wL'},'uniformoutput',false);
end
lab0 = {'x0' 'mu' 'wG' 'wL' 'A0' 'wL0' lab0{:} 'T' 'BKG1'}; %#ok<CCAT>

clear fitRes datfit0

for ii = 1:numel(detId)
    % [x0 mu wG wL | A0 wL0 | x1 A1 wL1 | ... xN AN wLN T BKG1]
    pin0 = peak0(ii,:)>0;
    [datfit0(ii), fitRes(ii)] = fits(dat(ii),'ID28_specfun2',...
        [0 res0(ii,:), 1e-3 0, peak0(ii,:),  T, 0 ],[1 0 0 0, 1 1, pin0 0 1]); %#ok<SAGROW>
end

% add to previous fits
[pvals, evals] = addfit(fitRes,dat(ii),pvals,evals);

Qlist = [Qlist Qp];
%datf  = [datf datfit0];
datf = datfit0;
%plotfit0

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% fit Q = (1.25,1.25,0)+D scans at 5 K

q1 = 1.25;
% scattering angle
tth = 2*asind(norm([q1 q1 0]*licro.rl)*lambda/4/pi);

% experimental scattering angle
%tth = 34.9569;
% momentum transfer in A^-1
Q = ID28_momentum(tth,lambda);
Qp = bsxfun(@rdivide,Q',[Q110 Q001 1]);
Qp = Qp(:,[1 1 2])';

% experimental values
% #   1.1957  1.2500  1.3040  1.3580  1.4113  1.2222  1.2772  1.3302  1.3836
% #   1.1986  1.2500  1.3009  1.3514  1.4010  1.2237  1.2756  1.3254  1.3753
% #  -0.1576 -0.0000  0.1715  0.3579  0.5568 -0.0826  0.0845  0.2599  0.4518
% calculated values
% #   1.1973  1.2500  1.3026  1.3545  1.4058  1.2230  1.2759  1.3279  1.3792
% #   1.1973  1.2500  1.3026  1.3545  1.4058  1.2230  1.2759  1.3279  1.3792
% #  -0.1574  0.0000  0.1723  0.3573  0.5558 -0.0824  0.0827  0.2607  0.4509

for ii = 1:3
    fprintf('%% # ');
    fprintf('%8.4f',Qp(ii,:));
    fprintf('\n');
end

% Q values in rlu
Qp = Qp(:,anai);

T   = 5;
Q   = 1.25;
detId = 1:9;
dat0 = ID28_importtxt(T,Q,detId,Icorr);
dat = dat0(anai);

peak0      = [];
peak0(1,:) = [20 2e-3 0.1, 40 2e-3 0.1, 60 2e-3 0.1, 70 2e-3 0.1];
peak0(2,:) = [20 2e-3 0.1, 40 2e-3 0.1, 63 2e-3 0.1, 67 2e-3 0.1];
peak0(3,:) = [15 2e-3 0.1, 40 2e-3 0.1, 65 2e-3 0.1,  0 0    0  ];
peak0(4,:) = [ 0 0e-3 0.0, 40 2e-3 0.1, 47 2e-3 1.0, 65 2e-3 0.1];
peak0(5,:) = [40 2e-3 0.1, 47 2e-3 1.0, 65 2e-3 0.1, 72 2e-3 0.1];
peak0(6,:) = [40 2e-3 0.1, 46 2e-3 1.0, 65 2e-3 0.1, 72 2e-3 0.1];
peak0(7,:) = [40 2e-3 0.1, 44 2e-3 1.0, 65 2e-3 0.1, 72 2e-3 0.1];
peak0(8,:) = [36 2e-3 0.1, 43 2e-3 1.0, 65 2e-3 0.1, 0 0 0];
peak0(9,:) = [36 2e-3 0.1, 40 2e-3 1.0, 65 2e-3 0.1, 0 0 0];

clear fitRes datfit0

for ii = 1:numel(detId)
    % [x0 mu wG wL | A0 wL0 | x1 A1 wL1 | ... xN AN wLN T BKG1]
    pin0 = peak0(ii,:)>0;
    [datfit0(ii), fitRes(ii)] = fits(dat(ii),'ID28_specfun2',...
        [0 res0(ii,:), 1e-3 0, peak0(ii,:),  T, 0 ],[1 0 0 0, 1 1, pin0 0 1]); %#ok<SAGROW>
end

% add to previous fits
[pvals, evals] = addfit(fitRes,dat(ii),pvals,evals);

Qlist = [Qlist Qp];
datf  = [datf datfit0];

% plotfit0

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% fit Q = (1.083,1.083,0)+D scans at 5 K

q1 = 1.083;
% scattering angle
tth = 2*asind(norm([q1 q1 0]*licro.rl)*lambda/4/pi);

% experimental scattering angle
%tth = 34.9569;
% momentum transfer in A^-1
Q = ID28_momentum(tth,lambda);
Qp = bsxfun(@rdivide,Q',[Q110 Q001 1]);
Qp = Qp(:,[1 1 2])';

% experimental values
% #   1.0283  1.0830  1.1374  1.1919  1.2456  1.0550  1.1104  1.1638  1.2177
% #   1.0307  1.0830  1.1348  1.1864  1.2371  1.0562  1.1091  1.1598  1.2108
% #  -0.1356  0.0000  0.1496  0.3142  0.4917 -0.0713  0.0734  0.2275  0.3977
% calculated values
% #   1.0296  1.0830  1.1363  1.1889  1.2410  1.0557  1.1092  1.1620  1.2140
% #   1.0296  1.0830  1.1363  1.1889  1.2410  1.0557  1.1092  1.1620  1.2140
% #  -0.1353  0.0000  0.1503  0.3136  0.4906 -0.0711  0.0719  0.2281  0.3969

for ii = 1:3
    fprintf('%% # ');
    fprintf('%8.4f',Qp(ii,:));
    fprintf('\n');
end

% Q values in rlu
Qp = Qp(:,anai);

T   = 5;
Q   = 1.08;
detId = 1:9;
dat0 = ID28_importtxt(T,Q,detId,Icorr);
dat = dat0(anai);

peak0      = [];
peak0(1,:) = [ 5 2e-3 0.1,  0 0 0,       0 0    0  ,0 0 0];
peak0(2,:) = [ 0 0e-3 0.0, 12 2e-3 0.1, 16 2e-3 0.1,0 0 0];
peak0(3,:) = [ 0 0e-3 0.0, 16 2e-3 0.1, 23 2e-3 0.1,0 0 0];
peak0(4,:) = [20 2e-3 0.1, 30 2e-3 0.1,  0 0    0  ,0 0 0];
peak0(5,:) = [ 0 0e-3 0.1, 20 2e-3 0.1, 30 2e-3 0.1,0 0 0];
peak0(6,:) = [ 0 0e-3 0,   20 2e-3 0.1, 30 2e-3 0.1,0 0 0];
peak0(7,:) = [ 0 0e-3 0,   20 2e-3 0.1, 30 2e-3 0.1,0 0 0];
peak0(8,:) = [ 0 0e-3 0,   20 2e-3 0.1, 30 2e-3 0.1,0 0 0];
peak0(9,:) = [ 0 0e-3 0,   20 2e-3 0.1, 38 2e-3 0.1,0 0 0];

clear fitRes datfit0

for ii = 1:numel(detId)
    % [x0 mu wG wL | A0 wL0 | x1 A1 wL1 | ... xN AN wLN T BKG1]
    pin0 = peak0(ii,:)>0;
    [datfit0(ii), fitRes(ii)] = fits(dat(ii),'ID28_specfun2',...
        [0 res0(ii,:), 1e-3 0, peak0(ii,:),  T, 0],[1 0 0 0, 1 1, pin0 0 0]); %#ok<SAGROW>
end

% add to previous fits
[pvals, evals] = addfit(fitRes,dat(ii),pvals,evals);

Qlist = [Qlist Qp];
datf  = [datf datfit0];

%plotfit0

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% fit Q = (1.5,1.5,0)+D scans at 5 K

q1 = 1.5;
% scattering angle
tth = 2*asind(norm([q1 q1 0]*licro.rl)*lambda/4/pi);

% experimental scattering angle
%tth = 34.9569;
% momentum transfer in A^-1
Q = ID28_momentum(tth,lambda);
Qp = bsxfun(@rdivide,Q',[Q110 Q001 1]);
Qp = Qp(:,[1 1 2])';

% experimental values
% #   1.4463  1.5000  1.5533  1.6065  1.6588  1.4725  1.5268  1.5791  1.6317
% #   1.4502  1.5000  1.5492  1.5980  1.6457  1.4745  1.5248  1.5729  1.6210
% #  -0.1906  0.0000  0.2042  0.4232  0.6541 -0.0995  0.1009  0.3084  0.5325
% calculated values
% #   1.4484  1.5000  1.5514  1.6020  1.6519  1.4736  1.5253  1.5761  1.6260
% #   1.4484  1.5000  1.5514  1.6020  1.6519  1.4736  1.5253  1.5761  1.6260
% #  -0.1904 -0.0000  0.2052  0.4226  0.6531 -0.0993  0.0989  0.3094  0.5316

% Q values in rlu
Qp = Qp(:,anai);

T   = 5;
Q   = 1.5;
detId = 1:9;
dat0 = ID28_importtxt(T,Q,detId,Icorr);
dat = dat0(anai);

peak0      = [];
peak0(1,:) = [12 2e-3 0.1, 34 2e-3 0.1, 38 2e-3 0.1, 60 2e-3 0.1];
peak0(2,:) = [10 2e-3 0.1, 35 2e-3 0.1, 60 2e-3 0.1,  0 0e-3 0.0];
peak0(3,:) = [12 2e-3 0.1, 38 2e-3 0.1, 60 2e-3 0.1,  0 0e-3 0.0];
peak0(4,:) = [12 2e-3 0.1, 38 2e-3 0.1, 60 2e-3 0.1,  0 0e-3 0.0];
peak0(5,:) = [12 2e-3 0.1, 38 2e-3 0.1, 60 2e-3 0.1,  0 0e-3 0.0];
peak0(6,:) = [12 2e-3 0.1, 38 2e-3 0.1, 60 2e-3 0.1,  0 0e-3 0.0];
peak0(7,:) = [12 2e-3 0.1, 38 2e-3 0.1, 60 2e-3 0.1,  0 0e-3 0.0];
peak0(8,:) = [40 2e-3 0.1, 44 2e-3 1.0, 60 2e-3 0.1,  0 0e-3 0.0];
peak0(9,:) = [40 2e-3 0.1, 45 2e-3 1.0, 60 2e-3 0.1, 72 1e-3 0.0];

clear fitRes datfit0

for ii = 1:numel(detId)
    % [x0 mu wG wL | A0 wL0 | x1 A1 wL1 | ... xN AN wLN T BKG1]
    pin0 = peak0(ii,:)>0;
    [datfit0(ii), fitRes(ii)] = fits(dat(ii),'ID28_specfun2',...
        [0 res0(ii,:), 1e-3 0, peak0(ii,:),  T, 0],[1 0 0 0, 1 1, pin0 0 0]); %#ok<SAGROW>
end

% add to previous fits
[pvals, evals] = addfit(fitRes,dat(ii),pvals,evals);

Qlist = [Qlist Qp];
datf  = [datf datfit0];

%plotfit0


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% fit Q = (1.375,1.375,0)+D scans at 5 K

q1 = 1.375;
% scattering angle
tth = 2*asind(norm([q1 q1 0]*licro.rl)*lambda/4/pi);

% experimental scattering angle
%tth = 34.9569;
% momentum transfer in A^-1
Q = ID28_momentum(tth,lambda);
Qp = bsxfun(@rdivide,Q',[Q110 Q001 1]);
Qp = Qp(:,[1 1 2])';

% experimental values
% #   1.3210  1.3750  1.4287  1.4823  1.5351  1.3473  1.4020  1.4546  1.5077
% #   1.3243  1.3750  1.4251  1.4748  1.5235  1.3491  1.4002  1.4492  1.4983
% #  -0.1741  0.0000  0.1878  0.3906  0.6055 -0.0911  0.0927  0.2842  0.4921
% calculated values
% #   1.3228  1.3750  1.4271  1.4783  1.5289  1.3483  1.4006  1.4521  1.5027
% #   1.3228  1.3750  1.4271  1.4783  1.5289  1.3483  1.4006  1.4521  1.5027
% #  -0.1739 -0.0000  0.1888  0.3899  0.6045 -0.0908  0.0908  0.2850  0.4913

for ii = 1:3
    fprintf('%% # ');
    fprintf('%8.4f',Qp(ii,:));
    fprintf('\n');
end

% Q values in rlu
Qp = Qp(:,anai);

T   = 5;
Q   = 1.38;
detId = 1:9;
dat0 = ID28_importtxt(T,Q,detId,Icorr);
dat = dat0(anai);

peak0      = [];
peak0(1,:) = [ 0 0e-3 0,  0 0e-3 0.0,  0 0e-3 0.0,  0 0e-3 0.0];
peak0(2,:) = [ 0 0e-3 0,  0 0e-3 0.0,  0 0e-3 0.0,  0 0e-3 0.0];
peak0(3,:) = [ 0 0e-3 0,  0 0e-3 0.0,  0 0e-3 0.0,  0 0e-3 0.0];
peak0(4,:) = [ 0 0e-3 0,  0 0e-3 0.0,  0 0e-3 0.0,  0 0e-3 0.0];
peak0(5,:) = [ 0 0e-3 5, 12 1e-3 0.0,  0 0e-3 0.0,  0 0e-3 0.0];
peak0(6,:) = [ 0 0e-3 0, 12 1e-3 0.0,  0 0e-3 0.0,  0 0e-3 0.0];
peak0(7,:) = [ 0 0e-3 0, 11 1e-3 1.0,  0 0e-3 0.0,  0 0e-3 0.0];
peak0(8,:) = [10 1e-3 1,  0 0e-3 0.0,  0 0e-3 0.0,  0 0e-3 0.0];
peak0(9,:) = [ 7 1e-3 5,  0 0e-3 0.0,  0 0e-3 0.0,  0 0e-3 0.0];

clear fitRes datfit0

for ii = 1:numel(detId)
    % [x0 mu wG wL | A0 wL0 | x1 A1 wL1 | ... xN AN wLN T BKG1]
    pin0 = peak0(ii,:)>0;
    [datfit0(ii), fitRes(ii)] = fits(cut(dat(ii),[-inf 18]),'ID28_specfun2',...
        [0 res0(ii,:), 1e-3 0, peak0(ii,:),  T, 0],[1 0 0 0, 1 1, pin0 0 0]); %#ok<SAGROW>
end

% add to previous fits
[pvals, evals] = addfit(fitRes,dat(ii),pvals,evals);

Qlist = [Qlist Qp];
datf  = [datf datfit0];

%plotfit0

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% fit Q = (1.333,1.333,0)+D scans at 5 K

% experimental values
% #   1.2792  1.3333  1.3871  1.4408  1.4938  1.3056  1.3604  1.4131  1.4663
% #   1.2824  1.3333  1.3836  1.4337  1.4827  1.3072  1.3587  1.4079  1.4573
% #  -0.1686 -0.0000  0.1824  0.3797  0.5893 -0.0882  0.0899  0.2761  0.4787
% calculated values
% #   1.2809  1.3333  1.3856  1.4370  1.4879  1.3065  1.3590  1.4107  1.4615
% #   1.2809  1.3333  1.3856  1.4370  1.4879  1.3065  1.3590  1.4107  1.4615
% #  -0.1684  0.0000  0.1833  0.3791  0.5882 -0.0880  0.0881  0.2769  0.4778

q1 = 4/3;
% scattering angle
tth = 2*asind(norm([q1 q1 0]*licro.rl)*lambda/4/pi);

% experimental scattering angle
%tth = 37.3697;
% momentum transfer in A^-1
Q = ID28_momentum(tth,lambda);
Qp = bsxfun(@rdivide,Q',[Q110 Q001 1]);
Qp = Qp(:,[1 1 2])';

% Q values in rlu
Qp = Qp(:,anai);

T   = 5;
Q   = 1.33;
detId = 1:9;
dat0 = ID28_importtxt(T,Q,detId,Icorr);
dat = dat0(anai);

peak0      = [];
peak0(1,:) = [ 0 0e-3 0.0, 41 2e-3 0.1, 46 1e-3 0.2,  0 0e-3 0.0];
peak0(2,:) = [40 2e-3 0.1, 47 1e-3 0.2,  0 0e-3 0.0,  0 0e-3 0.0];
peak0(3,:) = [40 2e-3 0.1, 48 1e-3 0.2,  0 0e-3 0.0,  0 0e-3 0.0];
peak0(4,:) = [40 2e-3 0.1, 48 1e-3 0.2,  0 0e-3 0.0,  0 0e-3 0.0];
peak0(5,:) = [35 2e-3 0.1, 42 1e-3 0.2, 60 1e-3 0.0,  0 0e-3 0.0];
peak0(6,:) = [35 2e-3 0.1, 43 1e-3 0.2,  0 0e-3 0.0,  0 0e-3 0.0];
peak0(7,:) = [33 2e-3 0.1, 38 1e-3 0.5, 10 1e-3 3.0, 60 1e-3 0.0];
peak0(8,:) = [33 2e-3 0.1, 60 1e-3 0.0, 10 1e-3 3.0,  0 0e-3 0.0];
peak0(9,:) = [33 2e-3 0.1, 60 1e-3 0.0, 10 1e-3 3.0,  0 0e-3 0.0];

clear fitRes datfit0

for ii = 1:numel(detId)
    % [x0 mu wG wL | A0 wL0 | x1 A1 wL1 | ... xN AN wLN T BKG1]
    pin0 = peak0(ii,:)>0;
    [datfit0(ii), fitRes(ii)] = fits(dat(ii),'ID28_specfun2',...
        [0 res0(ii,:), 1e-3 0, peak0(ii,:),  T, 0],[1 0 0 0, 1 1, pin0 0 0]); %#ok<SAGROW>
end

% add to previous fits
[pvals, evals] = addfit(fitRes,dat(ii),pvals,evals);

Qlist = [Qlist Qp];
datf  = [datf datfit0];

%plotfit0

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% fit Q = (1.2916,1.2916,0)+D scans at 5 K

% experimental values
% #   1.2374  1.2916  1.3455  1.3994  1.4525  1.2638  1.3187  1.3716  1.4249
% #   1.2404  1.2916  1.3422  1.3925  1.4418  1.2654  1.3171  1.3666  1.4163
% #  -0.1631  0.0000  0.1769  0.3688  0.5730 -0.0854  0.0872  0.2680  0.4652
% calculated values
% #   1.2390  1.2916  1.3441  1.3957  1.4468  1.2647  1.3174  1.3693  1.4203
% #   1.2390  1.2916  1.3441  1.3957  1.4468  1.2647  1.3174  1.3693  1.4203
% #  -0.1628 -0.0000  0.1778  0.3681  0.5720 -0.0852  0.0854  0.2688  0.4644

q1 = 1.2916;
% scattering angle
tth = 2*asind(norm([q1 q1 0]*licro.rl)*lambda/4/pi);

% experimental scattering angle
%tth = 34.9569;
% momentum transfer in A^-1
Q = ID28_momentum(tth,lambda);
Qp = bsxfun(@rdivide,Q',[Q110 Q001 1]);
Qp = Qp(:,[1 1 2])';

% Q values in rlu
Qp = Qp(:,anai);

T   = 5;
Q   = 1.29;
detId = 1:9;
dat0 = ID28_importtxt(T,Q,detId,Icorr);
dat = dat0(anai);

peak0      = [];
peak0(1,:) = [17 2e-3 0.0,  0 0e-3 0.0,  0 0e-3 0.0,  0 0e-3 0.0];
peak0(2,:) = [ 0 0e-3 0.0, 35 1e-3 3.0,  0 0e-3 0.0,  0 0e-3 0.0];
peak0(3,:) = [ 0 0e-3 0.0,  0 0e-3 0.0,  0 0e-3 0.0,  0 0e-3 0.0];
peak0(4,:) = [ 0 0e-3 0.0,  0 0e-3 0.0,  0 0e-3 0.0,  0 0e-3 0.0];
peak0(5,:) = [ 0 0e-3 0.0,  0 0e-3 0.0,  0 0e-3 0.0,  0 0e-3 0.0];
peak0(6,:) = [ 0 0e-3 0.0,  0 0e-3 0.0,  0 0e-3 0.0,  0 0e-3 0.0];
peak0(7,:) = [ 0 0e-3 0.0,  0 0e-3 0.0,  0 0e-3 0.0,  0 0e-3 0.0];
peak0(8,:) = [12 1e-3 2.0, 35 1e-3 0.0,  0 0e-3 0.0,  0 0e-3 0.0];
peak0(9,:) = [13 2e-3 2.0, 35 1e-3 0.0,  0 0e-3 0.0,  0 0e-3 0.0];

iList = size(peak0,1);

clear fitRes datfit0

for ii = 1:numel(detId)
    % [x0 mu wG wL | A0 wL0 | x1 A1 wL1 | ... xN AN wLN T BKG1]
    pin0 = peak0(ii,:)>0;
    [datfit0(ii), fitRes(ii)] = fits(dat(ii),'ID28_specfun2',...
        [0 res0(ii,:), 1e-3 0, peak0(ii,:),  T, 0],[1 0 0 0, 1 1, pin0 0 0]); %#ok<SAGROW>
end

% add to previous fits
[pvals, evals] = addfit(fitRes,dat(ii),pvals,evals);

Qlist = [Qlist Qp];
datf  = [datf datfit0];

%plotfit0

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% fit Q = (1.4167,1.4167,0)+D scans at 5 K

% experimental values
% #   1.3628  1.4167  1.4702  1.5237  1.5764  1.3891  1.4437  1.4962  1.5491
% #   1.3663  1.4167  1.4665  1.5159  1.5643  1.3909  1.4418  1.4905  1.5392
% #  -0.1796 -0.0000  0.1933  0.4015  0.6217 -0.0939  0.0954  0.2923  0.5056
% calculated values
% #   1.3647  1.4167  1.4686  1.5195  1.5700  1.3901  1.4422  1.4935  1.5438
% #   1.3647  1.4167  1.4686  1.5195  1.5700  1.3901  1.4422  1.4935  1.5438
% #  -0.1794 -0.0000  0.1943  0.4008  0.6207 -0.0936  0.0935  0.2932  0.5048

q1 = 1.4167;
% scattering angle
tth = 2*asind(norm([q1 q1 0]*licro.rl)*lambda/4/pi);

% experimental scattering angle
%tth = 39.8027;
% momentum transfer in A^-1
Q = ID28_momentum(tth,lambda);
Qp = bsxfun(@rdivide,Q',[Q110 Q001 1]);
Qp = Qp(:,[1 1 2])';

% Q values in rlu
Qp = Qp(:,anai);

T   = 5;
Q   = 1.42;
detId = 1:9;
dat0 = ID28_importtxt(T,Q,detId,Icorr);
dat = dat0(anai);

peak0      = [];
peak0(1,:) = [ 0 0e-3 0.0, 38 2e-3 0.1, 42 2e-3 0.1,  0 0e-3 0.0];
peak0(2,:) = [ 0 0e-3 0.0, 38 2e-3 0.1, 42 2e-3 0.1,  0 0e-3 0.0];
peak0(3,:) = [10 1e-3 3.0, 34 2e-3 0.1, 40 2e-3 0.1,  0 0e-3 0.0];
peak0(4,:) = [10 1e-3 3.0, 35 2e-3 0.1, 38 2e-3 0.1,  0 0e-3 0.0];
peak0(5,:) = [10 1e-3 3.0,  0 0e-3 0.0, 36 2e-3 0.1,  0 0e-3 0.0];
peak0(6,:) = [10 1e-3 3.0, 33 2e-3 0.1,  0 0e-3 0.0,  0 0e-3 0.0];
peak0(7,:) = [10 1e-3 3.0, 33 2e-3 0.1,  0 0e-3 0.0,  0 0e-3 0.0];
peak0(8,:) = [10 1e-3 3.0, 33 2e-3 0.1,  0 0e-3 0.0,  0 0e-3 0.0];
peak0(9,:) = [10 1e-3 3.0, 34 2e-3 0.1, 37 1e-3 0.1,  0 0e-3 0.0];

clear fitRes datfit0

for ii = 1:numel(detId)
    % [x0 mu wG wL | A0 wL0 | x1 A1 wL1 | ... xN AN wLN T BKG1]
    pin0 = peak0(ii,:)>0;
    [datfit0(ii), fitRes(ii)] = fits(dat(ii),'ID28_specfun2',...
        [0 res0(ii,:), 1e-3 0, peak0(ii,:),  T, 0],[1 0 0 0, 1 1, pin0 0 0]); %#ok<SAGROW>
end

% add to previous fits
[pvals, evals] = addfit(fitRes,dat(ii),pvals,evals);

Qlist = [Qlist Qp];
datf  = [datf datfit0];

%plotfit0

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% fit Q = (1.0417,1.0417,0)+D scans at 5 K

% experimental values
% #   0.9870  1.0417  1.0962  1.1507  1.2046  1.0136  1.0691  1.1226  1.1767
% #   0.9892  1.0417  1.0937  1.1456  1.1965  1.0148  1.0679  1.1189  1.1701
% #  -0.1301 -0.0000  0.1442  0.3034  0.4755 -0.0685  0.0707  0.2194  0.3843
% calculated values
% #   0.9882  1.0417  1.0952  1.1479  1.2002  1.0143  1.0680  1.1209  1.1731
% #   0.9882  1.0417  1.0952  1.1479  1.2002  1.0143  1.0680  1.1209  1.1731
% #  -0.1299 -0.0000  0.1449  0.3028  0.4745 -0.0683  0.0693  0.2200  0.3835

q1 = 1.0417;
% scattering angle
tth = 2*asind(norm([q1 q1 0]*licro.rl)*lambda/4/pi);

% experimental scattering angle
%tth = 28.9902;
% momentum transfer in A^-1
Q = ID28_momentum(tth,lambda);
Qp = bsxfun(@rdivide,Q',[Q110 Q001 1]);
Qp = Qp(:,[1 1 2])';

% Q values in rlu
Qp = Qp(:,anai);

T   = 5;
Q   = 1.04;
detId = 1:9;
dat0 = ID28_importtxt(T,Q,detId,Icorr);
dat = dat0(anai);

peak0      = [];
peak0(1,:) = [ 0 0e-3 0.0,  8 1e-1 0.0,  0 0e-3 0.0,  0 0e-3 0.0];
peak0(2,:) = [ 0 0e-3 0.0,  8 1e-2 2.0,  0 0e-3 0.0,  0 0e-3 0.0];
peak0(3,:) = [ 9 2e-3 0.1, 12 1e-3 0.1,  0 0e-3 0.0,  0 0e-3 0.0];
peak0(4,:) = [13 2e-3 0.1, 20 1e-3 0.1,  0 0e-3 0.0,  0 0e-3 0.0];
peak0(5,:) = [13 2e-3 0.1, 20 1e-3 0.1,  0 0e-3 0.0,  0 0e-3 0.0];
peak0(6,:) = [20 2e-3 0.1, 30 1e-3 0.1,  0 0e-3 0.0,  0 0e-3 0.0];
peak0(7,:) = [20 2e-3 0.1, 30 1e-3 0.1,  0 0e-3 0.0,  0 0e-3 0.0];
peak0(8,:) = [20 2e-3 0.1, 40 1e-3 0.1,  0 0e-3 0.0,  0 0e-3 0.0];
peak0(9,:) = [20 2e-3 0.1, 40 1e-3 0.1,  0 0e-3 0.0,  0 0e-3 0.0];

clear fitRes datfit0

for ii = 1:numel(detId)
    % [x0 mu wG wL | A0 wL0 | x1 A1 wL1 | ... xN AN wLN T BKG1]
    pin0 = peak0(ii,:)>0;
    [datfit0(ii), fitRes(ii)] = fits(dat(ii),'ID28_specfun2',...
        [0 res0(ii,:), 1e-3 0, peak0(ii,:),  T, 0],[1 0 0 0, 1 1, pin0 0 0]); %#ok<SAGROW>
end

% add to previous fits
[pvals, evals] = addfit(fitRes,dat(ii),pvals,evals);

Qlist = [Qlist Qp];
datf  = [datf datfit0];
deti  = repmat(1:9,[1 9]);
%plotfit0


%% plot color map for different temperatures

cd ~/Documents/structures/LiCrO2/ID28/data/combined
% subtract elastic line
sube = false;
% plot fit
pfit = false;
% scale plot
splot = false;

Tv = [5 40 60 80 300];
Tv = [5 60 300];
Tv = 5;

% load all data
qTrue = [1.1667, 1.25, 1.083, 1.5, 1.375, 1.3333, 1.2916, 1.4167, 1.0417];
qLoad = round(qTrue*100)/100;
qLoad(1) = 1.16;
% analysator index
anai  = [1 6 2 7 3 8 4 9 5];

% 5 K, load all detectors
detId = 1:9;

IcorrNew = Icorr;
multi = [1 1 1 1 1 1 1.3 2. 1.3671]*0+1;

for ii = 1:9
    IcorrNew(ii) = IcorrNew(ii)*multi(ii);
end

%IcorrNew(8) = IcorrNew(8)*1.6163;
%IcorrNew(9) = IcorrNew(9)*1.3671;

figure
for jj = 1:numel(Tv)
    %subplot(1,3,jj)
    T     = Tv(jj);
    dat   = [];
    Q     = [];
    
    for ii = 1:numel(qTrue)
        try
            q0 = qTrue(ii);
            % scattering angle
            tth = 2*asind(norm([q0 q0 0]*licro.rl)*lambda/4/pi);
            
            % momentum transfer in A^-1
            Q0 = ID28_momentum(tth,lambda);
            Qp = bsxfun(@rdivide,Q0',[Q110 Q001 1]);
            Qp = Qp(:,[1 1 2])';
            
            % Q values in rlu sorted
            Qp = Qp(:,anai);
            
            dat0 = ID28_importtxt(T,qLoad(ii),detId,IcorrNew);
            
            if isempty(dat)
                dat = dat0(anai);
                Q   = Qp;
            else
                dat = [dat dat0(anai)];
                Q   = [Q Qp];
            end
        end
    end
    
    % subtract elastic line
    if sube
        for ii = 1:numel(dat)
            [temp, eRes(ii)] = fits(dat(ii),'ID28_specfun2',[0 res0(mod(ii-1,9)+1,:), 1e-3 0, T, 0],[0 0 0 0, 1 1, 0 0]);
            temp = struct(temp);
            temp.y = temp.y-temp.yfit;
            dat(ii) = spec1d(temp);
            
        end
    end
    
    % sort momentum
    [Q(1,:),idx] = sort(Q(1,:));
    dat = dat(idx);
    if splot
        % scale intensity
        for ii = 1:numel(dat)
            dat(ii) = dat(ii).*iScale(ii);
        end
    end
    
    % surface plot
    hSurf = ndbase.cplot(dat,'x',Q(1,:),'npix',500,'scatter',false);
    caxis([0 1e-3])
    
    
    yMax = [];
    yMin = [];
    hold on
    % find upper contour
    for ii = 1:numel(dat)
        yMax(ii) = max(get(dat(ii),'x'));
        yMin(ii) = min(get(dat(ii),'x'));
    end
    if false
        plot(Q(1,:),yMax,'ko','markerfacecolor','r','markersize',3)
        plot(Q(1,:),yMin,'ko','markerfacecolor','g','markersize',3)
    end
    
    cut1(1) = min(Q(1,yMax>65));
    cut2 = max(yMax(Q(1,:)<cut1(1)));
    if ~isempty(cut2)
        % cut out unmeasured region
        sel1 = hSurf.XData<cut1(1) & hSurf.YData>cut2;
        hSurf.ZData(sel1) = nan;
    end
    title(sprintf('T = %d K',round(T)))
    axis([0.99 1.65 -5 70])
end

% title ''
% xlabel('(H,H,0) (r.l.u.)')
% ylabel('Energy Transfer (meV)')
% print('~/Documents/structures/LiCrO2/ID28/results/licro_alldet_5K.png','-dpng','-r300')
%title(sprintf('T = %d K',round(Tv)));
colormap(flipud(cm_inferno(500)))
axis([1 2 0 80])
caxis([0.3e-4 10e-4])
grid off
%line([4/3 4/3 nan 3/2 3/2],[0 100 nan 0 100],'color','k','linestyle','--')
line([3/2 3/2],[0 100],'color','k','linestyle','--')
xlabel('($h$,$h$,0) (r.l.u.)','interpreter','latex')
ylabel('Energy Transfer (meV)','interpreter','latex')
ax1 = gca;
title ''
set(gca,'layer','top')

ax2 = axes('Position',ax1.Position,'XAxisLocation','top','Color','none');
axis([1 2 0 80])
ax2.YTick = [];
ax2.XTick = [1 4/3 3/2 5/3 2];
ax2.XTickLabel = {'\Gamma' 'M' 'K''' 'M''' '\Gamma'''}';

% plot extracted width and position
if pfit
    axes(ax1)
    load ~/Documents/structures/LiCrO2/ID28/data/combined/fitRes
    pvalsP = pvals;
    pvalsP(pvalsP==0) = nan;
    %pvalsP(pvalsP==max(pvalsP(:)))=nan;
    %figure;
    hold on
    for ii = 7:3:18
        errorbar(Qlist(1,:),pvalsP(:,ii)',pvalsP(:,ii+2)','or')
        hold on
    end
end

line([1.5 1.5 nan 1 1 nan 4/3 4/3],[0 80 nan 0 80 nan 0 80],'color','k','LineStyle','--')

axis([1 2 0 80])

% xlabel('H in (H,H,L) (r.l.u.)')
% ylabel('Energy Transfer (meV)')
% grid on
% box on

%% line plots to compare

figure
sel1 = find(Q(1,:)<=1.5 & Q(1,:)>1.4);

for ii = sel1
    x = get(dat(ii),'x');
    y = get(dat(ii),'y');
    
    plot(x,y+0.02*Q(1,ii),'-')
    hold on
end
%axis([0 30 0.1 0.2])


%% extract the magnon energy and line width

load fitRes

magI = [];
magE = [];
magW = [];
magdW = [];
magdE = [];
magQ = [];

for ii = 1:size(pvals,1)
    % loop over Q list
    Q0 = Qlist(1,ii);
    E0 = pvals(ii,7:3:18);
    I0 = pvals(ii,8:3:19);
    W0 = pvals(ii,9:3:20);
    
    dE0 = evals(ii,7:3:18);
    dI0 = evals(ii,8:3:19);
    dW0 = evals(ii,9:3:20);
    
    dI0(E0==0) = [];
    dW0(E0==0) = [];
    dE0(E0==0) = [];
    
    I0(E0==0) = [];
    W0(E0==0) = [];
    E0(E0==0) = [];
    
    if min(E0) < 25
        magIdx = findmin(E0);
        magI(end+1) = I0(magIdx);
        magE(end+1) = E0(magIdx);
        magW(end+1) = W0(magIdx);
        magdE(end+1) = dE0(magIdx);
        magdW(end+1) = dW0(magIdx);
        magQ(end+1) = Q0;
    end
    
end

% sort Q
[~,idx] = sort(magQ);
magE = magE(idx);
magW = magW(idx);
magdE = magdE(idx);
magdW = magdW(idx);
magQ = magQ(idx);


%figure
clf
subplot(2,1,1)
errorbar(magQ,magE,magdE,'o');
axis([1 1.65 0 25])
xlabel('(H,H,0) (r.l.u.)')
ylabel('\epsilon_k (meV)')
subplot(2,1,2)
errorbar(magQ,magW,magdW,'o');
axis([1 1.65 -2 6])
line([1 2],[0 0],'color','k','linestyle','--')
xlabel('(H,H,0) (r.l.u.)')
ylabel('\Gamma_k (meV)')

%% check elastic line amplitude

A0  = pvals(:,5);
dA0 = evals(:,5);

[Q0,idx] = sort(Qlist(1,:));
A0   = A0(idx);
dA0  = dA0(idx);
deti = repmat(1:9,[1 9]);
deti = deti(idx);


%figure
clf
for ii = 1:9
    sel1 = deti == ii;
    %errorbar(Q0(sel),A0(sel),dA0(sel),'o');
    semilogy(Q0(sel1),A0(sel1),'o');
    hold on
end
axis([0.9 1.7 0 0.25])
% fit intensity

elastic = struct;
elastic.x = Q0';
elastic.y = A0;
elastic.e = dA0;
elastic = spec1d(elastic);

[eFit, fitResE] = fits(elastic,'fitfun.pvoigt',[1 1e-1 0.5 0.01 1.2],[0 1 1 1 1]);
clf
plot(eFit,'semilogy',0)

% rescale factor for intensity
eFit = struct(eFit);
iScale = eFit.yfit./eFit.y;

%% change to log(z)

C = hSurf.CData;
C(C<0) = 0;
C = log(C);
hSurf.CData = C;
caxis([-10 -2])

%% plot the measured Q points

clf
plot(Q(1,:),Q(3,:),'ko','MarkerFaceColor','r')
axis([0.95 1.7 -0.4 0.8])
grid on
xlabel('(H,H,0) (r.l.u.)')
ylabel('(0,0,L) (r.l.u.)')
legend('Measured Q point','Location','nw')


%% load all data for fitting

cd ~/Documents/structures/LiCrO2/ID28/data/combined

% temperature
T = 5; % [5 40 60 80 300]

% scale with lattice parameters
licro = spinw('~/Documents/structures/LiCrO2/LiCrO2.cif');
% incident and scattered beam vectors
lambda = 0.6968; % Angstrom

% lattice parameter calibration for low temperature
tth006 = 16.77;
Q006   = 4*pi/lambda*sind(tth006/2);
tth110 = 27.868;
Q110   = 4*pi/lambda*sind(tth110/2);
a = licro.abc(1)*norm([1 1 0]*licro.rl)/Q110;
c = licro.abc(3)*norm([0 0 6]*licro.rl)/Q006;
licro.lattice.lat_const = [a a c];
Q110 = norm([1 1 0]*licro.rl);
Q001 = norm([0 0 1]*licro.rl);

% load all data
qTrue = [1.1667, 1.25, 1.083, 1.5, 1.375, 1.3333, 1.2916, 1.4167, 1.0417];
qLoad = round(qTrue*100)/100;
qLoad(1) = 1.16;

% analyser index
anai  = [1 6 2 7 3 8 4 9 5];

% load all detectors
detId = 1:9;


dat   = [];
Q     = [];

IcorrNew = Icorr;
% IcorrNew(8) = IcorrNew(8)*1.6163;
% IcorrNew(9) = IcorrNew(9)*1.3671;

for ii = 1:numel(qTrue)
    try
        q0 = qTrue(ii);
        % scattering angle
        tth = 2*asind(norm([q0 q0 0]*licro.rl)*lambda/4/pi);
        
        % momentum transfer in A^-1
        Q0 = ID28_momentum(tth,lambda);
        Qp = bsxfun(@rdivide,Q0',[Q110 Q001 1]);
        Qp = Qp(:,[1 1 2])';
        
        % Q values in rlu sorted
        %Qp = Qp(:,anai);
        
        dat0 = ID28_importtxt(T,qLoad(ii),detId,IcorrNew);
        
        if isempty(dat)
            %dat = dat0(anai);
            dat = dat0;
            Q   = Qp;
        else
            %dat = [dat dat0(anai)]; %#ok<AGROW>
            dat = [dat dat0]; %#ok<AGROW>
            Q   = [Q Qp]; %#ok<AGROW>
        end
    end
end

% sort momentum
[~,idx] = sort(Q(1,:));
Q = Q(:,idx);
% sort data
dat = dat(idx);
% sort detector index
%deti = repmat(1:9,1,numel(dat)/9);
%deti = deti(idx);


%deti = repmat(anai,1,numel(dat)/9);
deti = repmat(1:9,1,numel(dat)/9);
deti = deti(idx);


%% fit data

clc

if exist('datfit','var')
    datfit = datfit(1);
    fitRes = fitRes(1);
end

pvals = nan(23,numel(dat));
evals = nan(23,numel(dat));

% empty starting parameter list
peak0      = zeros(numel(dat),15);
peak0( 1,:) = [ 3 1e-3 0.5,  0 0e-3 0.0,  0 0e-4 0.0,  0 0e-4 0.0,  0 0e-4 0.0];
peak0( 2,:) = [ 3 1e-3 0.5,  0 0e-3 0.0,  0 0e-4 0.0,  0 0e-4 0.0,  0 0e-4 0.0];
peak0( 3,:) = [ 5 1e-3 0.5,  9 1e-3 0.5,  0 0e-4 0.0,  0 0e-4 0.0,  0 0e-4 0.0];
peak0( 4,:) = [ 8 1e-3 0.5, 12 1e-3 0.5,  0 0e-4 0.0,  0 0e-4 0.0,  0 0e-4 0.0];
peak0( 5,:) = [12 1e-3 0.5, 16 1e-3 0.5,  0 0e-4 0.0,  0 0e-4 0.0,  0 0e-4 0.0];
peak0( 6,:) = [17 1e-3 0.5, 20 1e-3 0.5,  0 0e-4 0.0,  0 0e-4 0.0,  0 0e-4 0.0];
peak0( 7,:) = [17 1e-3 0.5, 22 1e-3 0.5,  0 0e-4 0.0,  0 0e-4 0.0,  0 0e-4 0.0];
peak0( 8,:) = [18 1e-3 0.5, 25 1e-3 0.5,  0 0e-4 0.0,  0 0e-4 0.0,  0 0e-4 0.0];
peak0( 9,:) = [20 1e-3 0.5, 30 1e-3 0.5,  0 0e-4 0.0,  0 0e-4 0.0,  0 0e-4 0.0];
peak0(10,:) = [20 1e-3 0.5, 30 1e-3 0.5,  0 0e-4 0.0,  0 0e-4 0.0,  0 0e-4 0.0];
peak0(11,:) = [20 1e-3 0.5, 32 1e-3 0.5,  0 0e-4 0.0,  0 0e-4 0.0,  0 0e-4 0.0];
peak0(12,:) = [20 2e-4 0.5, 35 5e-4 0.5,  0 0e-4 0.0,  0 0e-4 0.0,  0 0e-4 0.0];
peak0(13,:) = [20 2e-4 0.5, 39 5e-4 0.5,  0 0e-4 0.0,  0 0e-4 0.0,  0 0e-4 0.0];
peak0(14,:) = [20 2e-4 0.5, 39 5e-4 0.5,  0 0e-4 0.0,  0 0e-4 0.0,  0 0e-4 0.0];
peak0(15,:) = [21 2e-4 0.5, 37 5e-4 0.5,  0 0e-4 0.0,  0 0e-4 0.0,  0 0e-4 0.0];
peak0(16,:) = [21 2e-4 0.5, 37 5e-4 0.5,  0 0e-4 0.0,  0 0e-4 0.0,  0 0e-4 0.0];
peak0(17,:) = [20 2e-4 0.5, 39 5e-4 0.5,  0 0e-4 0.0,  0 0e-4 0.0,  0 0e-4 0.0];
peak0(18,:) = [20 2e-4 0.5, 40 5e-4 0.5,  0 0e-4 0.0,  0 0e-4 0.0,  0 0e-4 0.0];
peak0(19,:) = [20 2e-4 0.5, 40 5e-4 0.5,  0 0e-4 0.0,  0 0e-4 0.0,  0 0e-4 0.0];
peak0(20,:) = [20 2e-4 0.5, 40 5e-4 0.5,  0 0e-4 0.0, 61 1e-4 0.1, 69 1e-4 0.1];
peak0(21,:) = [20 2e-4 0.5, 40 5e-4 0.5,  0 0e-4 0.0,  0 0e-4 0.0,  0 0e-4 0.0];
peak0(22,:) = [20 2e-4 0.5, 42 5e-4 0.5,  0 0e-4 0.0,  0 0e-4 0.0,  0 0e-4 0.0];
peak0(23,:) = [20 2e-4 0.5, 42 5e-4 0.5,  0 0e-4 0.0,  0 0e-4 0.0,  0 0e-4 0.0];
peak0(24,:) = [18 1e-4 0.1, 41 5e-4 0.5,  0 0e-4 0.0, 63 1e-4 0.1, 67 1e-4 0.1];
peak0(25,:) = [16 1e-4 0.1,  0 0e-4 0.0,  0 0e-4 0.0,  0 0e-4 0.0,  0 0e-4 0.0];
peak0(26,:) = [16 1e-4 0.1, 41 5e-4 0.5, 45 3e-4 0.5,  0 0e-4 0.0,  0 0e-4 0.0];
peak0(27,:) = [16 1e-4 0.1, 41 5e-4 0.5, 45 3e-4 0.5,  0 0e-4 0.0,  0 0e-4 0.0];
peak0(28,:) = [16 1e-4 0.1, 41 8e-4 0.5, 46 3e-4 0.5, 66 5e-4 0.4,  0 0e-4 0.0];
peak0(29,:) = [ 0 0e-4 0.0,  0 0e-4 0.0,  0 0e-4 0.0,  0 0e-4 0.0,  0 0e-4 0.0];
peak0(30,:) = [ 0 0e-4 0.0, 41 5e-4 0.5, 46 3e-4 0.5,  0 0e-4 0.0,  0 0e-4 0.0];
peak0(31,:) = [ 0 0e-4 0.0, 41 5e-4 0.5, 47 3e-4 0.5, 65 1e-4 0.1,  0 0e-4 0.0];
peak0(32,:) = [11 1e-4 0.1, 41 5e-4 0.5, 47 3e-4 0.5,  0 0e-4 0.0,  0 0e-4 0.0];
peak0(33,:) = [ 0 0e-4 0.0,  0 0e-4 0.0,  0 0e-4 0.0,  0 0e-4 0.0,  0 0e-4 0.0];
peak0(34,:) = [ 0 0e-4 0.0, 41 5e-4 0.5, 47 3e-4 0.5,  0 0e-4 0.0,  0 0e-4 0.0];
peak0(35,:) = [ 0 0e-4 0.0, 41 5e-4 0.5, 47 3e-4 0.5, 65 1e-4 0.1,  0 0e-4 0.0];
peak0(36,:) = [ 0 0e-4 0.0, 41 5e-4 0.5, 48 3e-4 0.5,-65.2 1e-3 1.09,0 0e-4 0.0];
peak0(37,:) = [ 0 0e-4 0.0,  0 0e-4 0.0,  0 0e-4 0.0,  0 0e-4 0.0,  0 0e-4 0.0];
peak0(38,:) = [ 0 0e-4 0.0,  0 0e-4 0.0,  0 0e-4 0.0,  0 0e-4 0.0,  0 0e-4 0.0];
peak0(39,:) = [ 0 0e-4 0.0, 40 5e-4 0.1, 48 3e-4 0.5,-65 1e-4 0.1,  0 0e-4 0.0];
peak0(40,:) = [ 0 0e-4 0.0, 39 2e-4 0.2, 44 6e-4 1.0, 65 1e-4 0.1,  0 0e-4 0.0];
peak0(41,:) = [ 0 0e-4 0.0, 39 2e-4 0.2, 44 6e-4 1.0,  0 0e-4 0.0,  0 0e-4 0.0];
peak0(42,:) = [ 0 0e-4 0.0,  0 0e-4 0.0,  0 0e-4 0.0,  0 0e-3 0.0,  0 0e-4 0.0];
peak0(43,:) = [ 0 0e-4 0.0,  0 0e-4 0.0,  0 0e-4 0.0,  0 0e-3 0.0,  0 0e-4 0.0];
peak0(44,:) = [ 0 0e-4 0.0, 39 2e-4 0.2, 44 6e-4 1.0, 60 5e-4 0.1,  0 0e-4 0.0];
peak0(45,:) = [ 0 0e-4 0.0, 39 2e-4 0.2, 44 6e-4 1.0,  0 0e-3 0.0,  0 0e-4 0.0];
peak0(46,:) = [ 0 0e-4 0.0, 38 2e-4 0.2, 43 6e-4 1.0,  0 0e-3 0.0,  0 0e-4 0.0];
peak0(47,:) = [ 0 0e-4 0.0,  0 0e-4 0.0,  0 0e-4 0.0,  0 0e-3 0.0,  0 0e-4 0.0];
peak0(48,:) = [ 0 0e-4 0.0,  0 0e-4 0.0,  0 0e-4 0.0,  0 0e-3 0.0,  0 0e-4 0.0];
peak0(49,:) = [ 0 0e-4 0.0, 37 2e-4 0.2, 42 6e-4 1.0, 60 1e-3 0.1,  0 0e-4 0.0];
peak0(50,:) = [ 0 0e-4 0.0, 35 2e-4 0.2, 42 6e-4 1.0, 60 1e-3 0.1,  0 0e-4 0.0];
peak0(51,:) = [ 0 0e-4 0.0, 35 2e-4 0.2, 42 6e-4 1.0,  0 0e-3 0.0,  0 0e-4 0.0];
peak0(52,:) = [ 0 0e-4 0.0,  0 0e-4 0.0,  0 0e-4 0.0,  0 0e-3 0.0,  0 0e-4 0.0];
peak0(53,:) = [ 0 0e-4 0.0,  0 0e-4 0.0,  0 0e-4 0.0,  0 0e-3 0.0,  0 0e-4 0.0];
peak0(54,:) = [10 4e-4 0.5, 35 2e-4 0.2, 40 6e-4 1.0, 63 1e-3 0.1,  0 0e-4 0.0];
peak0(55,:) = [10 4e-4 0.5, 35 2e-4 0.5, 40 6e-4 0.5,  0 0e-3 0.0,  0 0e-4 0.0];
peak0(56,:) = [10 4e-4 0.5, 34 2e-4 3.0, 37 6e-4 1.0,  0 0e-3 0.0,  0 0e-4 0.0];
peak0(57,:) = [12 4e-4 1.5,  0 0e-4 0.0,  0 0e-4 0.0,  0 0e-3 0.0,  0 0e-4 0.0];
peak0(58,:) = [10 4e-4 0.5,  0 0e-4 0.0,  0 0e-4 0.0,  0 0e-3 0.0,  0 0e-4 0.0];
peak0(59,:) = [10 4e-4 0.5, 34 2e-4 3.0, 37 6e-4 1.0,  0 0e-3 0.0,  0 0e-4 0.0];
peak0(60,:) = [10 4e-4 0.5, 34 2e-4 3.0, 37 6e-4 1.0,  0 0e-3 0.0,  0 0e-4 0.0];
peak0(61,:) = [10 4e-4 0.5, 28 2e-4 3.0,  0 0e-4 0.0,  0 0e-3 0.0,  0 0e-4 0.0];
peak0(62,:) = [12 4e-4 0.5, 33 2e-4 3.0, 37 6e-4 1.0, 60 1e-3 0.1,  0 0e-4 0.0];
peak0(63,:) = [10 4e-4 0.5,-33 2e-4 3.0,  0 0e-4 0.0,  0 0e-3 0.0,  0 0e-4 0.0];
peak0(64,:) = [10 4e-4 0.5, 33 2e-4 3.0, 37 6e-4 1.0,  0 0e-3 0.0,  0 0e-4 0.0];
peak0(65,:) = [10 4e-4 0.5, 32 2e-4 3.0, 35 6e-4 1.0, 60 1e-3 0.1,  0 0e-4 0.0];
peak0(66,:) = [11 4e-4 0.5, 32 2e-4 3.0, 35 6e-4 1.0, 60 1e-3 0.1,  0 0e-4 0.0];
peak0(67,:) = [10 4e-4 0.5, 30 2e-4 3.0,  0 0e-4 0.0,  0 0e-3 0.0,  0 0e-4 0.0];
peak0(68,:) = [10 4e-4 0.5, 30 2e-4 3.0, 35 6e-4 1.0, 60 1e-3 0.1,  0 0e-4 0.0];
peak0(69,:) = [10 4e-4 0.5, 28 2e-4 3.0, 35 6e-4 1.0, 60 1e-3 0.1,  0 0e-4 0.0];
peak0(70,:) = [10 4e-4 0.5, 28 2e-4 3.0, 35 6e-4 1.0, 60 1e-3 0.1,  0 0e-4 0.0];
peak0(71,:) = [11 4e-4 0.5, 30 2e-4 5.0,  0 0e-4 0.0,  0 0e-3 0.0,  0 0e-4 0.0];
peak0(72,:) = [10 4e-4 0.5, 30 2e-4 1.0, 35 6e-4 1.0, 60 1e-3 0.1,  0 0e-4 0.0];
peak0(73,:) = [10 4e-4 0.5, 35 2e-4 3.0, 38 6e-4 1.0, 60 1e-3 0.1,  0 0e-4 0.0];
peak0(74,:) = [11 4e-4 0.5, 35 2e-4 2.0,  0 0e-4 0.0,  0 0e-3 0.0,  0 0e-4 0.0];
peak0(75,:) = [10 4e-4 0.5, 35 2e-4 3.0, 38 6e-4 1.0, 60 1e-3 0.1,  0 0e-4 0.0];
peak0(76,:) = [10 4e-4 0.5, 35 2e-4 3.0, 38 6e-4 1.0, 61.5 1e-3 0.1,0 0e-4 0.0];
peak0(77,:) = [10 4e-4 0.5, 34 2e-4 3.0, 37 6e-4 1.0,-61.5 1e-3 -0.52,0 0e-4 0.0];
peak0(78,:) = [10 4e-4 0.5, 35 2e-4 3.0, 38 6e-4 1.0, 60 1e-3 0.1,  0 0e-4 0.0];
peak0(79,:) = [10 4e-4 0.5, 35 2e-4 3.0, 40 6e-4 1.0, 60 1e-3 0.1,  0 0e-4 0.0];
peak0(80,:) = [ 0 0e-4 0.0, 36 2e-4 3.0, 42 6e-4 1.0, 60 1e-3 0.1,  0 0e-4 0.0];
peak0(81,:) = [ 0 0e-4 0.0, 35 2e-4 3.0, 42 1e-3 0.1, 60 1e-3 0.1,  0 0e-4 0.0];


if sum(peak0(:)>0)>30
    toplot = false;
else
    toplot = true;
end

% peak labels
lab0 = cell(1,size(peak0,2));
for ii = 1:size(peak0,2)/3
    lab0(3*(ii-1)+(1:3)) = cellfun(@(C)num2str(ii,[C '%d']),{'x' 'A' 'wL'},'uniformoutput',false);
end
lab0 = {'x0' 'mu' 'wG' 'wL' 'A0' 'wL0' lab0{:} 'T' 'BKG1'}; %#ok<CCAT>

% fit all data
for ii = 1:numel(dat)

    %if any(peak0(ii,:))
        % [x0 mu wG wL | A0 wL0 | x1 A1 wL1 | ... xN AN wLN T BKG1]
        pin0 = peak0(ii,:)>0;
        if ~exist('datfit','var')
            [datfit, fitRes] = fits(dat(ii),'ID28_specfun2',...
                [0 res0(deti(ii),:), 1e-3 0, abs(peak0(ii,:)),  T, 0 ],[1 0 0 0, 1 1, pin0 0 1]);
        else
            [datfit(ii), fitRes(ii)] = fits(dat(ii),'ID28_specfun2',...
                [0 res0(deti(ii),:), 1e-3 0, abs(peak0(ii,:)),  T, 0 ],[1 0 0 0, 1 1, pin0 0 1]);
        end
        
        if toplot && any(peak0(ii,:))
            
            clf
            plot(dat(ii),'semilogy',1);
            x = linspace(min(get(dat(ii),'x')),max(get(dat(ii),'x')),501);
            plot(x,ID28_specfun2(x,fitRes(ii).pvals),'linewidth',2);
            hold on
            title(sprintf('$\\#%d, \\chi^2 = %5.3f$',ii,fitRes(ii).chisq),'interpreter','latex')
            swplot.subfigure(2,2,1)
            axis([-5 80 9e-6 max([get(dat(ii),'y')*1.2; 1.4e-3])])
        end

        if ~any(peak0(ii,:))
            pvals(:,ii) = nan;
            evals(:,ii) = nan;
        else
            pvals(:,ii) = fitRes(ii).pvals;
            evals(:,ii) = fitRes(ii).evals;
        end
    %end
end

[pvals, evals] = addfit2(fitRes,dat,[],[]);

%
if 0
    
    idx = 34;
    clf
    plot(dat(idx),'semilogy',1);
    x = linspace(min(get(dat(idx),'x')),max(get(dat(idx),'x')),501);
    plot(x,ID28_specfun2(x,fitRes(idx).pvals),'linewidth',2);
    hold on
    title(sprintf('$\\#%d, \\chi^2 = %5.3f$',idx,fitRes(idx).chisq),'interpreter','latex')
    swplot.subfigure(2,2,1)
    axis([-5 80 9e-6 max([get(dat(idx),'y')*1.2; 1.4e-3])])
end

%% plot width and energy

xval = Q(1,:);
%xval = 1:size(Q,2);

figure;
subplot(3,1,1)
errorbar(xval,pvals(10,:),evals(10,:),'o')
hold on
errorbar(xval,pvals(13,:),evals(13,:),'o')
ylim([ 0 50])

subplot(3,1,2)
errorbar(xval,pvals(12,:),evals(12,:),'o')
hold on
errorbar(xval,pvals(15,:),evals(15,:),'o')
ylim([0 10])

subplot(3,1,3)
errorbar(xval,pvals(11,:),evals(11,:),'o')
hold on
errorbar(xval,pvals(14,:),evals(14,:),'o')
ylim([0 5e-3])

%% print all fit data

pvalsp = pvals;
pvalsp(pvals==0) = nan;
xval = Q(1,:);

dmax = 1;
sel1  = evals(9,:)<dmax;
sel2  = evals(12,:)<inf;
sel3  = evals(15,:)<inf;

datsave = cell(1,5);
datsave{1} = rmmissing(table(xval(sel1)',pvalsp(7,sel1)', evals(7,sel1)', pvalsp(9,sel1)', evals(9,sel1)'));
datsave{2} = rmmissing(table(xval(sel2)',pvalsp(10,sel2)',evals(10,sel2)',pvalsp(12,sel2)',evals(12,sel2)'));
datsave{3} = rmmissing(table(xval(sel3)',pvalsp(13,sel3)',evals(13,sel3)',pvalsp(15,sel3)',evals(15,sel3)'));
datsave{4} = rmmissing(table(xval',      pvalsp(16,:)',   evals(16,:)',   pvalsp(18,:)',   evals(18,:)'));
datsave{5} = rmmissing(table(xval',      pvalsp(19,:)',   evals(19,:)',   pvalsp(21,:)',   evals(21,:)'));

for ii = 1:5
    datsave{ii}.Properties.VariableNames = {'h' 'E' 'std_E' 'w' 'std_w'};
    datsave{ii}.Properties.VariableUnits = {'rlu' 'meV' 'meV' 'meV' 'meV'};
    writetable(datsave{ii},sprintf('~/Documents/structures/LiCrO2/ID28/export/mode_%d.xye',ii),...
        'WriteVariableNames',true,'FileType','text')
end


%% plot all energy

pvalsp = pvals;
pvalsp(pvals==0) = nan;
xval = Q(1,:);
%xval = 1:size(Q,2);

dmax = 1;
sel1  = evals(9,:)<dmax;
sel2  = evals(12,:)<inf;
sel3  = evals(15,:)<inf;

ymax = 10;
%clf;
figure
subplot(1,2,1)
% magnon
errorbar(xval(sel1),pvalsp(7,sel1),evals(7,sel1),'o')
hold on
% 2magnon
plot(2*xval(sel1)-1,2*pvalsp(7,sel1),'b-','linewidth',3)

errorbar(xval(sel2),pvalsp(10,sel2),evals(10,sel2),'o')
errorbar(xval(sel3),pvalsp(13,sel3),evals(13,sel3),'o')
errorbar(xval,pvalsp(16,:),evals(16,:),'o')
errorbar(xval,pvalsp(19,:),evals(19,:),'o')
axis([1 1.6 0 80])
title('Dispersion')
ylabel('Energy (meV)')
xlabel('(H,H,0)')

subplot(3,2,2)
errorbar(xval(sel1),pvalsp(9,sel1),evals(9,sel1),'o')
axis([1 1.6 0 ymax])
title('Spin wave width')
ylabel('\Gamma (meV)')
xlabel('(H,H,0)')

subplot(3,2,4)
plot(nan,nan)
hold on
errorbar(xval(sel2),pvalsp(12,sel2),evals(12,sel2),'o')
errorbar(xval(sel3),pvalsp(15,sel3),evals(15,sel3),'o')
% plot(xval(sel2),pvalsp(12,sel2),'o')
% plot(xval(sel3),pvalsp(15,sel3),'o')
axis([1 1.6 0 ymax])
title('Phonon widt (1&2)')
ylabel('\Gamma (meV)')
xlabel('(H,H,0)')

subplot(3,2,6)
plot(nan,nan)
hold on
plot(nan,nan)
plot(nan,nan)
errorbar(xval,pvalsp(18,:),evals(18,:),'o')
errorbar(xval,pvalsp(21,:),evals(21,:),'o')
axis([1 1.6 0 ymax])
title('Optical phonon width')
ylabel('\Gamma (meV)')
xlabel('(H,H,0)')


%% overplot LSWT

tri = sw_model('triAF',5);
tri.mag_str.F = tri.mag_str.F*3/2;

spec = tri.spinwave({[0 0 0] [1 1 0]});
%figure;
hold on
plot(spec.hkl(1,:)+1,spec.omega(3,:)*0.95)

%% check intensity of elastic line

pp = [fitRes(:).pvals];

Iel = pp(5,:);
multi = [1 1 1 1 1 2 1.3 2. 1.3671];

for ii = 1:9
    Iel(deti==ii) = Iel(deti==ii)*multi(ii);
end
dat = struct('x',Q(1,:),'y',Q(3,:),'z',Iel);

figure
%plot(Q(1,:),pp(5,:))
ndbase.cplot(dat,'convhull',true);
xlabel('H')
ylabel('L')
caxis([0 0.005])

%% hold on
errorbar(xval,pvals(15,:),evals(15,:),'o')
ylim([0 10])

subplot(3,1,3)
errorbar(xval,pvals(11,:),evals(11,:),'o')
hold on
errorbar(xval,pvals(14,:),evals(14,:),'o')
ylim([0 5e-3])