function[]=BASIC_display(params,lid,aer,LAY,INV)

//Plot Results of BASIC
//fig1 : Quick Look of RCS
//fig2 : Layers (BL, TL and clouds)
//fig3 : Extinction profiles and Histogramm of Sa
//fig4 : Quick Look of Extinction Profiles, and temporal series of AOD and Sa

mprintf('%s\t\t','Display Figures')
try

//* * * * * * * * * * * * * * * * * * * * * * * * *
//               STANDARD FIGURES                     
//* * * * * * * * * * * * * * * * * * * * * * * * *
f=sdf()
f.background=-2;
f.children(1).font_color=-1;
f.children(1).foreground=-1;
f.children(1).font_size=3;
f.children(1).x_label.font_size=4;
f.children(1).y_label.font_size=4;
f.children(1).title.font_size=4;
a=sda()
a.grid=[-1,-1];a.font_size=3;a.title.font_size=4;
a.font_color=-1;a.foreground=-1;a.hidden_axis_color=-1;
a.tight_limits="on";
// * * * * * * * * * * * * * * * * * * * * * * * * *




//* * * * * * * * * * * * * * * * * * * * * * * * *
//                   QUICK LOOK                     
//* * * * * * * * * * * * * * * * * * * * * * * * *
mean_lidpr2=nanmean(lid.pr2(1:100,:));
////power=log10(round(mean_lidpr2));
power=real(log10(mean_lidpr2));
lid.pr2=100*lid.pr2*(10^(-ceil(power)));


//min-max
if isnum(params.min_pr2) then
    Min_PR2=evstr(params.min_pr2);
else
    Min_PR2=0;
end

if isnum(params.max_pr2) then
    Max_PR2=evstr(params.max_pr2);
else
    //calcul du maximum pour QL
    Max_PR2=round(1.5*nanmean(lid.pr2(1:100,:)));
    Max_PR2=ceil(Max_PR2/10)*10;
end


fig=1;nb_sub=1;
f_QLb(lid.time,lid.z(1:$)*1E-3,lid.pr2(1:$,:),fig,Min_PR2,Max_PR2,nb_sub);
drawlater()
f=gcf();
f.children(1).title.text="$P(r).r^2\ (a.u)$"


//add bl and tl
plot(LAY.time,LAY.bl*1e-3)
plot(LAY.time,LAY.tl*1e-3)
a=gca();
a.children(1:2).children.line_mode='off';
a.children(1:2).children.mark_mode='on';
a.children(1:2).children.mark_size=4;
a.children(1).children.mark_foreground=-2;

drawnow()
// * * * * * * * * * * * * * * * * * * * * * * * * *






//* * * * * * * * * * * * * * * * * * * * * * * * *
//              FIGURES PLOT               
//* * * * * * * * * * * * * * * * * * * * * * * * *
//scf(2);clf(2);f=gcf();
//drawlater()
//a=gca();a.margins=[0.1,0.1,0.10,0.15]
//f.figure_size = [900,400];
//xtitle('','Time (UT)','Range (km)')
//plot(LAY.time(LAY.bl>0),LAY.bl(LAY.bl>0)*1E-3,'k')
//plot(LAY.time(LAY.tl>0),LAY.tl(LAY.tl>0)*1E-3,'r')
//a.children.children.line_mode="off";
//a.children.children.mark_mode="on";
//a.children.children.mark_size=2;
//a.children.children(1).mark_foreground=-1;
//a.children.children(2).mark_foreground=5;
//plot(LAY.time,LAY.base(:,1:5)*1E-3,'b')
//plot(LAY.time,LAY.top(:,1:5)*1E-3,'b')
//a.children(1).children.line_mode="off";
//a.children(1).children.mark_mode="on";
//a.children(1).children.mark_size=2;
//a.children(1).children.mark_foreground=4;
//a.children(2).children.line_mode="off";
//a.children(2).children.mark_mode="on";
//a.children(2).children.mark_size=2;
//a.children(2).children.mark_foreground=4;
//a.data_bounds(4)=15;
//a.data_bounds(3)=0;
//drawnow()






//* * * * * * * * * * * * * * * * * * * * * * * * *
//                   SLOPE INDEX                    
//* * * * * * * * * * * * * * * * * * * * * * * * *
fig=6;
thr_si=0.50;
ind_good=find(LAY.si>=1-thr_si & LAY.si<=1+thr_si);
ind_med=find(LAY.si<1-thr_si | LAY.si>1+thr_si);
ind_bad=find(LAY.si<0 | LAY.si>2);

scf(fig);clf(fig);
drawlater()
f=gcf();a=gca();
xtitle('','$Time\ (UT)$','$Slope\ Index$')
f.figure_size=[900,450];
a.x_label.font_size=4;a.y_label.font_size=4;
a.margins=[0.085,0.15,0.05,0.20];
//a.box='on';

plot(LAY.time,LAY.si)
plot(LAY.time,(1-thr_si)*ones(LAY.time),'k')
plot(LAY.time,(1+thr_si)*ones(LAY.time),'k')
a.children($).children.foreground=color('lightgray');
a.children(1:2).children.line_style=8;

if isempty(ind_good)==%F then
    plot(LAY.time(ind_good),LAY.si(ind_good));
    a.children(1).children.line_mode="off";
    a.children(1).children.mark_mode="on";
    a.children(1).children.mark_size=3;
    a.children(1).children.mark_foreground=color("green");
end
if isempty(ind_med)==%F then
    plot(LAY.time(ind_med),LAY.si(ind_med));
    a.children(1).children.line_mode="off";
    a.children(1).children.mark_mode="on";
    a.children(1).children.mark_size=3;
    a.children(1).children.mark_foreground=color("orange");
end

LAY.si_b=LAY.si;
LAY.si_b((LAY.si_b)<-1.98)=-1.98;
LAY.si_b((LAY.si_b)>3.98)=3.98;

if isempty(ind_bad)==%F then
    plot(LAY.time(ind_bad),LAY.si_b(ind_bad))
    a.children(1).children.line_mode="off";
    a.children(1).children.mark_mode="on";
    a.children(1).children.mark_size=3;
    a.children(1).children.mark_foreground=color("red");
end
a.data_bounds(3)=-2;a.data_bounds(4)=4;
drawnow()
// * * * * * * * * * * * * * * * * * * * * * * * * *







//* * * * * * * * * * * * * * * * * * * * * * * * *
//              LAYERS PLOT               
//* * * * * * * * * * * * * * * * * * * * * * * * *
scf(2);clf(2);f=gcf();
drawlater()
a=gca();
a.margins=[0.085,0.15,0.05,0.20];
f.figure_size = [900,450];
f.color_map=jetcolormap(64);
xtitle('','$Time\ (UT)$','$Range\ (km)$')
a.background=-1;
a.x_label.font_size=4;a.y_label.font_size=4;
plot(LAY.time,15*ones(LAY.bl),'b')
a.children(1).children.polyline_style=6;
a.children(1).children.mark_mode="on";
//a.children(1).children.foreground=color(0,125,255);
a.children(1).children.foreground=13;
a.children(1).children.mark_size_unit="point";
a.children(1).children.mark_size=1.;
a.children(1).children.mark_style=4;

plot(LAY.time,LAY.top(:,1:5)*1E-3,'c')
a.children(1).children.polyline_style=6;
a.children(1).children.foreground=color("gray");
a.children(1).children.mark_mode="on";
a.children(1).children.mark_size_unit="point";
a.children(1).children.mark_size=1.;
a.children(1).children.mark_style=4;


plot(LAY.time,LAY.peak(:,1:5)*1E-3,'w')
a.children(1).children.polyline_style=6;
a.children(1).children.mark_mode="on";
a.children(1).children.mark_size_unit="point";
a.children(1).children.mark_size=1.;
a.children(1).children.mark_style=4;


plot(LAY.time,LAY.base(:,1:5)*1E-3,'b')
a.children(1).children.polyline_style=6;
a.children(1).children.mark_mode="on";
a.children(1).children.mark_size_unit="point";
a.children(1).children.mark_size=1;
a.children(1).children.mark_style=4;

//a.children(1).children.foreground=color(0,125,255);
a.children(1).children.foreground=13;

plot(LAY.time(LAY.tl>0),LAY.tl(LAY.tl>0)*1E-3,'g')
a.children(1).children.polyline_style=6;
a.children(1).children.foreground=color(0,238,118);
a.children(1).children.mark_mode="on";
a.children(1).children.mark_size_unit="point";
a.children(1).children.mark_size=1;
a.children(1).children.mark_style=4;

plot(LAY.time(LAY.bl>0),LAY.bl(LAY.bl>0)*1E-3,'r')
a.children(1).children.polyline_style=6;
a.children(1).children.foreground=color(238,44,44);
a.children(1).children.foreground=53;
a.children(1).children.mark_mode="on";
a.children(1).children.mark_size_unit="point";
a.children(1).children.mark_size=1;
a.children(1).children.mark_style=4;

a.data_bounds(4)=15;
a.data_bounds(3)=0;
drawnow()
// * * * * * * * * * * * * * * * * * * * * * * * * *





//* * * * * * * * * * * * * * * * * * * * * * * * *
//              EXT PROFILES AND HISTOGRAM               
//* * * * * * * * * * * * * * * * * * * * * * * * *
scf(3);clf(3);f=gcf()
drawlater()
subplot(1,2,1)
f.figure_size=[900,700]
xtitle('','$\sigma_{a,ext}\ (km^{-1})$','$Range\ (km)$')
a=gca();
a.x_label.font_size=4;a.y_label.font_size=4;
a.margins=[0.12,0.1,0.1,0.12];

plot(INV.ext',lid.z(1:size(INV.ext,2))'*1E-3,'r')
vec=[1:size(INV.ext,1)];
ind_ok=vec((INV.nb_ok((INV.nb_tot)>0)./INV.nb_tot((INV.nb_tot)>0))==1);
ind_notok=vec((INV.nb_ok((INV.nb_tot)>0)./INV.nb_tot((INV.nb_tot)>0))<1);
if length(ind_ok)>0 then
    if isnan(nanmean(INV.ext(ind_ok,:)))<>%T then
        plot(INV.ext(ind_ok,:)',lid.z(1:params.z2/lid.vresol)'*1E-3,'b')
    end
end


subplot(2,2,2)
xtitle('','$AOD$','$Frequency$')
if length(ind_notok)>0 then
    histplot([0:1e-2:1],INV.aod(ind_notok));
    a=gca()
    a.children(1).children.foreground=color('red')
end
if length(ind_ok)>0 then
    histplot([0:1e-2:1],INV.aod(ind_ok));
    a=gca()
    a.children(1).children.foreground=color('blue')
end
a.data_bounds(1)=0;a.data_bounds(2)=1;
a.box='on';
a=gca();
a.x_label.font_size=4;a.y_label.font_size=4;
a.margins=[0.12,0.1,0.1,0.2];

subplot(2,2,4)
xtitle('','$S_a\ (sr)$','$Frequency$')
if length(ind_notok)>0 then
    histplot([0:5:140],INV.sa(ind_notok));
    a=gca()
    a.children(1).children.foreground=color('red')
end
if length(ind_ok)>0 then
    histplot([0:5:140],INV.sa(ind_ok));
    a=gca()
    a.children(1).children.foreground=color('blue')
end
a.data_bounds(1)=0;a.data_bounds(2)=150;
a.box='on';
a=gca();
a.x_label.font_size=4;a.y_label.font_size=4;
a.margins=[0.12,0.1,0.1,0.2];
drawnow()
// * * * * * * * * * * * * * * * * * * * * * * * * *







//* * * * * * * * * * * * * * * * * * * * * * * * *
//          QL_EXT PROFILES AND AOD(t),SA(t)       ALL
//* * * * * * * * * * * * * * * * * * * * * * * * *
scf(4);clf(4);f=gcf()
xinfo('ALL PROFILES')
drawlater()
fig=4;nb_sub=2;


//min-max
if isnum(params.min_ext) then
    min_ext=evstr(params.min_ext);
else
    min_ext=0;
end

if isnum(params.max_ext) then
    max_ext=evstr(params.max_ext);
else
    //calcul du maximum pour QL
    if length(ind_ok)>0 then
        max_ext=round(nanmax(INV.ext(ind_ok,:))*100)/100;
    if isnan(max_ext)==%T then
        max_ext=round(nanmax(INV.ext(:,:))*100)/100;
    end
    if isnan(max_ext)==%T then
        max_ext=0.5;
    end
    else
        max_ext=round(nanmax(INV.ext(:,:))*100)/100;
    end
end


subplot(2,1,1)
f_QLb(INV.time,lid.z(1:size(INV.ext,2))*1E-3,INV.ext(1:$,:)',fig,min_ext,max_ext,nb_sub)
f=gcf();
f.children(1).title.text="$\sigma_{a,ext}\ (km^{-1})$";
f.children(2).zoom_box=[f.children(2).data_bounds(1),f.children(2).data_bounds(2);f.children(2).data_bounds(3),ceil(lid.z(size(INV.ext,2))*1E-3)];

subplot(2,1,2)
a=gca();//a.margins=[0.1,0.1,0.10,0.15];
a.margins=[0.085,0.15,0.1,0.20]
xtitle('','$Time\ (UT)$',strcat(['AOD@',params.lambda]))
a.x_label.font_size=4;
a.y_label.font_size=3;
plot(INV.time,INV.aod,'r')
a.children.children.mark_mode="on";
a.children.children.mark_size=5;
a.children.children.line_style=8;
//better for Oslo
a.children.children.line_mode='off';
a.children.children.mark_foreground=color('red');
a.y_label.font_foreground=color('red');
//a.y_label.position=[INV.time(1)+0.04*(INV.time($)-INV.time(1)),a.y_label.position(2)]
a.font_color=color('red');
a.axes_visible=['off','on','off'];
//aod boundaries
if isnum(params.min_aod) then
    a.data_bounds(3)=evstr(params.min_aod);
end
if isnum(params.max_aod) then
    a.data_bounds(4)=evstr(params.max_aod);
end




//decimal axis if scilab 5.5.0
vers=getversion();
vers=part(vers,strindex(vers,'-')+1:length(vers));
points=strindex(vers,'.');
vers=evstr(part(vers,1:points($)-1));

if vers>=5.5 then
    a.ticks_format=["","%3.2f"]
end

newaxes()
a=gca();a.filled="off";
a.font_color=color('blue');
a.margins=[0.085,0.15,0.55,0.1]
a.y_location="right";
xtitle('','','Sa (sr)')
plot(INV.time,INV.sa,'b')

a=gca();
a.y_label.font_size=3;
a.children.children.mark_mode="on";
a.children.children.mark_size=5;
a.children.children.line_style=8;
//better for Oslo
a.children.children.line_mode='off';
a.children.children.mark_foreground=color('blue');
a.y_label.font_foreground=color('blue');
a.axes_visible=['off','on','off'];

newaxes();
a=gca();a.filled="off";
a.margins=[0.085,0.15,0.55,0.1];
plot(INV.time,%nan*ones(INV.sa));
a.axes_visible=["on","off","on"];

//xlabel
xpos=f.children(4).data_bounds(3)-0.2*(f.children(3).data_bounds(4)-f.children(4).data_bounds(3))
f.children(3).x_label.position(2)=xpos;

drawnow()
// * * * * * * * * * * * * * * * * * * * * * * * * *





//* * * * * * * * * * * * * * * * * * * * * * * * *
//          QL_EXT PROFILES AND AOD(t),SA(t)       AEROSOLS
//* * * * * * * * * * * * * * * * * * * * * * * * *

//select cases with no clouds
nb_tot=INV.nb_tot;
nb_tot((nb_tot)==0)=%nan;
ratio=INV.nb_ok./nb_tot;
ind_aer=find(ratio==1);
ind_cloud=find(ratio<1);

//flag clouded profiles
INV_ext=INV.ext;INV_ext(ind_cloud,:)=%nan;
INV_sa=INV.sa;INV_sa(ind_cloud)=%nan;
INV_aod=INV.aod;INV_aod(ind_cloud)=%nan;

scf(5);clf(5);f=gcf()
xinfo('AEROSOL PROFILES')
drawlater()
fig=5;nb_sub=2;
subplot(2,1,1)
f_QLb(INV.time,lid.z(1:size(INV.ext,2))*1E-3,INV_ext(:,:)',fig,min_ext,max_ext,nb_sub)
f=gcf();
f.children(1).title.text="$\sigma_{a,ext}\ (km^{-1})$";
f.children(2).zoom_box=[f.children(2).data_bounds(1),f.children(2).data_bounds(2);f.children(2).data_bounds(3),ceil(lid.z(size(INV.ext,2))*1E-3)];



subplot(2,1,2)
a=gca();//a.margins=[0.1,0.1,0.10,0.15];
a.margins=[0.085,0.15,0.1,0.20]
xtitle('','$Time\ (UT)$',strcat(['AOD@',params.lambda]))
a.x_label.font_size=4;
a.y_label.font_size=3;

plot(INV.time,INV_aod,'r')
a.children.children.mark_mode="on";
a.children.children.mark_size=5;
a.children.children.line_style=8;
//better for Oslo
a.children.children.line_mode='off';
a.children.children.mark_foreground=color('red');
a.y_label.font_foreground=color('red');
//a.y_label.position=[INV.time(1)+0.04*(INV.time($)-INV.time(1)),a.y_label.position(2)]
a.font_color=color('red');
a.axes_visible=['off','on','off'];
//aod boundaries
if isnum(params.min_aod) then
    a.data_bounds(3)=evstr(params.min_aod);
end
if isnum(params.max_aod) then
    a.data_bounds(4)=evstr(params.max_aod);
end


if vers>=5.5 then
    a.ticks_format=["","%3.2f"]
end


newaxes()
a=gca();a.filled="off";
a.font_color=color('blue');
a.margins=[0.085,0.15,0.55,0.1]
a.y_location="right";
xtitle('','','Sa (sr)')
plot(INV.time,INV_sa,'b')

a=gca();
a.y_label.font_size=3;
a.children.children.mark_mode="on";
a.children.children.mark_size=5;
a.children.children.line_style=8;
//better for Oslo
a.children.children.line_mode='off';
a.children.children.mark_foreground=color('blue');
a.y_label.font_foreground=color('blue');
a.axes_visible=['off','on','off'];

newaxes();
a=gca();a.filled="off";
a.margins=[0.085,0.15,0.55,0.1];
plot(INV.time,%nan*ones(INV.sa));
a.axes_visible=["on","off","on"];

//xlabel
xpos=f.children(4).data_bounds(3)-0.2*(f.children(3).data_bounds(4)-f.children(4).data_bounds(3))
f.children(3).x_label.position(2)=xpos;

drawnow()
// * * * * * * * * * * * * * * * * * * * * * * * * *






//* * * * * * * * * * * * * * * * * * * * * * * * *
//              EXPORTATION               
//* * * * * * * * * * * * * * * * * * * * * * * * *
figout=strcat([path_fig,site,'/',year,month,'/',day,'/',inv_mod,'/'])
mkdir(figout)
xs2bmp(1,strcat([figout,'QL_LAY-',site,'-',year,month,day,'.bmp']));
//without layers
scf(1);f=gcf();
f.children(2).children(1:2).visible="off";
xs2bmp(1,strcat([figout,'QL-',site,'-',year,month,day,'.bmp']));
//zoom
f.children($).data_bounds(4)=5;
f.children($).zoom_box=[];
xs2bmp(1,strcat([figout,'QL_ZOOM-',site,'-',year,month,day,'.bmp']))

//with layers
f.children(2).children(1:2).visible="on";
xs2bmp(1,strcat([figout,'QL_LAY_ZOOM-',site,'-',year,month,day,'.bmp']))

//without layers
f.children(2).children(1:2).visible="off";
xs2bmp(1,strcat([figout,'QL_ZOOM-',site,'-',year,month,day,'.bmp']))
f.children($).data_bounds(4)=15;
f.children($).zoom_box=[];


select params.fmt
case 'bmp' then
    xs2bmp(2,strcat([figout,'LAY-',site,'-',year,month,day,'.bmp']))
    scf(2);f=gcf();
    f.children($).data_bounds(4)=5;
    f.children($).zoom_box=[];
    xs2bmp(2,strcat([figout,'LAY_ZOOM-',site,'-',year,month,day,'.bmp']))
    xs2bmp(3,strcat([figout,'EXTSA-',site,'-',year,month,day,'.bmp']))
    xs2bmp(4,strcat([figout,'INVALL-',site,'-',year,month,day,'.bmp']))
    xs2bmp(5,strcat([figout,'INVAER-',site,'-',year,month,day,'.bmp']))
    xs2bmp(6,strcat([figout,'SI-',site,'-',year,month,day,'.bmp']))
case 'jpg' then
    xs2jpg(2,strcat([figout,'LAY-',site,'-',year,month,day,'.jpg']))
    scf(2);f=gcf();
    f.children($).data_bounds(4)=5;
    f.children($).zoom_box=[];
    xs2jpg(2,strcat([figout,'LAY_ZOOM-',site,'-',year,month,day,'.jpg']))
    xs2jpg(3,strcat([figout,'EXTSA-',site,'-',year,month,day,'.jpg']))
    xs2jpg(4,strcat([figout,'INVALL-',site,'-',year,month,day,'.jpg']))
    xs2jpg(5,strcat([figout,'INVAER-',site,'-',year,month,day,'.jpg']))
case 'png' then
    xs2png(2,strcat([figout,'LAY-',site,'-',year,month,day,'.png']))
    scf(2);f=gcf();
    f.children($).data_bounds(4)=5;
    f.children($).zoom_box=[];
    xs2png(2,strcat([figout,'LAY_ZOOM-',site,'-',year,month,day,'.png']))
    xs2png(3,strcat([figout,'EXTSA-',site,'-',year,month,day,'.png']))
    xs2png(4,strcat([figout,'INVALL-',site,'-',year,month,day,'.png']))
    xs2png(5,strcat([figout,'INVAER-',site,'-',year,month,day,'.png']))
else
    mprintf('%s\n','Unknown Format')
end

mprintf('%s\n','√')
catch
mprintf('%s\n','X')
//abort
end
endfunction

