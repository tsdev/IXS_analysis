function [string_pos, string_line] = ffind2(filename,string, extractallflag)
% [string_pos] = ffind(filename,string)
% It returns a pointer on the 'string' token in file 'filename'.
% An optional third parameter enables scanning of all 'string' positions.
% The matlab function fseek can then be used.
% input : filename and string to search
% output: found string position(s).
%
% Note: this ffind.m routine is used when the ffind.mex file does not exist 

if nargin < 3
  extractall = 0;
else
  extractall = 1;
end

% get already opened files
fids = fopen('all');
string_pos = [];

% open the file
[fid,message] = fopen(filename,'r');
if (fid<0)
   fprintf(1,'ffind: ERROR on %s open: %s\n', filename, message);
   return;
end




% filebuffersize = 1024*500;	% 500 ko buffer search
% stopflag = 0;

% get the file contents
% while (stopflag == 0)

%   filepos = ftell(fid);
  [filestr, counts] = fread (fid);
%   if (counts < filebuffersize) 
%   	  stopflag = 1;	% reach eof
%   end
  filestr=setstr(filestr');

  [scan_no,repeat_no]=strtok(string,'.');
  repeat_no=str2num(repeat_no(2:end));

  string_pos_loc = findstr(filestr, scan_no);

  if ~isequal(repeat_no,[])
      string_pos_loc_chosen=string_pos_loc(repeat_no);
  else
      string_pos_loc_chosen=string_pos_loc(1);
  end
  
  if ~isempty(string_pos_loc)
%         if ~extractall
% %           string_pos_loc(i) = string_pos_loc(i,1);
% %           stopflag = 1;
%         end
        string_pos = (string_pos_loc_chosen+length(string)-1);
  end


if (~isempty(fids) & isempty(find(fids == fid)))
	fclose(fid);
else
	fseek(fid,0,-1);
end

if isempty(string_pos)
	return;
end

