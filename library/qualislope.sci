function[qualindex]=qualislope(pr2,pr2_mol,z,z1,z2)
//check quality of rcs slope % molecular slope around reference altitude
    
    //parameters
    step=1500/(z(2)-z(1));//step for calculation of slope
    
    //initialization
    qualindex=zeros(size(pr2,2),1);
    
//    clf(1)
    
    //loop on each profile
    //winId=waitbar('Index Slope Calculation');
    zref=zeros(size(pr2,2),1);iref=zref;
    for i=1:size(pr2,2)
    //for i=154:154
    
        pr2_lid=pr2(:,i);
        pr2_lid((pr2_lid)==0)=1E-10;
        
        //reference altitude
        zref(i)=f_Zref(pr2_lid,z,z1,z2,5);
        [dif,iref(i)]=min(abs(z-zref(i)));
        
        //kmol
         
        //remove power
        power=floor(real(log10(mean(pr2_lid(20:30)))));
        pr2_lidb=pr2_lid*10^(-power);
         
         //              calibration factors                      
        [dif,iref_grd]=min(abs(z-zref(i)));
        mean_mol=mean(pr2_mol(iref_grd-5:iref_grd+5));
        mean_lid=mean(pr2_lidb(iref_grd-5:iref_grd+5));
        k_grd=mean_mol/mean_lid;
        
        pr2_lid=k_grd*(pr2_lidb);
        
        //if pr2 negative in the reference zone, the whole profile is reversed
        if pr2_lid(1)<0 then
            pr2_lid=-pr2_lid+2*mean_mol;
        end
         
//        scf(1) 
//        plot(pr2_lid,z,'b')
//        plot(pr2_mol,z,'k')
        
        //slope under
        area=[iref(i)-step:iref(i)];
        [a1,b1,sig1]=reglin(z(area),pr2_lid(area)');
        [amol1,bmol1,sigmol1]=reglin(z(area),pr2_mol(area)');
        
//        plot([0:max(pr2_lid(1000/15:10000/15))],z(area(1))*ones([0:max(pr2_lid(1000/15:10000/15))]),':k')
//        plot([0:max(pr2_lid(1000/15:10000/15))],z(area($))*ones([0:max(pr2_lid(1000/15:10000/15))]),':k')
//        plot(a1*z(area)+b1,z(area),'r')
        
        
        //slope between
        area=[iref(i)-step/2:iref(i)+step/2];
        [a2,b2,sig2]=reglin(z(area),pr2_lid(area)');
        [amol2,bmol2,sigmol2]=reglin(z(area),pr2_mol(area)');
        
//        plot([0:max(pr2_lid(1000/15:10000/15))],z(area(1))*ones([0:max(pr2_lid(1000/15:10000/15))]),':k')
//        plot([0:max(pr2_lid(1000/15:10000/15))],z(area($))*ones([0:max(pr2_lid(1000/15:10000/15))]),':k')
//        plot(a2*z(area)+b2,z(area),'r')
        
        
        //slope above
        area=[iref(i):iref(i)+step];
        [a3,b3,sig3]=reglin(z(area),pr2_lid(area)');
        [amol3,bmol3,sigmol3]=reglin(z(area),pr2_mol(area)');
        
//        plot([0:max(pr2_lid(1000/15:10000/15))],z(area(1))*ones([0:max(pr2_lid(1000/15:10000/15))]),':k')
//        plot([0:max(pr2_lid(1000/15:10000/15))],z(area($))*ones([0:max(pr2_lid(1000/15:10000/15))]),':k')
//        plot(a3*z(area)+b3,z(area),'r')
        
        
//        disp(a1/amol1)
//        disp(a2/amol2)
//        disp(a3/amol3)
        
//      the ratio has to be > 0 and not far from 1
        slopes=[a1/amol1,a2/amol2,a3/amol2];
        [dif,best]=min(abs(slopes-1))
        
        qualindex(i)=slopes(best);
        
        //waitbar(i/(size(pr2,2)),winId);
        
    end
    //close(winId)
    
    
endfunction

