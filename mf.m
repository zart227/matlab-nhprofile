function [r1,r2,w1,w2] = mf (Y,i,j,s)
l=size(Y);
x1=s; x2=s;
y1=s; y2=s;
if i<=s, x1=0; elseif i>=l(1)-s, x2=0; end
if j<=s, y1=0; elseif j>=l(2)-s, y2=0; end
% c1=Y(j-2*s1:j)
[r1,w1]=numwhite (Y,s, s, i-x1, j-y1);
[r2,w2]=numwhite (Y,s, s, i+x2, j+y2);
end