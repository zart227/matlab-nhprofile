function [ff, hh, cd, Passport] = readIonogramm(file)
passport_beforeFe2010 = 0;
passport_beforeAp2012 = 1;
Nsamp=256;  Nfreq=400; % задается число отсчетов на частоте и число частот
    [f_in, err_txt]=fopen(file,'r');     if ~isempty(err_txt), disp(err_txt); error(err_txt); end    
    if passport_beforeAp2012  > 0      %% passport после введения числа зондирующих частот
        Passport = textscan(f_in, '%s%d%d%d%d%d%d%d%d%d%d%d%d%d%s%d%d%d%s%s%s%d%d%s%s%d%d%s',1, 'delimiter', '\n');
    else if passport_beforeFe2010 > 0      %% passport после ftp-ного времени
            Passport = textscan(f_in, '%s%d%d%d%d%d%d%d%d%d%d%d%d%s%d%d%d%s%s%s%d%d%s%s%d%d%s',1, 'delimiter', '\n');
        else     %% passport после ftp-ного & email % 10 многоимпульсных.частот "времени" содержит 54 элемента
            Passport = textscan(f_in, '%s%d%d%d%d%d%d%d%d%d%d%d%d%s%d%d%d%d%d%d%d%d%d%d%s%s%s%d%d%d%s%s%s%s%s%s',1, 'delimiter', '\n');
        end;
    end;   
    fseek(f_in, 1024,'bof'); % сдвиг на 1024 байта для чтения отсчетов ионограммы
    [A, n]=fread(f_in,[Nsamp*2, Nfreq],'uint16'); % чтение парами (амплитуда+фаза)
    fclose(f_in);    
    Nfreq= n/(Nsamp*2); % число реально считанных импульсов зондирования
    FreqBand= [Passport{2} Passport{3}];
    FrqInc=floor( (double(FreqBand(2))-double(FreqBand(1)))/Nfreq );    
    frq=FreqBand(1):FrqInc: FreqBand(1)+ Nfreq*FrqInc-1;    
    ff=double(frq)/1000;      
    Amp=zeros(Nsamp, Nfreq); 
    Amp(1:Nsamp,:)=A(1:2:Nsamp*2-1,:); % выделение модуля амплитуды
    clear A;
    lags=1:Nsamp; % шаг по времени Tsamp = 16.66 mks <--> Fsamp = 60.0 khz
    hh=2.5*(lags+1); 
    cd=log(Amp+80);