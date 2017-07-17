function[params,aer,lid]=BASIC_input(site,year,month,day,aer_level,inv_mod)

//Read parameters, aeronet and Lidar files
// A. Mortier - Laboratoire d'Optique Atmospherique - Universite de Lille 1
//21/06/2013 - version 1.0


mprintf('%s\t','Parameters Reading')
try
// - - - - - - - - - - - - - - - - - - - - - - - - 
//              Parameters File Reading            
// - - - - - - - - - - - - - - - - - - - - - - - - 
[lid_site,lid_file,lid_data,aer_site,lambda,zmin,extrap_typ,width_f,nprol,width_wave,thr_cloud,zmin_bl,zmax_bl,zmax_tl,thr_tl,nproc,thr1,thr2,z1,z2,ntime,beta_a_zref,theta,min_pr2,max_pr2,min_ext,max_ext,min_aod,max_aod,min_ext2,max_ext2,min_aod2,max_aod2]=param_read(site);
// - - - - - - - - - - - - - - - - - - - - - - - - 
// - - - - - - - - - - - - - - - - - - - - - - - - 
params=struct("lid_site",lid_site,"lid_file",lid_file,"lid_data",lid_data,"aer_site",aer_site,"lambda",lambda,"zmin",zmin,"extrap_typ",extrap_typ,"width_f",width_f,"nprol",nprol,"width_wave",width_wave,"thr_cloud",thr_cloud,"zmin_bl",zmin_bl,"zmax_bl",zmax_bl,"zmax_tl",zmax_tl,"thr_tl",thr_tl,"nproc",nproc,"thr1",thr1,"thr2",thr2,"z1",z1,"z2",z2,"ntime",ntime,"beta_a_zref",beta_a_zref,"theta",theta,"min_pr2",min_pr2,"max_pr2",max_pr2,"min_ext",min_ext,"max_ext",max_ext,"min_aod",min_aod,"max_aod",max_aod,"min_ext2",min_ext2,"max_ext2",max_ext2,"min_aod2",min_aod2,"max_aod2",max_aod2)
//aug_params = params
//save('aug_params.sod', aug_params)
//clear aug_params

mprintf('%s\n','√')
catch
mprintf('%s\n','X')
exit
end



mprintf('%s\t\t','LIDAR reading')
try
// - - - - - - - - - - - - - - - - - - - - - - - -
//                  LIDAR Reading                 
// - - - - - - - - - - - - - - - - - - - - - - - - 
// Lidar NetCdF File Reading : EN préparation
// input : lid_site,date
// output : pr2,time,z,lambda
//[lid_time,pr2,z,theta,vresol]=lid_read(params.lid_site,params.lid_file,params.lid_data,year,month,day);
[lid_time,pr2,z,vresol]=lid_read_ascii(params.lid_site,params.lid_file,year,month,day);
//// * * * * * * * * * * * * 
//[sci]=sci_read_ascii(params.lid_site,params.lid_file,year,month,day);
//// * * * * * * * * * * * * 
sci=zeros(lid_time);

// - - patch - - 
[tmax,imax]=max(lid_time);
lid_time=lid_time(1:imax);
pr2=pr2(:,1:imax);
sci=sci(1:imax);
// - - patch - - 

mprintf('%s\n','√')
catch
mprintf('%s\n','X')
exit
end

// - - - - - - - - - - - - - - - - - - - - - - - -
lid=struct("time",lid_time,"pr2",pr2,"z",z,"theta",theta,"vresol",vresol,"sci",sci);




if inv_mod=="aod" then
    mprintf('%s\t\t','AERONET reading')
    try
    // - - - - - - - - - - - - - - - - - - - - - - - -
    //                AERONET Reading                 
    // - - - - - - - - - - - - - - - - - - - - - - - - 
    // input : ph_site, date, level, lambda
    // output : aodtime, aodlambda
    [aod_time,aod]=sun_readAER(params.aer_site,year,month,day,aer_level,lambda);
    //[aod_time,aod]=sun_readPHO(params.aer_site,year,month,day,aer_level,lambda);
    // - - - - - - - - - - - - - - - - - - - - - - - -
    // - - - - - - - - - - - - - - - - - - - - - - - - 
    mprintf('%s\n','√')
    catch
    mprintf('%s\n','X')
    exit
    end
else
    aod_time=lid.time;
    aod=%nan*ones(aod_time)
end


aer=struct("time",aod_time,"aod",aod)
//aug_aer = aer
//save('aug_aer.sod', aug_aer)
//clear aug_aer


//verif de lecture
//write('/Users/mortier/Desktop/BASIC_work/BASIC/tmp.txt',[lid.z'])


endfunction

