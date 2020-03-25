function [ x ] = psign( x,y )
%Sign function (signum function)
%   The value of the sign function, sign(x,y), for:
% 
% y >= 0 is abs(x).
% y < 0 is -abs(x).
if y>=0, x=abs(x);
else x=-abs(x); end
end

