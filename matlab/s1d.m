function status = s1d(str)
% switches spec1d on/off

if nargout>0
    % just return horace status
    if isempty(which('spec1d'))
        status = 'off';
    else
        status = 'on';
    end
    return
end

if nargin == 0
    str = 'on';
end

switch str
    case 'on'
        addpath(genpath('~/spectra_git/spec1d'));
        addpath(genpath('~/spectra_git/load'));
        
    case 'off'
        warn0 = warning;
        warning off
        rmpath(genpath('~/spectra_git/spec1d'));
        rmpath(genpath('~/spectra_git/load'));
        warning(warn0);
    otherwise
        error('s1d:WrongInput','Wrong input string!');
end

end