function out = corrspec(X,Y)

nX = numel(X);
nY = numel(Y);

X = X(:)' - mean(X);
Y = Y(:)' - mean(Y);

Y0 = [zeros(size(X)) Y zeros(size(X))];

zC = zeros(1,nX+nY);

for ii = 1:(nX+nY)
    zC(ii) = sum(Y0(ii+(0:(nX-1))).*X)/ii;
end

out.x = -nX:(nY-1);
out.z = zC;

end