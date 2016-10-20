function[PR2_sat]=saturation(z,PR2,patch_zmax,patch_zmin,patch_thr)
//thius function is  a patch for correcting saturated signals happening in low level clouds presence and which conducts to negative values.
//A. Mortier 
//09/09/2014

//errcatch(-1,"continue")

PR2_sat=PR2;

[dif,imax]=min(abs(z-patch_zmax));
[dif,imin]=min(abs(z-patch_zmin));

//check whcich profile is negative belox zmax: faster
min_PR2=min(PR2(imin:imax,:),'r');
ind_neg=[1:length(min_PR2)];
ind_neg=ind_neg((min_PR2)<=0);

try
    
    for j=1:length(ind_neg)
//        disp(j)
        //look under imax
        pr2=PR2(1:imax,ind_neg(j));
        z=z(1:imax);
//        scf(1);clf(1);
//        subplot(1,2,1)
//        plot(pr2,z)
//        subplot(1,2,2)
//        plot(slope,z)
        
        
        //above thr
        overthr=find(pr2>patch_thr);
        overthr=overthr((overthr)>imin);
        overthr=overthr((overthr)<imax);
        
        if length(overthr)>0 then
            //if one cloud - else: to do: check continuity
            imaxthr=overthr($);
            
            //saturation test
            indsat=find(pr2<=0);
            indsat=indsat((indsat)>imin);
            indsat=indsat((indsat)>imaxthr);
            
            
            //continuity
            dif=indsat(2:$)-indsat(1:$-1);
            indsat=indsat((dif)<>1);
        else
            indsat=[];
        end
        
        if length(indsat)>0 then
            // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
            // - - - - - derivee par reg lineaire sur fenetre glissante - - - 
            pas=20;
            slope=zeros(z);
            noise=zeros(z);
            for i=pas/2:length(pr2)-pas/2-pas
                
        //      fast linear regression
        // - - - - - - - - - - - - - - - - - - - 
                X=z(1+i-pas/2:i+pas/2)';
                Y=pr2(1+i-pas/2:i+pas/2);
                coefs=[ones(length(X),1) X] \ Y;
                slope(i+1)=coefs(2);
        // - - - - - - - - - - - - - - - - - - -
            end
            
            //patch with lmpr2 - slope equals to zero if pr2<0
            slope((slope)==0)=-1;
            
            // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
            //trouve les endroits ou la pente est nulle par changement de signe -
            sig=sign(slope);
            sigp1=sig(2:$);
            dif=sig(1:$-1)-sigp1;
            chgtsign=find(dif<>0);
            peak=find(dif==2);
            peak=peak((peak)>imin);
            
            //le point d'accroche est le pic a partir du minimum au dessus le point de saturation
            lastsat=indsat(1);
            peaksabove=peak((peak)>lastsat);
            hangingpoint=peaksabove(1);
            
            if length(hangingpoint)>0 then
                //then interpolate between imaxthr and hangingpoint
                nb=hangingpoint-imaxthr;
                a=(pr2(imaxthr)-pr2(hangingpoint))/nb;
                pr2(imaxthr:hangingpoint)=pr2(imaxthr)-a*[0:nb]';
                
                PR2_sat(1:imax,ind_neg(j))=pr2;
            end
            
//            subplot(1,2,1)
//            plot(pr2,z,'r')
        else
        end

        // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
        // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
    end

catch

            disp('error')
end


endfunction
