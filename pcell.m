function  c = pcell(varargin)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
l=length(varargin{1});
n=nargin;
c=cell(1,l*n);
for i=1:n
    for j=1:l,
        c(n*j-n+i)=num2cell(varargin{i}(j));
    end
end
end

