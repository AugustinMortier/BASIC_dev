function[bl,tl]=cov_haarv2(width_wave,thr_cloud,zmin_bl,zmax_bl,zmax_tl,PR2,lid_z,base_cld,nprol)
//calculate height of boundary layer and top layer width a constant width wavelet
//
//Input
//a : width of wavelet : 210/15
//thr_cloud : threshold on convolution between RCS and wavelet to detect clouds : -10
//zmax_tl : maximum altitude for top layer
//MaJ: 21/12/2015 : add nprol: average on nprol before processing

//Precaution car divise ensuite par PR2
PR2((PR2)==0)=1E-8;

//enregistrement des valeurs zmax
zmax_blrec=zmax_bl;
zmax_tlrec=zmax_tl;

vec=[1:size(PR2,2)];

// - - - wavelet - - - 
vresol=lid_z(2)-lid_z(1);
a=width_wave/vresol;
h=zeros(size(PR2,1),1);
h(1:a/2)=-1;
h(a/2+1:a)=1;


bl=ones(1,size(PR2,2))*%nan;
tl=ones(1,size(PR2,2))*%nan;

for i=1:size(PR2,2)
    //réinitialisation des altitudes max
    zmax_tl=zmax_tlrec;
    zmax_bl=zmax_blrec;
    
    ind=[vec(i)-nprol/2:vec(i)+nprol/2];
    indok=ind((ind)>0 & (ind)<=length(vec));
    pr2=mean(PR2(:,indok),'c');
    
    //on normalise au max en dessous 2000m
    [err,i2000]=min(abs(2000-lid_z));
    pr2=pr2/max(pr2(1:i2000));
    
    // - - - convolution - - - -
    con=convol(pr2(1:$),h);
    con(1:a)=%nan; //n'a pas de sens quand en dessous
    
    
    
    // - - - - - - - - - - - - - - - - - - - - - - - - 
    //if cloud detected, zmax has to be under the base
    if  base_cld(i)<=zmax_bl then
        //si nuage bas, alors laisser trouver le pic du nuage, sinon on cherche en dessous
        if base_cld(i)>=1500 then
            zmax_bl=base_cld(i)-300;
        else
            zmax_bl=base_cld(i);
        end
    end
    // - - - - - - - - - - - - - - - - - - - - - - - - 
    
    
    [err,iblmax]=min(abs(zmax_bl-lid_z));
    [err,iblmin]=min(abs(zmin_bl-lid_z));
    
    
    //mprintf('%i %i\n',iblmin,iblmax);
    if iblmin>=iblmax then
        iblmin=iblmax-1;
    end
    
    
    
    // - - - couche limite : max de convlution
    //on vérifie que le minimum de la convolution est supérieur à -10. Sinon, nuage, cherche en dessous
    ind=find(con(1:iblmax)<thr_cloud);
    if length(ind)>0 then
        if ind(1)<=iblmax then
            [val,bl(i)]=max(con(iblmin:ind(1)-1));
            bl(i)=bl(i)+iblmin;
        else
            [val,bl(i)]=max(con(iblmin:iblmax));
            bl(i)=bl(i)+iblmin;
        end
    else
        [val,bl(i)]=max(con(iblmin:iblmax));
        bl(i)=bl(i)+iblmin;
    end
    
    bl(i)=bl(i)-a/2;
    
    // - - - - - - - - - - - - - - - - - - - - - - - - 
    //if cloud detected, zmax has to be under the base
    if  base_cld(i)<=zmax_tlrec then
        //if base_cld(i)>=1500 then
        if base_cld(i)>=1500 then
            zmax_tl=base_cld(i)-vresol;//300;
        else
            //zmax_tl=base_cld(i);
         zmax_tl=base_cld(i)-vresol;
        end
    end
    // - - - - - - - - - - - - - - - - - - - - - - - - 
    
    
    [err,itlmax]=min(abs(zmax_tl-lid_z));
    
    
    
// top layer    
//    thr=3;//3
//    [err,i6500]=min(abs(6500-lid_z));
//    [err,i7000]=min(abs(7000-lid_z));
//    
//    
//    moy=mean(con(i6500:i7000));
//    std=stdev(con(i6500:i7000));
//    over=[]
//    while (length(over)==0)
//        if thr<=2.5 then//2.5
//            break
//        end
//        thr=thr-0.05;
//        thr_over=(moy+thr*std);
//        
//        if bl(i)<itlmax then
//            over=find(con(bl(i)+a:itlmax)>=thr_over);
//        else
//            break
//        end
//    end

    //start with the lowest threshold
    thr=2.5;//3
    [err,i6500]=min(abs(6500-lid_z));
    [err,i7000]=min(abs(7000-lid_z));
    
    
    moy=mean(con(i6500:i7000));
    std=stdev(con(i6500:i7000));
    over=[]
    //while (length(over)==0)
    //    if thr<=2.5 then//2.5
    //        break
    //    end
    //    thr=thr-0.05;
        thr_over=(moy+thr*std);
        
        if bl(i)<itlmax then
            over=find(con(bl(i)+a:itlmax)>=thr_over);
    //    else
    //        break
        end
    //end
    
    if length(over)>0 then
        //recupere juste si au dessus du seuil.
        tl(i)=over($)+bl(i);
    end
end



endfunction
