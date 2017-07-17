function[bl,tl]=cov_haarv2(width_wave,thr_cloud,zmin_bl,zmax_bl,zmax_tl,PR2,lid_z,base_cld,nprol,thr_tl)
//calculate height of boundary layer and top layer width a constant width wavelet
//
//Input
//a : width of wavelet : 210/15
//thr_cloud : threshold on convolution between RCS and wavelet to detect clouds : -10
//zmax_tl : maximum altitude for top layer


//Precaution car divise ensuite par PR2
PR2((PR2)==0)=1E-8;

//enregistrement des valeurs zmax
zmax_blrec=zmax_bl;
zmax_tlrec=zmax_tl;


// - - - wavelet - - - 
vresol=lid_z(2)-lid_z(1);
a=width_wave/vresol;
h=zeros(size(PR2,1),1);
h(1:a/2)=-1;
h(a/2+1:a)=1;


bl=ones(1,size(PR2,2))*%nan;
tl=ones(1,size(PR2,2))*%nan;
for i=1:size(PR2,2)
    
    // maj 22/09/2014
    vec_vg=[i-nprol/2:i+nprol/2];
    vec_vg=vec_vg((vec_vg)>=0);
    vec_vg=vec_vg((vec_vg)<=size(PR2,2));
//    if length(vec_vg)>=pastime then
//        vec_vg=round(vec_vg(1:pastime));
//    else
//        vec_vg=round(vec_vg);
//    end
    if length(vec_vg)>=nprol then
        vec_vg=round(vec_vg(1:nprol));
    else
        vec_vg=round(vec_vg);
    end  
    pr2=mean(PR2(:,vec_vg),'c');
    
    
    //réinitialisation des altitudes max
    zmax_tl=zmax_tlrec;
    zmax_bl=zmax_blrec;
    

    
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
    
    
    // - - - - - - - - - - - - - - - - - - - - - - - - 
    //if cloud detected, zmax has to be under the base
    if  base_cld(i)<=zmax_tlrec then
        if base_cld(i)>=1500 then
            zmax_tl=base_cld(i)-60;
        else
            zmax_tl=base_cld(i);
        end
    end
    // - - - - - - - - - - - - - - - - - - - - - - - - 
    
    
    [err,itlmax]=min(abs(zmax_tl-lid_z));
    
    
    
    
    // maj 22/09/2014
    //vertical gradient of con to detect maximums
    dif1=sign(con(1:$-1)-con(2:$));
    dif2=dif1(1:$-1)-dif1(2:$)
    
    maxs=find(dif2==-2)+1
    maxs=maxs((maxs)<=length(lid_z));
    maxs=maxs((maxs>bl(i)));
    maxis=maxs((maxs<=itlmax));
    
    con(isnan(con))=0;
    [aa,bb]=reglin(z(maxs),con(maxs))
    reg=abs(aa)*lid_z;
    
    
//    scf(8);clf(8);
//    a=gca()
//    plot(con(1:length(lid_z)),lid_z,'r')
//    plot(con(maxs),lid_z(maxs),'k')
//    a.children(1).children.mark_mode='on';
//    a.children(1).children.line_mode='off';
//    a.children(1).children.mark_size=3;
//    
//    plot(abs(aa)*lid_z(maxs),lid_z(maxs),'--k')
    //plot(1.5*reg,lid_z(maxs),'--k')
    
    
    
    thr=3;
    over=[]
    while (length(over)==0)
        if thr<=thr_tl then
            break
        end
        thr=thr-0.05;
        over=find(con(maxis)./reg(maxis)>=thr);
    end
    
    if length(over)>0 then
        //recupere juste si au dessus du seuil.
        tl(i)=maxis(over($))//-a/2;
    end
end

bl=bl-a/2;


endfunction
