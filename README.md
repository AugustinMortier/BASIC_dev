# BASIC v1.5
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
```


- AERONET files

### Requirement :
- Scilab (tested on 5.5.2)

IMPORTANT: Before running the software, increase the Java Heap Memory :
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
