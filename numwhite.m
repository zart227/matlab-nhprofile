function [r,white]=numwhite (Y,s1, s2, i, j)
if nargin==5
    l=size(Y);
    if i<=s1, x1=i-1; x2=s1; else x1=s1; x2=s1; end
    if j<=s2, y1=j-1; y2=s1; elseif j>=l(1)-s2, y1=s2; y2=l(1)-j; else y1=s2; y2=s2; end
    c=Y(j-y1:j+y2,i-x1:i+x2);
    [r,white]=rt(c);
elseif nargin==1
    [r,white]=rt(Y);
elseif nargin==2
    c=Y(:,s1);
    [r,white]=rt(c);
elseif nargin==3
    c=Y(:,s1:s2);
    [r,white]=rt(c);
end
function [r,white]=rt(c)
white = sum(c(:));
r=white/numel(c);