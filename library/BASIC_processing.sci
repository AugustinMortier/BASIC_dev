function[LAY,INV,lid]=BASIC_processing(params,lid,aer,inv_mod,sa_apriori)
//MaJ 05/09/2014 : export also pr2 (filtered and extrapolated)

//Main program :
//Molecular simulation
//spectral filtering
//extrapolation
//altitude layers
//clouding
//Klett inversion
//Quality check


// - - - - - - - - - - - - - - - - - - - - - - - - 
// Mise des élements des structures dans des variables
z=lid.z;
pr2=lid.pr2;
lid_time=lid.time;
vresol=lid.vresol;
theta=lid.theta;

lambda=params.lambda;
width_f=params.width_f;
extrap_typ=params.extrap_typ;
zmin=params.zmin;
nprol=params.nprol;
width_wave=params.width_wave;
thr_cloud=params.thr_cloud;
zmin_bl=params.zmin_bl;
zmax_bl=params.zmax_bl;
zmax_tl=params.zmax_tl;
nproc=params.nproc;
thr1=params.thr1;
thr2=params.thr2;
z1=params.z1;
z2=params.z2;
beta_a_zref=params.beta_a_zref;
ntime=params.ntime;
theta=params.theta;

aod=aer.aod;
aod_time=aer.time;
// - - - - - - - - - - - - - - - - - - - - - - - - 



mprintf('%s\t','Molecular simulation')
try
// - - - - - - - - - - - - - - - - - - - - - - - - 
//              MOLECULAR Simulation               
// - - - - - - - - - - - - - - - - - - - - - - - - 
T0=298;p_z0=1013;
[amol,bmol]=std_atm(z',T0,p_z0,lambda);
trayleigh=exp(-2*cumsum(amol)*vresol);
pr2_mol=bmol.*trayleigh;
// - - - - - - - - - - - - - - - - - - - - - - - - 
// - - - - - - - - - - - - - - - - - - - - - - - - 
mprintf('%s\n','√')
catch
mprintf('%s\n','X')
abort
end


// on limite la puissance de 10 du pr2
power=floor(log10(nanmean(lid.pr2(100:150,:))));
pr2=pr2*10^(-real(power)+1);


mprintf('%s\t','Spectral filtering')
try
// - - - - - - - - - - - - - - - - - - - - - - - - 
//              Spectral Filtering                 
// - - - - - - - - - - - - - - - - - - - - - - - - 
//on s'assure que le nb d'altitude est pair
if size(pr2,1)/2<>round(size(pr2,1)/2) then
    pr2=pr2(1:$-1,:);
end
pr2_f=pr2;
pr2_f(1:zmin/vresol,:)=ones(zmin/vresol,1)*pr2_f((zmin/vresol)+1,:);
if width_f>0 then
    for i=1:size(pr2,2)
        pr2_f(:,i) = filtrage_spectral(pr2(:,i),width_f);
    end
    pr2=real(pr2_f);
end
// - - - - - - - - - - - - - - - - - - - - - - - - 
// - - - - - - - - - - - - - - - - - - - - - - - - 
mprintf('%s\n','√')
catch
mprintf('%s\n','X')
abort
end




mprintf('%s\t\t','Extrapolation')
try
// - - - - - - - - - - - - - - - - - - - - - - - - 
//           Extrapolation low altitude           
// - - - - - - - - - - - - - - - - - - - - - - - - 
// input : pr2,z,zmin,typ (cst/lin)
if zmin>0 then
    [pr2]=extrap(pr2,z,zmin,extrap_typ);
end
// - - - - - - - - - - - - - - - - - - - - - - - - 
// - - - - - - - - - - - - - - - - - - - - - - - - 
mprintf('%s\n','√')
catch
mprintf('%s\n','X')
abort
end



mprintf('%s\t\t','Slope Index')
try
// - - - - - - - - - - - - - - - - - - - - - - - - 
//               Slope Index                  
// - - - - - - - - - - - - - - - - - - - - - - - - 
[si]=qualislope(pr2,pr2_mol,z,z1,z2)
// - - - - - - - - - - - - - - - - - - - - - - - - 
// - - - - - - - - - - - - - - - - - - - - - - - - 
mprintf('%s\n','√')
catch
mprintf('%s\n','X')
abort
end




mprintf('%s\t\t','Clouding')
try
// - - - - - - - - - - - - - - - - - - - - - - - - 
//                    Clouding                    
// - - - - - - - - - - - - - - - - - - - - - - - - 
//au max, traite les 20 premiers km
if z($)>20000 then
    [err,imax]=min(abs(z-20000));
else
    imax=size(pr2,1);
end
pr2=pr2(1:imax,:);z=z(1:imax);

//exec(strcat([path_fonctions,'clouderive.sci']));
pastime=nproc;
//vec=[1+pastime/2:size(pr2,2)-pastime/2];
vec=[1:size(pr2,2)];

k=0;
BASE=%nan*ones(10,length(lid_time));PEAK=BASE;TOP=BASE;
BASE2=%nan*ones(10,length(lid_time));PEAK2=BASE2;TOP2=BASE2;
//winId=waitbar('Clouding');

for i=vec
//    printf('%i\n',i)
    //pr2_avg=mean(pr2(:,i-pastime/2:i+pastime/2),'c');
    if nproc>=2
        ind=[vec(i)-nproc/2:vec(i)+nproc/2];
    else
        ind=vec(i);
    end
    indok=ind((ind)>0 & (ind)<=length(vec));
    pr2_avg=mean(pr2(:,indok),'c');
    [base,peak,top,base2,peak2,top2]=clouderive(z,zmin,pr2_avg,thr1,thr2);
    BASE(1:length(base),i)=base';
    PEAK(1:length(base),i)=peak';
    TOP(1:length(base),i)=top';
    BASE2(1:length(base2),i)=base2';
    PEAK2(1:length(base2),i)=peak2';
    TOP2(1:length(base2),i)=top2';
    //waitbar(i/size(pr2,2),winId)
end
BASE2((BASE2)>0)=z(BASE2((BASE2)>0));
PEAK2((PEAK2)>0)=z(PEAK2((PEAK2)>0));
TOP2((TOP2)>0)=z(TOP2((TOP2)>0));
    
//build a vector flagcld which contains 0 (no cloud) or altitude of the first cloud in the column
ind_sun=BASE2(1,:);
ind_sun=find(isnan(ind_sun)==%F);
flagcld=zeros(lid_time);
flagcld(ind_sun)=BASE2(1,ind_sun)';

//number of clouds in each profile
nbcld=zeros(1,size(BASE2,2));
for i=1:size(BASE2,2)
   nbcld(i)=length(find(BASE2(:,i)>0));
end
// - - - - - - - - - - - - - - - - - - - - - - - - 
mprintf('%s\n','√')
catch
mprintf('%s\n','X')
abort
end





mprintf('%s\t\t','Altitude Layers')
try
// - - - - - - - - - - - - - - - - - - - - - - - - 
//               Altitude Layers                  
// - - - - - - - - - - - - - - - - - - - - - - - - 
//if clouds detected, zmax_bl/tl < base(cloud)
[i_bl,i_tl]=cov_haarv2(width_wave,thr_cloud,zmin_bl,zmax_bl,zmax_tl,pr2,z,BASE2(1,:),nprol);
//indice to altitude
bl=%nan*ones(i_bl);tl=bl;
i_bl((i_bl<=1))=1;i_tl((i_tl<=1))=1;
bl(i_bl>0)=z(i_bl(i_bl>0));
tl(isnan(i_tl)==%F)=z(i_tl(isnan(i_tl)==%F));
//flag
bl((bl<=zmin_bl))=%nan;
bl((bl>=zmax_bl))=%nan;
tl((tl>=zmax_tl))=%nan;
//
// - - - - - - - - - - - - - - - - - - - - - - - - 
// - - - - - - - - - - - - - - - - - - - - - - - - 
mprintf('%s\n','√')
catch
mprintf('%s\n','X')
abort
end





mprintf('%s\t\t','Inversion')
try
// - - - - - - - - - - - - - - - - - - - - - - - - 
//               INVERSION                  
// - - - - - - - - - - - - - - - - - - - - - - - - 
nb_tot=[];nb_ok=[];ZREF=[];SA=[];BETA_A=[];
BL=[];TL=[];SI=[];


//for each aod, average of pr2 during ntime then ref altitude then klett
for i=1:length(aod)
    
    //average of pr2
    ind=find(lid_time<aod_time(i)+ntime/(2*0.6*100) & lid_time>aod_time(i)-ntime/(2*0.6*100));
    nb_tot=[nb_tot,length(ind)];
    
    //check if clouds in profiles
    ind_clear=find(flagcld(ind)==0);
    ind_cloudover=find(flagcld(ind)>z2);
    ind_ok=ind(gsort([ind_clear,ind_cloudover],'c','i'));
    
    if length(ind_ok)>0 then
    //if length(ind_ok)==nb_tot(i) then
        
        //number of profiles used in inversion
        nb_ok=[nb_ok,length(ind_ok)];
        
        //average of non cloudy profiles
        pr2_inv=mean(pr2(:,ind_ok),'c');
        
        //bl and tl for profiles
        BL=[BL,nanmean(bl(ind_ok))];
        TL=[TL,nanmean(tl(ind_ok))];
        
        //slope index for profiles
        SI=[SI,nanmean(si(ind_ok))];
        
        
        // - - - - - - - - - - - - - - - - - - - - - - - -
        //                Reference Altitude              
        // - - - - - - - - - - - - - - - - - - - - - - - -
        pas=5;
        [zref]=f_Zref(pr2_inv,z,z1,z2,pas);
        ZREF=[ZREF,zref];
        // - - - - - - - - - - - - - - - - - - - - - - - - 
        
        
        // - - - - - - - - - - - - - - - - - - - - - - - - 
        // KLETT Inversion
        // - - - - - - - - - - - - - - - - - - - - - - - - 
        if inv_mod=="aod" then
            [beta_a,sa,xx,err_aod]=Inv_Klett_aod(pr2_inv,bmol,aod(i),zref,zmin,beta_a_zref,vresol,theta,extrap_typ);
        end
        if inv_mod=="sa" then
            [beta_a,sa,aod(i),err_aod]=Inv_Klett_sa(pr2_inv,bmol,aod(i),zref,zmin,beta_a_zref,vresol,theta,sa_apriori,extrap_typ);
        end
        
        
        beta_a(length(beta_a):z2/vresol)=0;
        BETA_A=[BETA_A,real(beta_a)];
        SA=[SA,sa];

        //
        // - - - - - - - - - - - - - - - - - - - - - - - - 

        
    else
        nb_ok=[nb_ok,0];
        BL=[BL,nanmean(bl(ind))];
        TL=[TL,nanmean(tl(ind))];
        ZREF=[ZREF,0]
        BETA_A=[BETA_A,zeros(z2/vresol,1)];
        SA=[SA,0];
        SI=[SI,-999];
        
    end
end
//extinction (in km-1)
ALPHA_A=BETA_A.*(ones(size(BETA_A,1),1)*SA)*1E3;
aod=real(aod);
// - - - - - - - - - - - - - - - - - - - - - - - - 
// - - - - - - - - - - - - - - - - - - - - - - - - 
mprintf('%s\n','√')
catch
mprintf('%s\n','X')
abort
end




// - - - - - - - - - - - - - - - - - - - - - - - - 
//                 Quality Check                   
// - - - - - - - - - - - - - - - - - - - - - - - - 
negpro=[];qlty_ok=[];
for i=1:size(ALPHA_A,2)
    ind=find(ALPHA_A(1:1000/vresol,i)<0 | SA(i)<5 | SA(i)>149 )
    if length(ind)>0 then
        negpro=[negpro,i]
    else
        ind=find(ALPHA_A(:,i)>2 | ALPHA_A(:,i)<-0.5)
        if length(ind)>0 then
             negpro=[negpro,i]
         else
             qlty_ok=[qlty_ok,i]
        end
    end
end
ALPHA_A(:,negpro)=%nan;
SA(negpro)=%nan;
// - - - - - - - - - - - - - - - - - - - - - - - - 
// - - - - - - - - - - - - - - - - - - - - - - - - 


pr2=pr2*10^-(-real(power)+1);


// - - - - - - - - - - - - - - - - - - - - - - - - 
// création des structures : LAY(ers) et INV(ersion)
// - - - - - - - - - - - - - - - - - - - - - - - - 
LAY=struct('time',lid_time,'bl',bl','si',si,'tl',tl','nbcld',nbcld','base',BASE2','peak',PEAK2','top',TOP2');
INV=struct('time',aod_time,'si',SI','aod',aod,'nb_ok',nb_ok','nb_tot',nb_tot','sa',SA','ext',ALPHA_A');
lid=struct('pr2',pr2,'z',z,'time',lid_time,'vresol',vresol,'theta',theta)
// - - - - - - - - - - - - - - - - - - - - - - - - 
// - - - - - - - - - - - - - - - - - - - - - - - - 


endfunction
