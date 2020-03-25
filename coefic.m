function [mv,fv,ht]=coefic(mv,fv,ht)
global B Q fh adip mode mod fa ha lbug;
global hs fc fcc hmax sh parht hval vwidth vdepth xwat;
global maxb nr nl nx mt jm lk kr krm kv mf;
global f_out;
persistent wvirt gindv ftc
if isempty(wvirt), wvirt=(0); gindv=0; ftc=0; end
tr=([.046910077,.23076534 ,.50      ,.76923466,.95308992...
           .009219683,.047941372,.11504866,.20634102,.31608425,.43738330...
           .56261670 ,.68391575 ,.79365898,.88495134,.95205863,.99078032]);
w= ([.11846344 ,.23931434 ,.28444444,.23931434,.11846344...
           .02358767 ,.05346966 ,.08003917,.10158371,.11674627,.12457352...
           .12457352 ,.11674627 ,.10158371,.08003917,.05346966,.02358767]);
vb=(0.6); gtc=(180); 
gauss=(zeros(1,17)); fnr=(zeros(1,17));
format=['%s',repmat('%8.2f',1,15)];

f1=fv(kv+1);
nff=abs(mv);
km=kv+nff;
fw=fv(km+1);

if fw<1, fw=fv(km)*2-fv(km-1); end
i=kv+min(nff, max(mod-15,2)+nr);
dw=fw-fv(i);
da=fv(kv+nr-nl)-fa;

hr=ha+10*min(1,kr-1);
if krm>kr, hr=ht(kr+1); end
if krm==kr, ftc=fa*1.2; end
if hval~=0, hs=hmax+vwidth/3; end
if mv>=0
    if lk<0&krm~=kr
        deltf=(0);
        grad2=Q(1)-gtc;
        if grad2>=0
            while 1
                grad1=grad2;
                deltf=deltf+.1*fa;
                grad2=sumval(mt-1,Q,deltf,2)-gtc;
                if grad2<=0|deltf>=fa*.45, break;end
            end
            deltf=deltf+.1*fa*min(grad2,0)/(grad1-grad2);
        end
        ftc=(ftc+fa+deltf)*.5;
    end
    
    for i=1:maxb
        for j=1:19
            B(i,j)=(0);
        end
    end
end

i=1-nl;
if i==0&mod~=12, i=(-1); end
if mv<0, i=(1); end
while 1
    ireal=nff+nl+max(i,0);
    kvi=kv+i;
    kri=kr+i;
    
    f=fv(kvi);
    hv=ht(kvi);
    fr2=f*f;
    if kri<=krm, hr=ht(kri)*.8+ht(kr+1)*.2; end
    hfh=hr;
    if f1<0, hfh=hs; end
    fh=gind(0,hfh);
    if f<0, fr2=f*(f+fh); end
    fr=sqrt(fr2);
    
    wreal=(10);
    if kvi<kv, wreal=(3); end
    if i>0
        if fr<=fv(kr)|fr<=fc, jm=-jm; end
        if parht>2*sh|nff+nr>maxb, jm=-jm; end
        if jm<=0,
            fprintf(['coef2: ',repmat('%d ',1,6),repmat('%8.2f ',1,8),'\n'],i,kri,kvi,nr,mf,mv,...
                hv,f,fr,fc,fw,fv(kr),fv(km),parht);
        end
        if jm<=0, return; end
        if mv>=0
            wvirt=(1);
            if f<0|fw<=fr
                wvirt=xwat;
            elseif nr>nl&fcc==0
                wvirt=sqrt(min((fr-fa)/da,(fw-fr)/dw));
            end
            B(i,18)=f;
            B(i,19)=wvirt;
            
            fvl=fv(kvi-1);
            if nx<=0&f>=0&fvl>=0
                deltf=(fv(kvi+1)-fvl)/2;
                if deltf<0, deltf=f-fvl; end
                wvirt=wvirt*sqrt(8*abs(deltf)/sqrt(f));
                %wvirt=wvirt*150/(ht(kvi)-50);
            end
        end
        tb=sq(fa/fr);
        ta=(0);
        if mv<0
            fp=fv(kr);
            if fp==fc, fp=fv(kr-2); end
            if fp>=fr, fprintf(f_out,format, 'coef3',fc,fp,fr); end
            ta=sq(fp/fr);
            inum=(5);
            if adip>73&ta<3, inum=(12); end
        else
            ftc=min(ftc,fa*.2+fr*.8);
            tc=.39-.05/cos(.016*adip);
            inum=(5);
            if adip>=60|mode>=8, inum=(12); end
            if adip>=80&tb>1.2*tc, inum=(17); end
            if f1<0, inum=(17); end
            if f1<0, tc=sq(ftc/fr); end
        end
        ira=(1);
        if inum==12,ira=(6); end
        irb=ira+inum-1;
        if inum==17, ta=tc; end
        td=tb-ta;
        
        depar=(0);
        delin=(0);
        if lk<0|parht~=0
            if sh~=0, dz=.5*parht/sh; end
            for ir=6:17
                if lk>=0
                    tp=sq(fc/fr*sq(tr(ir)*dz));
                    depar=depar+gind(f,tp)*w(ir);
                end
                gindv=gind(f,sq((fa-tr(ir)*vdepth)/fr));
                delin=delin+gindv*w(ir);
            end
            if lbug==7, fprintf(f_out,format,'COEF4',fc,f,depar,delin,gindv); end
            if lbug==9, fprintf(f_out,format,'fh,fr,ftc,hfh,hr=',fh,fr,rtc,hfh,hr); end
            if parht>0,fh=gind(0,(hmax+vwidth)*.8+hr*2); end
        end
        for ir=ira:irb
            if inum==17&ir==6
                td=ta;
                ta=(0);
                fh=gind(0,hr);
                if f<=0
                    fr2=f*(f+fh);
                    fr=sqrt(fr2);
                    td=sq(ftc/fr);
                end
            end
            t=tr(ir)*td+ta;
            fn=sq(t)*fr;
            gauss(ir)=gind(f,t)*t*w(ir)/fn*td*fr2;
            fnr(ir)=fn-fa;
        end
    end
    for j=1:jm
        rh=(fr-fa)^j;
        dpeak=(0);
        sum=(0);
        if kvi==kv & j==1, rh=(1); end
        if i>0
            if j==jm, dpeak=depar*parht; end
            if j>=mt&(j~=mt|lk<0)
                rh=j-mt;
                if j==mt, sum=delin; end
                if lk>0, sum=gindv*vb+delin*(1-vb); end
            else
                for ir=ira:irb
                    a=gauss(ir);
                    gauss(ir)=a*fnr(ir);
                    sum=sum+a;
                end
                sum=j*sum;
            end
            B(i,j)=(sum+rh)*wvirt;
            if mv<0, ht(kvi)=ht(kvi)-Q(j)*psign(sum,hv)-psign(dpeak,hv); end
        end
        if ireal<=nff+nr, B(ireal,j)=rh*wreal; end
    end
    if lbug==5, fprintf(['COEF6 ',repmat('%d ',1,3),repmat('%8.2f ',nff,i,ireal,f,fr,hv,dpeak,wvirt)],'/n'); end
    if mv>=0
        if i>0, B(i,jm+1)=(hv-ha-dpeak)*wvirt; end
        if ireal<=nff+nr
            real=ht(kri)-ha;
            if mod==12, real=Q(1)+2*Q(2)*(fa-fv(kr-1));end
            B(ireal,jm+1)=real*wreal;
        end
    end
    i=max(i,0)+1;
    if i>nff, break; end
end
end