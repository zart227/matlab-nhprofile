function [ varargout ] = ini( varargin )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
n=nargout;
for i=1:n; 
    if isempty(varargin{i}), 
        l=length(varargin{i});
        if l>1
            varargout{i}=zeros(1,l);
        else
            varargout{i}=0;
        end
    else
        varargout{i}=varargin{i};
    end, 
end

end

