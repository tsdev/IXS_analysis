%% test

x = linspace(-10,10,100);
y = fitfun.pvoigt(x,[0 1 1 1 1/3]);

IntL = sum(y)*(x(2)-x(1));

figure
plot(x,y)

% Lorentzian to get the right area better than 99%, we need 30 wL grid on
% both sides and at least 100 points.

%%


x = -100:0.1:100;
dx = x(2)-x(1);

%                   [x0 A mu wG wL]
y = fitfun.pvoigt(x,[0  1 0  2*dx 2*dx]);

IntG = sum(y)*(x(2)-x(1))

figure
plot(x,y,'o-')

% Gaussian to get the right area better than 99%, we need 2 wG(FWHM) grid on
% both sides and at least 10 points.

%%

x = linspace(-40,40,560);

x0 = 20;
% Lorentzian
p1 = [1 1 1/3];
% Gaussian
p2 = [0 1 1/3];

y = fitfun.pvoigt2(x,[0 1 p1 p2]);

%figure;
hold on
plot(x,y,'o-')
sum(y)*(x(2)-x(1))


%% test general spectral function

x = linspace(-75,75,203);

x0 = 20;
% Lorentzian
p1 = [1 1 2];
% Gaussian
p2 = [0 0.2 1/3];
% % Lorentzian
% p1 = [1 1 1/3];
% % Gaussian
% p2 = [0 1 1/3];

% elastic line only
%y = fitfun.pvoigt2(x,[0 1 p1 p2]);
y = fitfun.genspecfun(x,[0 0 1 p1 p2 15 1 p1 p2 30 1 p1 p2 45 1 p1 p2 60 1 p1 p2]);
%y = fitfun.genspecfun(x,[0 0 1 p1 p2 45 1 p1 p2]);
%y = fitfun.genspecfun(x,[0 0 10 p1 p2]);

sum(y*(x(2)-x(1)))
%figure;
hold on
plot(x,y,'o-')

%% test IXS spectral function

x = -75:0.6:75;

% instr resolution
pI = [0.5 3 3];
T = 100;

y = fitfun.IXSspecfun(x,[T pI, 0 1 0, 10 1 0]);

sum(y*(x(2)-x(1)))
%figure;
hold on
plot(x,y,'o-')
box on

%% fit data

doc ID28_importmulti
















