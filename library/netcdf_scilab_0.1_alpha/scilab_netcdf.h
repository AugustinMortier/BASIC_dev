
#ifndef _SCILAB_NETCDF_H_
#define _SCILAB_NETCDF_H_

#include "netcdf.h"

void scilab_netcdf_open_(char *filename, int *fd);
void scilab_netcdf_close_(int *fd, int *close_status);
void scilab_netcdf_getFloatVar_(int *fd, char *str, double **result, int *len);
void scilab_netcdf_getIntVar_(int *fd, char *str, int **result, int *len);
void scilab_netcdf_getCharVar_(int *fd, char *str, char **result, int *len);

#endif
