function y = nlorbkg2(x,p)
% n-Lorentzian added plus linear background
% p = [ Amp Centre gamma ... Ax B ]


if ismatrix(p) && size(p,2)==1
    p = p';
end

if ismatrix(x) && size(x,1)==1
    x = x';
    flipx = true;
else
    flipx = false;
end

ndimx = ndext.realdim(x);
ndimp = ndext.realdim(p);
nP    = size(p,ndimp);

% cell that can be used to select variable number of dimension of a matrix
selDim = repmat({':'},1,ndimx);


gamma = p(selDim{:},3:3:nP);

nL = floor(size(p,ndimp)/3);

% bakcground
y = bsxfun(@plus,bsxfun(@times,p(selDim{:},nP-1),x),p(selDim{:},nP));


for ii = 1:nL
    
    y = y + bsxfun(@rdivide,p(selDim{:},3*ii-2),(1+bsxfun(@rdivide,bsxfun(@minus,x,p(selDim{:},3*ii-1)),gamma(selDim{:},ii).^2));
    
end

if flipx
    y = y';
end

end