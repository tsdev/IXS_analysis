%% ID28 logbook for LiCrO2

datf = '~/Documents/structures/LiCrO2/ID28/data/combined';
addpath(genpath('/Users/tothsa/Documents/structures/LiCrO2/ID28/matlab'))
cd(datf)
addpath('../../matlab')
col = 'rgbmcykrgbk';
detOrder = [1 6 2 7 3 8 4 9 5];

Icorr = [2.024 1.285 1.1359 1 1.2547 2.6693 3.0843 1.5445 1.916];

%% Q = (1.5 1.5 0), det2

T   = [300 80 60 40];
Q   = 1.5;
det = 2;
[dat,tStr,lStr] = ID28_importtxt(T,Q,det,Icorr);

figure
for ii = 1:4
    plot(dat(ii)+(ii-1)*1e-4,[col(ii) '-'])
    hold on
end

legend(lStr)
title(tStr)
axis([-10 75 0 11e-4])

%% Q = (1.5 1.5 0), all det

T   = 5;
Q   = 1.16;
det = 2;
[dat,tStr,lStr] = ID28_importtxt(T,Q,det,Icorr);


%dat = dat(detOrder);

figure
for ii = 1:9
    plot(dat(ii)+(ii-1)*4e-4,[col(ii) '-'])
    hold on
end
axis([-10 74 0 4e-3])
legend(lStr(detOrder,:))
title(tStr)

%% Q = (1.42 1.42 0), all det

T   = 5;
Q   = 1.42;
det = 2;
[dat,tStr,lStr] = ID28_importtxt(T,Q,det,Icorr);


%dat = dat(detOrder);

figure
for ii = 1:9
    plot(dat(ii)+(ii-1)*1.5e-4,[col(ii) '-'])
    hold on
end
axis([-5 30 0 1.45e-3])
legend(lStr(detOrder,:))
title(tStr)

%% compare different T at Q = (1.16 1.16 0), det2

T   = [5 40];
Q   = 1.16;
det = 2;
[dat,tStr,lStr] = ID28_importtxt(T,Q,det,Icorr);

figure
for ii = 1:2
    plot(dat(ii),[col(ii) '-'])
    hold on
end
axis([-5 40 0 1.45e-3])
legend(lStr)
title(tStr)

%% Q = (1.5 1.5 0), det4

T   = [300 80 60 40];
Q   = 1.5;
det = 4;
[dat,tStr,lStr] = ID28_importtxt(T,Q,det,Icorr);

figure
for ii = 1:4
    plot(dat(ii)+(ii-1)*1e-4,[col(ii) '-'])
    hold on
end

legend(lStr)
title(tStr)
axis([-10 75 0 11e-4])


%% Q = (1.25 1.25 0), det2

T   = [300 80 60 40];
Q   = 1.25;
det = 2;
[dat,tStr,lStr] = ID28_importtxt(T,Q,det,Icorr);

figure
for ii = 1:4
    plot(dat(ii)+(ii-1)*1e-4,[col(ii) '-'])
    hold on
end

legend(lStr)
title(tStr)
axis([-10 75 0 11e-4])

%% T = 40 K, det2

T   = 40;
Q   = [1.16 1.25 1.33 1.42 1.5];
det = 2;
[dat,tStr,lStr] = ID28_importtxt(T,Q,det,Icorr);
iShift = 1e-4;

figure
for ii = 1:numel(dat)
    plot(dat(ii)+(ii-1)*iShift,[col(ii) '-'])
    hold on
end

legend(lStr)
title(tStr)
axis([-10 75 0 11e-4])

%% fit test

x = linspace(-50,50,1001);
AE = 0.3;
x0 = 15; % meV
A  = 1;
mu = 0.5;
wG = 3;
wL = 3;
T  = 50; % K
p = [x0 A mu wG wL T];

y = ID28_specfun(x,[0 AE mu wG wL x0 A mu wG wL T]);

clf
plot(x,y)

%% fit data

T   = 300;
Q   = 1.5;
det = 2;
[dat,tStr,lStr] = ID28_importtxt(T,Q,det,Icorr);

figure
plot(dat,'r-')
title(tStr)

AE = 8e-4;
x0 = [29.23 35 59]; % meV
A  = 8e-4;
mu = 0.5;
wG = 3;
wL = 3;
T  = 300; % K
p = [0 AE mu wG wL x0(1) A mu wG wL x0(2) A mu wG wL x0(3) A mu wG wL T];


dats = struct(dat);
EN = dats.x;
y = ID28_specfun(EN,p);
hold on
plot(EN,y,'b','linewidth',2)

[dat,fitRes] = fits(dat,'ID28_specfun',p,p*0+1);
clf
for ii = 1:4
    plot(EN,ID28_specfun(EN,fitRes.pvals,[],ii),'g-','linewidth',2)
    hold on
end
[p1, p2, p3] = plot(dat);
set(p3,'color','r')

%% test resolution

TTH = 35.0693;
Si_reflection = 9; 
analy_wid = 20; % mm
analy_hei = 55; % mm
samp_anal_dist = 7000; % mm

[Q_chosen,Q_actual,Q_figure,Q_res]= single_analyser(TTH,Si_reflection,analy_wid,analy_hei,samp_anal_dist)

%% plot measured data


% T = 40 K
Q40    = [1.167 1.25 1.33 1.42 1.5];
E40    = {};
E40{1} = [20.8 15.73 NaN 12.51 10.33];
E40{2} = [38.0 41.78 NaN NaN   30.15];

% T = 5 K
Q5    = [1.08 1.17 1.25 1.29 1.33 1.38 1.42 1.50];
E5    = {};
E5{1} = [16.26 21.24 16.20 6.39 2.59 6.85 10.45 10.34];
E5{2} = [23.05 37.94 42.01 NaN 39.80 NaN 34.76 30.55];
E5{3} = [NaN   NaN   NaN   NaN 46.11 NaN 39.29 35.68];
E5{4} = [NaN   NaN   65.02 NaN NaN   NaN NaN   60.32];


w5    = {};
% elastic width
w5E   = [0.41 0.07 0.00 0.22 0.00 0.20 0.00 0.05];
w5{1} = [0.59 3.82 1.23 8.50 10.12 4.75 5.74 0.89];
w5{2} = [0.53 0.85 3.50 NaN 3.07 NaN 1.26 1.99];
w5{3} = [NaN  NaN  NaN  NaN 2.76 NaN 1.46 1.08];
w5{4} = [NaN  NaN  1.76 NaN NaN  NaN NaN  0.12];

figure;
for ii = 1:numel(E5)
    plot(Q5,E5{ii},[col(ii) 'o'],'markerfacecolor',col(ii))
    hold on
end
for ii = 1:numel(E5)
    for jj = 1:numel(Q5)
        line([0 0]+Q5(jj),E5{ii}(jj)+[-1 1]*w5{ii}(jj),'color',col(ii),'linewidth',2)
    end
end

for ii = 1:numel(E40)
    %plot(Q40,E40{ii},[col(ii) 'o'],'markerfacecolor',col(ii))
    plot(Q40,E40{ii},[col(ii) 'o'],'markerfacecolor','k')
    hold on
end

%plot(Q,E2,'bo','markerfacecolor','b')
xlabel('(H,H,0) (rlu)');
ylabel('Energy Transfer (mev)')

line([4/3 4/3],[0 70],'linestyle','--','color','k')
axis([1 1.5 0 75])

%% get approximate detector normalizations
% needs to be corrected for plexaglass structure factor

[Plexi, datastr, ~, ~] = specdata('~/Documents/structures/LiCrO2/ID28/data/LiCrO.fourc',92);

datastr = cellstr(datastr)';

for idx = 1:9
    hIdx(idx) = find(strcmp(datastr,sprintf('deta%d',idx)));
end
Plexi = Plexi(:,hIdx);

figure;
for ii = 1:9
    plot(Plexi(:,ii))
    hold on
end

nInt = sum(Plexi,1)/size(Plexi,1);
nInt(9) = max(Plexi(:,9));
nInt = nInt/max(nInt);


%% fit a single scan

res999 = [...
    0.658240,3.019813,3.019813; 0.653311,2.921084,2.921084;...
    0.650948,2.947347,2.947347; 0.631650,2.932882,2.932882;...
    0.637999,2.974501,2.974501; 0.643725,2.830674,2.830674;...
    0.646920,2.930675,2.930675; 0.664114,2.798965,2.798965;...
    0.678832,2.859026,2.859026];


T   = 5;
Q   = 1.5;
det = 2;
[dat,tStr,lStr] = ID28_importtxt(T,Q,det,Icorr);

T0 = 7;
pInst = res999(det(1),:);
p0 = [T0 pInst, 0 2.5e-3 0, 10 1.5e-3 0, 36 4.5e-3 2, 60 4e-3 0];

nLine = (numel(p0)-4)/3;
bnd = [0 500;0 1;0 10;0 10;repmat([0 100;1e-5 Inf;0 5],nLine,1)];
[datf, fitRes] = fits(dat,'fitfun.IXSspecfun',p0,[0 0 0 0, 1 1 1, [1 1 1, 1 1 1, 1 1 1]*0],'bounds',bnd);

figure
plot(datf)





