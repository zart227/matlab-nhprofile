function x=sumval (n,a,b,l)
j=n;
if l==3, j=n-1; end
s=0;
jd=(1);
if l>4, 
    jd=l; 
end
jb=(n-1)*jd+1;
ll=(min(l,4));
while 1
    switch ll
        case 1
            s=double((s+a(j))*b(1));
        case 2
            s=s*double(b(1))+double(a(j)*j);
        case 3
            s=s*double(b(1))+double(a(j+1)*(j+1)*j);
        case 4
            s=s+double(a(j)*b(jb));
            jb=jb-jd;
        otherwise
            disp('!!!!!!!!!!!!error!!!!!!!!!!!!');
    end
    j=j-1;
    if j<=0, break; end
end
    x=s;
end