function [ fv,ht ] = reduce( fv,ht )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
global B Q fh mode fa ha lbug
global fc 
global maxb nr mt jm lk kr kv mf f_out
format7=[' reduce:',repmat('%8.3f',1,15)];
k=mf;
fred=fv(mf)+.04*mode;
while 1
    k=k+1;
    if abs(ht(k))>40&fv(k)<=fred, continue 
    else break, end
end
kv1=kv+1;
kvm=min(k-1,kv+maxb-nr);
if lbug==7, fprintf(f_out,format7,ht{kv1:kvm});end
[~,fv,ht]=coefic(kv-kvm,fv,ht);   
if lbug==7, fprintf(f_out,format7,ht{kv1:kvm}); end
if jm<=0, return, end
for k=kv1:kvm
    if abs(ht(k))<ha, break, end
end
if abs(ht(k))<ha&&k<=kvm
    format52=['*****reduce: data error at f, h =',repmat('%8.3f',1,6),'%5d',' end >>>>\n'];
    if lbug>=-9, fprintf(f_out,format52,fv(k-1),ht(k-1),fv(k),ht(k),fv(k+1),ht(k+1),k); end
    while 1
        fv(k)=fv(k-1);
        ht(k)=ht(k-1);
        k=k-1;
        if k<=kv-4, break, end
    end
    kv=kv1;
end
mq=mt+min(lk,0);
lk=max(lk,1)+1; 
far=fv(kr);
g2=Q(1);
for l=lk:kr
    fl=fv(l-1);
    fn=fv(l);
    avn=(fl^2+fn*(fl+fn))/3;
    ha=ht(l);
    dh=ha-ht(l-1);
    deltf=fn-fa;
    g1=g2;
    if fn~=fc&&fn>fa, g2=sumval(mq,Q,deltf,2); end
    if fn==fc||fn<fa, avn=avn+fn*(fn-fl)/3; end
    dh=dh+(g2-g1)*(fl+fn)*(fn-fl)^2/(12*avn);
    fh=gind(0,ha);
    k=kvm;
    while 1
        k=k+1;
        f=fv(k);
        if (f==-1), break, end
        fr=f;
        hv=ht(k);
        if hv==0&&ht(k+1)==0, break, end
        if abs(hv)<=40, continue, end
        if f<0&&f>-fh, [fv]=f90(fv,ht,k); break, end
        if f<0, fr=sqrt((f+fh)*f); end
        if fr<far, [fv]=f90(fv,ht,k); break, end
        tav=sqrt(1-avn/fr^2);
        ht(k)=hv-gind(f,tav)*dh*psign(1,hv);
        if lbug==7, fprintf(f_out,format7,fl,fn,tav,dh,f,v,ht(k)); end
    end
end
lk=kr;        
end
function [fv]=f90(fv,ht,k)
global f_out lbug
format52=['*****reduce: data error at f, h =',repmat('%8.3f',1,6),'%5d',' end >>>>\n'];
if lbug>=-9, fprintf(f_out,format52,fv(k-1),ht(k-1),fv(k),ht(k),fv(k+1),ht(k+1)); end
fv(k)=-1;
end
