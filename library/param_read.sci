function[lid_site,lid_file,lid_data,aer_site,lambda,zmin,extrap_typ,width_f,nprol,width_wave,thr_cloud,zmin_bl,zmax_bl,zmax_tl,nproc,thr1,thr2,z1,z2,ntime,beta_a_zref,theta,min_pr2,max_pr2,min_ext,max_ext,min_aod,max_aod]=param_read(site)
//Read parameters file for site
//

// - - - - - - - - - - - - - - - - - - - - - - - -
//Parameters File Reading
//params=read_csv(strcat([path_parameters,site,'-parameters.txt']),"\t");
params=mgetl(strcat([path_parameters,site,'-parameters.txt']));

lid_site=tokens(params(2));lid_site=lid_site(2);
lid_file=tokens(params(3));lid_file=lid_file(2);
lid_data=tokens(params(4));lid_data=lid_data(2);
aer_site=tokens(params(5));aer_site=aer_site(2);
lambda=tokens(params(6));lambda=lambda(2);
zmin=tokens(params(8));zmin=evstr(zmin(2));
extrap_typ=tokens(params(9));extrap_typ=extrap_typ(2);
width_f=tokens(params(11));width_f=evstr(width_f(2));
nprol=tokens(params(13));nprol=evstr(nprol(2));
width_wave=tokens(params(14));width_wave=evstr(width_wave(2));
thr_cloud=tokens(params(15));thr_cloud=evstr(thr_cloud(2));
zmin_bl=tokens(params(16));zmin_bl=evstr(zmin_bl(2));
zmax_bl=tokens(params(17));zmax_bl=evstr(zmax_bl(2));
zmax_tl=tokens(params(18));zmax_tl=evstr(zmax_tl(2));
nproc=tokens(params(20));nproc=evstr(nproc(2));
thr1=tokens(params(21));thr1=evstr(thr1(2));
thr2=tokens(params(22));thr2=evstr(thr2(2));
z1=tokens(params(24));z1=evstr(z1(2));
z2=tokens(params(25));z2=evstr(z2(2));
ntime=tokens(params(27));ntime=evstr(ntime(2));
beta_a_zref=tokens(params(28));beta_a_zref=evstr(beta_a_zref(2));
theta=tokens(params(29));theta=evstr(theta(2));
min_pr2=tokens(params(31));min_pr2=min_pr2(2);
max_pr2=tokens(params(32));max_pr2=max_pr2(2);
min_ext=tokens(params(33));min_ext=min_ext(2);
max_ext=tokens(params(34));max_ext=max_ext(2);
min_aod=tokens(params(35));min_aod=min_aod(2);
max_aod=tokens(params(36));max_aod=max_aod(2);

// - - - - - - - - - - - - - - - - - - - - - - - -

endfunction
