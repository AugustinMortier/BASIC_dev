//function[params,aer,lid]=BASIC_input(site,year,month,day,aer_level,inv_mod)

//Read Jenoptik NetCDF Files and convert to ASCII
// A. Mortier - MetNo
//03/09/2014 - version 1.0
clear
stacksize('max')


//input
site='oslo';Site='Oslo';
yyyy='2014';mm='09';dd='03';


mprintf('%s\n','Netcdf2ASCII Conversion')
//try
// - - - - - - - - - - - - - - - - - - - - - - - - 
//                  NetCDF READING                 
// - - - - - - - - - - - - - - - - - - - - - - - - 

lid_dir=strcat(['/metno/obssatdata/ceilometer-data/',yyyy,'/',mm,'/',dd,'/','raw','/',site,'/']);
dir_out=strcat(['/home/augustinm/Desktop/BASIC/data/LID/',Site,'/',yyyy,'/',mm,'/']);
file_out=strcat([dir_out,Site,'_1064_',yyyy,mm,dd,'.txt'])

dir_files=dir(lid_dir);
list_files=dir_files(2);
//check name of files
list_files=list_files(grep(list_files,'.nc'));

if isempty(list_files) then
    mprintf('%s\n','Empty Folder')
end

//Overlap correction
FR=fscanfMat('/home/augustinm/Desktop/BASIC/data/LID/Oslo/FR/TUB110019.dat')

for i=1:size(list_files,1)
    disp(i)
    fil=strcat([lid_dir,list_files(i)]);
    
    //time reading
    head_time='time';
    out=unix_g(strcat(['ncdump -v ',head_time,' ',fil]));
    total_line=size(out,1);
    //add 2 because 'data' is 2 lines above
    data_line=grep(out,'data')+2;
    time1=strcat([out(data_line:total_line-1)]);
    [ind, which] = strindex(time1,'= ');
    time=evstr(tokens(part(time1,ind+1:length(time1)-1),','));
    
    
    //range reading
    head_range='range';
    out=unix_g(strcat(['ncdump -v ',head_range,' ',fil]));
    total_line=size(out,1);
    //add 2 because 'data' is 2 lines above
    data_line=grep(out,'data')+2;
    range1=strcat([out(data_line:total_line-1)]);
    [ind, which] = strindex(range1,'= ');
    z=evstr(tokens(part(range1,ind+1:length(range1)-1),','));
    
    //beta_raw reading
    head_beta_raw='beta_raw';
    out=unix_g(strcat(['ncdump -v ',head_beta_raw,' ',fil]));
    total_line=size(out,1);
    //add 2 because 'data' is 2 lines above
    data_line=grep(out,'data')+2;
    beta_raw1=strcat([out(data_line:total_line-1)]);
    [ind, which] = strindex(beta_raw1,'= ');
    beta_raw=evstr(tokens(part(beta_raw1,ind+1:length(beta_raw1)-1),','));
    
    beta_tab=zeros(length(z),length(time));
    for j=1:size(beta_tab,2)
        beta_tab(:,j)=beta_raw((j-1)*length(z)+1:j*length(z));
    end
    
    //time averaging (1 profile/15sec -> 1 profile/min)
    //to do : read time in the file ncdump -t -v time
    nb_avg=4;//nb of profiles averaged
    if round(length(time/nb_avg))==length(time/nb_avg) then
        avg_time=zeros(length(time)/nb_avg,1);
        avg_beta=zeros(length(z),length(avg_time));
        
        //read time in title
        undersc=strindex(fil,'_');
        hh=evstr(part(fil,undersc(3)+1:undersc(3)+2));
        mm=evstr(part(fil,undersc(3)+3:undersc(3)+4));
        
        for j=1:length(avg_time)
            avg_time(j)=hh+(mm+(j-1))/60;
            avg_beta(:,j)=mean(beta_tab(:,(j-1)*nb_avg+1:nb_avg*j),'c');
        end
    else
        mprintf('%s\n','uncomplete file')
    end
    
    //concatenation
//    TIME=[TIME;avg_time];
//    BETA=[BETA,avg_beta];
    
    
    //writing
    fmt_out=strcat(['%4.2f\t','%6.4f\t','%8.2f','\n'])
    
    for j=1:length(avg_time)
        if j==1 & i==1 then
            //unix_s(strcat(['rm ',file_out]))
            fd1=mopen(file_out,'wt')
            mfprintf(fd1,'%s\n','# Converted file from NetCDF')
            mfprintf(fd1,'%s\t%s\t%s\n','# Time (UT)','Range (km)','RCS')
        end
            mfprintf(fd1,fmt_out,[repmat(avg_time(j),length(z),1),z*1E-3,avg_beta(:,j)*1e-3./FR])
    end
    
end

//mclose(fd1)





//endfunction

