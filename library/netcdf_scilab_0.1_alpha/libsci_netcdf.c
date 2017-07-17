#include <mex.h> 
#include <sci_gateway.h>
#include <api_scilab.h>
#include <MALLOC.h>
static int direct_gateway(char *fname,void F(void)) { F();return 0;};
extern Gatefunc intsnetcdf_open;
extern Gatefunc intsnetcdf_close;
extern Gatefunc intsnetcdf_getFloatVar;
extern Gatefunc intsnetcdf_getIntVar;
extern Gatefunc intsnetcdf_getCharVar;
static GenericTable Tab[]={
  {(Myinterfun)sci_gateway,intsnetcdf_open,"netcdf_open"},
  {(Myinterfun)sci_gateway,intsnetcdf_close,"netcdf_close"},
  {(Myinterfun)sci_gateway,intsnetcdf_getFloatVar,"netcdf_getFloatVar"},
  {(Myinterfun)sci_gateway,intsnetcdf_getIntVar,"netcdf_getIntVar"},
  {(Myinterfun)sci_gateway,intsnetcdf_getCharVar,"netcdf_getCharVar"},
};
 
int C2F(libsci_netcdf)()
{
  Rhs = Max(0, Rhs);
  if (*(Tab[Fin-1].f) != NULL) 
  {
     if(pvApiCtx == NULL)
     {
       pvApiCtx = (StrCtx*)MALLOC(sizeof(StrCtx));
     }
     pvApiCtx->pstName = (char*)Tab[Fin-1].name;
    (*(Tab[Fin-1].f))(Tab[Fin-1].name,Tab[Fin-1].F);
  }
  return 0;
}
