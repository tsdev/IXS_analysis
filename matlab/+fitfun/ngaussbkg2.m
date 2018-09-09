function y = ngaussbkg2(x,p)
% n-Gauss added plus linear background
% p = [ Amp Centre FWHM ... Ax B ]


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


c = p(selDim{:},3:3:nP)/2.35482;

nG = floor(size(p,ndimp)/3);

y = bsxfun(@plus,bsxfun(@times,p(selDim{:},nP-1),x),p(selDim{:},nP));

for ii = 1:nG
    
    expx = exp(-0.5*bsxfun(@rdivide,bsxfun(@minus,x,p(selDim{:},3*ii-1)),c(selDim{:},ii)).^2);
    y    = y + bsxfun(@times,p(selDim{:},3*ii-2),expx);
    
end

if flipx
    y = y';
end

end