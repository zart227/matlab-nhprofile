function [bb,q,lbug]=adjust(ha,fa,fm,fc,lk,jm,mt,bb,q,lbug)
global f_out buff
lflag=fix((lbug+50)/100);
lbug=lbug-lflag*100;
ladj=(0);
devn=q(20);
mq=mt;
if lk<0, mq=mt-1; end
format7=['*adjust----  lk jm mt    ha     fa    fm      q1',repmat('%9d',1,9),'\n',repmat(' ',1,40),repmat('%9d',1,10),'\n'];
if lbug>2||(lbug>0&&lk<2), 
    buff=sprintf(format7,2:mt);
    fprintf(f_out,buff);
    if mt<9, fprintf(f_out,'\n'); end
end
format9=['*adjust%5s%3d%3d%3d%8.2f%6.2f%6.2f',repmat('%9.2f',1,10),'\n',repmat(' ',1,41),repmat('%9.2f',1,10),'\n'];
if lbug>0, 
    c=pcell(q(1:jm));
    buff=sprintf(format9,'--- ',lk,jm,mt,ha,fa,fm,c{:},devn);
    if jm==9, buff=[buff(1:132),'\n']; end
    fprintf(f_out,buff); 
    if jm<9, fprintf(f_out,'\n'); end
end
if lflag>3||jm<4, return; end

qmin=(2);

if lflag<=1
    if lk<=1
        qmax=(80);
        if lk==-1,qmax=(160); end
        if q(1)>qmax, qmin=2*qmax*q(1)/(qmax+q(1));end
    else
        if jm>mt, qmin=ha/4-20; end
    end
    if q(1)<qmin||qmin>=85
        [bb,q,devn]=psolve(-900,-1,bb,q,qmin,devn,lbug);
        ladj=ladj+1;
        c=pcell(q(1:jm));
        if lbug>0, 
            buff=sprintf(format9,'q(1)',lk,jm,mt,ha,fa,fm,c{:},devn);
            if jm==9, buff=[buff(1:132),'\n']; end
            fprintf(f_out,buff);
            if jm<9, fprintf(f_out,'\n'); end
        end
    end
    if jm>mt & lk>0 & q(2)>=-1.5
        [bb,q,devn]=psolve(-900,-2,bb,q,-1.5,devn,lbug);
        ladj=ladj+2;
        c=pcell(q(1:jm));
        if lbug>0, 
            buff=sprintf(format9,'q(2)',lk,jm,mt,ha,fa,fm,c{:},devn);
            if jm==9, buff=[buff(1:132),'\n']; end
            fprintf(f_out,buff); 
            if jm<9, fprintf(f_out,'\n'); end
        end
    end
end

while 1
    ql=q(mq);
    if mq<5 | abs(ql)<150 | fc>0 | lk<=0, break, end
    if ql/q(mq-2)<=2||ql/q(mq-1)>=-1
        if abs(ql)<999&&abs(q(mq-1))<999, break, end
    end
    [bb,q,devn]=psolve(900,-mq,bb,q,0,devn,lbug);
    c=pcell(q(1:jm));
    if lbug>0, 
        buff=sprintf(format9,'mq ',lk,jm,mt,ha,fa,fm,c{:},devn);
        if jm==9, buff=[buff(1:132),'\n']; end 
        fprintf(f_out,buff);
        if jm<9, fprintf(f_out,'\n'); end
    end
    mq=mq-1;
end
if jm~=mt
    if lk<=0
        qm=q(mt);
        qmt=(.1);
        if qm<0
            [bb,q,devn]=psolve(-900,-mt,bb,q,qmt,devn,lbug);
            c=pcell(q(1:jm));
            if lbug>0,
                buff=sprintf(format9,'Slab ',lk,jm,mt,ha,fa,fm,c{:},devn);
                if jm==9, buff=[buff(1:132),'\n']; end 
                fprintf(f_out,buff);
                if jm<9, fprintf(f_out,'\n'); end
            end
            if devn>q(19)*1.25, [bb,q,devn]=psolve(0,-mt,bb,q,qmt,devn,lbug); end
        end
        ofst=(-.1);
        if q(jm)<=0
            if lk<0&&ha+q(jm)<=60
                ofst=60-ha;
                [bb,q,devn]=f450(jm,bb,q,ofst,devn,lbug,lk,mt,ha,fa,fm);
            end
        else
            [bb,q,devn]=f450(jm,bb,q,ofst,devn,lbug,lk,mt,ha,fa,fm);
        end
    else
        if q(jm)<0, 
            ofst=(0.1); 
            [bb,q,devn]=f450(jm,bb,q,ofst,devn,lbug,lk,mt,ha,fa,fm);
        end        
    end
end
if fc<=0||mq<4, return, end
hfm=ha+(sumval(mq,q,fm-fa,1));
shm=(max(.27*hfm-21,5));
d=fc-fm;
if d<.03, d=(0.1*sqrt(fm)+.03*fm);end
curve=0.28*shm/(d*sqrt(fm*d));
if sumval(mq,q,fm-fa,3)>curve, return, end
devn=fm-fa;
[bb,q,devn]=psolve(100,-300,bb,q,curve,devn,lbug);
c=pcell(q(1:jm));
if lbug>0,
    buff=sprintf(format9,'Curvm',lk,jm,mt, ha,fa,fm,c{:},devn);
    if jm==9, buff=[buff(1:132),'\n']; end
    fprintf(f_out,buff);
    if jm<9, fprintf(f_out,'\n'); end
end
if q(1)>qmin||mod(ladj,2)==1, return, end
[bb,q,devn]=psolve(-900,-1,bb,q,qmin,devn,lbug);
c=pcell(q(1:jm));
if lbug>0, 
    buff=sprintf(format9,'q(1)',lk,jm,mt,ha,fa,fm,c{:},devn);
    if jm==9, buff=[buff(1:132),'\n']; end
    fprintf(f_out,buff);
    if jm<9, fprintf(f_out,'\n'); end
end
end
function [bb,q,devn]=f450(jm,bb,q,ofst,devn,lbug,lk,mt,ha,fa,fm)
global f_out buff
[bb,q,devn]=psolve(-900,-jm,bb,q,ofst,devn,lbug);
format=['*adjust%5s%3d%3d%3d%8.2f%6.2f%6.2f',repmat('%9.2f',1,10),'\n',repmat(' ',1,41),repmat('%9.2f',1,10),'\n'];
c=pcell(q(1:jm));
if lbug>0,
    buff=sprintf(format,'Ofset',lk,jm,mt, ha,fa,fm,c{:},devn);
    if jm==9, buff=[buff(1:132),'\n']; end
    fprintf(f_out,buff);
    if jm<9, fprintf(f_out,'\n'); end
end
end