function [beta_aer,Saer_OK,AOD,err_AOD] = Inv_Klett_aod(X,beta_mol,AOD_photo,altitude_max,altitude_min,Beta_a_init,resol,theta,extrap_typ)

//Klett Inversion Constrained by AOD


////Moleculaire à lire dans le programme avant
Smol=8*%pi/3;


Nref=altitude_max/resol;
//n_min=altitude_min/resol;
BETA=zeros(1,Nref)
BETA(Nref)=beta_mol(Nref)*1+Beta_a_init


// À vérifier ici
resol=resol*cos(theta*%pi/360)


Sa_min=1;Sa_max=150;

while abs(Sa_max-Sa_min)>0.1
    
    Sa=abs(Sa_max+Sa_min)/2;
    
        int1(1:Nref)=cumsum((Sa-Smol)*beta_mol(1:Nref)*resol)
        for i=1:Nref
            int1(i)=2*int1($)-2*int1(i)
        end
        for i=1:Nref
            PHI(i)=(log(X(i)/X(Nref)) + int1(i))
        end
        

        int2=2*cumsum(Sa*exp(PHI(1:Nref))*resol)
        for i=1:Nref
            int2(i)=int2($)-int2(i)
        end


        for i=1:Nref-1
            BETA(i)=(exp(PHI(i)))/((1/BETA(Nref))+int2(i))
        end
        
        beta_aer=BETA-beta_mol(1:Nref)'
        if extrap_typ=='cst' then
            beta_aer(1:altitude_min/resol)=beta_aer(1+altitude_min/resol)*ones(beta_aer(1:altitude_min/resol));
        end
        sigma_aer=Sa*beta_aer
        beta_aer=real(beta_aer);
        sigma_aer=real(sigma_aer)
        
       //Calcul de l'AOD du profil
        vec_AOD=cumsum(sigma_aer * resol)
        AOD=vec_AOD($)
        

    if AOD>AOD_photo then
        Sa_max=Sa
    end
    if AOD<AOD_photo then
        Sa_min=Sa
    end
    if isnan(AOD)==%T then
        Sa_min=1;
        Sa_max=1;
        Sa=0;
    end
    if abs(AOD)==%inf then
        Sa_min=1;
        Sa_max=1;
        Sa=0;
    end
    
end

    

//    //Minim AOD
//    [x,y]=min(abs(AOD_photo*ones(AOD_profil)-AOD_profil))
    Saer_OK=Sa
    err_AOD=100 - (AOD*100/AOD_photo)
          
    
     //Inversion avec le bon Saer

        int1(1:Nref)=cumsum((Saer_OK-Smol)*beta_mol(1:Nref)*resol)
        for i=1:Nref
            int1(i)=2*int1($)-2*int1(i)
        end
        for i=1:Nref
            PHI(i)=(log(X(i)/X(Nref)) + int1(i))
        end

        int2=2*cumsum(Saer_OK*exp(PHI(1:Nref))*resol)
        for i=1:Nref
            int2(i)=int2($)-int2(i)
        end

        for i=1:Nref-1
            BETA(i)=(exp(PHI(i)))/((1/BETA(Nref))+int2(i))
        end


        beta_aer=BETA-beta_mol(1:Nref)'
        if extrap_typ=='cst' then
            beta_aer(1:altitude_min/resol)=beta_aer(1+altitude_min/resol)*ones(beta_aer(1:altitude_min/resol));
        end
        sigma_aer=Saer_OK*beta_aer
        beta_aer=beta_aer'

endfunction


