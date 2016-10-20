// - - - - - - - BASIC - - - - - - - 
//
// A. Mortier - augustinmortier@gmail.com
// Laboratoire d'Optique Atmospherique - Universite de Lille 1
// 23/06/2013 - version 1.0
// 20/06/2014 - version 1.1 : updates for ASCII reading (only) and optimization of several functions
//
//This software provides layers altitude (Boundary Layer & Top Layer), Cloud detection and process Klett inversion constrained by AERONET AOD or Lidar Ratio.
//
//input :        - lidar file (format NetCDF or ASCII)
//			- aeronet file (AERONET format) IF CONSTRAINT BY AOD
//			- parameters file
//output :      - figures if "fig" among arguments
//		    - txtT Files if "out" among arguments : _LAY (Layers) & _INV (Inversion)


clear
stacksize('max')
mprintf('%s\n',' --BASIC- -  -    -`•´-')

// - - - - - - - - - - - - - - - - - - - - - - - - 
//              ARGUMENTS READING                
// - - - - - - - - - - - - - - - - - - - - - - - - 
//read of site, date and aer_lev
list_args=sciargs()
//indpath_exec=grep(list_args,'.sce')
//slashes=strindex(list_args(indpath_exec),"/")
//here=strcat([part(list_args(indpath_exec),1:slashes($)-1),"/"]);
here = get_absolute_file_path('BASIC.sce')

ind=find(list_args=="-args")
if length(ind)==0 then
    mprintf('%s \n','No arguments')
end  
args=list_args(ind+1:$);
nb_args=grep(args,"nw")-1;
args=args(1:nb_args);
if size(args,2)>=5 then
    site=args(1);
    year=args(2);
    month=args(3);
    day=args(4);
    //si args 5 comprend lev, alors aeronet et inv_mod="aod"
    aer_level=args(5);
    if part(aer_level,1:3)=="lev" then
        inv_mod="aod";sa_apriori=[];
    else
        if part(aer_level,1:3)=="sa_" then
            //sinon, sa_50, alors inv_mod=50 et sa_apriori = 50
            inv_mod="sa";sa_apriori=evstr(part(aer_level,4:7))
        else
            mprintf("%s \n",'Wrong 5th Argument: sa_.. or lev.. expected')
            exit
        end
    end
    
    
    if size(args,2)>5 then
        add_args=args(6:$);
        fig=grep(add_args,"fig")
        out=grep(add_args,"out")
    else
        fig=0;out=0;
    end
else
    mprintf("%s \n",'5 Arguments Expected !')
    exit
end
//mprintf('%s \n','· · · · · · · · · · · · · · ·')
mprintf('%s %s %s %s %s \n',site,'-',year,month,day)
// - - - - - - - - - - - - - - - - - - - - - - - -
// - - - - - - - - - - - - - - - - - - - - - - - - 



//site="OPGC";year="12";month="03";day="28";aer_level="lev15";here="/Users/mortier/Desktop/BASIC/";inv_mod="aod";sa_apriori=[];
//site="Palaiseau";year="12";month="03";day="22";aer_level="lev15";here="/Users/mortier/Desktop/BASIC_work/BASIC/";inv_mod="aod";sa_apriori=[];fig=1;
//site="OPE";year="12";month="03";day="20";aer_level="lev10";here="/Users/mortier/Desktop/BASIC_work/BASIC/";fig=1;inv_mod="aod";sa_apriori=[];
//site="Lille";year="12";month="03";day="20";aer_level="lev10";here="/Users/mortier/Desktop/BASIC_work/BASIC/";inv_mod="aod";sa_apriori=[];fig=1;
//site="Beijing";year="14";month="01";day="02";aer_level="lev10";here="/Users/mortier/Desktop/postdoc/Beijing/work/BASIC/";inv_mod="sa";sa_apriori="70";fig=1;out=1;
//
//site="LILAS-AN532";year="14";month="03";day="30";fig=1;out=1;
//site="Lille";year="14";month="03";day="30";fig=1;out=1;
//aer_level="lev15";inv_mod="aod";sa_apriori=[];


here = get_absolute_file_path('BASIC.sce')


// - - - - - - - - - - - - - - - - - - - - - - - - 
//              Path for BASIC.sce                
// - - - - - - - - - - - - - - - - - - - - - - - - 
mprintf('%s \n',strcat([here,'PATH.txt']))
PATH=mgetl(strcat([here,'PATH.txt']))
path_parameters=PATH(1)
path_library=PATH(2);
path_dataLID=PATH(3);
path_dataAER=PATH(4);
path_out=PATH(5);
path_fig=PATH(6);

//Library LOADING
BASIC_lib=lib(strcat([path_library]))
// - - - - - - - - - - - - - - - - - - - - - - - -
// - - - - - - - - - - - - - - - - - - - - - - - - 



// - - - - - - - - - - - - - - - - - - - - - - - - 
//                 BASIC INPUT                    
// - - - - - - - - - - - - - - - - - - - - - - - - 
[params,aer,lid]=BASIC_input(site,year,month,day,aer_level,inv_mod);
// - - - - - - - - - - - - - - - - - - - - - - - - 
// - - - - - - - - - - - - - - - - - - - - - - - - 




// - - - - - - - - - - - - - - - - - - - - - - - - 
//                 BASIC PROCESSING                
// - - - - - - - - - - - - - - - - - - - - - - - - 
if length(aer.aod)>0 then
    [LAY,INV,lid]=BASIC_processing(params,lid,aer,inv_mod,sa_apriori);
else
    abort
end
// - - - - - - - - - - - - - - - - - - - - - - - - 
// - - - - - - - - - - - - - - - - - - - - - - - - 



if fig>0 then
    // - - - - - - - - - - - - - - - - - - - - - - - - 
    //                  BASIC DISPLAY                  
    // - - - - - - - - - - - - - - - - - - - - - - - - 
    if length(aer.aod)>0 then
        BASIC_display(params,lid,aer,LAY,INV);
    else
        abort
    end
    // - - - - - - - - - - - - - - - - - - - - - - - - 
    // - - - - - - - - - - - - - - - - - - - - - - - - 
end




if out>0 then
    // - - - - - - - - - - - - - - - - - - - - - - - - 
    //                  BASIC WRITE                  
    // - - - - - - - - - - - - - - - - - - - - - - - - 
    BASIC_write(params,lid,LAY,INV);
    // - - - - - - - - - - - - - - - - - - - - - - - - 
    // - - - - - - - - - - - - - - - - - - - - - - - - 
end



exit

