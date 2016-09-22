function[zref]=f_Zref(X,z,z1,z2,step1)
//Returns Reference Altitude 

step1=5;
step2=5;

[dif,i1]=min(abs(z-z1));
[dif,i2]=min(abs(z-z2));

//Scilab version
version=getversion();
[ind,which]=strindex(version,'-');
vers=evstr(part(version,ind+1:ind+3));


// sliding average by convolution
if vers<=5.3 then
    avg=convol(X,ones(2*step1,1)/(2*step1))';
    avg=avg(step1:$-step1);
else
    avg=conv(X,ones(2*step1,1)/(2*step1),'same');
end
avg=avg(i1:i2);


//minimum on this average
[dif,imin]=min(avg);
yy=imin+i1-1;


//around the minimum, closest value between X and avg
dif=X(i1:i2)-avg;
i_around=imin-step2:imin+step2;
indok= find(i_around>=1 & i_around<=length(avg));
i_around=i_around(indok);

[dif,yy2]=min(abs(dif(i_around)));

iref=yy+yy2-step2-2;
zref=z(iref);


endfunction

