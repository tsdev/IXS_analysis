function sout=sign(varargin)
k=1;
for i=1:length(varargin)
    for j=1:length(varargin{i})
        if isa(varargin{i}(j),'spec1d')
            s1(k)=varargin{i}(j);
            k=k+1;
        end
    end
end

for i=1:(k-1)
    r.x=s1(i).x;
    r.y=sign(s1(i).y);
    r.e=zeros(size(s1(i).x));
    if ~isempty(s1(i).yfit)
        r.yfit=sign(s1(i).yfit);
    end
    r.x_label=s1(i).x_label;
    r.y_label=s1(i).y_label;
    r.datafile=s1(i).datafile;
    sout(i)=spec1d(r);
end