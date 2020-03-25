function  polrun
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
clc;
clear global
clear functions
global ndim;
global f_in;
global f_out;
ndim=(399);
global fv  ht  qq;
fv=(zeros(1,ndim)); ht=(zeros(1,ndim));qq=(zeros(1,50));
datin='POLRUN.DAT';
c=cell(1,2*ndim);
dat = date;
N=ndim;
[f_in, err_txt]=fopen(datin,'r');     
if ~isempty(err_txt), disp(err_txt); end
[f_out, err_txt]=fopen('polout.t','w');     
if ~isempty(err_txt), disp(err_txt); end
format=' P O L A N    of  FEBRUARY 1993.     Data file: %s       Run: %s\n';

fprintf(f_out, format, datin, dat);

%qq(1)=-1;
quik=0;

while ~feof(f_in)
     [head, fh,dip, amode, valley, list]=readHeader;
     if fh==0,  disp('stop encountered in original fortran code  '); return;end
     if fh==9, quik=1; continue; end
     if fh==-9
         quik=0;
         continue;
     end

    %while ~feof(fileID)
    clear format;
    format='\n%s   FH%5.2f  Dip%5.1f    Amode%5.1f  Valy%6.2f  List %d\n';
    fprintf(f_out,format, head, fh,dip, amode, valley, list);
    fprintf(format, head, fh,dip, amode, valley, list);
    %format=repmat('%f ',[1,11]);
    % fmt=[26,repmat(5,[1,11])];
    % disp(fmt);
    
    % str=fgetl(fid);
    % disp(head);
    % start
    %  disp(fv(1:5));
    %  disp(ht(1:5));
    
    while ~feof(f_in)
        [head,start]=readf(f_in,1,5);
        if(fv(1)==0),break; end;
        clear format;
        format='\r\n%s  Start =%7.3f\n';
        fprintf(f_out,format, head, start);
        fprintf(format, head, start);
        nh=(5);
        while ~(((fv(nh)+ht(nh))==0)&& ht(nh-1)==0)
            if (fv(nh)==-1|nh>ndim-40), break;end
            readf(f_in, nh+1, 8);
            nh=nh+8;
        end
        nh=nh-1;
        while(fv(nh)+ht(nh-1)==0)
            nh=nh-1;
        end
        clear format;
        format=['%6.2f%6.1f',repmat('%8.2f%6.1f',1,6),'\n'];
        c=cell(1,nh*2);
        for i=1:nh, c(2*i-1)=num2cell(fv(i)); c(2*i)=num2cell(ht(i));end
        if(quik<1)
            fprintf(f_out, '\nInput data\n');
            fprintf(f_out, format, c{:});
            if mod(nh,7)~=0, fprintf(f_out, '\n'); end
        end
        if quik>=1, list=0; end
        %fh=(fh); amode=(amode); dip=(dip); list=(list);
        [N,fv,ht,qq]=polan(N,fv,ht,qq,fh,dip,start,amode,valley,list,f_out);
        
        if(quik>=1), continue; end
        c=pcell(fv(1:N+2),ht(1:N+2));
        format=['\n%s\n',repmat(['%6.2f%6.1f',repmat('%8.2f%6.1f',1,6),'\n'],1,10)];
        fprintf(f_out, format, 'Real Heights',c{:});
        if mod(N+2,7)~=0, fprintf(f_out,'\n'); end
        format=['\n%s\n',repmat(['%8.2f',repmat('%10.2f',1,9),'\n'],1,10)];
        if qq(1)>2, fprintf(f_out,format,'Coefficients QQ',qq(1:(fix(qq(1))+1))); end
        if mod(fix(qq(1))+1,10)~=0,fprintf(f_out,'\n'); end
        fprintf(f_out,' ====================================================\n');
    end
end
end



%===========================================================
function [HEAD, FH,DIP, AMODE, VALLEY, LIST]=readHeader()
global f_in;
c=fgetl(f_in); 
if isempty(c), HEAD=[]; FH=0;DIP=0; AMODE=0; VALLEY=0; LIST=0;return; end
HEAD=c(1:25); 
str=c(26:30);
FH=str2double(str);
str=c(31:35);
DIP=str2double(str);
str=c(36:40);
AMODE=str2double(str);
str=c(41:45);
VALLEY=str2double(str);
l=length(c);
if l<50, 
    LIST=0;
else
    str=c(46:50);
    LIST=str2double(str);
end
%[FH,DIP, AMODE, VALLEY, LIST]=strread(c(27:end),'%f %f %f %f %f');
%if isempty(LIST), LIST=0; end
end

function varargout=readf(fid,m,j)
%READF Read data from file.
% j - количество отсчетов записываемых в fv, ht
% m - индекс, с которого записывается в fv, ht

global fv ht ndim;

n=nargout;
c=fgetl(fid);

if isempty(c), varargout{1}='';varargout{2}=0;fv=zeros(1,ndim);ht=zeros(1,ndim);return;end
% disp(n);

if n==2
   [varargout{1}]=c(1:26);
%    c(27:30)
   [varargout{2}]=(str2double(c(27:30)));
   fv=(zeros(1,ndim));ht=(zeros(1,ndim));
   readFH(c,m,5,31);
else
   readFH(c,m,j,1);
end

end


function readFH(str,m,j,k)
global fv ht;

l=length(str);
%disp(l);
for i=1:j
    s=i+m-1;
    n=10*i-10+k;
    if (n+4>l)
        fv(s)=(str2double(str(n:l)));
       % r=fv(s);
        if isnan(fv(s)), fv(s)=(0); end
        %fprintf('str=%s\n',str(n:l));
        %fprintf('fv(%d)=%5.2f\n',s,fv(s));
        %fprintf('ht(%d)=%5.0f\n',s,ht(s));
        return; 
    end
    fv(s)=(str2double(str(n:n+4)));
    if isnan(fv(s)), fv(s)=(str2double(str(n+1:n+4)));end
    if fv(s)>=1000|fv(s)<=-1000, fv(s)=fv(s)/1000; end
   % fprintf('fv(%d)=%5.2f\n',s,fv(s));
    if (n+9>l) 
        ht(s)=(0); 
       % fprintf('ht(%d)=%5.0f\n',s,ht(s)); 
        return; 
    end
    ht(s)=(str2double(str(n+5:n+9)));
    if ht(s)>=1000|ht(s)<=-1000, ht(s)=ht(s)/100; end
    if isnan(ht(s)), ht(s)=(0); end
    %fprintf('ht(%d)=%5.0f\n',s,ht(s));
end
end

%function varargout=read(fid,format)
% str=fgetl(fid);
% n=nargout;
% if isempty(str), i=1:n;  varargout{i}=0;
% return; 
% end
% % disp(n);
% 
% if n==12
%    [varargout{1}]=str(1:26);
%    [varargout{2}]=str2double(str(27:30));
%    %i=3:n;  varargout{i}=0;
%    %k=31;
%    for i=3:n
%        k=49-6*i;
%        varargout{i}=str2double(str(k:k+5));
%        
%    end
%    readFH(c,m,5,31);
% else
%    readFH(c,m,j,1);
% end
% end
% function varargout=readF(str,m)
% n=nargout;
% for i=1:n
%     k=37-6*i;
%     varargout{i}=str2double(str(k:k+5));
%     if i&(varargout{i}>=1000|varargout{i}<=-1000), varargout{i}=varargout{i}/1000; end
% end
% end