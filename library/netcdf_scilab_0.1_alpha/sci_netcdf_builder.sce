// generated with intersci 
ilib_name = 'libsci_netcdf'		// interface library name

files = ['sci_netcdf','scilab_netcdf'];
libs = ['libnetcdf'];

table =["netcdf_open","intsnetcdf_open";
	"netcdf_close","intsnetcdf_close";
	"netcdf_getFloatVar","intsnetcdf_getFloatVar";
	"netcdf_getIntVar","intsnetcdf_getIntVar";
	"netcdf_getCharVar","intsnetcdf_getCharVar"];
ilib_build(ilib_name,table,files,libs);
