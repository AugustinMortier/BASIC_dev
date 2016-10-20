function[]=f_QLb(X,Y,PR2,fig,Min,Max,nb_sub)


nb_col=64;
//Trace le QL pour une matrice PR2 donnÃ©e
PR2t=PR2;
respr2=(Max-Min)/nb_col;
PR2t((PR2)<=Min+respr2)=1;
for n=2:nb_col-1
    PR2t((PR2>Min+respr2*(n-1) & PR2<Min+respr2*n))=n;
end
PR2t((PR2)>=Max-respr2)=nb_col;




// ******************************************************************************************
// on calcule le nombre de dŽcimaux (d'apres le max), pour l'echelle
k=-1
for i=1:10
    if k<0 then
        if floor(Max*10^(i-1))==Max*10^(i-1) then
            k=i-1
        end
    end
end


if fig>=0 then
    scf(fig)
    clf(fig)
    if  nb_sub>1 then
        subplot(nb_sub,1,1)
    end
    a = gca();f=gcf();
    f.figure_size = [900,450*nb_sub];
    a.tight_limits="on";
    f.background=-8;
    f.color_map=jetcolormap(nb_col)
    f.children.tight_limits="on";
    fmt_ok=strcat(['%.',string(k+1),'f'])
    colorbar(Min,Max,[1,nb_col],fmt=fmt_ok)
    
    drawlater()
    
    
    grayplot(X,Y(1:$),PR2t(1:$,:)')//,zminmax=zminmax, colout=[-1 -1], colminmax=colors, strf="081")
    
    //-------------------------------------------------------------------
    a=get("current_axes")//get the handle of the newly created axes gca
    a.background=-2;
    a.box="on";
    a.line_style=1;
    a.font_size=3;
    a.data_bounds=[min(X),0;max(X),Y($)]
    a.zoom_box=[min(X),max(X);0,15]
    
    //f.info_message=strcat(['30 Juin - Aspet']);
    f.background=-2;
    f.children($).children.data_mapping="direct"
    f.children(1).title.font_size=4
    f.children(1).title.font_foreground=-1
    f.children.font_color=-1;
    f.children.x_label.font_foreground=-1
    f.children.y_label.font_foreground=-1
    f.children(2).title.font_foreground=-1
    f.children(2).title.font_size=4
    
    f.children(1).margins=[0.40,0.45,0,0]
    //f.children($).margins=[0.075,0.0025,0.05,0.15]
    f.children($).margins=[0.10,0.0025,0.05,0.20];
    


    drawnow()
    xtitle(strcat(['']), '$Time\ (UT)$', '$Range\ (km)$')
    a=gca();
    a.x_label.font_size=4;a.y_label.font_size=4;
    
end
clear PR2t
endfunction
