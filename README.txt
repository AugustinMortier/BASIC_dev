BASICv1.0

AUTHOR : A. Mortier
		Laboratoire d'Optique Atmosphérique
		Université de Lille 1
CONTACT : augustin.mortier@ed.univ-lille1.fr



REQUIREMENT : 
- Scilab


LAUNCH : 

scilab -nb -nw -nouserstartup -f /Users/mortier/Desktop/BASIC/BASIC.sce -args SITE YY MM DD MOD_INV [options]


with 

MOD_INV :
- LEV** : AERONET File (level : **) 
or
- SA_** : Lidar Ratio (** sr)

[Options]
- fig : display and save figures in directory indicated in PATH (QL, inversion)
- out : extract data and write txt files ind directory indicated in PATH (LAY, INV)



ex : 
scilab -nb -nw -nouserstartup -f /Users/mortier/Desktop/BASIC/BASIC.sce -args Palaiseau 12 03 20 lev15 fig out

scilab -nb -nw -nouserstartup -f /Users/mortier/Desktop/BASIC/BASIC.sce -args Palaiseau 12 03 20 sa_50 fig



- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
PARAMETERS FILE DESCRIPTION

#SITE PARAMETERS
lid_Site : name of the Lidar Site
lid_file=LOA_CE370_L1B-PR2_yyyy-mm-ddT00-00-00_1440_V1-00.nc : name of Lidar file
lid_data=rcs_532_nop_ph_l0_t0 : name of RCS field (NetCDF)
lambda=532 : Wavelength (nm) 
#EXTRAPOLATION
zmin=300 : minimal altitude (m) below the extrapolation is done
type=cst : extrapolation method: constante (cst) or linear (lin)
#SPECTRAL FILTERING
width_f=0.5 : spectral filtering width (0 : no filtering - 1 : maximum filtering)
#LAYERS
width_wave=210 : wavelet width (m)
thr_cloud=-10 : threshold on convolution between RCS and wavelet for rough clouds detection
zmin_bl=330 : minimal altitude of boundary layer (m)
zmax_bl=3000 : maximal altitude of boundary layer (m)
zmax_tl=4000 : maximal altitude of top layer (m)
#CLOUDING
thr1=10 : first threshold for significant layers detection regarding to signal noise
thr2=4 : second threshold for clouds detection (RCS(icloud)max / RCS(icloud)top > thr2)
#REF ALTITUDE
Z1=4000 : minimal altitude (m) for reference altitude
Z2=6000 : maximal altitude (m) for reference altitude
#INVERSION
ntime=10 : time average for inversion (min)
beta_a_zref=5E-8 : aerosol backscattering at reference altitude (1/m.1/sr)
theta : angle of Lidar (0 : vertical)
#DISPLAY : Impose boundaries for color scale pictures or let the algorithm calculate it
min_pr2	Auto / integer
max_pr2	Auto / integer
min_ext	Auto / integer
max_ext	Auto / integer
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


