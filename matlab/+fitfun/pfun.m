function pp = pfun(x,p0)

% xdim = ndims(x);
% if ismatrix(x) && size(x,2)==1
%     xdim = 1;
% end
% 
% p0 = p0(:);
% 
% permIdx = 1:(xdim+1);
% permIdx(end) = 1;
% permIdx(1)   = xdim+1;
% 
% pp = repmat(premute(p0,permIdx),size(x));
% pp()

Ei = 80;
dE = (1-x/Ei).^(3/2);
pp = repmat(p0(:)',numel(x),1);

% increasing the linewidth
pp(:,3:5) = bsxfun(@times,pp(:,3:5),dE);
% correcting the amplitude
pp(:,1:2) = bsxfun(@times,pp(:,1:2),1./dE);

end
