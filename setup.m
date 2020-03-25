function [fv, ht]=setup(fv, ht, ndim, start)
global fh mode fa ha tcont;
global hs fc sh vwidth vdepth;
global lk ;
global js fmin hmin j
vdepth=(0);
vwidth=(0);
tcont=(0);
sh=(0);
fc=(0);
for k=ndim-44:-1:1
    fv(k+44)=fv(k);
    ht(k+44)=ht(k);
    if fv(k)>0, j=k; end
end
while 1
    fmin=fv(j);
    if j>1, fmin=min(fmin,sqrt(fv(1)*(fv(1)+.9*fh))); end
    hmin=ht(j);
    for i=1:5
        if ht(j+i)<45, break, end
        hmin=min(hmin,ht(j+i));
    end
    ha=hmin;
    fa=fmin;
    hs=ha;
    js=(0);
    lk=(1);
    if (start<0)&(start>=-1)&(j==1), [fv,ht]=f40(fv,ht); return, end
    h1max=min(hmin+40,ht(2)+200*(fv(2)-fv(1)));
    if (j==1)&(ht(1)>h1max)&(i>4)
        for i=1:43
            fv(i)=fv(i+1);
            ht(i)=ht(i+1);
        end
        continue
    end
    break
end
js=(2);
if fv(j+2)>0, dh=abs(ht(j+2)-ht(j))*fmin/(fv(j+2)-fmin); end
if (fv(j+2)<=0)|(ht(j+2)<=0), dh=ht(j)/6; end
hs=min(hmin-dh,hmin/2+50);
hs=max(hs,hmin/4+55);
fa=min(.5,.6*fmin);
if abs(start)>=45, hs=min(abs(start),hs*.4+hmin*.6); end
if j<=1
    ha=hs;
    if (mode==10)|(mode>=20), fa=fmin*.6; end
    if (start>=45)|(start==0), [fv,ht]=f40(fv,ht); return, end
    h=fix(start*.1)*10;
    ha=90+h+h;
    fa=start-h;
else
    js=(1);
    ha=hs*.4+hmin*.6;
    lk=(0);
    if start>-3, fa=-start-1; end
    if start<-1, [fv,ht]=f40(fv,ht); return, end
    lk=(-1);
    fa=fmin*.6;
    vdepth=fmin*.3;
end
[fv,ht]=f40(fv,ht);
end
function [fv,ht]=f40(fv,ht)

global fa ha ;
global hs ;
global kr  kv ;
global js fmin hmin j
kv=45-js;
fv(44)=(fa+fmin)/2;
ht(44)=hs+(hmin-hs)*fv(44)/fmin;
if j==1, hs=ht(44); end
fv(kv)=fa;
ht(kv)=ha;
fv(1)=fa;
ht(1)=ha;
kr=(1);
end