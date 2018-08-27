%% ID28 logbook for LiCrO2

datf = '~/Documents/structures/LiCrO2/ID28/data/LiCrO.fourc';

addpath(genpath('/Users/tothsa/Documents/structures/LiCrO2/ID28/matlab'))

%% import data

% temperature correction values for each detector
Tcorr = [0.1711 -0.09799 0.4409 -0.0122 -0.0194 0.0196 0.0189...
    -0.0097 -0.0019];

%Tcorr(4:6) = Tcorr(4:6)+0.15;

%Tcorr = 0*Tcorr;
toPlot = true;
Si_refl = 9;

% T = 300 K
% Q = (1.5 1.5 0)
dat{1} = ID28_importmulti(datf,[126 127 134],Si_refl,Tcorr,toPlot);

%%
% Q = (1.25 1.25 0)
dat{2} = ID28_importmulti(datf,133,Si_refl,Tcorr,toPlot);

% T = 40 K
% Q = (1.5 1.5 0)
dat{3} = ID28_importmulti(datf,[246, 223, 261],Si_refl,Tcorr,toPlot);
% Q = (1.25 1.25 0)
dat{4} = ID28_importmulti(datf,[221, 256, 258],Si_refl,Tcorr,toPlot);
% Q = (1.167 1.167 0)
dat{5} = ID28_importmulti(datf,[253, 257],Si_refl,Tcorr,toPlot);
% Q = (1.333 1.333 0)
dat{6} = ID28_importmulti(datf,[254, 259],Si_refl,Tcorr,toPlot);
% Q = (1.4167 1.4167 0)
dat{7} = ID28_importmulti(datf,[255, 260],Si_refl,Tcorr,toPlot);

%% fit elastic line

% use the instrumental resolution as a starting parameter
% [mu,wG,wL]

res999 = [...
    0.658240,3.019813,3.019813; 0.653311,2.921084,2.921084;...
    0.650948,2.947347,2.947347; 0.631650,2.932882,2.932882;...
    0.637999,2.974501,2.974501; 0.643725,2.830674,2.830674;...
    0.646920,2.930675,2.930675; 0.664114,2.798965,2.798965;...
    0.678832,2.859026,2.859026];

figure
for ii = 1:9
    toFit = cut(dat{3}(ii),[-8 8]);
    %[fSpec, fRes] = fits(toFit,'pseudovoigt',[max(toFit) 0 3 3 min(toFit)],[0 0 0 0 0]+1);
    [fSpec, fRes] = fits(toFit,'gauss',[max(toFit) 0 3 min(toFit)],[0 0 0 0]+1);
    subplot(3,3,ii)
    plot(fSpec)
end




%% add up the scans
 





%%
int1 = int1 - mean(int1);
int2 = int2 - mean(int2);
int3 = int3 - mean(int3);




for ii = 1:numel(int1)
    xc(ii) = sum(int1(ii:end).*int2(1:(numel(int1)-ii+1)));
end
for ii = 1:(numel(int1)-numel(int3)-1)
    xc3(ii) = sum(int1(ii:(ii+numel(int3)-1)).*int3);
end

dx = findmax(xc);

figure;
plot(1:numel(int1),int1)
hold on
plot((1:numel(int2))+dx,int2)

%% quick plot at 40 K

D = {};
D{1} = importdata('LiCrO2_40K_1p1667_1p1667_0.dat');
D{2} = importdata('LiCrO.fourc2_40K_1p25_1p25_0.dat');
D{3} = importdata('LiCrO2_40K_1p333_1p333_0.dat');
D{4} = importdata('LiCrO2_40_K_1p4167_1p4167.dat');
D{5} = importdata('LiCrO2_40K_1p5_1p5_0.dat');


H = [1.1667 1.25 4/3 1.4167 1.5];

%%
toShift = toPlot;
idxList = 1:5;
figure
for idx = idxList;
    p1 = errorbar(D{idx}(:,1),D{idx}(:,2)+(H(idx)-H(1))*1.5e-3*toShift,D{idx}(:,3),'-');
    set(p1,'linewidth',2)
    hold on
end
legend(num2str(H(idxList)','H = %5.3f rlu'))

xlabel('Energy Transfer (meV)')
ylabel('IXS Intensity (arb. units)')
set(gca,'fontsize',14)

%% voigt test

xv=linspace(-5,5,501);
figure;
plot(xv,make_pseudovoigt([1 0 1 1 0],xv));
hold on
plot(xv,voigt(xv,[1.5 0 1/2.35482 1/2 0]));

%% resolution for (9,9,9) Si reflection

res999 = [...
    0.658240,3.019813,3.019813; 0.653311,2.921084,2.921084;...
    0.650948,2.947347,2.947347; 0.631650,2.932882,2.932882;...
    0.637999,2.974501,2.974501; 0.643725,2.830674,2.830674;...
    0.646920,2.930675,2.930675; 0.664114,2.798965,2.798965;...
    0.678832,2.859026,2.859026];

