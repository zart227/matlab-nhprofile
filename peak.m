function [ fv,ht,qq ] = peak( fv,ht,qq )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
global B Q fh mode mod fa ha tcont lbug;
global hs fc fcc hmax sh parht hval vwidth vdepth xwat
global maxb nf nr nl nx ms mt jm lk kr krm kv mf nc;
global f_out;
persistent hmx qset pq devn fadj hadj
[hmx,qset,devn,fadj,hadj]=ini(hmx,qset,devn,fadj,hadj);
if isempty(pq), pq=zeros(1,20); end
kr=kr+1;
kv=kv+1;
fm=fv(krm);
hn=ht(krm);
ht(krm)=hn;
nk=min(fix(nf*9/(nf+9)),fix(kr/3))+2;
if(fv(kv-nk)<fm*.7), nk=nk-1; end
if(fv(kv-nk)<fm*.85) && (nk>5), nk=nk-1;end
if(mode==10)||(mode>=30), nk=nk-1; end
ka=kv-1-nk;
kb=krm-nk;
sh=max(0.27*hn-21,5);
hmax=hn+0.3*sh;
fh=gind(0,hmax);
mk=nk;
if(fcc>0.1), mk=mk+1;end
fcx=abs(fv(kv+1));
hcx=ht(kv+1);
if(abs(hcx)<=30)&&(fcx>=fm+0.5*fh)
    mk=mk+1;
    fv(kv+1)=fv(kv);
    fv(kv)=fcx;
    ht(kv+1)=ht(kv);
    ht(kv)=hcx;
    kv=kv+1;
end
fv(kr)=fcc;
ht(kr)=ht(kv);
fnext=fv(kv+1);
if(fnext==-1), fnext=0; end
if (fnext<0)
    fnext=sqrt(fnext*(fnext+0.99*fh));
    for i=2:60; if(fv(kv+i)>=0), break; end; end
    fnext=min(fnext,fv(kv+i));
end
for loop=1:3
    pgrad=1;
    for i=1:mk
        f=fv(ka+i);
        if f==fcx, f=sqrt(fcx*(fcx-fh)); end
        w=2^(14*(f-fm)/f)/0.7;
        grad=0;
        if f<=fm
            w=w*0.7;
            mq=mt+min(lk,0);
            grad=4/f/max(sumval(mq,Q,f-fa,2),3);
            if i==nk, grad=grad-grad*0.2*(1-mt/nf)^3; end
        end
        t=sh*grad;
        pgrad=pgrad*20*(max(grad,0.002));
        B(i,1)=w;
        B(i,5)=grad;
        B(i,6)=(log(1+t)-t)*0.25;
        B(i,2)=B(i,6)*w;
        B(i,3)=log(f)*w;
    end
    w=0.1*sqrt(pgrad)+0.02;
    B(mk+1,1)=0;
    B(mk+1,2)=w;
    B(mk+1,3)=w;
    
    format=' peak: nk,mk,sh,w=%3d%3d%6.1f%7.3f';
    if lbug==8, fprintf(f_out,format,nk,mk,sh,w); end
    format=[repmat(' ',1,7),'F, H, G, W=',repmat('%7.2f',1,16),'\n',repmat(' ',1,18),repmat('%7.2',1,16)];
    if (lbug==8) && (loop==1)
       fprintf(f_out,format,fv(kb+1:kb+mk),ht(kb+1:kb+mk),B(1:mk,5),B(1:mk,1));
    end
    [B,pq,devn]=psolve(mk+1,2,B,pq,qset,devn,lbug);
    gmax=B(nk,5);
    erfac=400/(1+mk-nk)/(nk-0.8)*devn;
    qfac=0.1/gmax-0.1/B(fix((nk+1)/2),5);
    if qfac<erfac
        avsh=max(pq(2),0)*0.5+0.5;
        if pq(2)>1, avsh=pq(2)/avsh; end
        [B,pq,devn]=psolve(10,-2,B,pq,avsh,devn,lbug);
    end
    fc=exp(pq(1));
    if (mk==nk)&&(fc>1.5*fm), [B,pq,devn]=psolve(400,-1,B,pq,log(1.5*fm),devn,lbug); end
    sh=sh*sqrt(abs(pq(2)));
    parht=sh*min(log(1+sh*gmax),1.8);
    hmax=hn+parht;
    fh=gind(0,hmax);
    format=['%s',repmat('%10.3f',1,10),'\n',repmat(' ',1,15),repmat('%10.3f',1,10)];
    if lbug==8, fprintf(f_out,format,'qfac,erfac,prht',qfac,erfac,parht);end
    if parht>sh/loop, break; end;
    if qfac<(erfac*2*loop^2), break; end
end
fc=exp(pq(1));
fcn=0;
fcm=fnext*0.8+fm*0.2-0.015;
if (fc>fcm)&&(fcm>fm), fcn=fcm; end
if fc<fm*1.002, fcn=fm*1.002; end
if fcn~=0, [B,pq,devn]=psolve(300,-1,B,pq,log(fcn),devn,lbug); end
fc=exp(pq(1));
shr=pq(2);
sumhw=0;
sumw=0;
fw=fv(max(kb,1));
for i=1:nk
    w=(fv(kb+i)-fw)^2;
    r=4*log((fv(kb+i)/fc));
    zf=sqrt(-2*r);
    for ii=1:3
        rf=1+zf-exp(zf);
        gf=rf-zf;
        zf=zf+(r-rf)/gf;
    end
    zg=log(1+sh*B(i,5));
    zm=zf;
    hlx=hmx;
    hmx=ht(kb+i)+sh*zm;
    
    if lbug==8, fprintf(f_out,format,' f,h, m,w, zf,g=',fv(kb+i),ht(kb+i), hmx,w, zf,zg); end
%    if lbug==8, fprintf(f_out,format,'r,z1:r2,g2:zf,zg', r,z1, r2,g2, zf,zg); end
    sumhw=sumhw+hmx*w;
    sumw=sumw+w;
end
hmax=sumhw/sumw;
if nf>=3
    hadj=hmax-hmx;
    ht(krm)=hn+hadj*0.80;
    ht(krm-1)=ht(krm-1)+(hmax-hlx)*0.40;
    fchap=fc*exp(0.25*(zm-sh*gmax));
    fadj=fchap-fm;
    if lbug==8, fprintf(f_out,format,' fc,fad,hmax,had=',fc,fadj,hmax,hadj);end
end
parht=hmax-ht(krm);
ht(kr)=hmax-0.5*parht;
z=0.5*parht/sh;
fv(kr)=fc*exp(0.25*(1+z-exp(z)));
kr=kr+1;
fv(kr)=fc;
ht(kr)=hmax;
devn=devn*2/(1+mk-nk);
for i=1:1
    if fnext==0, break; end
    fc=min(fc, fnext-0.03);
    dfc=fv(kr)-fc;
    fm=fm-dfc;
    devn=min(devn,0.5*(fnext-fm)/fc);
    if dfc<=0.01, break; end
    format=('* FC reduced from%7.3f   to%7.3f  since next layer starts at%7.3f MHz.\n');
    if lbug>=-9, fprintf(f_out,format,fv(kr),fc,fnext);end
    df=dfc/fv(kr)^3;
    for k=1:kr
        fv(k)=fv(k)-df*fv(k)^3;
    end
    fa=fa-df*fa^3;
end
devf=fc*devn+abs(fadj);
bavge=-B(2,6)-B(nk,6);
devs=sh/shr*devn/bavge;
devh=devn*parht/bavge+devs*sh*gmax+abs(hadj);
tcont=tcont+parht*(fc^2+0.5*fm^2)/1.5;
ssh=sh;
if loop==1, ssh=-sh; end
format='PEAK%7.3f (+/-%5.3f) MHz,  Height%6.1f (+/-%4.1f) km.    ScaleHt%5.1f (+/-%4.1f) km  SlabT%6.1f km\n';
if lbug>=-9, fprintf(f_out,format,fc,devf,hmax,devh,ssh,devs,tcont/fc^2); end
fv(kr+4)=devf;
ht(kr+4)=devh;
fv(kv)=fc;
if qq(1)<=1, return; end
numq=qq(1);
for j=numq+1:numq+4
    if qq(j)==-1, return; end
end
wf=0.1+0.9/nf;
fp=fv(krm)*wf+fv(krm-1)*(1-wf);
fp=min(fp,0.98*fc);
qq(numq+1)=max(fp,0.90*fm);
qq(numq+2)=fc;
qq(numq+3)=hmax;
qq(numq+4)=ssh;
qq(1)=numq+4;
end

% function y = sq(x)
% y=sqrt((1-x)*(1+x));
% end

% function y=gind(a,B)
% end