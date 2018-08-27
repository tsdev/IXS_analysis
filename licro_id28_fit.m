%% ID28 logbook for LiCrO2

% add spec1d library
addpath(genpath('~/IXS_analysis_git/matlab/spec1d'));
addpath(genpath('~/IXS_analysis_git/matlab/load'));
addpath(genpath('~/IXS_analysis_git/matlab/Colormaps'));
        
% add custom code
datf = '~/IXS_analysis_git/data/combined';
addpath(genpath('~/IXS_analysis_git/matlab'))
cd(datf)

col = 'rgbmcykrgbk';
detOrder = [1 6 2 7 3 8 4 9 5];

Icorr = [2.024 1.285 1.1359 1 1.2547 2.6693 3.0843 1.5445 1.916];

%% test resolution fits

res = cell(1,9);
fit0 = cell(1,9);

for ii = 1:9
    res{ii}=importdata(num2str(ii,'~/IXS_analysis_git/data/Resolution_999_Oct_2015/a%dres9_pm.exp'));
    fit0{ii}=importdata(num2str(ii,'~/IXS_analysis_git/data/Resolution_999_Oct_2015/a%dres9_pm.fit'));
    rest.x = res{ii}(:,1);
    rest.y = res{ii}(:,2);
    rest.e = res{ii}(:,3);
    resS(ii) = spec1d(rest);
    fitt.x = fit0{ii}(:,1);
    fitt.y = fit0{ii}(:,2);
    fitt.e = sqrt(fit0{ii}(:,2))/1000;
    fitS(ii) = spec1d(fitt);
end

%% plot all resolution of each detector

figure
for ii = 1:9
    subplot(3,3,ii)
    semilogy(res{ii}(:,1),res{ii}(:,2),'o-');
end

%% fit resolution

% ID28_specfun2: [x0 mu wG wL A0 wL0 x1 A1 wL1 ... xN AN wLN T]
resp = zeros(9,8);
clear fitRes
clear fitfRes

bb = [0 1;0 1;0 13.1;0 13;0 10;-1 1;0 300;-1 1];
for ii = 1:9
    [datfit(ii), fitRes(ii)] = fits(resS(ii),@ID28_specfun2,[0 0.65 3 3, 1 1e-5*0, 297 0],[0 1 1 1, 1 0, 0 1],'win',[-50 50],'bounds',bb);
    [~, fitfRes(ii)] = fits(fitS(ii),@ID28_specfun2,[0 0.65 3 3, 1 0, 297 0],[0 1 1 1, 1 0, 0 1],'win',[-100 100]);
end

resp  = [fitRes(:).pvals]';
rese  = [fitRes(:).evals]';
respf = [fitfRes(:).pvals]';

res0  = resp(:,2:4);
rese0 = rese(:,2:4);

%%
figure
for ii = 1:9
    subplot(3,3,ii)
    plot(datfit(ii),'semilogy',1);
    
    title(num2str(ii,'det%d'))
    %plot(datf(ii))
    hold on
    
    pp = respf(ii,:);
    pp(5) = resp(ii,5);
    x = res{ii}(:,1);
    y = ID28_specfun2(x,pp);
    semilogy(x,y,'r-','linewidth',2);
    pp(2) = 0;
    y = ID28_specfun2(x,pp);
    semilogy(x,y,'g-','linewidth',2);
    
    
    
    % calculate chi2
    R2(1,ii) = sum(1./res{ii}(:,1).^2.*(res{ii}(:,1)-y).^2);
    
    dats = struct(datfit(ii));
    R2(2,ii) = sum(1./res{ii}(:,1).^2.*(res{ii}(:,1)-dats.yfit).^2);
    
    %semilogy(fit0{ii}(:,1),fit0{ii}(:,2),'r-')
    %plot(fit0{ii}(:,1),fit0{ii}(:,2),'r-')
    ylim auto
end


%% test peak function

% p = [x0 A mu wG wL wL1]
x0 = 0;
A  = 1;
mu = 0.5;
wG = 1;
wL = 3;
wL1 = 0;
x = linspace(-10,10,1001);

p = [x0 A mu wG wL wL1];
y1 = ID28_peak(x,p);

wL1 = 1e-4;
p = [x0 A/wL*2*0.87 mu wG wL/2 wL1];
y2 = ID28_peak(x,p);

clf
semilogy(x,y1);
hold on
semilogy(x,y2)


%% Q = (1.5 1.5 0), det2


T   = [300 80 60 40];
Q   = 1.5;
detId = 2;
[dat,tStr,lStr] = ID28_importtxt(T,Q,detId,Icorr);

figure
for ii = 1:4
    plot(dat(ii)+(ii-1)*1e-4,[col(ii) '-'])
    hold on
end

legend(lStr)
title(tStr)
axis([-10 75 0 11e-4])

%% check list of Q points

T   = 5;
Q   = [1.04 1.08 1.16 1.25 1.29 1.33 1.38 1.42 1.50];
detId = 2;
[dat,~,~,found]  = ID28_importtxt(T,Q,detId,Icorr);
Q(found)

%% fit Q = (1.5,1.5,0) scans at different temperatures

% reslution parameters:
load('res0.mat')

clear datfit

T   = [300 80 60 40 5];
Q   = 1.5;
detId = 2;
dat  = ID28_importtxt(T,Q,detId,Icorr);
peak0 = [];
peak0(1,:) = [0 0     0, 30 1e-3 1, 35 1e-3 1.75, 59 1e-3 1];
peak0(2,:) = [9 1e-4 10, 28 1e-3 1, 35 1e-3 1, 59 1e-3 1];
peak0(3,:) = [10 1e-3 3, 30 1e-3 1, 35 1e-3 1, 59 1e-3 1];
peak0(4,:) = [10 1e-3 3, 30 1e-3 1, 35 1e-3 1, 59 1e-3 1];
peak0(5,:) = [10 1e-3 3, 30 1e-3 1, 35 1e-3 1, 59 1e-3 1];

nPeak = size(peak0,2)/3;

% peak labels
lab0 = cell(1,size(peak0,2));
for ii = 1:size(peak0,2)/3
    lab0(3*(ii-1)+(1:3)) = cellfun(@(C)num2str(ii,[C '%d']),{'x' 'A' 'wL'},'uniformoutput',false);
end
lab0 = {'x0' 'mu' 'wG' 'wL' 'A0' 'wL0' lab0{:} 'T' 'BKG1'};

clear fitRes

for ii = 1:numel(T)
    % [x0 mu wG wL | A0 wL0 | x1 A1 wL1 | ... xN AN wLN T BKG1]
    pin0 = peak0(ii,:)>0;
    
    if ii == 1
        pin1 = pin0;
        %pin1(9) = 0;
        [datfit(ii), fitRes(ii)] = fits(dat(ii),'ID28_specfun2',...
            [0 res0(detId,:), 1e-3 0, peak0(ii,:),  T(ii), 0 ],[1 0 0 0, 1 1, pin1 0 1]);
    else
        [datfit(ii), fitRes(ii)] = fits(dat(ii),'ID28_specfun2',...
            [0 res0(detId,:), 1e-3 0, peak0(ii,:),  T(ii), 0 ],[1 0 0 0, 1 1, pin0 0 1]);
    end
end

pvals = [fitRes(:).pvals]';
evals = [fitRes(:).evals]';

% plot fit results
clf

nPeak = [3 3 4 4 4];
for ii = 1:5
    subplot(5,1,ii)
    
    plot(datfit(ii),'.','semilogy',1)
    title(num2str([T(ii) fitRes(ii).chisq],'T = %d K, chi2 = %4.2f'))
    hold on
    dats=struct(datfit(ii));
    x = linspace(dats.x(1),dats.x(end),501);
    
    plot(dats.x,dats.y-dats.yfit-5e-5,'r-')
    for jj = 1:(nPeak+1)
        y = ID28_specfun2(x,pvals(ii,:),[],jj);
        plot(x,y,'g-','linewidth',2)
    end
    axis([-5 45 1e-5 1e-3])
    set(gca,'ytick',[1e-5 1e-4 1e-3])

end

%% overplot all data

col = {'r' 'g' 'b' 'y' 'c'};
%figure
Ishift = 10e-5*0;

clf
for ii = 1:numel(datfit)
    subplot(5,1,ii)
    [pp,ll] = plot(datfit(ii)+(ii-1)*Ishift,'.','semilogy',1);
    
    hold on
    line([-20 100],[1 1]*(ii-1)*Ishift,'color','k','linestyle','--')
    hold on
    axis([-5 45 1e-5 1e-3])
    set(gca,'ytick',[1e-5 1e-4 1e-3])
end

title('Q = (1.5,1.5,0)')

%% overplot all data using patch

figure
subplot(2,1,1)
col = royal(6);
for ii = 1:5
    Ishift = (ii-1)*1e-4;
    x = get(datfit(ii),'x')';
    x = [x(1) x x(end)];
    y = get(datfit(ii),'y')';
    y = [0 y 0]+Ishift;
    
    pHandle = fill(x,y,y*0-Ishift);
    pHandle.FaceColor = col(ii,:);
    pHandle.FaceAlpha = 0.7;
    hold on
end
axis([-5 45 0.e-4 9e-4])
title('Q = (1.5,1.5,0)')
box on
xlabel('Energy Transfer (meV)')
ylabel('Intensity (arb. units)')

%% extract the magnon+phonon mixed modes

p1 = [fitRes(:).pvals];
e1 = [fitRes(:).evals];

Imph  = sum(p1(6+[2 5],:),1);
dImph = sqrt(sum(e1(6+[2 5],:).^2,1));

Im    = sum(p1(6+2,:),1);
dIm   = sqrt(sum(e1(6+2,:).^2,1));

Iph   = sum(p1(6+5,:),1);
dIph  = sqrt(sum(e1(6+5,:).^2,1));

Iph2  = sum(p1(6+8,:),1);
dIph2 = sqrt(sum(e1(6+8,:).^2,1));

clf
errorbar(T,Imph,dImph,'r.-','MarkerFaceColor','r')
hold on
errorbar(T,Im,dIm,'g.-','MarkerFaceColor','g')
errorbar(T,Iph,dIph,'b.-','MarkerFaceColor','b')
%errorbar(T,Iph2,dIph2)
%legend('magnon+phonon','magnon','phonon','phonon2')
legend('EM+LA','EM','LA')
axis([0 310 0 3.5e-3])
xlabel('Temperature (K)')
ylabel('Intensity (arb. units)')

%% calculate the transferrred intensity at 7 K
% more than 50% is transferred

ILA  = Iph(end);
Ima  = Im(end);
dILA = dIph(end);
dIma = dIm(end);

TR  = Ima/(ILA+Ima);
dTR = 1/(ILA+Ima)*sqrt(dIma^2+TR^2*(dIma^2+dILA^2));


%% overplot fit results

% strawberry
cStr = [210 19 23]/255;
cGr  = [89 176 53]/255;

col = {'r' 'b' 'y' 'c' 'm'};

Treal = [295 99 69.2 40 7.1];

cBlue = get(gca,'ColorOrder');

tx = zeros(1,5)-3;
ty = [0.3 0.4 0.4 0.4 0.7];
% plot fit results
figure
subplot(1,2,1)
hold on
yMul = 7.5e-1;

clear hError

for ii = 1:5
    dats=struct(datfit(ii));
    x = linspace(dats.x(1),dats.x(end),501);
    
    for jj = 1:(nPeak+1)
        y = ID28_specfun2(x,pvals(ii,:),[],jj);
        plot3(x,y*1e3+(ii-1)*yMul,x*0-1e2,'-','linewidth',2,'color',col{jj})
    end
    y = ID28_specfun2(x,pvals(ii,:));
    plot3(x,y*1e3+(ii-1)*yMul,x*0-1e2,'-','linewidth',2,'color',cBlue(1,:))

    [~, hError(ii)] = plot(datfit(ii)*1e3+(ii-1)*yMul,'k.','markerfacecolor',cGr,'markeredgecolor','k');
    %errorbar(dats.x,dats.y*1e3+(ii-1)*yMul,dats.e*1e3,'ko','markerfacecolor',cBlue(1,:),'markeredgecolor','k')
    hError(ii).Color = [0 0 0];
    line([-10 80],[0 0]+(ii-1)*yMul,'linestyle','--','color','k')
    text(tx(ii),(ii-1)*yMul+ty(ii),num2str(round(Treal(ii)),'T = %d K'),'fontsize',18)
end
ylim([0 4])
set(gca,'fontsize',16)
xlim([-5 70])
grid off

%% extract the peak fit parameters

Treal = [295 99 69.2 40 7.1];
colp  = {'x1' 'x2' 'x3' 'x4'};

figure
for idx = 1:numel(colp)
    col   = find(strcmp(lab0,colp{idx}));
    
    subplot(2,2,idx)
    cla
    errorbar(Treal,pvals(:,col),evals(:,col),'o-')
    title(lab0{col});
    set(gca,'fontsize',14)
    xlabel('Temperature (K)')
end

%% overplot peak positions and line width

pvals(pvals==0) = nan;
Treal = [295 99 69.2 40 7.1];
colp = {'x1' 'x2' 'x3' 'x4'};

figure
subplot(1,3,1)
for idx = 1:numel(colp)
    col   = find(strcmp(lab0,colp{idx}));
    
    errorbar(Treal,pvals(:,col),evals(:,col),'o-')
    hold on
end
legend(colp)
title('Peak position (meV)');
set(gca,'fontsize',14)
xlabel('Temperature (K)')
axis([0 300 0 65])


colp = {'wL1' 'wL2' 'wL3' 'wL4'};

subplot(1,3,2)
for idx = 1:numel(colp)
    col   = find(strcmp(lab0,colp{idx}));
    
    errorbar(Treal,pvals(:,col),evals(:,col),'o-')
    hold on
end
legend(colp)
title('Lorentzian FWHM (meV)');
set(gca,'fontsize',14)
xlabel('Temperature (K)')
axis([0 300 0 20])

colp = {'A1' 'A2' 'A3' 'A4'};

subplot(1,3,3)
for idx = 1:numel(colp)
    col   = find(strcmp(lab0,colp{idx}));
    
    errorbar(Treal,pvals(:,col)*1e3,evals(:,col)*1e3,'o-')
    hold on
end
legend(colp)
title('Relative intensity');
set(gca,'fontsize',14)
xlabel('Temperature (K)')
axis([0 300 0 5])

%% relative peak positions

pvals(pvals==0) = nan;
Treal = [295 99 69.2 40 7.1];
colp = {'x1' 'x2' 'x3' 'x4'};

figure
for idx = 1:numel(colp)
    col   = find(strcmp(lab0,colp{idx}));
    
    errorbar(Treal,pvals(:,col)/pvals(1,col),evals(:,col)/pvals(1,col),'o-')
    hold on
end
legend(colp)
title('Peak position (meV)');
set(gca,'fontsize',14)
xlabel('Temperature (K)')
axis([0 300 0 65])

%% fit Q = (1.25,1.25,0) scans at different temperatures

% reslution parameters:
load('res0.mat')

T   = [300 80 60 40 5];
Treal = [295 99 69.2 40 7.1];

Q   = 1.25;
detId = 2;
dat  = ID28_importtxt(T,Q,detId,Icorr);
peak0 = [];
peak0(1,:) = [0 0     0, 42 1e-3 1, 45 1e-3 1, 65 1e-3 1];
peak0(2,:) = [0 0     0, 42 1e-3 1, 45 1e-3 1, 65 1e-3 1];
peak0(3,:) = [15 1e-3 3, 42 1e-3 1, 45 1e-3 1, 65 1e-3 1];
peak0(4,:) = [15 1e-3 3, 42 1e-3 1, 45 1e-3 1, 65 1e-3 1];
peak0(5,:) = [15 1e-3 3, 42 1e-3 1, 45 1e-3 1, 65 1e-3 1];

nPeak = size(peak0,2)/3;

% peak labels
lab0 = cell(1,size(peak0,2));
for ii = 1:nPeak
    lab0(3*(ii-1)+(1:3)) = cellfun(@(C)num2str(ii,[C '%d']),{'x' 'A' 'wL'},'uniformoutput',false);
end
lab0 = {'x0' 'mu' 'wG' 'wL' 'A0' 'wL0' lab0{:} 'T' 'BKG1'};

clear fitRes

for ii = 1:numel(T)
    % [x0 mu wG wL | A0 wL0 | x1 A1 wL1 | ... xN AN wLN T BKG1]
    pin0 = peak0(ii,:)>0;
    
    [datfit(ii), fitRes(ii)] = fits(dat(ii),'ID28_specfun2',...
        [0 res0(detId,:), 1e-3 0, peak0(ii,:),  T(ii), 0 ],[1 0 0 0, 1 1, pin0 0 1]);
end

pvals = [fitRes(:).pvals]';
evals = [fitRes(:).evals]';


% plot fit results
figure

for ii = 1:5
    subplot(5,1,6-ii)
    
    plot(datfit(ii),'b')
    title(num2str(Treal(ii),'T = %5.1f K'))
    hold on
    dats=struct(datfit(ii));
    plot(dats.x,dats.y-dats.yfit-5e-5,'r-')
    x = linspace(-5,80,501);
    for jj = 1:(nPeak+1)
        y = ID28_specfun2(x,pvals(ii,:),[],jj);
        plot(x,y,'g-','linewidth',2)
    end
    ylim([0 1e-3])
end

%% overplot all data

figure
for ii = 1:1
    plot(datfit(ii)+(ii-1)*5e-5)
    hold on
end
axis([-5 75 0 12e-4])

%% overplot all data using patch

%figure
subplot(2,1,2)
col = royal(6);
for ii = 1:5
    Ishift = (ii-1)*1e-4;
    x = get(datfit(ii),'x')';
    x = [x(1) x x(end)];
    y = get(datfit(ii),'y')';
    y = [0 y 0]+Ishift;
    
    pHandle = fill(x,y,y*0-Ishift);
    pHandle.FaceColor = col(ii,:);
    pHandle.FaceAlpha = 0.7;
    hold on
end
axis([-5 45 0.e-4 6e-4])
title('Q = (1.25,1.25,0)')
box on
xlabel('Energy Transfer (meV)')
ylabel('Intensity (arb. units)')

%print('~/Documents/structures/LiCrO2/ID28/results/licro_diffuse_magscat.pdf','-dpdf')

%% extract the peak fit parameters

Treal = [295 99 69.2 40 7.1];
colp  = {'x1' 'x2' 'x3' 'x4'};

for idx = 1:numel(colp)
    col   = find(strcmp(lab0,colp{idx}));
    
    subplot(2,2,idx)
    cla
    errorbar(Treal,pvals(:,col),evals(:,col),'o-')
    title(lab0{col});
    set(gca,'fontsize',14)
    xlabel('Temperature (K)')
end

%% overplot peak positions and line width

pvals(pvals==0) = nan;
Treal = [295 99 69.2 40 7.1];
colp = {'x1' 'x2' 'x3' 'x4'};

clf
subplot(1,3,1)
for idx = 1:numel(colp)
    col   = find(strcmp(lab0,colp{idx}));
    
    errorbar(Treal,pvals(:,col),evals(:,col),'o-')
    hold on
end
legend(colp)
title('Peak position (meV)');
set(gca,'fontsize',14)
xlabel('Temperature (K)')
axis([0 300 0 70])


colp = {'wL1' 'wL2' 'wL3' 'wL4'};

subplot(1,3,2)
for idx = 1:numel(colp)
    col   = find(strcmp(lab0,colp{idx}));
    
    errorbar(Treal,pvals(:,col),evals(:,col),'o-')
    hold on
end
legend(colp)
title('Lorentzian FWHM (meV)');
set(gca,'fontsize',14)
xlabel('Temperature (K)')
axis([0 300 0 12])

colp = {'A1' 'A2' 'A3' 'A4'};

subplot(1,3,3)
for idx = 1:numel(colp)
    col   = find(strcmp(lab0,colp{idx}));
    
    errorbar(Treal,pvals(:,col)*1e3,evals(:,col)*1e3,'o-')
    hold on
end
legend(colp)
title('Relative intensity');
set(gca,'fontsize',14)
xlabel('Temperature (K)')
axis([0 300 0 9])


%% fit Q = (1.33,1.33,0) scans at different temperatures
figure
% reslution parameters:
load('res0.mat')

T   = [60 40 5];
Q   = 1.33;
detId = 2;
dat  = ID28_importtxt(T,Q,detId,Icorr);
peak0 = [];
peak0(1,:) = [ 0    0 0,40 1e-3 3,  0    0 0];
peak0(2,:) = [ 0    0 0,40 1e-3 3,  0    0 0];
peak0(3,:) = [ 0    0 0,40 1e-3 3, 46 1e-3 1];
peak0(4,:) = [ 1 1e-3 5,40 1e-3 3, 46 1e-3 1];

dat(4) = dat(3);
T(4)   = T(3);

nPeak = size(peak0,2)/3;

% peak labels
lab0 = cell(1,size(peak0,2));
for ii = 1:nPeak
    lab0(3*(ii-1)+(1:3)) = cellfun(@(C)num2str(ii,[C '%d']),{'x' 'A' 'wL'},'uniformoutput',false);
end
lab0 = {'x0' 'mu' 'wG' 'wL' 'A0' 'wL0' lab0{:} 'T' 'BKG1'};

clear fitRes

for ii = 1:numel(T)
    % [x0 mu wG wL | A0 wL0 | x1 A1 wL1 | ... xN AN wLN T BKG1]
    pin0 = peak0(ii,:)>0;
    
    [datfit(ii), fitRes(ii)] = fits(dat(ii),'ID28_specfun2',...
        [0 res0(detId,:), 1e-3 0, peak0(ii,:),  T(ii), 0 ],[1 0 0 0, 1 0, pin0 0 1]);
    
end

pvals = [fitRes(:).pvals]';
evals = [fitRes(:).evals]';


% plot fit results
clf

for ii = 1:numel(T)
    subplot(2,2,ii)
    
    plot(datfit(ii),'b','semilogy',1)
    title(num2str([T(ii) fitRes(ii).chisq],'T = %d K, chi2=%4.2f'))
    hold on
    dats=struct(datfit(ii));
    semilogy(dats.x,dats.y-dats.yfit-1e-4,'r-')
    line([dats.x(1) dats.x(end)],[1 1]*fitRes(ii).pvals(end),'color','k')
    ylim([0 1e-3])
end


%% fit Q = (1.42,1.42,0) scans at different temperatures

% reslution parameters:
load('res0.mat')

T   = [60 40 5];
Q   = 1.42;
detId = 2;
dat  = ID28_importtxt(T,Q,detId,Icorr);
peak0 = [];
peak0(1,:) = [10 1e-3 5, 31 1e-3 1, 0 0 0];
peak0(2,:) = [12 1e-3 5, 31 1e-3 1, 0 0 0];
peak0(3,:) = [12 1e-3 5, 34 1e-3 1, 40 1e-3 1];

nPeak = size(peak0,2)/3;

% peak labels
lab0 = cell(1,size(peak0,2));
for ii = 1:nPeak
    lab0(3*(ii-1)+(1:3)) = cellfun(@(C)num2str(ii,[C '%d']),{'x' 'A' 'wL'},'uniformoutput',false);
end
lab0 = {'x0' 'mu' 'wG' 'wL' 'A0' 'wL0' lab0{:} 'T' 'BKG1'};

clear fitRes

for ii = 1:numel(T)
    % [x0 mu wG wL | A0 wL0 | x1 A1 wL1 | ... xN AN wLN T BKG1]
    pin0 = peak0(ii,:)>0;
    
    [datfit(ii), fitRes(ii)] = fits(dat(ii),'ID28_specfun2',...
        [0 res0(detId,:), 1e-3 0, peak0(ii,:),  T(ii), 0 ],[1 0 0 0, 1 1, pin0 0 1]);
end

pvals = [fitRes(:).pvals]';
evals = [fitRes(:).evals]';
chi2  = [fitRes(:).chisq];

% plot fit results
clf

for ii = 1:numel(T)
    subplot(2,2,ii)
    
    plot(datfit(ii),'b','semilogy',1)
    ylim auto
    yy = ylim;
    title(num2str([T(ii) chi2(ii)],'T = %d K, chi^2 = %4.2f'))
    hold on
    dats=struct(datfit(ii));
    %semilogy(dats.x,dats.y-dats.yfit-5e-5,'r-')
    x = linspace(dats.x(1),dats.x(end),501);
    for jj = 1:(nPeak+1)
        y = ID28_specfun2(x,pvals(ii,:),[],jj);
        semilogy(x,y,'g-','linewidth',2)
    end
    ylim(yy);
end

%% fit all T = 5 K scans

% reslution parameters:
load('res0.mat')

T   = 5;
Q   = [1.04 1.08 1.16 1.25 1.29 1.33 1.38 1.42 1.50];
detId = 2;
dat  = ID28_importtxt(T,Q,detId,Icorr);
peak0 = [];
peak0(1,:) = [ 9 1e-3 5, 12 1e-3 9, 0     0 0, 0     0 0];
peak0(2,:) = [17 1e-3 1, 23 1e-3 1, 0     0 0, 0     0 0];
peak0(3,:) = [20 1e-3 1, 38 1e-3 2, 0     0 0, 0     0 0];
peak0(4,:) = [15 1e-3 3, 42 1e-3 1, 45 1e-3 1, 65 1e-3 1];
peak0(5,:) = [ 8 1e-3 5,  0    0 0, 0     0 0, 0     0 0];
peak0(6,:) = [ 1 1e-3 5, 40 1e-3 3, 46 1e-3 1, 0     0 0];
%
peak0(7,:) = [ 7 1e-3 3, 32 1e-3 2, 0     0 0, 0     0 0];
peak0(8,:) = [12 1e-3 5, 34 1e-3 1, 40 1e-3 1, 0     0 0];
peak0(9,:) = [10 1e-3 3, 30 1e-3 1, 35 1e-3 1, 59 1e-3 1];

nPeak = size(peak0,2)/3;

% peak labels
lab0 = cell(1,size(peak0,2));
for ii = 1:nPeak
    lab0(3*(ii-1)+(1:3)) = cellfun(@(C)num2str(ii,[C '%d']),{'x' 'A' 'wL'},'uniformoutput',false);
end
lab0 = {'x0' 'mu' 'wG' 'wL' 'A0' 'wL0' lab0{:} 'T' 'BKG1'};

clear fitRes

for ii = 1:numel(Q)
    % [x0 mu wG wL | A0 wL0 | x1 A1 wL1 | ... xN AN wLN T BKG1]
    pin0 = peak0(ii,:)>0;
    [datfit(ii), fitRes(ii)] = fits(dat(ii),'ID28_specfun2',...
        [0 res0(detId,:), 1e-3 0, peak0(ii,:),  T, 0 ],[1 0 0 0, 1 1, pin0 0 0],'fcp',[0.0001 40 0.0001]);
end

pvals = [fitRes(:).pvals]';
evals = [fitRes(:).evals]';


%% plot1 fit results
figure

for ii = 1:numel(Q)
    subplot(3,3,ii)
    
    %plot(datfit(ii),'semilogy')
    plot(datfit(ii))
    title(num2str([Q(ii) fitRes(ii).chisq],'QH = %4.2f, chi2 = %4.2f'))
    hold on
    dats=struct(datfit(ii));
    xlim0(ii,:) = [dats.x(1) dats.x(end)];
    dy = (max(dats.y)-min(dats.y))/10;
    %semilogy(dats.x,dats.y-dats.yfit-dy,'r-')
    x = linspace(xlim0(ii,1),xlim0(ii,2),501);
    for jj = 1:(nPeak+1)
        y = ID28_specfun2(x,pvals(ii,:),[],jj);
        plot(x,y,'g-','linewidth',2)
    end
    xlim(xlim0(ii,:))
    line(xlim0(ii,:),[1 1]*fitRes(ii).pvals(end),'color','g')
    ylim auto
    yLim = ylim;
    ylim([0 yLim(2)]);
end

%saveas(gcf,'~/Documents/structures/LiCrO2/ID28/results/fit5K')

%% logplot fit results

% strawberry
cStr = [210 19 23]/255;
cGr  = [89 176 53]/255;

clf

yL = [...
    5e-6 2e-2;  5e-6 1e-2;...
    5e-6 1e-2;  5e-6 5e-3;...
    5e-6 2e-3;  5e-6 2e-3;...
    5e-6 2e-3;  5e-6 2e-3;...
    5e-6 2e-3;...
    ];

nPeak = [4 4 4 4 3 4 4 4 4 ];

for ii = 1:numel(Q)
    subplot(5,2,ii)
    
    [pp,ll,qq] = plot(datfit(ii),'.','semilogy',1);
    pp.MarkerFaceColor=cGr;
    ll.Color = 'k';
    qq.Color = ones(1,3)*0.5;
    %plot(datfit(ii))
    title(num2str([Q(ii) fitRes(ii).chisq],'QH = %4.2f, chi = %4.2f'))
    hold on
    dats=struct(datfit(ii));
    xlim0(ii,:) = [dats.x(1) dats.x(end)];
    dy = (max(dats.y)-min(dats.y))/10;
    %semilogy(dats.x,dats.y-dats.yfit-dy,'r-')
    
    x = linspace(xlim0(ii,1),xlim0(ii,2),501);
    for jj = 1:(nPeak(ii)+1)
        y = ID28_specfun2(x,pvals(ii,:),[],jj);
        plot(x,y,'-','linewidth',2,'color',cStr)
    end
    %xlim([-5 xlim0(ii,2)])
    xlim([-5 70])
    line(xlim0(ii,:),[1 1]*fitRes(ii).pvals(end),'color','g')
    ylim(yL(ii,:));
    set(gca,'YTick',[1e-5 1e-4 1e-3 1e-2])
    xlabel('')
end

%saveas(gcf,'~/Documents/structures/LiCrO2/ID28/results/fit5K')

%% extract values

% parameter values
pvals0=[fitRes(:).pvals];
evals0=[fitRes(:).evals];

% peak pos
xP = cat(3,pvals0([7:3:end-3],:),evals0([7:3:end-3],:));

% peak amplitude
AP = cat(3,pvals0([8:3:end-3],:),evals0([8:3:end-3],:));

% peak width
wP = cat(3,pvals0([9:3:end],:),evals0([9:3:end],:));




%% plot2 fit results

Qreal = [1.0417 1.083 1.1667 1.25 1.2916 1.333 1.375 1.4167 1.5];

figure
clear hPlot
clf
i0 = 3;
for ii = i0:numel(Q)
    yShift = (Qreal(ii)-1.1667)*3*3e-4*6;
    %yShift = (ii-i0)*3e-4;
    
    [hPlot(ii-i0+1), hErr] = plot(dat(ii)+yShift,'ro');
    hPlot(ii-i0+1).MarkerEdgeColor = [0 0 0];
    hErr.Color = [0 0 0];
    hold on
    dats=struct(datfit(ii));
    xlim0(ii,:) = [dats.x(1) dats.x(end)];
    dy = (max(dats.y)-min(dats.y))/10;
    %semilogy(dats.x,dats.y-dats.yfit-dy,'r-')
    x = linspace(xlim0(ii,1),xlim0(ii,2),501);
    for jj = nPeak+1
        y = ID28_specfun2(x,pvals(ii,:),[],jj);
        plot3(x,y+yShift,x*0+1e2,'r-','linewidth',2,'color',[0.8 0.6 0.6])
    end
    line([-30 30],[1 1]*yShift,'color','k','linestyle','--')
    pLx = get(dat(ii),'x');
    pLy = get(dat(ii),'y');
    pLx = [x fliplr(pLx')];
    pLy = [y fliplr(pLy')];
    patch(pLx,pLy+yShift,'r','edgecolor','r','facecolor',[1 0.3 0.3]);
    % plot full fit
    y = ID28_specfun2(x,pvals(ii,:));
    plot3(x,y+yShift,x*0+1e2,'r-','linewidth',2,'color',[0.8 0.6 0.6])
 
    text(19,yShift+1.5e-4,1e2,sprintf('Q = (%5.3f,%5.3f,0))',[Qreal(ii) Qreal(ii)]),'fontsize',15);
end
axis([-7 30 0 2.8e-3])
%legend(hPlot(i0:end),num2str(repmat(Qreal(i0:end)',[1 2]),'Q = (%5.3f,%5.3f,0))'));

%% plot3 fit results

figure
subplot(1,2,2)
cla
clear hPlot

i0 = 3-2;
mult = [1/8 1/8 6/8 3 5 5 5 5 1]*0.8;
col = 'rgbmcykrgbk';

for ii = i0:numel(Q)
    %yShift = (Qreal(ii)-1.1667)*3*3e-4*6;
    yShift = (ii-i0)*5e-4;
    dat2p = dat(ii);
    dat2py = ID28_specfun2(get(dat2p,'x'),pvals(ii,:),[],nPeak(ii)+1);
    dat2p = set(dat2p,'y',get(dat2p,'y')-dat2py);
    
    [hPlot(ii-i0+1), hErr] = plot(mult(ii)*dat2p+yShift,'r.');
    hPlot(ii-i0+1).MarkerEdgeColor = [0 0 0];
    hErr.Color = [0 0 0];
    hold on
    dats=struct(datfit(ii));
    xlim0(ii,:) = [dats.x(1) dats.x(end)];
    dy = (max(dats.y)-min(dats.y))/10;

    x = linspace(xlim0(ii,1),xlim0(ii,2),501);

    line([-30 30],[1 1]*yShift,[1 1]*1e2,'color','k','linestyle','--')
    pLx = get(dat2p,'x');
    pLy = get(dat2p,'y');
    pLx = [pLx' pLx(end) pLx(1)];
    pLy = [pLy' 0 0]*mult(ii);
    %patch(pLx,pLy+yShift,'r','edgecolor','r','facecolor',[1 0.3 0.3]);
    % plot full fit
    %y = ID28_specfun2(x,pvals(ii,:))-ID28_specfun2(x,pvals(ii,:),[],nPeak+1);
    %plot3(x,y*mult(ii)+yShift,x*0+1e2,'r-','linewidth',2,'color',[0.8 0.6 0.6])
    % plot fit components
    for jj = 1:4
        y = ID28_specfun2(x,pvals(ii,:),[],jj)-ID28_specfun2(x,pvals(ii,:),[],nPeak(ii)+1);
        plot3(x,y*mult(ii)+yShift,x*0+1e2,'-','linewidth',2,'color',col(jj))
    end
 
    text(19,yShift+3.8e-4,1e2,sprintf('Q = (%5.3f,%5.3f,0))',[Qreal(ii) Qreal(ii)]),'fontsize',15);
    text(2,yShift+3.8e-4,1e2,sprintf('%dx',round(mult(ii)/0.8*8)),'fontsize',25)
end

% half width
HWHM = 1.469;

axis([-7 30 0 2.3e-3])
axis([0 30 0 2.3e-3])
axis([0 30 0 3.5e-3])
line([0 0],[0 3e-3],[1e3 1e3],'color','k','linestyle','--')
patch([0 HWHM HWHM 0],[0 0 3 3],[-1 -1 -1 -1],'k','facecolor',[1 1 1]*0.7,'edgecolor',[1 1 1]*0.9)
ylim([0 4.5e-3])

line(pvals(1,7)+HWHM*[-1 1],0.2e-3*[1 1],'color','r','linewidth',2)
% % plot grid
% set(gca,'color',[1 1 1]*0.9);
% grid off
% for ii = 1:7
%     line([0 30],[1 1]*ii*0.5e-3-0.25e-3,[0 0]-5,'color','w','linewidth',2)
% end
% for ii = 1:5
%     line([1 1]*ii*5,[0 4e-3],[0 0]-5,'color','w','linewidth',2)
% end

%% plot fit results for Fig. 3.

clf

i0 = 1;
ymax = [100 40 8 2 2 2 2 2 8]*1e-4;

for ii = i0:numel(Q)
    %subplot(6,2,mod((ii*2-1),6))
    subplot(6,2,mod((ii*2-1),12)+(ii>6))
    dat2p  = dat(ii);
    dat2py = ID28_specfun2(get(dat2p,'x'),pvals(ii,:),[],nPeak(ii)+1);
    dat2p  = set(dat2p,'y',get(dat2p,'y')-dat2py);
    
    [hPlot(ii-i0+1), hErr] = plot(dat2p,'r.');
    hPlot(ii-i0+1).MarkerEdgeColor = [0 0 0];
    hErr.Color = [0 0 0];
    hold on
    dats = struct(datfit(ii));
    xlim0(ii,:) = [dats.x(1) dats.x(end)];
    dy = (max(dats.y)-min(dats.y))/10;

    x = linspace(xlim0(ii,1),xlim0(ii,2),501);

    %line([-30 30],[1 1]*yShift,[1 1]*1e2,'color','k','linestyle','--')
    pLx = get(dat2p,'x');
    pLy = get(dat2p,'y');
    pLx = [pLx' pLx(end) pLx(1)];
    pLy = [pLy' 0 0];
    %patch(pLx,pLy+yShift,'r','edgecolor','r','facecolor',[1 0.3 0.3]);
    % plot full fit
    y = ID28_specfun2(x,pvals(ii,:))-ID28_specfun2(x,pvals(ii,:),[],nPeak(ii)+1);
    plot3(x,y,x*0+1e2,'r-','linewidth',2,'color','r')
    % plot fit components
    for jj = 2:3
        y = ID28_specfun2(x,pvals(ii,:),[],jj)-ID28_specfun2(x,pvals(ii,:),[],nPeak(ii)+1);
        plot3(x,y,x*0+1e2,'-','linewidth',2,'color',col(jj))
    end
 
    text(15,0.8*ymax(ii),1e2,sprintf('Q = (%5.3f,%5.3f,0))',[Qreal(ii) Qreal(ii)]),'fontsize',15);
    %title(sprintf('Q = (%5.3f,%5.3f,0)',[Qreal(ii) Qreal(ii)]),'fontsize',15)
    %text(2,3.8e-4,1e2,sprintf('%dx',round(mult(ii)/0.8*8)),'fontsize',25)
    axis([0 30 0 ymax(ii)])
    ylabel ''
    xlabel ''
%     switch ii
%         case 1
%             set(gca,'YTick',[0:2:10]/1000);
%         case 5
%             set(gca,'YTick',[0:2:10]/1e5);
%         case 7
%             set(gca,'YTick',[0:2:10]/1e5);
%     end
    
    if ii~=6 && ii~=9
        set(gca,'XTickLabel','')
    else
        xlabel('Energy Transfer (meV)')
    end
end

% half width
HWHM = 1.469;

%line([0 0],[0 3e-3],[1e3 1e3],'color','k','linestyle','--')
%patch([0 HWHM HWHM 0],[0 0 3 3],[-1 -1 -1 -1],'k','facecolor',[1 1 1]*0.7,'edgecolor',[1 1 1]*0.9)
%ylim([0 4.5e-3])

%line(pvals(1,7)+HWHM*[-1 1],0.2e-3*[1 1],'color','r','linewidth',2)

% % plot grid
% set(gca,'color',[1 1 1]*0.9);
% grid off
% for ii = 1:7
%     line([0 30],[1 1]*ii*0.5e-3-0.25e-3,[0 0]-5,'color','w','linewidth',2)
% end
% for ii = 1:5
%     line([1 1]*ii*5,[0 4e-3],[0 0]-5,'color','w','linewidth',2)
% end

%% instrumental energy resolution
% get FWHM = 2.938, HWHM = 1.469 meV

figure
Q0 = linspace(-15,15,40000);
Ir = ID28_specfun2(Q0,[0 res0(2,:) 0 1 1e-4 1 0 1 0]);

%x0 mu wG wL A0 wL0 x1 A1 wL1
hold on
plot(Q0,Ir,'-g','linewidth',2)

%% save fitted dispersion into a file

disp5K.x = [1.0417 1.083 1.1667 1.25 1.2916 1.333 1.375 1.4167 1.5];
disp5K.y = pvals(:,4+(1:4)*3)';
disp5K.e = evals(:,4+(1:4)*3)';

figure
for ii = 1:4
    errorbar(disp5K.x,disp5K.y(ii,:),disp5K.e(ii,:),'o')
    hold on
end

save('~/Documents/structures/LiCrO2/ID28/disp5K_fit.mat','disp5K')

%% plot dispersion using scatter

Qreal = [1.0417 1.083 1.1667 1.25 1.2916 1.333 1.375 1.4167 1.5];

col = {'r' 'g' 'b' 'k'};

ax = [1 2 0 70];

y0   = pvals(:,4+(1:4)*3)';
r0   = (pvals(:,5+(1:4)*3)');
ysel = bsxfun(@gt,y0,xlim0(:,2)');
y0(ysel) = nan;
pvals(:,4+(1:4)*3) = y0';

col = flipud(royal(5));
col(1,:) = [];
% plot intensity
figure
subplot(2,1,1)
for ii = 1:4
    sHandle(1) = scatter(Qreal,y0(ii,:),r0(ii,:)*2e4+1e-5,'k');
    hold on
    sHandle(2) = scatter(3-Qreal,y0(ii,:),r0(ii,:)*2e4+1e-5,'k');
    plot3(Qreal,y0(ii,:),ii+0*Qreal,'.k')
    plot3(3-Qreal,y0(ii,:),ii+0*Qreal,'.k')
    sHandle(1).MarkerFaceColor = col(ii,:);
    sHandle(1).MarkerFaceAlpha = 0.5;
    sHandle(2).MarkerFaceColor = col(ii,:);
    sHandle(2).MarkerFaceAlpha = 0.5;
    box on
end

xlabel('(H,H,0) (r.l.u.)')
ylabel('Energy Transfer (meV)')


subplot(2,1,2)
y1 = pvals(:,4+(1:4)*3)';
r1 = pvals(:,6+(1:4)*3)'.^2;


for ii = 1:4
    sHandle(1) = scatter(Qreal,y1(ii,:),r1(ii,:)*5+1e-5,'k');
    hold on
    sHandle(2) = scatter(3-Qreal,y1(ii,:),r1(ii,:)*5+1e-5,'k');
    box on
    plot3(Qreal,y0(ii,:),ii+0*Qreal,'.k')
    plot3(3-Qreal,y0(ii,:),ii+0*Qreal,'.k')

    sHandle(1).MarkerFaceColor = col(ii,:);
    sHandle(1).MarkerFaceAlpha = 0.5;
    sHandle(2).MarkerFaceColor = col(ii,:);
    sHandle(2).MarkerFaceAlpha = 0.5;

end
xlabel('(H,H,0) (r.l.u.)')
ylabel('Energy Transfer (meV)')
%print('~/Documents/structures/LiCrO2/ID28/results/licro_disp.pdf','-dpdf')


%% overplot dispersion


%% plot dispersion

Qreal = [1.0417 1.083 1.1667 1.25 1.2916 1.333 1.375 1.4167 1.5];

%figure
hold on

y0 = pvals(:,4+(1:4)*3)';
r0 = (pvals(:,5+(1:4)*3)').^(1/2);

ysel = bsxfun(@gt,y0,xlim0(:,2)');
y0(ysel) = nan;
pvals(:,4+(1:4)*3) = y0';

om = struct;
om.x = Qreal;
om.y = {};
om.z = {};

for ii = 1:numel(Qreal)
    om.y{ii} = y0(:,ii);
    om.z{ii} = r0(:,ii);
end

pvals(pvals==0) = nan;

for ii = 1:4
    pp = errorbar(Qreal-1,pvals(:,4+ii*3)',evals(:,4+ii*3)','or');
    set(pp,'linewidth',1.5);
    hold on
    pp = errorbar(3-Qreal-1,pvals(:,4+ii*3)',evals(:,4+ii*3)','ro');
    set(pp,'linewidth',1.5);
end



%% plot width and intensity of the magnetic peaks

dd = struct;
dd.x = Qreal;
dd.y = pvals(:,8);
dd.e = evals(:,8);
dd = spec1d(dd);

clf
subplot(2,1,1)
plot(dd,'semilogy')
%errorbar(Qreal,pvals(:,8),evals(:,8))
semilogy(Qreal,pvals(:,8),'o-')
xlim([1 1.5])
ylim([min(pvals(:,8)) max(pvals(:,8))]);
xlabel('Q (H,H,0)')
ylabel('Integrated intensity (arb.u.)')
title('Integrated intensity of the magnon peak')
set(gca,'fontsize',14)
subplot(2,1,2)
errorbar(Qreal,pvals(:,9),evals(:,9))
xlim([1 1.51])
ylim([-0.5 12])
xlabel('Q (H,H,0)')
ylabel('FWHM of Lorentzian (meV)')
title('Width of the magnon peak')
set(gca,'fontsize',14)
grid on