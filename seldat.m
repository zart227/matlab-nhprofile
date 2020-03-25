function [nv, fv, ht]=seldat(nv, fv, ht)
global fh fcc nf kr kv mf
global lbug f_out
global mod maxb nx

ffit=(0.411);
gfit=(40.1);

%2
while 1
    fcc=(0);
    fsx=(0);
    frx=(0);
    mf=kv;
    fs=fv(kv);
    f1=(0);
    fh=gind(0,ht(kr));
    nf=(0);   
%10    
    while 1
        nf=nf+1;
%12        
        while 1
            mf=mf+1;
            fm=fv(mf);
            fn=fv(mf+1);
            hv=ht(mf);
            if (lbug==6)&(kr==1), fpintf(f_out,nv,nf,f1,fm,'\n'); end
            if fm>fs, break; end %20
            frx=(sqrt(fm*(fm+fh)));
            if mf==kv+1, fsx=frx; end
            if (fm<0)&(frx>=fsx)&(nf==1), continue, end %12
%15            
            nv=-mf;
            return
        end
%20
        if f1==0, f1=fm; end
        if (hv<0)|(fn<0)
            fcc=(min(fn,-.1)); %40
            ht(mf)=abs(hv);
            break
        end
        if abs(ht(mf+1))<=50
            fcc=(max(fn,.1)); %50
            break
        end
        fs=fm;
        if fn<=fm, nv=-mf; return, end %15
        if (nf+1)<nv & (mf-kv)<(maxb-8), continue;  end %10
        grad=(ht(mf+1)-hv)/(fn-fm);
        if (nf+1==nv)&( (nf<=2)|(kr>1)|(grad<100) ), continue;  end %10
        if (mod>10)|(mod<4), break, end %70
        if (ht(mf+1)-hv)>((fn-fm)*gfit); break, end %70
        if (frx>fsx)&(fm>frx), break, end %70
        if ((fm-f1+.04*((nf-nv)))<ffit)|(fm<fsx), continue, end %10
        break %70
    end
%70
    if nf<1, nv=-mf; return, end %15
    mx=mf-nf;
    kv1=kv;    
%80
    while 1
        nx=mx-kv;
        if nx==0, f100; return, end %100
        f=fv(mx);
        if sqrt((f+fh)*f)<=fm+0.1 %90
            if nx==1, f100; return, end %100
            if ht(mx)-ht(mx-1)<gfit*(fv(mx-1)-f), f100; return, end %100
        end
%90
        j=mx;
%95
        while 1
            fv(j)=fv(j-1);
            ht(j)=ht(j-1);
            j=j-1;
            if j>=kv, continue, end %95
            break
        end
        kv=kv+1;
        if kv>kv1+nv, break, end %2
    end %80
end %2
end
function f100
global nx lk kr 
%100
if (nx==0)&(kr==1), lk=(1); end
end