function [ fv,ht,loop ] = staval( fv,ht,dip,valley,loop )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

global FV HT DIP VALLEY LOOP
global hs hmax sh parht hval  xwat ;
global kr kv;
global vbase vdeep vconst val1 dval1 vpeak wvx hxerr
%persistent VAL DVAL DEVL DEVLL HDEC FHHT
[FV,HT,DIP,VALLEY,LOOP]=eq2(fv,ht,dip,valley,loop);
%[VAL, DVAL, DEVL, DEVLL, HDEC, FHHT]=ini(VAL, DVAL, DEVL, DEVLL, HDEC, FHHT);
global val dval devl devll hdec fhht
[val, dval,devl,devll,hdec,fhht]=ini(val, dval,devl,devll,hdec,fhht);
vbase=(0.6); vdeep=(.008); vconst=(20);
val1=(.1001); dval1=(6); vpeak=(1.4);
wvx=(1); hxerr=(2);
global nfb tras sha
nfb=LOOP;
LOOP=abs(LOOP);
if LOOP>1, 
    f200(); 
    [fv,ht,loop]=eq2(FV,HT,LOOP);
    return, 
end
if LOOP==1, LOOP=(4); end
if LOOP==4, 
    f40();
    [fv,ht,loop]=eq2(FV,HT,LOOP); 
    return, 
end
tras=-3.1;
xwat=wvx;
parht=(0);
hval=HT(kv);
if hval==0, hval=VALLEY; end
if hval==0, hval=1; end
if hval>=10, hval=0; end
if hval==0, return, end
hdec=(fix(hval)-hval)*2;
devl=(1.e6);
devll=(1.e7);
dval=dval1;
hmax=HT(kr);
sha=hmax*.25-20;
hs=hmax+sha;
sh=sh*vpeak;
f20;
[fv,ht,loop]=eq2(FV,HT,LOOP);
%[VAL, DVAL, DEVL, DEVLL, HDEC, FHHT]=eq2(val, dval,devl,devll,hdec,fhht);
end
function f20
global vwidth sha hval
vwidth=(sha+7)*abs(hval);
if hval<-2, vwidth=fix(-hval)*2; end
f40;
end
function f40
global val vwidth vdeep vconst hmax hdec hval val1 nx
val=vwidth^2*vdeep/(vconst+vwidth);
if hmax>140, val=.5*val; end
if hdec>0, val=hdec; end
if (hval==-1) & (nx>0), val=val1;end
if fix(hval)==-1, hval=(-1); end
f60;
end
function f60
global vdepth val hdec fa parht sh ha hmax nc fhht
vdepth=val;
if (hdec<=0) | (val>8*fa), vdepth=val*fa/(val+fa); end
parht=2*sh*sq(1-vdepth/fa);
ha=hmax+parht;
if nc==0, fhht=ha+20; end
end
function f200
global tras devn fnl dhl q jm
tras=-4.3;
devn=q(20);
fnl=(0);
dhl=q(jm);
f220;
end
function f220
global FV HT DIP LOOP f_out
global nx devn hval hxerr dval qm qmm q jm hr ha hn fa fn fh mc mv mq mt lbug
global nc nf nfb lk hl fl kr kv krm  khx dhx dhl fnl wvx xwat fhht deltf 
if (nx<=0) | (devn==0 & hval==-1), dval=(-1); end
qm=q(jm);
hr=ha+qm;
hn=hr;
fn=fa;
mc=nc;
mv=nf+nx;
mq=mt+min(lk,0);
for i=1:mv
    hl=hn;
    fl=fn;
    fn=FV(kv+i);
    if fn<0,fn=sqrt((fn+fh)*fn); end
    deltf=fn-fa;
    hn=hr+(sumval(mq,q,deltf,1));
    if nc+mc>=25||DIP<0, f290(i); continue, end
    if (hn-hl)/(fn-fl)>2, f290(i); continue, end
    mc=mc+3;
    if nx>0 & xwat==wvx & nc>1, f380; return, end
    qmm=qm-max(5,abs(qm)/4)*max(1,3-kr);
    if fn~=fnl | hn-hl>dhl, f350; return, end
    if lbug>=-9, fprintf(f_out,'Data/Gyrofrequency incompatible at f =%6.2f\n',FV(kv+i)); end
    mc=(30);
    f290(i);
end
krm=min(kr+mv,kv-1);
if nc<=2, xwat=wvx; end
khx=kr+1+fix(nx/3);
dhx=HT(khx)-fhht;
fhht=HT(khx);
if nc==1 | abs(dhx)>hxerr, LOOP=(3); end
if nx<=0 | nfb<0 | nc>=20, LOOP=(2); end
if kr>1, f500; return, end
f400;
end
function f290(i)
global kr kv hn
global HT
if kr+i<kv, HT(kr+i)=hn; end
end
function f350
global jm B Q qm qmm devn lbug nc fn hn hl fnl dhl f_out
[B,Q,devn]=psolve(-900,-jm,B,Q,qmm,devn,lbug);
format='%3d STAVAL: Qm reduced from%6.1f to%6.1f, to avoid -ve slope at f,h =%7.2f%7.2f   Devn increases%6.2f to%6.2f\n';
if lbug>0, fprintf(f_out,format,nc,qm,Q(jm),fn,hn,Q(19),devn); end
fnl=fn;
dhl=hn-hl;
f220;
end
function f380
global LOOP f_out
global xwat wvx lbug
xwat=wvx/2;
if lbug>=-9, fprintf(f_out,' X ray Weights Reduced to 1/4.\n'); end
LOOP=(4);
end
function f400
global LOOP f_out
global slab Q mt lk lbug nc qm devn jm nf nx ms fhht kd
slab=Q(mt);
if lk==0, slab=(0); end
format='%2d Start Ofset%6.1f km,  Slab%6.1f km.  Devn%5.2f km.%3d terms fit%3d O +%2d X +%2d.  hx=%6.1f\n';
if lbug >=-9, fprintf(f_out,format,nc,qm,slab,devn,jm,nf,nx,ms,fhht); end
if LOOP==3, return, end
kd=1-lk;
f700;
end
function f500
global LOOP
global vwidth qm parht hdec dval lbug nc vdepth devn jm nf nx ms fhht
global kd slab hval vbase devl vbot f_out
vwidth=qm+parht;
if hdec>0, dval=-hdec; end
format='%2d Valley%6.1f km wide,%6.2f MHz deep.  Devn%5.2f km.%3d terms fit%3d O +%2d X +%2d.  hx=%6.1f\n';
if (lbug>0 | dval<0 | nc>=20) & lbug>=-9, fprintf(f_out,format,nc,vwidth,vdepth,devn,jm,nf,nx,ms,fhht); end
if LOOP==3, return, end
kd=(4);
LOOP=(4);
vbot=qm*vbase;
slab=qm-vbot;
if dval<0 | nc>25, f700; return, end
if hval==-1, f600; return, end
if devn>devl/.9 & nc<4, f20; return, end
if devl<1.e6, f560; return, end
devl=devn;
f40;
end
function f560
global dval lbug
dval=(-1);
if lbug==0, f500; return, end
f700;
end
function f600
global dval dval1 val val1 adip devn devl
if dval~=dval1, f620; return, end
if val==val1, f675; return, end
dval=1+.5*cos(.015*adip);
if devn<devl, f675; return, end
val=val1;
f680;
end
function f620
global devn devl devll dval val
if devn>devl*.97-.003 & devll<1.e6, f660; return, end
if devn<devl, f670; return, end
dval=1/dval;
val=val*dval;
devll=devn;
f680;
end
function f660
global devl devll devn dval
dmin=(devll-devn)/abs(devll+devn-devl-devl)*.5-1;
dval=-dval^min(dmin,.5);
f680;
end
function f670
global devl devll
devll=devl;
f675;
end
function f675
global devl devn
devl=devn;
f680
end
function f680
global val dval
val=val*abs(dval);
f60;
end
function f700
global LOOP kr kd kv nx fa vdepth HT FV parht vbase ha qm
LOOP=(2);
kr=kr+kd;
kv=kv+abs(nx);
if kd==0, return; end
if kd==1, f750; return, end
fbot=fa-vdepth;
HT(kr-2)=ha;
FV(kr-2)=fbot;
HT(kr-1)=ha+qm*vbase;
FV(kr-1)=FV(kr-2);
if kd<4, f750; return, end
HT(kr-3)=ha-0.5*parht;
FV(kr-3)=0.5*sqrt(3*fa^2+fbot^2);
FV(kv)=fa;
f750
end
function f750
global ha qm kd kr HT FV fa slab kv lk vbot
ha=ha+qm;
if kd<=2, kr=kd; end
HT(kr)=ha;
FV(kr)=fa;
if kr>3, f800; return, end
HT(1)=ha-slab;
FV(kv-1)=fa;
f1=FV(kv+1);
if lk==0, FV(kv-1)=(fa+f1)*.5; end
FV(kv)=(FV(kv-1)+f1)*.5;
kv=kv-2-lk;
vbot=(0);
f800;
end
function f800
global kr tcont FV HT vbot slab fa parht vdepth lbug tras
if kr>1, tcont=tcont+FV(kr-1)^2*(vbot+.5*slab)+fa^2*.5*slab... 
    +parht*(fa*fa-vdepth*(fa+FV(kr-1))/3); end
if lbug==6, trace(FV,HT,tras); end
if lbug==6, lbug=0; end
if lbug==9,lbug=-9; end
end

