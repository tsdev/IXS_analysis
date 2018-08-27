%% conversion from primitive to hexagonal

T = [1/3 2/3 1/3;-2/3 -1/3 1/3;1/3 -1/3 1/3];

Qhex = [1 1 0]';
Qpri = T*Qhex

%% real space
BV = inv(T)';

Rhex = [0 0 1]';
Rpri = BV*Rhex

%% check cell volume

tri = spinw;
tri.genlattice('lat_const',[2.9010 2.9010 14.4311],'angled',[90 90 120])

BV1 = tri.basisvector;
BV2 = inv(T)';

% basis vector for the primitive cell
BV = BV1*inv(BV2);

V1 = BV1(:,3)'*cross(BV1(:,1),BV1(:,2))
V  = BV(:,3)'*cross(BV(:,1),BV(:,2))

%% phonon basis vectors at Qhex = (1.5,1.5,0)

% probably wrong
%specHex = phonopy_dispersion('~/Documents/structures/LiCrO2/ID28/simulation/sim2/band_hex.yaml');
%specPri = phonopy_dispersion('~/Documents/structures/LiCrO2/ID28/simulation/sim2/band_pri.yaml');
%save('spec_HH0_101.mat','specHex','specPri')

% change all q-points --> qpoints before importing
%cd ~/Documents/structures/LiCrO2/ID28/simulation/sim2
% system('perl -i -pe ''s/q-position/qposition/g'' band.yaml')
%bandHex = YAML.read('~/Documents/structures/LiCrO2/ID28/simulation/sim2/band_hex.yaml');
%bandPri = YAML.read('~/Documents/structures/LiCrO2/ID28/simulation/sim2/band_pri.yaml');

load('bandHH0_501.mat')
%save('band_HH0_101.mat','bandHex','bandPri')

%% load phonon spectrum

%specPri = phonopy_dispersion('~/Documents/structures/LiCrO2/ID28/simulation/sim2/band.yaml');
%save('specPri_HH0_501.mat','specPri')
load('specPri_HH0_501.mat')

%% plot dispersion

spec0 = {specPri specPri};
col   = {'-r' '-b'}; 
figure
pHandle = [];
for ii = 1:2
    spec = spec0{ii};
    nMode = size(spec.Sab,1);
    for jj = 1:nMode
        pHandle(ii) = plot(spec.hkl(1,:),spec.omega(jj,:),col{ii},'linewidth',2);
        hold on
    end
end
axis([1 2 0 100])
legend(pHandle,'hex','pri')
xlabel('Q')
ylabel('Energy (meV)')
%legend(num2str((1:12)'))
% exp(-2*pi*k*t) structure factor

%% extrac eigenvectors for the primitive cell

% basis vectors of the primitive cell
BVp = [-1.446 0.83485 4.803; 0 -1.6697 4.80296; 1.446 0.83485 4.80296]';
% at (1.5,1.5,0) the 2nd and 3rd modes are the interesting ones
% order of the mode is [Li, Cr, O, O], we keep only the Cr polarisation
% vector
modeCr = specPri.Sab(4:6,:,50);

% absolute value of the chromium polarisation
ampCr = sqrt(sum(abs(modeCr).^2,1));

% 2nd & 3rd modes
modeCr(:,[2 3])


%% plot polarisation vector on the same atom different mode

N = 4;
figure;
[~,R] = sw_rot([0 0 1],60*pi/180);
piped(BVp)
hold on
box on
axis equal
vect([],specPri.Sab(3*(N-1)+(1:3),1,50),'color','r','linewidth',5)
vect([],specPri.Sab(3*(N-1)+(1:3),2,50),'color','g','linewidth',3)

%% plot polarisation vector on differet atom the same mode

% plot Q (1,-1,0) of the primitive cell
QA = [1 -1 0]*2*pi*inv(BVp)/3;
Qidx = 251;

nMax = 12;
figure;
col = 'rgbk';
for jj = 1:nMax
    subplot(3,4,jj)
    piped(BVp)
    hold on
    axis equal
    
    for ii = 1:4
        pHandle(ii) = vect([],real(specPri.Sab(3*(ii-1)+(1:3),jj,Qidx)),'color',col(ii),'linewidth',(12-2*ii));
    end
    title(num2str(jj,'Mode%d'))
    box on
    vect(-QA,QA,'linewidth',3,'color','y')
end
legend(pHandle,'Li','Cr','O','O')

%% plot the Cr vector * Qabs for each mode

figure
nMode = size(specPri.Sab,1);
for jj = 1:nMode
    plot(specPri.hkl(1,:),specPri.omega(jj,:),'b','linewidth',2);
    hold on
end

vecCr = specPri.Sab(4:6,:,:);
QA    = [1 -1 0]*2*pi*inv(BVp)/3;

coplC = squeeze(sum(bsxfun(@times,real(vecCr),QA'),1));

% plot intensity
Qsel = 1:10:501;
for ii = 1:12
    sHandle = scatter(specPri.hkl(1,Qsel),specPri.omega(ii,Qsel),100*abs(coplC(ii,Qsel))+1e-3,'g');
    sHandle.MarkerFaceColor = 'g';
    sHandle.MarkerFaceAlpha = 0.5;
    sHandle.MarkerEdgeAlpha = 0.5;
    hold on
end
box on
axis([1 2 0 90])
title('e_{Cr}*Q')
xlabel('(H,H,0)')
ylabel('Energy (meV)')

% plot the mode names
mIdx   = [1 2 4 6 7 9 11 12];
mOm    = [-0.017 0.003+0.8 6.844-0.9 11.524 13.778-0.8  14.159 17.299-1.1 17.408]*sw_converter(1,'THz','meV','photon');
%mLabel = {'A2u','Eu','Eu','A2u','Eg','Eu','A1g','A2u'};

% own calculation
% compared to Bilbao server: http://www.cryst.ehu.es/results/rep/166-6c.html
lab0 = {'Eu' 'A2u' 'A1g' 'Eg'};
mLabel = lab0([2 1 1 1 1 2 4 4 1 3 2 1]);
mIdx = 1:12;
mOm  = specPri.omega(:,1)+[0 4 8, 0 0 0, -5 -3 0, -5 0 -4]';
for ii = 1:numel(mIdx)
    %text(1.02,specPri.omega(mIdx(ii),1),mLabel{ii},'color','k','fontsize',15);
    tHandle = text(1.02,mOm(ii)+2,mLabel{ii},'color','k','fontsize',15);
    % select IR active modes
    if any(strcmp(mLabel{ii},{'A2u' 'Eu'}))
            tHandle.Color='r';
    end
end
text(1.2,8,'Raman active modes','fontsize',15)
text(1.2,13,'IR active modes','fontsize',15,'color','r')
rectangle('Position',[1.18 5 0.38 11])

%% plot dispersion of the two lower modes which contribute to the magnon phonon scattering

om = specPri.omega;
om(abs(coplC)<1e-3) = nan;
om(om>50) = nan;

figure
pHandle = [];
nMode = size(specPri.Sab,1);
for jj = 1:nMode
    plot(specPri.hkl(1,:),om(jj,:),'b.','linewidth',2);
    hold on
end
% remove artefact at Bragg position
om(1:2,[1 end]) = nan;

% 2 omega for each point CHECK!
if numel(om(~isnan(om))) ~= size(om,2)*2
    error('wrong number of omega values!')
end

%% extract individual dispersions

[modeIdx,qIdx] = find(~isnan(om));

linIdx = sub2ind(size(om),modeIdx,qIdx);

om(isnan(om)) = [];
om2 = reshape(om,2,[]);

figure
plot(specPri.hkl(1,:),om2(1,:))
hold on
plot(specPri.hkl(1,:),om2(2,:))

% extract eigenvectors
vecCr = reshape(specPri.Sab(4:6,linIdx),3,2,[]);

% save coupled modes
cMode.hkl   = specPri.hkl;
cMode.omega = om2;
cMode.vecCr = vecCr;

QA    = [1 -1 0]*2*pi*inv(BVp)/3;

intCr = squeeze(sum(bsxfun(@times,real(cMode.vecCr),QA'),1));

for ii = 1:2
    scatter(cMode.hkl(1,:),cMode.omega(ii,:),abs(intCr(ii,:))*100+1e-3,'g')
end

save('Cr_coupled_modes.mat','cMode');

% convert the vector to xyz coordinates
%%

stream = py.file('/Users/tothsa/Documents/structures/LiCrO2/ID28/simulation/sim2/band2.yaml', 'r');

band   = struct(py.yaml.load(stream));
bandPh = cell(band.phonon);

% Y['phonon'][1]['band'][1]['eigenvector']
% select Q point (2nd)
Qidx = 2;
bandQ1 = struct(bandPh{Qidx});
bandM  = cell(bandQ1.band);

nMode = numel(bandMode);

om = zeros(nMode,1);
for ii = numel(bandMode)
    modeN = struct(bandM{ii});
end





    
%% plot unit cell

figure;
piped(BV1,'color','b','linewidth',1);
piped(BV,'color','r','linewidth',1);
axis equal
ax = gca;
ax.XAxisLocation = 'origin';
ax.YAxisLocation = 'origin';

%% check cell volume

licro=spinw('LiCrO2.cif');
BV1 = licro.basisvector;
V   = BV1(:,3)'*cross(BV1(:,1),BV1(:,2));

%%

BV = inv(T)';

Rhex = [0 0 1]';
Rpri = BV*Rhex

