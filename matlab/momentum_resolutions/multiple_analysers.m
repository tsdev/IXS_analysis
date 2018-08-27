function [Q_chosen,Q_actual,Q_arrays,Q_res]=multiple_analysers(tth_chosen_A2,reflection,analysers_ext)

% MULTIPLE ANALYSERS: For a given tth in degrees for analyser 2 
% (tth_chosen_A2) and order of Si reflection (i.e. 9), MULTIPLE ANALYSERS 
% calculates (all Q are in inverse Angstroms):
%
% The chosen values of Q (Q_chosen) for all 9 analysers
% The actual mean average magnitude of Q (Q_actual) for all 9 analysers: 
% this can differ from the chosen value, especially when tth is small 
% The objects Q_arrays, which contain for all 9 analysers:
%   Q_arrays.Q_figure<i>.Q_horiz, a 2D array of size (arb_num_horiz,arb_num_verti)
%   containing the horizontal components of Q over the analyser slit for
%   analyser i
%   Q_arrays.Q_figure<i>.Q_verti, a 2D array of size (arb_num_horiz,arb_num_verti)
%   containing the vertical components of Q over the analyser slit for
%   analyser i
%   Q_arrays.Q_figure<i>.Q_mag, a 2D array of size (arb_num_horiz,arb_num_verti)
%   containing the magnitudes of Q over the analyser slit for analyser i 
%   Q_arrays.Q_figure<i>.Q_diff, a 2D array of size (arb_num_horiz,arb_num_verti)
%   containing the difference between the actual Q and the chosen Q 
%   over the analyser slit for analyser i (Q_figure.Q_mag - Q_chosen)
% The total range of momenta incident on the analyser as defined by the
% slits is given for all 9 analysers in Q_res. Q_res has (num_analysers,2) 
% elements. The (i,1) element is the horizontal momentum resolution for
% analyser i whereas (i,2) element is the vertical momentum resolution for 
% analyser i. 
%
%
% Additional inputs:
%
% The analyser slit extents in millimetres (analysers_ext) in a array of 
% (num_analysers,2) elements. The (i,1) element is the width of the slit 
% for analyser i, whereas (i,2) element is the height of the slit for 
% analyser i. 
%
% Example usage:
%
% analysers_ext=[20 60;20 60;20 60;20 60;20 60;20 60;20 60;20 60;20 60];
% [Q_chosen,Q_actual,Q_arrays,Q_res]=multiple_analysers(1.6,11,analysers_ext);
% [Q_chosen,Q_actual,Q_arrays,Q_res]=multiple_analysers(30,9,analysers_ext);
%
% ACWalters 3rd December 2009


% List of tth offsets relative to analyser 2, given in degrees. The 
% offsets are arranged so that tth_offsets(i) corresponds to 
% analyser number i.
% Can be altered if more accurate values become available
tth_offsets=[-1.52 0.00 1.52 3.05 4.57 -0.78 0.746 2.26 3.78];

% The distance between the sample and analyser number i is provided in
% samp_anal_dist(i), given in millimetres.
% Can be altered if more accurate values become available
samp_anal_dist=[6605 6550 6630 6550 6605 7050 7130 7130 7050];

% A simple loop which runs the function single_analyser 9 times for each
% analyser and calculates errorbars
Q_res=[];
for i=1:length(tth_offsets)
    eval(['[Q_chosen(i,1),Q_actual(i,1),Q_arrays.Q_figure' num2str(i) ',Q_res' num2str(i) ']=single_analyser(tth_chosen_A2+tth_offsets(i),reflection,analysers_ext(i,1),analysers_ext(i,2),samp_anal_dist(i));']);
    eval(['Q_res=[Q_res;Q_res' num2str(i) '];']);
end

% EXAMPLE SCRIPT TO PLOT COLOUR FIGURES OF THE MEASURED Q FOR ANALYSERS 1 AND 9
%
% hf1=figure;
% set(hf1,'color','w','units','normalized','position',[0.02 0.05 0.3 0.85])
% ha=axes;
% set(ha,'DataAspectRatio',[1 1 1])
% hs = surface(Q_arrays.Q_figure1.Q_horiz,Q_arrays.Q_figure1.Q_verti,Q_arrays.Q_figure1.Q_diff);
% axis tight
% box on
% set(hs,'edgecolor','none')
%
% hf9=figure;
% set(hf9,'color','w','units','normalized','position',[0.02 0.05 0.3 0.85])
% ha=axes;
% set(ha,'DataAspectRatio',[1 1 1])
% hs = surface(Q_arrays.Q_figure9.Q_horiz,Q_arrays.Q_figure9.Q_verti,Q_arrays.Q_figure9.Q_diff);
% axis tight
% box on
% set(hs,'edgecolor','none')