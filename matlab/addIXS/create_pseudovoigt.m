function y = make_pseudovoigt(x,xdata)

% ACWalters 8/2/10

	I_0 = x(1);
	CEN = x(2);
	gamma = x(3);
	eta = x(4);
    back = x(5);
            
	A = 2/pi;
	B = 2*sqrt(log(2)/pi);
	C = 4*log(2);

	gamma=gamma+1e-10;
    
	F1 = A*(eta/gamma)./(1 + 4*((xdata-CEN)/gamma).^2);
	F2 = B*(1-eta)*(2/gamma);
	F3 = exp(-C*((xdata-CEN)/gamma).^2);     
    
	y = I_0*(F1 + F2.*F3)+back;