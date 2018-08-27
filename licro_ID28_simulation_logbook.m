%% ID28 simulation logbook

T = [1/3 2/3 1;-2/3 -1/3 1;1/3 -1/3 1];

Q_hex = [0 0 0;1 0 0;1 1 0]';

Q_pri = T*Q_hex

%% simulated phonon energies

Q = [1.5 1.5 0];
E = [31 35 60]; % meV

%% import edf files

phDisp = load(iData,'/Users/tothsa/Documents/structures/LiCrO2/ID28/simulation/ab2tds/dispimage.edf');