function[pr2]=extrap(pr2,z,zmin,extrap_typ)
//Extrapolate RCS for low range
//
//
//Input
//pr2 : Matrice of RCS
//z : range vector (m)
//zmin : altitude beyond extrapolation is done (m)
//extrap_typ : 'lin' or 'cst'


    
    
    //find index of range refering to zmin
    [err,imin]=min(abs(zmin-z))
    
    
    //extrapolation
    if extrap_typ=="cst" then
        low=ones(imin,1)*pr2(imin+1,:);
        pr2(1:imin,:)=low;
    end
    
    if extrap_typ=="lin" then
    slope=zeros(pr2(1,:))
    origin=zeros(pr2(1,:))
    
    for i=1:size(pr2,2)
        slope(i)=15/(pr2(imin+2,i)-pr2(imin+1,i));
        origin(i)=(imin+1*15)-pr2(imin+1,i)*slope(i)+(imin-1)*15//On sait que le point de coo imin+1 appartient à la droit
        PR2_calc(1:imin,i)=(z(1:imin)'+15-origin(i))/slope(i)
    end
        pr2(1:imin,:)=PR2_calc(1:imin,:)
    end
    
    
endfunction
