function[sci]=sci_read_ascii(lid_site,lid_file,year,month,day)
//Reading Lidar Ascii files downloaded from LOA
// A. Mortier - 24/06/2014


//name of file (find "yyyy","mm","dd" and replace by value)
lid_file=strsubst(lid_file,'yyyy',strcat(['20',year]));
lid_file=strsubst(lid_file,'mm',month);
lid_file=strsubst(lid_file,'dd',day);

//look for extension
ext=strindex(lid_file,'.')
lid_file=strcat([part(lid_file,1:ext-1),'-add',part(lid_file,ext:$)])

//delete non data lines
path_dataLID2=strcat([path_dataLID,lid_site,'/20',year,'/',month,"/"])
unix_s(strcat(['sed ''/#/d'' ',path_dataLID2,lid_file,' > ',path_dataLID2,'tmp1_',year,month,day]))
unix_s(strcat(['sed ''/@/d'' ',path_dataLID2,'tmp1_',year,month,day,' > ',path_dataLID2,'tmp2_',year,month,day]))

//sed * en 0
unix_s(strcat(['sed -i ''s/*/0/g'' ',path_dataLID2,'tmp2_',year,month,day]))

//reading file
M=fscanfMat(strcat([path_dataLID2,'tmp2_',year,month,day]));
time=M(:,1);
sci=M(:,2);


//delete temporary files
unix_s(strcat(['rm ',path_dataLID2,'tmp*_',year,month,day]));



endfunction
