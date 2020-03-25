function  trace( fv,ht,tras )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
global  mode mod fa ha  lbug;
global hs fc fcc  sh parht hval vwidth vdepth ;
global  nf nr nl nx ms mt jm lk kr krm kv mf ;
global f_out;
format9=[' #%s',repmat('%8.2f',1,16),'\n',repmat([repmat(' ',1,5),repmat('%8.2f',1,16),'\n'],1,10)];
if abs(lbug)>9, return; end
if tras==0
    
    fprintf(f_out,format9,'FRQ',fv(1:15));
    fprintf(f_out,format9,'HTS',ht(1:15));
    return;
end
format=['---------------------------------------------------------',...
    '\n#TRACE:  kr  lk jm mt    ha     fa   frm    fm',...
    '   kv  nf  nr nl nx ms  mode mod     hs',...
    '    fc   fcc    sh   parht   hval vwidth vdepth\n'];
if tras==2.2, fprintf(f_out,format); end
frm=fv(krm);
fm=fv(mf);
format=['#=%4.1f:%4d%4d%3d%3d%8.2f',repmat('%6.2f',1,3),'%4d%4d%4d%3d%3d%3d%5d%4d   ',repmat('%6.2f',1,4),repmat('%7.2f',1,4),'\n'];
fprintf(f_out,format,tras,kr,lk,jm,mt,ha,fa,frm,fm,kv,nf,nr,nl,nx,ms,mode,mod,hs,fc,fcc,sh,parht,hval,vwidth,vdepth);
if (lbug<4)||(abs(tras-3.3)~=1), return; end

km=kv+nf+nx;
fprintf(f_out,format9,'FRQ',fv(kv:km));
fprintf(f_out,'\n');
fprintf(f_out,format9,'VHT',ht(kv:km+3));
fprintf(f_out,'\n');
fprintf(f_out,format9,'RHT',ht(kr:krm));
fprintf(f_out,'\n');
return;
end

