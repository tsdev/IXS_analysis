function [filenamestem,Xs_interp,Ys,Es,Is_sum,Ns_sum,Es_sum] = msqwadd(datadir,specfile,scan_numbers,T_shifts,Si_refl)

% FUNCTION msqwadd sums ID28 datasets, taking into account any temperature
% drift of the analysers, and outputs the data on an energy transfer scale.
%
% The input arguments are:
% datafile: a string defining the SPEC file containing the data
% run_numbers: a 1D array containing the run/scan numbers which are to be
% summed
% T_shifts: a 2D array with appropriate temperature shifts in Kelvin for
% each analyser for each run, i.e. T_shifts(3,7) would contain the
% temperature shift for the 7th analyser for the 3rd run to be summed.
% Si_refl: a number defining the Si reflection used for the experiment,
% i.e. Si_refl = 9 means the (9 9 9) was used
%
% The output arguments are:
% filenamestem: a string which contains the stem for the output datafiles,
% i.e. if the datafile is called Jim and the run numbers to be summed are 4
% and 5, filenamestem = 'Jim_4_5'
% Xs: calculated 2D energy transfer array in meV: Xs(:,3) contains the 1D
% energy transfer array for analyser 3
% Ys: interpolated 2D intensity array normalised by monitor
% Es: squareroot 2D error array for the Ys, calculated from the interpolated 
% intensities prior to normalisation
% Ts_interp: interpolated 2D array of the temperature difference between
% the analysers and the monochromator
% Is_sum: unnormalised 2D intensity array after summation
% Ns_sum: 2D monitor array after summation
% Es_sum: 2D squareroot errors calculated directly from Is_sum array

% Example usage:
% scan_numbers=[101:103];
% T_shifts=repmat([0.150 -0.130 0.420 0.100 0.100 0.129 0.012 -0.053 -0.02],length(scan_numbers),1);
% [filenamestem,Xs_interp,Ys,Es,Is_sum,Ns_sum,Es_sum] = msqwadd('C:\Walters\ID28\sqwadd\','alphauranium',scan_numbers,T_shifts,9);

close all

analysers=1:9;

% Load data
data = ID28_loaddata(datadir,specfile,scan_numbers);

% Plot unsummed data on T x-axis
[hf,ha,hl]=ID28_DTplotunsummed(data,specfile,scan_numbers,analysers);

T_shifts = ID28_fitelasticline(data,specfile,scan_numbers,analysers,Si_refl);

data = ID28_Tshift(data,specfile,scan_numbers,analysers,T_shifts);

% Calculate energy transfers from Ts
data = temp2energy(data,specfile,scan_numbers,analysers,Si_refl);

% Create interpolated energy scales
Xs_interp=ID28_Xinterpolate(data,specfile,scan_numbers,analysers);

% Sum data
[runs,Is_sum,Ns_sum,Ns_mean,Es_sum,Ys,Es]=ID28_sumdata(data,specfile,scan_numbers,analysers,Xs_interp);

% Plot summed data on E x-axis
[hf_Esummed,ha_Esummed,hl_Esummed]=ID28_Eplotsummed(analysers,Xs_interp,Ys,Es);

% Output data to datafiles
filenamestem = ID28_writedata(datadir,specfile,scan_numbers,Xs_interp,Ys,Es,Is_sum,Ns_sum,Es_sum);