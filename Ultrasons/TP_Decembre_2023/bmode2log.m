% This function convert a bmode image into a log-compress image.
% To use it :
%      Im_log = bmode2log(B_in)
%      Im_log = bmode2log(B_in, dB)
% where 
%   - B_in is the input RF image
%   - Im_log is the output log-compress image
%   - dB is an optional argument to impose the dnamic of the log-compressed
%   image. If not given, 40dB is used
function Im_log = bmode2log(B_in, varargin)
thres = 40;
if (nargin==2)
    thres = varargin{1};
end
Im_log = 20*log10(B_in/max(B_in(:))) + thres;
Im_log(Im_log<0) = 0;