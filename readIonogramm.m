function [ff, hh, cd, Passport] = readIonogramm(file)
passport_beforeFe2010 = 0;
passport_beforeAp2012 = 1;
Nsamp=256;  Nfreq=400; % �������� ����� �������� �� ������� � ����� ������
    [f_in, err_txt]=fopen(file,'r');     if ~isempty(err_txt), disp(err_txt); error(err_txt); end    
    if passport_beforeAp2012  > 0      %% passport ����� �������� ����� ����������� ������
        Passport = textscan(f_in, '%s%d%d%d%d%d%d%d%d%d%d%d%d%d%s%d%d%d%s%s%s%d%d%s%s%d%d%s',1, 'delimiter', '\n');
    else if passport_beforeFe2010 > 0      %% passport ����� ftp-���� �������
            Passport = textscan(f_in, '%s%d%d%d%d%d%d%d%d%d%d%d%d%s%d%d%d%s%s%s%d%d%s%s%d%d%s',1, 'delimiter', '\n');
        else     %% passport ����� ftp-���� & email % 10 ���������������.������ "�������" �������� 54 ��������
            Passport = textscan(f_in, '%s%d%d%d%d%d%d%d%d%d%d%d%d%s%d%d%d%d%d%d%d%d%d%d%s%s%s%d%d%d%s%s%s%s%s%s',1, 'delimiter', '\n');
        end;
    end;   
    fseek(f_in, 1024,'bof'); % ����� �� 1024 ����� ��� ������ �������� ����������
    [A, n]=fread(f_in,[Nsamp*2, Nfreq],'uint16'); % ������ ������ (���������+����)
    fclose(f_in);    
    Nfreq= n/(Nsamp*2); % ����� ������� ��������� ��������� ������������
    FreqBand= [Passport{2} Passport{3}];
    FrqInc=floor( (double(FreqBand(2))-double(FreqBand(1)))/Nfreq );    
    frq=FreqBand(1):FrqInc: FreqBand(1)+ Nfreq*FrqInc-1;    
    ff=double(frq)/1000;      
    Amp=zeros(Nsamp, Nfreq); 
    Amp(1:Nsamp,:)=A(1:2:Nsamp*2-1,:); % ��������� ������ ���������
    clear A;
    lags=1:Nsamp; % ��� �� ������� Tsamp = 16.66 mks <--> Fsamp = 60.0 khz
    hh=2.5*(lags+1); 
    cd=log(Amp+80);