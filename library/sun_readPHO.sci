function[aod_time,aod]=sun_readPHO(aer_site,year,month,day,aer_level,lambda)
//Read the AERONET File downloaded from PHOTONS and process the AOD for desired Wavelength.
// For UV, if UV measurements available, Angström Exponent between.
// Else, Use AOD@870nm and Angstrom Exponent
//
//
//Input example
//aer_site : "Palaiseau"
//year : "12"
//month : "03"
//day : "22"
//aer_level : "lev15"
//lambda (nm): "355"

aer_fil=strcat([path_dataAER,aer_site,'/20',year,'/',year,month,day,aer_site,".",aer_level])

// Check if file exists
[fd,err]=mopen(aer_fil,'r')


if err==0 then
    
    // File reading
    M=read_csv(aer_fil)
    
    //find header
    ind_head=grep(M,'Date')
    header=M(ind_head(1),:);
    first_line=ind_head(1)+1;
    I=first_line-1;
    
    hour=evstr(part(M(first_line:$,2),1:2))
    minute=evstr(part(M(first_line:$,2),4:5))
    second=evstr(part(M(first_line:$,2),7:8))
    
    second_deci=second/0.6
    minute_deci=minute/0.6
    aod_time=hour+minute_deci/100+second_deci/10000
    aod=[];
    
    
    //more accurate for UV
    if evstr(lambda)<500 then
        
        ind_aod340=find(header=="AOT_340")
        ind_aod440=find(header=="AOT_440")
        
        //initialization
        aod340=zeros(size(M,1)-I,1);aod440=zeros(size(M,1)-I,1);
        alpha_uv=zeros(size(M,1)-I,1);
        if ind_aod340>0 & ind_aod440>0 then
            for i=1:size(M,1)-I
                if M(i+I,ind_aod340)<>'N/A' then
                    aod340(i)=evstr(M(i+I,ind_aod340))
                else
                    disp('N/A Value for AOD@340')
                end
                if M(i+I,ind_aod440)<>'N/A' then
                    aod440(i)=evstr(M(i+I,ind_aod440))
                else
                    disp('N/A Value for AOD@440')
                end
            end
        end
        
        //check if only N/A 
        if  length(aod340(aod340==0))<length(aod440) & length(aod340(aod340==0))<length(aod440) then
            mprintf('%s\n','Use of UV Channels')
            alpha_uv=-(log(aod340./aod440))/(log(340/440));
            aod=aod440.*((440/evstr(lambda)).^(alpha_uv));
        end
    end
    
    
    //if aod not created : >500nm or no available measurements
    if length(aod)==0 then
        // Initialization
        ind_alpha=find(header=="440-870Angstrom")
        ind_aod870=find(header=="AOT_870")
        aod870=zeros(size(M,1)-I,1)
        alpha=zeros(aod870)
        
        // aod@870 & angstrom exponent reading
        for i=1:size(M,1)-I
            if M(i+I,6)<>'N/A' then
                aod870(i)=evstr(M(i+I,ind_aod870))
                alpha(i)=evstr(M(i+I,ind_alpha))
            else
                disp('N/A Value for AOD@870')
            end
        end
        
        // If only N/A
        if  length(aod870(aod870==0))==length(aod870) then
            mprintf('%s\n','No AOD@870nm')
            exit
        end
        
        // Process of AOD
        aod=aod870.*((870/evstr(lambda)).^(alpha))
    end
    
    
    
    // Since XXXX, the first value of the file refers to the previous day
    aod=aod((aod_time)>0)
    aod_time=aod_time((aod_time)>0)
    

    mclose(fd)
else
    
    mclose(fd)
//    mprintf('%s\n','No AERONET data')
//    aod=[];aod_time=[];
end



endfunction