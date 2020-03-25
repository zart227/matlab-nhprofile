function [N,FV,HT,QQ]=polan(N,FV,HT,QQ,fb,dip,start,amode,valley,list,output)
global B Q fh adip mode mod fa ha tcont lbug f_out
global hs fc fcc hmax sh parht hval vwidth vdepth
global maxb nf nr nl nx ms mt jm lk kr krm kv mf nc
global mod1 nnr
persistent devn ndim
f_out=output;
if isempty(fh),initglobal; end
[devn,ndim]=ini(devn,ndim);
kj=0;
IT=([1,2, 3, 4, 4, 5, 6, 6, 6,73, 1, 2, 3, 4, 5, 6, 6, 6, 6,73]);
IV=([1,2, 3, 4, 5, 7, 8,10,12,90, 1, 1, 2, 3, 4, 5, 7, 8,13,90]);
IR=([0,0, 0, 1, 1, 2, 2, 3, 5, 2, 0,-1,-1, 1,-2,-3,-3,-4,-6,-3]);
IH=([1,1, 2, 3, 3, 4, 5, 6, 8,28, 1, 1, 1, 1, 1, 1, 2, 2, 3,28]);
maxb=(98);
if ndim==0
    ndim=max(N,100);
    if N<100, disp('SET INITIAL N = NDIM, > #DATA + 46\n'); end
end
if QQ(1)~=-1,QQ(1)=1; end
FV(ndim-45)=(-1);
HT(ndim-45)=(0);
format=['\n#Args: N,f1,h1=%4d%5.2f%6.1f   fb,dip,start%6.2f%6.1f%6.1f',...
    '   mode,valy,list%5.1f%6.2f%3d\n'];
if list>1, fprintf(f_out,format,N,FV(1),HT(1),fb,dip,start,amode,valley,list); end
adip=(max(abs(dip),.001));
fh=gind(fb,-adip);
lbug=list;
if lbug>7, lbug=-lbug; end
if (lbug>1),  trace (FV,HT, 0.); end                          %##----->
mode =abs(amode);
if (mode==0),  mode = 6 + fix(adip/60.)*10; end
modb = 0;                                                          %normal
if (mode>=30),  modb = fix(mode/10); end                               %one poly
moda = mode - modb*10;                                          %1stlayer
modc = 0;
if (modb>=30),  modc = fix(modb/10); end                                %toplayer
modb = modb - modc*10;                                          %midlayer
if (moda==0),  moda = modb; end
if (modb==0),  modb = moda; end
if (modc==0),  modc = modb; end
mod1 = moda - fix(moda/10)*10;
if (mode==10||mode>=30),  mod1 = 10; end                          %snglpoly
[FV,HT]=setup(FV,HT,ndim,start);
dhs=max(ha-hs,0);
f200;
while 1
    nt = IT(mod);
    nv = IV(mod);
    nh = IH(mod);
    nr = abs(nnr);
    nl = (min(1, nr - nnr));
    ms = (0);
    msa = (0);
    if (lk == 1 & kv == 29 & amode >= 0), msa = (1);end
    if (nv > 1 & nv < 8), nv =nv- msa;end
    
    [nv,FV,HT]=seldat(nv, FV, HT);
    tras = (-2.2);
    if (nv < 0)     
        %ERROR
        
        kv = -nv - 1;
        ShowError(FV,HT,tras);
        [N,FV,HT,QQ]=Error(FV,HT,QQ);
        return
    end
    
    
    fm = FV(mf);
    mv = mf - kv;
    if (nf > nv), nh =nh+ fix((nf - nv) / 2); end
    if (fcc > 0 & lbug == -8), lbug = 8;end
    if (lbug > 2 | (lbug == 2 & mod < 10)), trace(FV, HT, 2.2); end
    
    if (kr ~= 1)
     %   kj=kj+1;
        [FV,HT]=reduce(FV, HT);
        mv = mf - kv;
        
        tras = -2.3;
        if (jm <= 0)                                        %ERROR
            
            ShowError(FV,HT,tras);
            [N,FV,HT,QQ]=Error(FV,HT,QQ);
           
            return;
        end
        if (lbug > 2), trace(FV, HT, 2.3);end
    end
    mt = nt;
    if (nt > 20), mt = round(2 * sqrt(nf));end
    if (lk < 0)|(hval ~= 0), mt=mt+1;end
    if (nx > 0), mt =mt+fix(nx / 3);end
    if (nf > nv), mt =mt+ fix((nf - nv) / 3);end
    if (mode >= 30)
        mt = moda;
        if (kr > 1), mt = modb; end
        if (FV(mf + 2) == 0 | nf >=nv), mt = modc; end
    end
    mt = min(14, min(mt, mv + nr + msa));
    jm = mt;
    fa = FV(kr);
    ha = HT(kr);
    nc = (0);
    loop = (0);
    [FV,HT,loop]=staval(FV, HT, dip, valley, loop);
    if (hval ~= 0 & amode >= 0), mt = mt+ max(fix((9 - mt) / 3), 0); end
    if (lk <= 0 | hval ~= 0), jm = mt + 1; end
    if (lbug > 3), trace(FV, HT, 3.1); end
    while 1
        %kj=kj+1;
        [mv,FV,HT]=coefic(mv, FV, HT);
        tras = -3.2;
        if (jm <= 0)                                       %ERROR
            
            ShowError(FV,HT,tras);
            [N,FV,HT,QQ]=Error(FV,HT,QQ);
            
            return;
        end
        
        if (amode >=0) & ((mv + 4) <= maxb)
            
            if (msa == 1)
                
                g = 1 + 1.8 / FV(29);
                B(mv+1, 1) = (0.5);
                B(mv+1, jm+1) = .5 * g * (HT(30) - ha);
                ms = (1);
            end
            if (lk < 0)
                
                ws = (.1);
                if (start > 44), ws = (.3); end
                B(mv+1, jm ) = -ws;
                B(mv+1, mt) = .25 * ws;
                B(mv+1, jm+1) = dhs * .25 / (fa * fa) * ws;
                B(mv + 2, mt) = ws * .3;
                B(mv + 2, jm+1) = (hs / 2 - 40) / (fa * fa) * ws * .3;
                B(mv + 3, mt - 1) = ws * .15;
                ms = (3);
                
            elseif (hval ~= 0)
                
                wv = (1.0);
                if (hval < -2), wv = (10); end
                if (nx > 0), wv = (0.2); end
                B(mv+1, jm) = wv;
                B(mv+1, jm+1) = (vwidth - parht) * wv;
                B(mv + 2, mt) = (.5);
                B(mv + 3, 1) = (.4);
                B(mv + 3, jm) = -.1 / vdepth;
                B(mv + 4, mt - 1) = (.15);
                ms = min(4, mt);
            end
        end
        nc=nc+1;
        if (lbug > 2 | (ms > 0 & lbug ~= 0)), trace(FV, HT, 3.3); end
        ns = min(mv + nr + ms, maxb);
        %devn = 0;
        [B,Q,devn]=psolve(ns, jm, B, Q, 0, devn, lbug);
        tras = 4.1;
        if (ns < jm)                                        %ERROR
            
            if (fc ~= -1)
                
                if (nv < 0), kv = -nv - 1; end
                ShowError(FV,HT,tras);
            end
            [N,FV,HT,QQ]=Error(FV,HT,QQ);
            
            return;
        end
        
        if (msa == 1), lbug =lbug+ 200; end
        if (dip < 0), lbug =lbug+ 400; end
        
        [B,Q,lbug]=adjust(ha, fa, fm, fcc, lk, jm, mt, B, Q, lbug);
        
        loop = (2);
        if (jm ~= mt & nx <= 0)
            
            vwidth = Q(jm) + parht;
            if (nc == 1 & hval ~= 0), loop = (1); end
        end
        if (lbug > 1 & hval ~= 0 | lbug > 2), trace(FV, HT, 4.3); end
        if (fb < 0), loop = -abs(loop); end
      %  kj=kj+1;
        if (jm > mt), [FV,HT,loop]=staval(FV, HT, start, valley, loop); end
        if (loop == 4 | (loop == 3 & fb > 0)), continue;
        else break, end
    end
    krm = kr + nr - nl;
    kvm = kv + nr - nl;
    fl = FV(kvm);
    nh = min(nh, nf - fix(mod1 / 10) * 2);
    mq = mt + min(lk, 0);
    ka = kvm + 1;
   % tcont = 0;
    for j = ka:mf
        
        fr = FV(j);
        krm=krm+1;
        deltf = fr - fa;
        FV(krm) = fr;
        HT(krm) = ha + (sumval( mq, Q, deltf, 1));
    end
    fn = FV(kvm + nh);
    if (fcc ~= 0)
        
        nh = krm - kr;
        fn = fm;
    end
    for j = 1:mq
        
        tcont = tcont+ j * Q(j) * (tcontf(fn - fa, j) - tcontf(fl - fa, j));
    end
    kj=kj+1;
    kr = kr+nh;
    kv = kv+nh;
    if (fcc == 0)
        
        if (mod <= 10)
            
            kr =kr- IR(mod);
            kv =kv- IR(mod);
            mod = mod+ 10;
        end
        nnr = IR(mod);
        continue;
    end
    if (fcc == -.1)
        
        
        f200;
        continue;
    end
    fc=fcc;
   
    if (QQ(1) >= 1)
        
        numq = QQ(1) + 4;
        for i = (numq - 3):(numq + mq)           
            if (QQ(i) == -1), break; end
            if (i >= numq), QQ(i) = Q(i - numq + 1); end
        end
        if (QQ(i) ~= -1)
            
            QQ(numq - 3) = fa;
            QQ(numq - 2) = ha;
            QQ(numq - 1) = mq;
            numq =numq+ mq;
            QQ(numq) = devn;
            if (fcc < 0), numq=numq+1; end
            if (fcc < 0 & QQ(numq) ~= -1), QQ(numq) = fm; end
            QQ(1) = numq;
        end
        
        
    end
    tras = 6;
    if (fcc < 0)
        
        [N,FV,HT,QQ]=Error(FV,HT,QQ);
        return;
    end
    if (HT(krm) < 70)
        
        ShowError(FV,HT,tras);
        [N,FV,HT,QQ]=Error(FV,HT,QQ);
        return;
    end
    [FV,HT,QQ]=peak(FV, HT, QQ);
    
    if (lbug ~= -10), lbug = abs(lbug);end
    if (lbug == 8), lbug = -8; end
    hs = (hmax + HT(krm)) / 2;
    
    if (HT(kv+1) > 0), f200; continue
    else break, end
end

N = kr + 3;
FV(N - 2) = fc * .98642;
FV(N - 1) = fc * .93300;
FV(N) = fc * .83462;
HT(N - 2) = hmax + sh * 0.3565;
HT(N - 1) = hmax + sh * 0.8878;
HT(N) = hmax + sh * 1.6216;
FV(N + 2) = tcont * .124;
HT(N + 2) = sh;
FV(N + 3) = (0);
HT(N + 3) = (0);
numq = QQ(1) + 1;
if (numq > 1), QQ(numq) = -99; end

end
function [N,FV,HT,QQ]=Error(FV,HT,QQ)
global kr kv
N=kr+1;
FV(N)=FV(kv+1);
HT(N)=HT(kv+1);
FV(N+1)=(0);
HT(N+1)=(0);
lq=QQ(1)+1;
if (lq>1)&(QQ(lq)~=-1), QQ(lq)=-98; end
end
function ShowError(FV,HT,tras)
global f_out kv lbug
ki=kv-1;kj=kv+4;
c=pcell(FV(ki:kj),HT(ki:kj));
format=['\n>>>>>error at f,h =',repmat('%7.2f',1,12),' section',...
    '%f4.1 %i5  >>>> end\n'];
if lbug~=-10,
    fprintf(f_out,format,c{:},tras,kv);
    trace(FV,HT,tras);
end
end
function y=tcontf(x,j)
global fa
y=(fa*(fa/j+2*x/(j+1))+x*x/(j+2))*x^j;
end
function f200
global mod mod1 krm kr nnr
mod=mod1;
krm=kr;
nnr=(0);
end