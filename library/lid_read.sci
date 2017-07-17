function[lid_time,pr2,z,theta,vresol]=lid_read(lid_site,lid_file,lid_data,year,month,day)
//Read the Netcdf Lidar File


//name of file (find "yyyy","mm","dd" and replace by value)
lid_file=strsubst(lid_file,'yyyy',strcat(['20',year]));
lid_file=strsubst(lid_file,'mm',month);
lid_file=strsubst(lid_file,'dd',day);


exec(strcat([path_library,'/netcdf_scilab_0.1_alpha/loader.sce']));
fd = netcdf_open(strcat([path_dataLID,lid_site,'/',year,month,'/',day,'/',lid_file]))

if fd>0 then
    
    altisite=netcdf_getFloatVar(fd,'altitude')
    theta=netcdf_getFloatVar(fd,'zenith_angle')
    vresol=netcdf_getFloatVar(fd,'range_resol')
    timeresol=netcdf_getFloatVar(fd,'time_resol')
    lid_time=netcdf_getFloatVar(fd,'time')
    pr2=netcdf_getFloatVar(fd,lid_data)
    save("pr2.sod", pr2)
    save("lid_time.sod", lid_time)
    save("altisite.sod", altisite)
    netcdf_close(fd)
    
    //probleme de lecture
    if length(altisite)>1 then
        mprintf("%s \n","Reading Problem !!!")
        altisite=70;//altisite=420;
        theta=0;
        vresol=15;//7.5;
        timeresol=60//(lid_time(2)-lid_time(1))*60*60;
    end
    
    
    //on met en forme la matrice PR2
    nl=size(pr2,1)/length(lid_time);
    nc=length(lid_time)
    PR2=zeros(nl,nc)
    for i=1:size(PR2,2)
        PR2(:,i)=pr2(nl*(i-1)+1:nl*i)
    end
    pr2=PR2;
    
    //flag
//    pr2((pr2)=-9999)=%nan; : erreur ˆ la gŽnŽration de la nouvelle big avec Scilab5.4.1
    pr2((pr2)==-9999)=%nan;

    
    
    //si time_resolution<1 minute, alors on moyenne pour avoir un profil par minute (pour limiter la taille de la matrice PR2)
    if  timeresol<60 then
        nb2mean=60/timeresol;
        pr2=zeros(nl,nc/nb2mean)
        for i=1:size(pr2,2)
            pr2(:,i)=mean(PR2(:,nb2mean*(i-1)+1:nb2mean*i),'c')
        end
        lid_time=lid_time(nb2mean:nb2mean:$)
    end
    
    
    

    
    //si vresol<15 m , alors moyenner
    if  vresol<15 then
        PR2=pr2;
        nb2mean=15/vresol;

        pr2=zeros(nl/nb2mean,length(lid_time))
        for i=1:size(pr2,1)
            pr2(i,:)=mean(PR2(1+(i-1)*nb2mean:i*nb2mean,:),'r')
        end
        vresol=15
        nl=size(pr2,1);
    end
    
    
    //range axis
    z=[altisite+vresol:vresol:altisite+vresol*nl]

else
    mprintf('%s\n','Error Opening Netcdf')
    abort
end

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
// l'erreur sur le fd ne marche pas toujours...
// on teste l'existence sur le premier parametre de sortie : lid_time

if length(lid_time)==0 then
    mprintf('%s\n','Error Opening Netcdf')
    abort
end



endfunction
