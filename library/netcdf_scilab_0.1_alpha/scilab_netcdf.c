
#include "netcdf.h"

void scilab_netcdf_open_(char *filename, int *fd) {
    int result = nc_open(filename, 0, fd);
    /* if (result == 0) 
        *fd = -1; */

    result = nc_enddef(*fd);
    }

void scilab_netcdf_close_(int *fd, int *close_status) {
    *close_status = nc_close(*fd);
    }


void scilab_netcdf_getFloatVar_(int *fd, char *str, double **result, int *len) {
    int i, j, sz, n_dims, var_id, status;
    int *dims;
    *len = 1;

    status = nc_inq_varid(*fd, str, &var_id);
    status = nc_inq_varndims(*fd, var_id, &n_dims);
    dims = (int *) calloc(n_dims, sizeof(int));
    status = nc_inq_vardimid(*fd, var_id, dims);

    for (i = 0; i < n_dims; i++) {
        size_t dim_length;
        status = nc_inq_dimlen(*fd, dims[i], &dim_length);
        *len *= dim_length;
        }

    *result = (double *) malloc(*len * sizeof(double));
    status = nc_get_var_double(*fd, var_id, *result);

    free(dims);
    }

void scilab_netcdf_getIntVar_(int *fd, char *str, int **result, int *len) {
    int i, j, sz, n_dims, var_id, status;
    int *dims;
    *len = 1;

    status = nc_inq_varid(*fd, str, &var_id);
    status = nc_inq_varndims(*fd, var_id, &n_dims);
    dims = (int *) calloc(n_dims, sizeof(int));
    status = nc_inq_vardimid(*fd, var_id, dims);

    for (i = 0; i < n_dims; i++) {
        size_t dim_length;
        status = nc_inq_dimlen(*fd, dims[i], &dim_length);
        *len *= dim_length;
        }

    *result = (int *) malloc(*len * sizeof(int));
    status = nc_get_var_int(*fd, var_id, *result);

    free(dims);
    }

void scilab_netcdf_getCharVar_(int *fd, char *str, char **result, int *len) {
    int i, j, sz, n_dims, var_id, status;
    int *dims;
    *len = 1;

    status = nc_inq_varid(*fd, str, &var_id);
    status = nc_inq_varndims(*fd, var_id, &n_dims);
    dims = (int *) calloc(n_dims, sizeof(int));
    status = nc_inq_vardimid(*fd, var_id, dims);

    for (i = 0; i < n_dims; i++) {
        size_t dim_length;
        status = nc_inq_dimlen(*fd, dims[i], &dim_length);
        *len *= dim_length;
        }

    *result = (char *) malloc(*len * sizeof(char));
    status = nc_get_var_text(*fd, var_id, *result);

    printf("         %s\n", *result);

    free(dims);
    }

