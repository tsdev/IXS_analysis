function Q = ID28_momentum(tth,lambda)
% return the momentum trnsfer vectors
%
% Q = ID28_MOMENTUM(tth, lambda)
%
% The function returns a Q matrix with [3 nDet] dimensions. Each column
% corresponds to the corresponding detector index. The momentum on det2 is
% along the x-axis.
%
% Input:
%
% tth       2Theta value in degree.
% lambda    Wavelength in Angstrom.
%
% Output:
%
% Q         Matrix with dimensions [3 nDet].
%

% detector angle differences
anai  = [1 6 2 7 3 8 4 9 5];
dtth0 = [0 0.741 1.52 2.27 3.05 3.79 4.57 5.30 6.09];

% relative to det2 and sort
dtth0 = dtth0-dtth0(3);

dtth = zeros(1,9);
dtth(anai) = dtth0;
dtth = dtth';

% incident and scattered beam vectors
ki = [2*pi/lambda 0 0];
kf = ki(1)*[cosd(tth+dtth) sind(tth+dtth) dtth*0];

% momentum transfer
Q0 = bsxfun(@minus,kf,ki);

% rotate det2 momentum to [1 0 0]
R = sw_rotmatd([0 0 1],-atan2d(Q0(2,2),Q0(2,1)));

Q = (R*Q0');

end