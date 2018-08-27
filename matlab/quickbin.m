function data = quickbin(x,y,mon,dxmax)
% bin data and make sure bin width is larger than dx

[x,idx] = sort(x);
y   = y(idx);
mon = mon(idx);

dx = diff(x);

aBin = 0;
bIdx = ones(size(x));

bCounter = 1;

for ii = 2:numel(x)
    aBin = aBin + dx(ii-1);
    if aBin>dxmax
        aBin = 0;
        bCounter = bCounter + 1;        
    end
    bIdx(ii) = bCounter;
end

xSum  = accumarray(bIdx',x);
ySum  = accumarray(bIdx',y);
mSum  = accumarray(bIdx',mon);
N     = accumarray(bIdx',ones(size(y)));

mSum(mSum==0) = 1;

data.x = xSum./N;
data.y = ySum./mSum;
data.e = sqrt(ySum)./mSum;


end