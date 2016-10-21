function[lid_time,pr2,z,vresol]=lid_read_ascii(lid_site,lid_file,lid_var,year,month,day)
//Reading Lidar Ascii files downloaded from LOA
// A. Mortier - 24/06/2014

//lid_site="Beijing"
//year='14'
//month='06'
//day='11'
//path_dataLID="/Users/mortier/Desktop/postdoc/Beijing/work/BASIC/data/LID/"


//name of file (find "yyyy","mm","dd" and replace by value)
lid_file=strsubst(lid_file,'yyyy',strcat(['20',year]));
lid_file=strsubst(lid_file,'mm',month);
lid_file=strsubst(lid_file,'dd',day);


//delete non data lines
path_dataLID2=strcat([path_dataLID,lid_site,'/20',year,'/',month,"/"])
unix_s(strcat(['sed ''/#/d'' ',path_dataLID2,lid_file,' > ',path_dataLID2,'tmp1_',year,month,day]))
unix_s(strcat(['sed ''/@/d'' ',path_dataLID2,'tmp1_',year,month,day,' > ',path_dataLID2,'tmp2_',year,month,day]))


//reading file
M=fscanfMat(strcat([path_dataLID2,'tmp2_',year,month,day]));
all_time=M(:,1);
all_z=M(:,2);
all_pr2=M(:,3);


//time vector
ind=find(all_time(2:$)-all_time(1:$-1)<>0);
lid_time=[all_time(ind);all_time($)];


//vertical resolution
vresol=min(all_z(2:51)-all_z(1:50));


//init
nltest=length(all_time)/length(lid_time)
if round(nltest)==nltest then
    nl=nltest;
else
    nl=2048;
end
//pr2=%nan*ones(2048,length(lid_time));
pr2=zeros(nl,length(lid_time));

prev_time=lid_time(1);
j=1;
//        mprintf('%s\n','read pr2 and not ln(pr2) !')
for i=1:size(all_time,1)
    if all_time(i)==prev_time then
        select lid_var
        case 'lnpr2' then pr2(all_z(i)/vresol+1,j)=exp(all_pr2(i));
        case 'pr2' then pr2(all_z(i)/vresol+1,j)=all_pr2(i);
        end
    else
        prev_time=all_time(i);
        j=j+1;
    end
end

////endofline
//eol=find(isnan(nanmean(pr2,'c'))==%T)
//pr2=pr2(1:eol(1),:);

//mprintf('%s\n','lid_read_ascii rechanger pour les kms')
z=round([1:size(pr2,1)]*vresol*1e3);
//z=round([1:size(pr2,1)]*vresol);


vresol=z(2)-z(1);

//delete temporary files
unix_s(strcat(['rm ',path_dataLID2,'tmp*_',year,month,day]));



endfunction
