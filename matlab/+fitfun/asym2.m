function y = asym2(x,p)
% p = [AmpGl AmpLl AmpGr AmpGr W1 W2 W3 W4 Center Ax B ]

p = permute(p,[2 1 3]);

AGl = p(:,:,1);
ALl = p(:,:,2);
AGr = AGl+ALl;

wGl = p(:,:,3);
wLl = p(:,:,4);
wGr = p(:,:,5);

x0  = p(:,:,6);

A   = p(:,:,7);
B   = p(:,:,8);

xS    = x-x0;

% background
yBKG = bsxfun(@plus,bsxfun(@times,A,xS),B);

% Lorentzian on the left
yL = bsxfun(@rdivide,ALl,(1+bsxfun(@rdivide,xS,wLl).^2));
    
% Gaussian on the left
yG = bsxfun(@times,AGl,exp(-bsxfun(@rdivide,xS,2*wGl).^2));

% Gaussian on the right
yR = bsxfun(@times,AGr,exp(-bsxfun(@rdivide,xS,2*wGr).^2));

y = (yL + yG).*(xS<0) + yR.*(xS>=0) + yBKG;

end