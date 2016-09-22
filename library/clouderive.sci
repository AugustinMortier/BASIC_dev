function[baseok,peakok,topok,baseok2,peakok2,topok2,test1,test2]=clouderive(z,zmin,PR2,THR1,THR2)
//Read the AERONET File and process the AOD for desired Wavelength.
//Use AOD@870nm and Angstrom Exponent
//
// A. Mortier - Laboratoire d'Optique Atmosph‚àö¬©rique - Universit‚àö¬© de Lille 1
//24/04/2013 - version 1.0
//
//cette fonction trouve les bases, peaks et top d'un profil lidar PR2
//bas√© sur Pal, 1992 - Adapt√© par Mortier A.
// 
// pour les Ceiolometres : gros bruit en latitude: desactive le test
// if abs(nanmean(PR2($-20:$))./max(PR2(1:100)))>2 then

errcatch(-1,"continue")

//THR1=10
//THR2=4
//THR3=0.1
// Z EN METRES !!

vresol=z(2)-z(1);
imin=zmin/vresol;

//test
//PR2=PR2+min(PR2);

peakok=[];baseok=[];topok=[];base=[];top=[];topok2=[];baseok2=[];peakok2=[];

try
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
//             check if signal available above 10km
//[err,z_checkmin]=min(abs(z-10000))
if max(PR2(1:100))<=0 then
    peakok=%nan;baseok=%nan;topok=%nan;base=%nan;top=%nan;topok2=%nan;baseok2=%nan;peakok2=%nan;
else
    
//    if abs(nanmean(PR2($-20:$))./max(PR2(1:100)))>2 then
//        peakok=%nan;baseok=%nan;topok=%nan;base=%nan;top=%nan;topok2=%nan;baseok2=%nan;peakok2=%nan;
//    else

    
    // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
    // - - - - - derivee par reg lineire sur fenetre glissante - - - - -
    pas=20;
    slope=zeros(z);
    noise=zeros(z);
    for i=pas/2:length(PR2)-pas/2-pas
        
//      fast linear regression
// - - - - - - - - - - - - - - - - - - - 
        X=z(1+i-pas/2:i+pas/2)';
        Y=PR2(1+i-pas/2:i+pas/2);
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
    
    base=find(dif==-2);
    peak=find(dif==2);
    
    base=base((base)>imin);
    peak=peak((peak)>imin);
    
    
    if length(base)>0 then
        //si  un pic en premier, force a¬†chercher une base avant si possible
        if peak(1)<=base(1) then
            //derivee seconde
            slope2=zeros(slope);
            slope2(1:length(slope)-1)=slope(2:$)-slope(1:$-1);
            indice=find(slope2(1:peak(1))./max(slope2(1:peak(1)))>=0.25);
            if length(indice)>0 then
                base=[indice($),base]
            else
                base=[imin+1,base]
            end
        end
        
        // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
        // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
        
        //update 10/09/2014
        peak=peak((base)>imin);
        base=base((base)>imin);
        
        
        // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
        //on calcule le bruit en dessous de la base
        pasnoise=8;
        noise=zeros(base);
        for i=1:length(base);
            if base(i)>pasnoise then
                noise(i)=abs(stdev(PR2(base(i)-pasnoise:base(i))));
            else
                disp(base)
                stop
            end
        end
        // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
        // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
        
        
        // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
        //on extrapole le bruit de 30 a 15km, et un peu au sol ?
        //polynome d'ordre 2
        //conditions : c=min(noise) et deivee nulle en z=0
        c=min(noise);
        b=0;
        
        //le point a 12000m appartient a la droite
        npas=10;npas=4;
        [m,mm]=min(abs(base*vresol-8000))
        if mm>npas then
            y1=mean(noise(mm-npas:mm+npas));
        else
            y1=mean(noise)
        end
        x1=base(mm)*vresol;
        a=(y1-c)/(x1.^2)
        pf=a.*z.^2+b*z+c;
        
        // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
        // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
        
        
        
        // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
        //verifie que termine par peak
        if length(base)>length(peak) then
            base=base(1:length(peak));
        else
            peak=peak(1:length(base));
        end
        // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
        // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
        
        //disp(base)
        
        // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        // - - - - - - - - - - - - - T E S T - - - - - - - - - - - - - - - -
        test=[];
        for i=1:length(base)
            test_peak=mean(PR2(peak(i)-1:peak(i)+1));
            test_base=mean(PR2(base(i)-1:base(i)+1));
            if test_base<0 then
                test_base=0
            end
            if test_peak-test_base>(THR1*pf(peak(i))) then
                test=[test,i]
            end
        end
        if length(test)>0 then
            peakok=peak(test);
            baseok=base(test);
            
            //on limite le dernier pic neanmoins aux 15 premiers kms
            indice=find(peakok<=15000/vresol)
            peakok=peakok(indice);
            baseok=baseok(indice);
        else
            peakok=[];baseok=[];
        end
    end
    
    
    
    if length(peakok)>0 then
        // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        //maintenant que premier tri, on regarde autour de chache peak le max du PR2 et le min du PR2 pour la base sur une moyenne glissante
        for i=1:length(peakok)
            vec=[peakok(i)-5:peakok(i)+5];
            [m,mm]=max(PR2(vec))
            peakok(i)=vec(mm)
            
            
            //moyenne glissante
            vec=[baseok(i)-5:baseok(i)+5];
            
            vec_m=%nan*ones(vec);
            for ii=1:length(vec)
                vec_m(ii)=mean(PR2([vec(ii)-2:vec(ii)+2]));
            end
            //on se concentre sur le minimum de moyenne glissante
            [m,mm]=min(vec_m);
            
            [m2,mm2]=min(abs(PR2([vec(mm)-3:vec(mm)+3])));
            baseok(i)=vec(mm)-3+mm2;
            
        end
        
        //si en d√É¬©calant les bases, 2 se superposent, alors on enleve le pic a dessus la base i
        for i=1:length(baseok)-1
            if baseok(i)==baseok(i+1) then
                baseok(i+1)=1;
                //le pic est le plus grand entre le i et le i+1
                [m,mm]=max(PR2(peak([i,i+1])))
                if mm==1 then
                    peakok(i+1)=1
                else
                    peakok(i)=1
                end
            end
        end
        baseok=baseok((baseok)>1);
        peakok=peakok((peakok)>1);
        
        //si en d√É¬©calant, une base passe au dessus d'un pic, alors on suprime base et pic
        anomal=find(peakok-baseok<=0)
        peakok(anomal)=1;
        baseok(anomal)=1;
        peakok=peakok((peakok)>1);
        baseok=baseok((baseok)>1);
        // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    
        if  length(peakok)>0 then
            // on v√É¬©rifie que chacundes couches v√É¬©rifie le crit√É¬®re nuages pour continuer
            // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
            // - - - - - - - - - - - - - T E S T - - - - - - - - - - - - - - - 
            MIN=abs(min(PR2(1:15000/vresol)))+0.1;
            peakok2=[];topok2=[];baseok2=[];test=[];
            for i=1:length(peakok)
                if abs((mean(PR2(peakok(i)))+MIN)./(mean(PR2(baseok(i)-1:baseok(i)+1))+MIN))>=1.5 then
                    test=[test,i]
                end
            end    
            if length(test)>0 then
                peakok2=peakok(test);
                baseok2=baseok(test);
            end
            peakok=[peakok2];
            baseok=[baseok2];
        end
    end
    // - - - - - - - - - - - - - - - - - -
    
    
    
    //la suite n'a de sens que si des peaks ont pass√É¬© le test
    if length(peakok)>0 then
    
        // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        // - - - - - - - - - - - - - - T O P - - - - - - - - - - - - - - - -
        //pour chaque pic trouve, on regarde au dessus √É¬† partir de quand la derivee croise le zero
        base_tmp=baseok;
        peak_tmp=[];
        for i=1:length(peakok)-1
            vec=[peakok(i):baseok(i+1)]
            //on ne garde que les indices dont le pr2 <= a la base(n)
            indice=find(PR2(vec)<=PR2(baseok(i)))
            
            if length(indice)>0 then
                vec=vec(indice);
                if length(vec)>=5 then//se limite a 5 pr ne pas aller trop loin
                    [m,mm]=min(abs(slope(vec(1:5))))
                else
                    [m,mm]=min(abs(slope(vec)))
                end
                top(i)=vec(mm)
            else
                //si on ne trouve pas de valeur inf√©rieur, alors supprime la base n+1
                base_tmp(i+1)=1;
            end
        end
        baseok=base_tmp((base_tmp)>1);
        
        //si 
        
        
    
        //on cherche alors le peak maximal
        for i=1:length(baseok)
            //on cherche les peaks au dessus de la base(i)
            if i<length(baseok) then
                indice=find(peakok>baseok(i) & peakok<baseok(i+1))
            else
                indice=find(peakok>baseok(i))
            end
            
            [m,mm]=max(PR2(peakok(indice)))
            peak_tmp(i)=peakok(indice(mm))
        end
    
    
        
        // m o d i f - m o d i f
        //*
        top=top((top)>0)
        //*
        //ordre inverse
        peakok=peak_tmp;
        i=length(peakok);
        // m o d i f - m o d i f
         
        //on recherche √É¬† partir du moment ou le signal devient inf√É¬©rieur √É¬† a base
        indice=find(PR2<PR2(baseok($)));
        indice=indice((indice)>peakok($));
        //on recherche jusqu'√É¬† la base du pic sup√É¬©rieur non retenu
    
            
            if length(indice)>=5 then//se limite √É¬† 5 pour ne pas aller trop loin
                [m,mm]=min(abs(slope(indice(1:5))))
            else
                [m,mm]=min(abs(slope(indice)))
            end
            top(i)=indice(mm)
            
            // m o d i f - m o d i f
            if length(indice)==0 then
                top(i)=peakok(i)+1
            end
            // m o d i f - m o d i f
            
        topok=top';
        topok=topok((topok)>0);
        peakok=peak_tmp';
        if length(peakok)<>length(topok) then
            disp(baseok)
            disp(topok)
            disp(peakok)
        end
        
    
        // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        //on minimise les top autour des indices trouv√É¬©s
        for i=1:length(topok)
            vec=[topok(i)-5:topok(i)+5];
            //patch 08/09/2014
            vec=vec((vec)<=length(PR2));
            [m,mm]=min(PR2(vec));
            topok(i)=vec(mm);
        end
        
        
            //si en dealant les tops, 2 se superposent, alors on enleve le pic a dessus la base i
        for i=1:length(topok)-1
            if topok(i)==topok(i+1) then
                topok(i+1)=1;
                baseok(i+1)=1
                //le pic est le plus grand entre le i et le i+1
                [m,mm]=max(PR2(peak([i,i+1])))
                if mm==1 then
                    peakok(i+1)=1
                else
                    peakok(i)=1
                end
            end
        end
        
        
        baseok=baseok((baseok)>1);
        peakok=peakok((peakok)>1);
        topok=topok((topok)>1);
        
//        if length(peakok)<>length(topok) then
//            disp(baseok)
//            disp(topok)
//            disp(peakok)
//        end
        
        
        if length(peakok)>0 then
            //si en d√É¬©calant, une base passe au dessus d'un pic, alors on suprime base et pic
            anomal=find(topok-baseok<=0)
            peakok(anomal)=1;
            baseok(anomal)=1;
            topok(anomal)=1;
            peakok=peakok((peakok)>1);
            baseok=baseok((baseok)>1);
            topok=topok((topok)>1);
            
            anomal=find(topok-peakok<=0)
            peakok(anomal)=1;
            baseok(anomal)=1;
            topok(anomal)=1;
            peakok=peakok((peakok)>1);
            baseok=baseok((baseok)>1);
            topok=topok((topok)>1);
    
    
    
        //un top doit etre en dessous de la base n+1, sinon √É¬©limine le trio n+1 ???
        anomali=find(topok(1:$-1)-baseok(2:$)>0)
        peakok(anomali)=1;
        baseok(anomali)=1;
        topok(anomali)=1;
        peakok=peakok((peakok)>1);
        baseok=baseok((baseok)>1);
        topok=topok((topok)>1);
        // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    
    
        // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        //condition at top, P(top)<=P(base)
        for i=1:length(topok)-1
            if PR2(topok(i))>=PR2(baseok(i)) then
                topok(i)=1;
                baseok(i+1)=1;
                //on recherche le pic max entre le pic i et i+1 et on vire l'autre
    //modif 29/11/12 soir            [m,mm]=max(peakok([i,i+1]))
    //modifi√© par la ligne suivante
                [m,mm]=max(PR2(peakok([i,i+1])))
                if mm==1 then
                    peakok(i+1)=1
                end
                if mm==2 then
                    peakok(i)=1
                end
            end
        end
    
        baseok=baseok((baseok)>1);
        topok=topok((topok)>1);
        peakok=peakok((peakok)>1);
    
        end
        // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        
        if length(peakok)>0 then
            // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
            // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
            //condition at top, P(top_n)>=P(base_n+1)
            for i=1:length(topok)-1
                if PR2(topok(i))<=PR2(baseok(i+1)) then
                    topok(i)=1;
                    baseok(i+1)=1;
                    //on recherche le pic max entre le pic i et i+1 et on vire l'autre
                    [m,mm]=max(PR2(peakok([i,i+1])))
                    if mm==1 then
                        peakok(i+1)=1
                    end
                    if mm==2 then
                        peakok(i)=1
                    end
                end
            end
            baseok=baseok((baseok)>1);
            topok=topok((topok)>1);
            peakok=peakok((peakok)>1);
            // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
            // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        end
    
        if length(peakok)>0 then
            // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
            // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
            ////il faut que la PR2_base(n+1) soit inf√É¬©rieur au PR2_base(n), sinon m√™me couche
            ref=PR2(baseok(1));
            rec=[];
            for i=2:length(baseok)
                if PR2(baseok(i))<=ref then
                    ref=PR2(baseok(i))
                    rec=[rec,i]
                else
                    baseok(i)=1;
                    topok(i-1)=1
                end
            end
            baseok=baseok((baseok)>1);
            topok=topok((topok)>1);
            // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
            // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        end
    
        if length(peakok)>0 then
            // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
            // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
            //on cherche pour chaque base filtr√É¬©e le peak maximal associ√É¬©
            peaklist=[]
            baseok=baseok((baseok)>1);
            for i=1:length(baseok)-1
                indice=find(peakok>baseok(i) & peakok<baseok(i+1))
                if length(indice)>0 then
                    [m,mm]=max(PR2(peakok(indice)))
                    peaklist(i)=peakok(indice(mm))
                else
                    baseok(i)=1;
                    peaklist(i)=1;
                end
            end
            i=length(baseok);
            indice=find(peakok>baseok(i));
            [m,mm]=max(PR2(peakok(indice)));
            peaklist(i)=peakok(indice(mm));
            peakok=peaklist';
            peakok=peakok((peakok)>1);
            baseok=baseok((baseok)>1);
            // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
            // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        end
    
        if length(peakok)>0 then
            // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
            // - - - - - - - - - - - - - T E S T - - - - - - - - - - - - - - -
            //on evalue la moyenne au dessus de chaque top;
            MIN=0;//THR2=4;
            peakok2=[];topok2=[];baseok2=[];
            indlow=find(topok<7500/vresol);
            if length(indlow)>0 then
                test1=find(abs((PR2(peakok(indlow))+MIN)./(PR2(topok(indlow))+MIN))>=THR2);
                
                if length(test1)>0 then
                    peakok2=peakok(test1);
                    baseok2=baseok(test1);
                    topok2=topok(test1);
                end
        
            end
            indhigh=find(topok>=7500/vresol);
            if length(indhigh)>0 then
                peakok2=[peakok2,peakok(indhigh)];
                baseok2=[baseok2,baseok(indhigh)];
                topok2=[topok2,topok(indhigh)];
            end
        //    test=find(PR2(peakok)-PR2(topok)>THR2*pf(peakok)')
        // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        else
            baseok=[];peakok=[];topok=[];
            baseok2=[];peakok2=[];topok2=[];
        end
            
            
//            
//            // - - - - test sur largeur de couche pour bases en dessous 3000m
//            baseok2=baseok2((baseok2)>0)
//            peakok2=peakok2((peakok2)>0)
//            topok2=topok2((topok2)>0)
//            
//            if length(peakok2)>0 then
//                for i=1:length(peakok2)
//                    test1=(PR2(peakok2(i))/PR2(baseok2(i)))
//                    test2=(PR2(peakok2(i))/PR2(baseok2(i)))/(z(peakok2(i))-z(baseok2(i)))
//                    if  test2<THR3 then
//                        if z(baseok2(i))<3000 then
//                            peakok2(i)=-1;
//                            baseok2(i)=-1;
//                            topok2(i)=-1;
//                        end
//                    end
//                end
//                peakok2=peakok2((peakok2)>0);
//                baseok2=baseok2((baseok2)>0);
//                topok2=topok2((topok2)>0);
//            else
//                baseok=[];peakok=[];topok=[];
//                baseok2=[];peakok2=[];topok2=[];
//                test1=[];test2=[];
//            end
       
       
       
       
       
       
    ////prise en compte de l'angle d'inclinaison
    //baseok=baseok*cos(theta*%pi/180);
    //peakok=peakok*cos(theta*%pi/180);
    //topok=topok*cos(theta*%pi/180);
    //baseok2=baseok2*cos(theta*%pi/180);
    //peakok2=peakok2*cos(theta*%pi/180);
    //topok2=topok2*cos(theta*%pi/180);
    //        
    end
    
    
//end
end
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
catch

peakok=%nan;baseok=%nan;topok=%nan;base=%nan;top=%nan;topok2=%nan;baseok2=%nan;peakok2=%nan;

end


endfunction
