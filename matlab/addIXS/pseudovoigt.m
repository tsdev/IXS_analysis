function [y, name, pnames, pin]=pseudovoigt(x,p, flag)
% pseudovoigt     : PseudoVoigt
% function [y, {name, pnames, pin}]=pseudovoigt(x,p, {flag})
%
% MFIT pseudoVoigt fitting function
% p = [ Amplitude Centre width Lorz_width Background ]

% Author:  A.C. Walters, March 2009, MZ <mzinkin@sghms.ac.uk> adapted from DFM
% Description:  Voigt

if nargin==2;
    y = make_pseudovoigt(p,x)+p(5);
else
	y=[];
	name='PseudoVoigt function';
	pnames=str2mat('Amplitude ','Centre','Width',...
						'Mix_param','Background');
	if flag==1, pin=[0 0 1 1 0]; else pin = p; end
	if flag==2
		mf_msg('Click on peak');
		[cen amp]=ginput(1);
		mf_msg('Click on width');
		[width y]=ginput(1);
		width=abs(width-cen);
		mf_msg('Click on background');
		[x bg]=ginput(1);
		amp=amp-bg;
		pin=[amp cen width 0.5 bg];
	end
end
