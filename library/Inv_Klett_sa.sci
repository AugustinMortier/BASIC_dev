function [beta_aer,Saer_OK,AOD,err_AOD] = Inv_Klett_sa(X,beta_mol,AOD_photo,altitude_max,altitude_min,Beta_a_init,resol,theta,Sa,extrap_typ)

//Klett Inversion Constrained by SA


////Moleculaire à lire dans le programme avant
Smol=8*%pi/3;


Nref=altitude_max/resol;
//n_min=altitude_min/resol;
BETA=zeros(1,Nref)
BETA(Nref)=beta_mol(Nref)*1+Beta_a_init


// À vérifier ici
resol=resol*cos(theta*%pi/360)

//    //Minim AOD
//    [x,y]=min(abs(AOD_photo*ones(AOD_profil)-AOD_profil))
    Saer_OK=Sa
          
    
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
        
        //Calcul de l'AOD du profil
        vec_AOD=cumsum(sigma_aer * resol);
        AOD=vec_AOD($);
        err_AOD=0;

endfunction


