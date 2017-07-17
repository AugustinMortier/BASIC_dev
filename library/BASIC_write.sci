function[]=BASIC_write(params,lid,LAY,INV)
// write 2 files :
//- INV : Inversion results (time, Sa, AOD, number of profiles, number of clear profiles, Extinction ptofiles) 
//-LAY : Layers files (time, Boundary Layer, Top Layer, Nu:ber of clouds, Clouds bases, Clouds peaks, Clouds top)

mprintf('%s\t\t','Writing Results')
try
// - - - - - - - - - - - - - - - - - - - - - - - - 
// OUTPUT n°1
//
//flag %nan
flag=-9.9;
LAY.base(isnan(LAY.base))=flag;
LAY.peak(isnan(LAY.peak))=flag;
LAY.top(isnan(LAY.top))=flag;
LAY.bl(isnan(LAY.bl))=flag;
LAY.tl(isnan(LAY.tl))=flag;
if inv_mod=='sa' then
    pathout=strcat([path_out,site,'/',year,month,'/',day,'/',inv_mod,'_',string(sa_apriori),'/']);
else
    pathout=strcat([path_out,site,'/',year,month,'/',day,'/',inv_mod,'/']);
end
//pathout=strcat([path_out,site,'/',year,month,'/',day,'/sa_50/']);
mkdir(pathout)
filout1=strcat([pathout,site,year,month,day,'_LAY'])
header=['Time(UT)','SI','Bl(m)','TL(m)','Nb_cloud','Base1','Base2','Base3','Base4','Base5','Base6','Base7','Base8','Base9','Base10','Peak1','Peak2','Peak3','Peak4','Peak5','Peak6','Peak7','Peak8','Peak9','Peak10','Top1','Top2','Top3','Top4','Top5','Top6','Top7','Top8','Top9','Top10'];
OUT=[LAY.time,LAY.si,LAY.bl,LAY.tl,LAY.nbcld,LAY.base,LAY.peak,LAY.top];
fmt_header=strcat([repmat('%s\t',1,size(header,2)),'\n']);
fmt_out=strcat(['%4.2f\t','%6.4f\t','%5.2f\t','%5.2f\t','%i\t',repmat(['%6.4f\t'],1,3*10),'\n'])

fd=mopen(filout1,'w')
mfprintf(fd,fmt_header,header)
mfprintf(fd,fmt_out,OUT)
mclose(fd)



// OUTPUT n°2
// - - - - - - - - - - - - - - - - - - - - - - - - 

//flag %nan
INV.sa(isnan(INV.sa))=flag;
INV.ext(isnan(INV.ext))=flag;

filout2=strcat([pathout,site,year,month,day,'_INV'])
header=['Time(UT)',strcat(['aod@',params.lambda]),'SI','clear_nb','total_nb','Sa(sr)',string(lid.z(1:params.z2/lid.vresol))]
OUT=[INV.time,INV.aod,INV.si,INV.nb_ok,INV.nb_tot,INV.sa,INV.ext]

fmt_header=strcat([repmat('%s\t',1,size(header,2)),'\n']);
fmt_out=strcat(['%4.2f\t','%3.2f\t','%4.2f\t','%i\t','%i\t','%4.2f\t',repmat('%6.4f\t',1,size(INV.ext,2)),'\n'])

fd=mopen(filout2,'w')
mfprintf(fd,fmt_header,header)
mfprintf(fd,fmt_out,OUT)
mclose(fd)


mprintf('%s\n','√')
catch
mprintf('%s\n','X')
abort
end

endfunction

