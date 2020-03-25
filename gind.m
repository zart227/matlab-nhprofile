function y=gind(f,t)
global f_out 
ibug=(0);
persistent gh ghsn gcsct fh fhsn fcsct hfh c c2
if isempty(gh), gh=(0); end
if isempty(ghsn), ghsn=(0); end
if isempty(gcsct), gcsct=(0); end
if isempty(fh), fh=(0); end
if isempty(fhsn), fhsn=(0); end
if isempty(fcsct), fcsct=(0); end
if isempty(hfh), hfh=(0); end
if isempty(c), c=(0); end
if isempty(c2), c2=(0); end
if f==0
    if gh<0|t<2, y=fh; return; end
    if ibug==1, fprintf(f_out,'gind fh to ht=%f',t); end
    fh=gh/(1+t/6371.2)^3;
    fhsn=ghsn*fh/gh;
    fcsct=gcsct*fh/gh;
    hfh=.5*fhsn;
    c=fcsct+fhsn;
    c2=c*c;
    y=fh;
    return;
end
if t<0
    gh=f;
    fh=abs(gh);
    dip=(max(-.01745329*t,.001));
    ghsn=gh*sin(dip);
    gcsct=((gh*cos(dip))^2)*.5/ghsn;
    fhsn=ghsn*fh/gh;
    fcsct=gcsct*fh/gh;
    hfh=.5*fhsn;
    c=fcsct+fhsn;
    c2=c*c;
    y=fh;
    return;
end
t2=((max(t,.1e-9))^2);
if f<0
    x=(f+fh)*t2;
    g1=x-fh;
else
    g1=f*t2;
end
g2=fcsct/g1;
g3=sqrt(g2*g2+1);
if f<0
    g4=fhsn*(g3-g2);
    x=x*(g1-fh);
    g5=-g4*x/(fhsn*(sqrt(x+c2)+c));
else
    g4=fhsn/(g2+g3);
    g5=g1+g4;
end
g6=f+g4;
g7=(f*g2*g4/g1-hfh)*(f-g1)/(g3*g6);
y=abs(g7+g6)/sqrt(g5*g6)-1;
end
