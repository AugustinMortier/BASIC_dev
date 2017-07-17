function[amol,bmol]=std_atm(z,T0,p_z0,lambda)

//Process Extinction and Backscatter coefficient for a standart molecular atmosphere
//
//Input
//z : Range vector
//T0 : Temperature at level ground (K)
//p_z0 : Pressure at level ground (hPa)
//lambda : Wavelength (nm)


  
  //standart gradients & parameters
  dTdz_tropo=-6.5;
  dTdz_strato=1.4;
  dTdz_meso=-2.4;
  z_tpause=13;
  z_spause=55; 
  p_He=8;


  p_z0=p_z0*100;
  z = z/1000;
  n_tpause=round(interp1(z(1:$-1),1:length(z)-1,z_tpause,'nearest','extrap'));
  n_spause=round(interp1(z(1:$-1),1:length(z)-1,z_spause,'nearest','extrap'));
  Tz(1:n_tpause,1)=T0+dTdz_tropo.*z(1:n_tpause);
  Tz(n_tpause+1:n_spause,1)=T0+dTdz_tropo.*z(n_tpause+1)+dTdz_strato.*(z(n_tpause+1:n_spause)-z(n_tpause+1));
  Tz(n_spause+1:length(z),1)=T0+dTdz_tropo.*z(n_tpause+1)+dTdz_strato.*(z(n_spause+1)-z(n_tpause+1))+dTdz_meso.*(z(n_spause+1:$)-z(n_spause+1));
  Pz=p_z0.*exp(-z./p_He);
  
  N_m=Pz./(8.314/6.023e23.*Tz);
  section_m=5.45*(550./evstr(lambda))^4.09*1e-32;
  bmol=N_m.*section_m;
  amol=8.0*%pi*bmol/3.0;
  
  
endfunction