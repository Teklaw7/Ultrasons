% This function convert a radio-freuqncy image into a bmode image.
% To use it :
%      Bmode = bmode2log(rf_in)
% where 
%   - rf_in is the input RF image
%   - Bmode is the output bmode image
function rf_out = rf2bmode(rf_in)
rf_out = abs(hilbert(rf_in));