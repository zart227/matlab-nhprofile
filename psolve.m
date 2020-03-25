function [ B,Q,devn ] = psolve( M, N, B, Q, QSET, devn, lbug )
%psolve Summary of this function goes here [ B,Q,devn ] = psolve( M, N, B, Q, QSET, devn, lbug )
%   Detailed explanation goes here
global f_out;
global nn remov s nad ww
global m n b q qset DEVN LBUG
global NQ NP WSETQ VSETQ
%persistent nq np wsetq vsetq
%[nq,np,wsetq,vsetq]=ini(nq,np,wsetq,vsetq);
%
if isempty(NQ), NQ=(0); end 
if isempty(NP), NP=(0); end
if isempty(WSETQ), WSETQ=(zeros(1,17)); end
if isempty(VSETQ), VSETQ=(zeros(1,17)); end
[m,n,b,q,qset,DEVN,LBUG]=eq2(M, N, B, Q, QSET, devn, lbug);
%[NQ,NP,WSETQ,VSETQ]=eq2(nq,np,wsetq,vsetq);
format=['%s%5d',repmat('%8.3f',1,9),'\n'];
if n>=0
    NQ=n;
    NP=n+1;
    if (LBUG==5||m<n)
        f88(m,b,NP);
        if m<n,
            %[nq,np,wsetq,vsetq]=eq2(NQ,NP,WSETQ,VSETQ);
            [B, Q, devn]=eq2(b,q,DEVN);
            return; 
        end
    end
    k=(0);
    while 1
        k=k+1;
        WSETQ(k)=0;
        s=(0);
        mk=m-k+1;
        if mk<=0, 
            exit7;
            %[nq,np,wsetq,vsetq]=eq2(NQ,NP,WSETQ,VSETQ);
            [B, Q, devn]=eq2(b,q,DEVN);
            return; 
        end
        col=b(k:99,k);
        s=(sumval(mk,col,col,4));
        if k==NP, 
            exit7; 
           % [nq,np,wsetq,vsetq]=eq2(NQ,NP,WSETQ,VSETQ);
            [B, Q, devn]=eq2(b,q,DEVN);
            return; 
        end
        a=b(k,k);
        d=psign(sqrt(s),a);
        b(k,k)=a+d;
        c=a*d+s;
        if (c==0), 
            m=-m; 
            f88; 
           % [nq,np,wsetq,vsetq]=eq2(NQ,NP,WSETQ,VSETQ);
            [B, Q, devn]=eq2(b,q,DEVN);
            return; 
        end
        for j=k+1:NP
            col1=b(k:99,k); col2=b(k:99,j);
            s=(sumval(mk,col1,col2,4)/c);
            for i=k:m
                b(i,j)=b(i,j)-b(i,k)*s;
            end
        end
        b(k,k)=-d;
    end
end
ww=(abs(m)/100);
nad=fix(abs(n)/100);
if (LBUG>=4)||(abs(n)>NQ&&nad==0), fprintf(f_out,format,'>>reSolve with n,qset,w=', n, qset, .01*m); end
if nad>0
    df=DEVN;
    fj=1;
    if nad>1, fj=1/df; end
    nn=(max(1,nad-1));
    for j=nn:NQ
        fj=fj*df;
        qj=fj;
        if (nad>1), qj=qj*j; end
        if (nad>2), qj=qj*(j-1); end
        q(j)=qj*ww;
    end
    q(NP)=qset*ww;
    remov=1;
    f52;
    %[nq,np,wsetq,vsetq]=eq2(NQ,NP,WSETQ,VSETQ);
    [B, Q, devn]=eq2(b,q,DEVN);
    return
end
remov=-1;
nn=abs(n)-1;
f4;
%[nq,np,wsetq,vsetq]=eq2(NQ,NP,WSETQ,VSETQ);
[B, Q, devn]=eq2(b,q,DEVN);
end

function f88 
global f_out;
global m b NP

% persistent NP;
format=['\n>>Solve:  J =  ',repmat('%9d',1,13),repmat(['\n',repmat(' ',1,15),repmat('%9d',1,12)],1,round(NP/13)-1),'\n'];
fprintf(f_out,format,1:NP); fprintf('\n');
format=['Matrix B row%3d',repmat('%9.4f',1,13),repmat(['\n',repmat(' ',1,15),repmat('%9.4f',1,12)],1,round(NP/13)-1),'\n'];
for i=1:abs(m)
    fprintf(f_out,format,i,b(i,1:NP)); fprintf('\n');
end
end
function exit7
global m b NP  s 
b(NP,1)=m;
b(NP,NP)=sqrt(s);
exit8;
end
function exit8
global b q NP NQ DEVN
DEVN=abs(b(NP,NP))/sqrt(b(NP,1));
for ii=2:NP
    i=NP-ii+1;
    s=b(i,NP);
    for j=i+1:NQ
        if ii>2, s=s-q(j)*b(i,j);
        end
    end
    q(i)=s/b(i,i);
end
q(19)=q(20);
q(20)=DEVN;
end
function f4
global nn WSETQ
nn=nn+1;
if WSETQ(nn)~=0, f5; return, end
f51;
end
function f5
global q nn NP WSETQ VSETQ remov
q(nn)=WSETQ(nn);
q(NP)=WSETQ(nn)*VSETQ(nn);
if remov<0, WSETQ(nn)=(0); end
f52;
end
function f51
global nn remov m n ww qset NQ WSETQ VSETQ
if (nn<NQ&&m<0), f4; return, end
remov=1;
nn=abs(n);
WSETQ(nn)=ww;
if m==0, exit8; return, end
VSETQ(nn)=qset;
f5;
end
function f52
global nn b q remov NP nad
for i=nn:NP
    bii=b(i,i);
    r=sqrt(max(bii^2+(q(i)^2)*remov, 0.1e-9));
    c=bii/r;
    s=q(i)/r;
    for j=i:NP
        qj=q(j);
        if (i==nn&&j~=i&&j~=NP&&nad==0), qj=(0); end
        q(j)=c*qj-s*b(i,j);
        b(i,j)=c*b(i,j)+s*qj*remov;
    end
end
if remov<0, f51; return, end
exit8;
end

