function [Q_chosen,Q_actual,Q_figure,Q_res]=single_analyser(tth_chosen,reflection,analy_wid,analy_hei,samp_anal_dist)

% SINGLE_ANALYSER: For a given tth (in degrees) and order of Si reflection 
% (i.e. 9), SINGLE_ANALYSER calculates  (all Q are in inverse Angstroms):
%
% The chosen value of Q (Q_chosen)
% The actual mean average magnitude of Q (Q_actual): this can differ from 
% the chosen value, especially when tth is small 
% The object Q_figure, which contains:
%   Q_figure.Q_horiz, a 2D array of size (arb_num_horiz,arb_num_verti)
%   containing the horizontal components of Q over the analyser slit   
%   Q_figure.Q_verti, a 2D array of size (arb_num_horiz,arb_num_verti)
%   containing the vertical components of Q over the analyser slit 
%   Q_figure.Q_mag, a 2D array of size (arb_num_horiz,arb_num_verti)
%   containing the magnitudes of Q over the analyser slit 
%   Q_figure.Q_diff, a 2D array of size (arb_num_horiz,arb_num_verti)
%   containing the difference between the actual Q and the chosen Q 
%   over the analyser slit (Q_figure.Q_mag - Q_chosen)
% The Q_resolution in the horizontal and the vertical
% (Q_res=[Q_res_horizontal Q_res_vertical])
%
% Additional inputs:
%
% The analyser slit width in millimetres (analy_wid)
% The analyser slit height in millimetres(analy_hei)
% The distance between the sample and the analyser slits in millimetres (samp_anal_dist)
%
% Example usage:
% [Q_chosen,Q_actual,Q_figure,Q_res]=single_analyser(1,11,20,60,7000);
% [Q_chosen,Q_actual,Q_figure,Q_res]=single_analyser(0.1,9,20,60,7000);
%
% ACWalters Bonfire Night November 2009


% Set up conversion from Si reflection into Ei
energy=ones(15,1);
energy(7)=13.83935;
energy(8)=15.81640;
energy(9)=17.79345;
energy(11)=21.747556;
energy(12)=23.724572;
energy(13)=25.7016568;

% Convert chosen tth into chosen Q
Q_chosen=tth2Q(tth_chosen,energy(reflection));

% Set up arbitrary sizes of Q arrays: more elements, more accurate, but
% program is slower. Can be made smaller if program is running slowly
arb_num_horiz=200;
arb_num_verti=200;

% Write 2D arrays in real space which define the real space horizontal and
% vertical extent of the analyser slit, with the origin at the centre of
% each
anal_grid_horiz=repmat([-0.5*analy_wid:analy_wid/(arb_num_horiz-1):0.5*analy_wid],arb_num_verti,1);
anal_grid_verti=repmat([-0.5*analy_hei:analy_hei/(arb_num_verti-1):0.5*analy_hei]',1,arb_num_horiz);

% Calculate the difference in scattering angle between a photon scattered
% into the centre of the analyser and all photons scattered to all 
% positions in the analyser
delta_angle_horiz=2.*atand(0.5.*anal_grid_horiz./samp_anal_dist);
delta_angle_verti=2.*atand(0.5.*anal_grid_verti./samp_anal_dist);

% Calculate horiztonal and vertical components of Q based on differences in
% scattering angle just calculated
Q_figure.Q_horiz=tth2Q(tth_chosen+delta_angle_horiz,energy(reflection));
Q_figure.Q_verti=tth2Q(delta_angle_verti,energy(reflection));

% Calculate total magnitude of Q for all positions in the analyser and the
% difference between this and the chosen Q
Q_figure.Q_mag=sqrt(Q_figure.Q_horiz.^2+Q_figure.Q_verti.^2);
Q_figure.Q_diff=Q_figure.Q_mag-Q_chosen;

% Calculate the mean magnitude of the measured Q
Q_actual=mean(mean(Q_figure.Q_mag));

% Calculate momentum resolution from maximum difference in Q in horizontal
% and vertical
Q_res(1,1)=2*(Q_figure.Q_horiz(1,end)-Q_chosen);
Q_res(1,2)=2*Q_figure.Q_verti(end,1);

% EXAMPLE SCRIPT TO PLOT COLOUR FIGURE OF THE MEASURED Q
%
% hf1=figure;
% set(hf1,'color','w','units','normalized','position',[0.02 0.05 0.3 0.85])
% ha=axes;
% set(ha,'DataAspectRatio',[1 1 1])
% hs = surface(Q_figure.Q_horiz,Q_figure.Q_verti,Q_figure.Q_diff);
% axis tight
% box on
% set(hs,'edgecolor','none')
% colorbar
% xlabel('$Q_{horizontal}$ (\AA$^{-1}$)','interpreter','latex','fontsize',12)
% ylabel('$Q_{vertical}$   (\AA$^{-1}$)','interpreter','latex','fontsize',12)

% EXAMPLE SCRIPT TO PLOT INTERGRATED DEPICTIONS OF THE MEASURED Q IN THE
% VERTICAL AND HORIZONTAL
%
% hf2=figure;
% set(hf2,'color','w','units','normalized','position',[0.32 0.05 0.6 0.85])
% subplot(2,1,1) , plot(Q_horiz(1,:)-Q_chosen,mean(Q_diff,1))
% xlabel('$Q_{horizontal}$ (\AA$^{-1}$)','interpreter','latex','fontsize',12)
% ylabel('Mean difference from chosen $Q$ (\AA$^{-1}$)','interpreter','latex','fontsize',12)
% set(gcf,'color','w')
% subplot(2,1,2) , plot(Q_verti(:,1),mean(Q_diff,2))
% xlabel('$Q_{vertical}$ (\AA$^{-1}$)','interpreter','latex','fontsize',12)
% ylabel('Mean difference from chosen $Q$ (\AA$^{-1}$)','interpreter','latex','fontsize',12)
