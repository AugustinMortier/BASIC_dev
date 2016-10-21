function[lid_site,lid_file,lid_data,lid_var,aer_site,lambda,zmin,extrap_typ,width_f,nprol,width_wave,thr_cloud,zmin_bl,zmax_bl,zmax_tl,nproc,thr1,thr2,z1,z2,ntime,beta_a_zref,theta,min_pr2,max_pr2,min_ext,max_ext,min_aod,max_aod,fmt]=param_read(site)
//Read parameters file for site
//

// - - - - - - - - - - - - - - - - - - - - - - - -
//Parameters File Reading
//params=read_csv(strcat([path_parameters,site,'-parameters.txt']),"\t");
params=mgetl(strcat([path_parameters,site,'-parameters.txt']));

for nl=2:38
    line=tokens(params(nl));
    if size(line,1)>=2
        param=line(2);
    end
    select nl
        case 2 then lid_site=param;
        case 3 then lid_file=param;
        case 4 then lid_data=param;
        case 5 then lid_var=param;
        case 6 then aer_site=param;
        case 7 then lambda=param;
        case 9 then zmin=evstr(param);
        case 10 then extrap_typ=param;
        case 12 then width_f=evstr(param);
        case 14 then nprol=evstr(param);
        case 15 then width_wave=evstr(param);
        case 16 then thr_cloud=evstr(param);
        case 17 then zmin_bl=evstr(param);
        case 18 then zmax_bl=evstr(param);
        case 19 then zmax_tl=evstr(param);
        case 21 then nproc=evstr(param);
        case 22 then thr1=evstr(param);
        case 23 then thr2=evstr(param);
        case 25 then z1=evstr(param);
        case 26 then z2=evstr(param);
        case 28 then ntime=evstr(param);
        case 29 then beta_a_zref=evstr(param);
        case 30 then theta=evstr(param);
        case 32 then min_pr2=param;
        case 33 then max_pr2=param;
        case 34 then min_ext=param;
        case 35 then max_ext=param;
        case 36 then min_aod=param;
        case 37 then max_aod=param;
        case 38 then fmt=param;
    end
end
// - - - - - - - - - - - - - - - - - - - - - - - -

endfunction
