# BASIC dev
Software (Scilab running) for Lidar/Sun photometer data processing and visualization


This version reads:
- ASCII Lidar files formatted as following:

```
#Level 1 Data
# PI: xx (mailto: xx.fr)
#Time    Z(km)     Ln(Pr2)
0.000833333 0.015 -19.1413
0.000833333 0.045 -7.78543
0.000833333 0.06 -7.22136
0.000833333 0.105 -4.91273
0.000833333 0.12 -5.48947
0.000833333 0.135 -6.81563
0.000833333 0.15 -7.43927
0.000833333 0.165 -7.75094
0.000833333 0.18 -7.93884
0.000833333 0.195 -8.03819
0.000833333 0.21 -8.09097
...
```


- AERONET files

### Requirement :
- Scilab (tested on 5.5.2)

**IMPORTANT:** Before running the software, increase the Java Heap Memory :
Edit -> Preferences -> Java Heap Memory from 256 to 1024 (or more)

### Launch :
```
scilab -nb -nw -nouserstartup -f /path/BASIC.sce -args SITE YY MM DD MOD_INV [options]
```
with
MOD_INV :
- LEVxx : AERONET File (level : xx)
or
- SA_xx : Lidar Ratio (xx sr)

\[Options\]
- fig : display and save figures in directory indicated in PATH (QL, inversion)
- out : extract data and write txt files ind directory indicated in PATH (LAY, INV)

### Exemples:
Run Lille 30 of March 2014 with AERONET Lev1.5 data, creates figures and output file
```
scilab -nb -nw -nouserstartup -f ./BASIC.sce -args Lille 14 03 30 lev15 fig out
```

Run Lille 30 of March 2014 assuming a Lidar Ratio of 50 sr, creates figures
```
scilab -nb -nw -nouserstartup -f ./BASIC.sce -args Lille 14 03 30 sa_50 fig
```

Several figures are created including:

![Attenuated Backscatter Profiles](https://github.com/AugustinMortier/BASIC/blob/master/fig/Lille/1403/30/aod/QL-Lille-140330.bmp "Attenuated Backscatter Profiles")
Attenuated Backscatter Profiles - Lille 30/03/2014.


![Layers](https://github.com/AugustinMortier/BASIC/blob/master/fig/Lille/1403/30/aod/LAY-Lille-140330.bmp "Clouds and Aerosol Layers")
Clouds and Aerosol Layers - Lille 30/03/2014.  
Note: better clouds detection is found when PR2 are used as input for Lidar file instead of ln(PR2)

![Slope Index](https://github.com/AugustinMortier/BASIC/blob/master/fig/Lille/1403/30/aod/SI-Lille-140330.bmp "Slope Index")
Slope Index - Lille 30/03/2014.  
This parameter shows how the Lidar signal fits with a theoritical molecular signal at high altitude. The best quality index is 1. Profiles associated with SI>0.5 and SI<1.5 reveal a good agreement with the molecular slope at the reference point (found between Z1 and Z2). Values found outside of these values might reveal low signal, or the presence of aerosols or clouds between Z1 and Z2 (here, 6 km and 8 km).

![Iversion](https://github.com/AugustinMortier/BASIC/blob/master/fig/Lille/1403/30/aod/EXTSA-Lille-140330.bmp "Extinction profiles and Lidar Ratio")
Extinction profiles, AOD and Lidar Ratio - Lille 30/03/2014.

## Parameters file description

```
#SITE PARAMETERS
lid_Site : name of the Lidar Site
lid_file=LOA_CE370_L1B-PR2_yyyy-mm-ddT00-00-00_1440_V1-00.nc : name of Lidar file
lid_data=rcs_532_nop_ph_l0_t0 : name of RCS field (NetCDF)
lid_var=lnpr2 / pr2 :  the lid_file contains wether Range Corrected Signal (pr2), or lnpr2 
aer_Site : name of the co-located AERONET station
lambda=532 : Wavelength (nm)
#EXTRAPOLATION
zmin=300 : minimal altitude (m) below the extrapolation is done
type=cst : extrapolation method: constante (cst) or linear (lin)
#SPECTRAL FILTERING
width=0.5 : spectral filtering width (0 : no filtering - 1 : maximum filtering)
#LAYERS
nprol : number of profiles averaged in time for PBL and TL layers detections
width_wave=210 : wavelet width (m)
thr_cloud=-10 : threshold on convolution between RCS and wavelet for rough clouds detection
zmin_bl=330 : minimal altitude of boundary layer (m)
zmax_bl=3000 : maximal altitude of boundary layer (m)
zmax_tl=4000 : maximal altitude of top layer (m)
#CLOUDING
nproc : number of profiles averaged in time for cloud detection
thr1=10 : first threshold for significant layers detection regarding to signal noise
thr2=4 : second threshold for clouds detection (RCS(icloud)max / RCS(icloud)top > thr2)
#REF ALTITUDE
Z1=4000 : minimal altitude (m) for reference altitude
Z2=6000 : maximal altitude (m) for reference altitude
#INVERSION
ntime=20 : time average for inversion (min)
beta_a_href=5E-8 : aerosol backscattering at reference altitude (1/m.1/sr)
theta : angle of Lidar (0 : vertical)
#DISPLAY : Impose boundaries for color scale pictures or let the algorithm calculate it
min_pr2 Auto / float
max_pr2 Auto / float
min_ext Auto / float
max_ext Auto / float
min_aod Auto / float
max_aod Auto / float
fmt png/jpg/bmp : format of pictures exportation. In some configurations, the only bmp format might work under MacOS 
```
