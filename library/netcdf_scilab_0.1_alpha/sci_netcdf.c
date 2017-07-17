#include "stack-c.h"
#include "scilab_netcdf.h"
/******************************************
 * SCILAB function : netcdf_open, fin = 1
 ******************************************/

int intsnetcdf_open(fname)
   char *fname;
{
 int m1,n1,l1,un=1,l2;
 CheckRhs(1,1);
 CheckLhs(1,1);
 /*  checking variable str */
 GetRhsVar(1,"c",&m1,&n1,&l1);
 /* cross variable size checking */
 CreateVar(2,"i",&un,&un,&l2);/* named: fd */
 C2F(scilab_netcdf_open)(cstk(l1),istk(l2));
 LhsVar(1)= 2;
 return 0;
}
/******************************************
 * SCILAB function : netcdf_close, fin = 2
 ******************************************/

int intsnetcdf_close(fname)
   char *fname;
{
 int m1,n1,l1,un=1,l2;
 CheckRhs(1,1);
 CheckLhs(1,1);
 /*  checking variable fd */
 GetRhsVar(1,"i",&m1,&n1,&l1);
 CheckScalar(1,m1,n1);
 /* cross variable size checking */
 CreateVar(2,"i",&un,&un,&l2);/* named: close_status */
 C2F(scilab_netcdf_close)(istk(l1),istk(l2));
 LhsVar(1)= 2;
 return 0;
}
/******************************************
 * SCILAB function : netcdf_getFloatVar, fin = 3
 ******************************************/

int intsnetcdf_getFloatVar(fname)
   char *fname;
{
 int m1,n1,l1,m2,n2,l2,me3,un=1,mn3,ne3,loc2;
 double *le3;
 CheckRhs(2,2);
 CheckLhs(1,1);
 /*  checking variable fd */
 GetRhsVar(1,"i",&m1,&n1,&l1);
 CheckScalar(1,m1,n1);
 /*  checking variable str */
 GetRhsVar(2,"c",&m2,&n2,&l2);
 /* cross variable size checking */
 /* external variable named result (xxe3) */
 C2F(scilab_netcdf_getFloatVar)(istk(l1),cstk(l2),&le3,&me3);
 CreateVarFromPtr(3,"d",&me3,(loc2=1,&loc2),&le3);
 if (me3*1 != 0) FreePtr(&le3);
 LhsVar(1)=3;
 return 0;
}
/******************************************
 * SCILAB function : netcdf_getIntVar, fin = 4
 ******************************************/

int intsnetcdf_getIntVar(fname)
   char *fname;
{
 int m1,n1,l1,m2,n2,l2,me3,un=1,mn3,ne3,loc2;
 int  *le3;
 CheckRhs(2,2);
 CheckLhs(1,1);
 /*  checking variable fd */
 GetRhsVar(1,"i",&m1,&n1,&l1);
 CheckScalar(1,m1,n1);
 /*  checking variable str */
 GetRhsVar(2,"c",&m2,&n2,&l2);
 /* cross variable size checking */
 /* external variable named result (xxe3) */
 C2F(scilab_netcdf_getIntVar)(istk(l1),cstk(l2),&le3,&me3);
 CreateVarFromPtr(3,"i",&me3,(loc2=1,&loc2),&le3);
 if (me3*1 != 0) FreePtr(&le3);
 LhsVar(1)=3;
 return 0;
}
/******************************************
 * SCILAB function : netcdf_getCharVar, fin = 5
 ******************************************/

int intsnetcdf_getCharVar(fname)
   char *fname;
{
 int m1,n1,l1,m2,n2,l2,me3,un=1,mn3,ne3,loc2;
 char *le3;
 CheckRhs(2,2);
 CheckLhs(1,1);
 /*  checking variable fd */
 GetRhsVar(1,"i",&m1,&n1,&l1);
 CheckScalar(1,m1,n1);
 /*  checking variable str */
 GetRhsVar(2,"c",&m2,&n2,&l2);
 /* cross variable size checking */
 /* external variable named result (xxe3) */
 C2F(scilab_netcdf_getCharVar)(istk(l1),cstk(l2),&le3,&me3);
 CreateVarFromPtr(3,"c",&me3,(loc2=1,&loc2),&le3);
 if (me3*1 != 0) FreePtr(&le3);
 LhsVar(1)=3;
 return 0;
}
