close all
%first you'll need to open the mola file separately, just double click it
%to get the cdata file available
%Hf = readmatrix("heat_flow_HPE_const_UTh_3.8_2900_N_2600_S.dat");
Hf = readmatrix("heat_flow_HPE_const_UTh_3.8_2900_N_2700_S.dat");
Tc = readmatrix('Mars-thick-Khan2022-39-2700-2900.dat');
%Tc = imresize(Tc,[721,1441],"nearest");
%stop
%Hf = readmatrix("Mars-thick-Khan2022-39-2700-2700.dat")
MOLA_stc = open('mola16ppd_oc180_hillshade.tif');
%%%noa_clip = open('ArcMap_products/Noachian_FINAL_MASK.tif');
rho = readmatrix('density_grid_2900_N_2700_S.dat');
%figure
%imagesc(rho)

C_K = csvread('\Users\frizz\Desktop\Code\GRS_Research\GRS_maps\2010_04_29_2x2_K_1461_newfit_SmB5_Masked_Rebin_5x5.csv',5);
C_Th = csvread('\Users\frizz\Desktop\Code\GRS_Research\GRS_maps\2010_05_31_2x2_Th_2615_newfit_ppm_SmB10_Masked_Rebin_5x5.csv',5);
C_S = csvread('\Users\frizz\Desktop\Code\GRS_Research\GRS_maps\2010_04_29_10x10_S_WM_CapAndScatCor2_SmB25_Masked_Rebin_5x5.csv',5);
skip = 1;


K = reshape(C_K(:,5),[72,36]);
K = K';
K = flipud(K);
Th = reshape(C_Th(:,5),[72,36]);
Th = Th';
Th = flipud(Th);
S = reshape(C_S(:,5),[72,36]);
S = S';
S = flipud(S);
%this is the noachian aged clip
%imagesc(noa_clip.Noachian_FINAL_MASK)
%%%noa_nan = noa_clip.Noachian_FINAL_MASK;
%%%noa_nan(noa_clip.Noachian_FINAL_MASK >= 3) = NaN;
%%%noa_nan_binary = noa_nan./2;
%%%nnb = imresize(noa_nan_binary, [721 1441]);
%%%nnb = double(nnb);
%figure
%imagesc(nnb)

MOLA = cdata;
MOLA = imresize(MOLA, [721 1441]);
MOLA = mat2gray(MOLA, [0 255]);

%[X,Y] = meshgrid (2.5:5:357.5, -87.5:5:87.5);
Hftest = imresize(Hf,[721 1441]);
unclip_mean = mean(Hf(:),'omitnan')
%%%noach_Hftest = Hftest.*nnb;
%%%noach_Hftest(noach_Hftest == 0) = NaN;
%%%clip_mean = mean(noach_Hftest(:),'omitnan')

originLat = dm2degrees([0 0]);
originLon = dm2degrees([180 0]);

figure('units','normalized','position',[.1 .1 .8 .6])
axesm('robinson','Origin',[originLat originLon],'FLineWidth',1.3,'GLineWidth',1.3,'GAltitude',10000,'FontSize',9,'GLineStyle','.','MapLonLimit',[0 360],'MapLatLimit',[-60 60])
axis off
framem on
gridm on
mlabel on
plabel on;
setm(gca,'MLabelParallel',60) 

lonn = [0:0.25:360];
latt = [90:-0.25:-90];
[XX, YY] = meshgrid(lonn,latt);

bb = geoshow(YY,XX,MOLA);

%raw = readmatrix('dichotomy_coordinates-JAH-0-360.txt');
%hold on
%plotm(raw(:,2),raw(:,1),Color='blue',LineWidth=5)


%now plot the aqueous minerals points
%separate into mineralogy types

%aq_min = readmatrix("2014_aqueous_minerals.csv");
%hold on
%paleolake = readmatrix("putative_paleolake_deposits_Fassett_Head2008b.csv");
%plotm(paleolake(:,3),paleolake(:,2),'r.')
%hold on
%serp = readmatrix("serpentine_detections_amador.csv");
%plotm(serp(:,3),serp(:,4),'k.')
%legend([silica, phyllo,chloride,carb,sulf])
%bz = scatterm(aq_min(:,2),aq_min(:,1),'k*'); %plotm works too
%uistack(bz,'bottom')
%hold on 


%freezeColors 
hold on 
%[c,hh] = contourm(YY,XX,(Hftest),'LineWidth',1);
tt = geoshow(YY,XX,Hftest,'DisplayType','texturemap');%,'FaceAlpha',0.6);
%%%tt = geoshow(YY,XX,noach_Hftest,'DisplayType','texturemap');%,'FaceAlpha',0.6);
set(tt,'FaceAlpha','texturemap','AlphaData',double(~isnan(Hftest)));


%uistack(tt,'bottom')

hold all


zoom(2)
set(gca,'FontSize',18) 
tightmap
%colormap(hsv)
c = colorbar('southoutside');
c.Label.String = 'Crustal Heat Flow [mW/m^2]';
%c.Label.String = '\sigma';
set(gca,'FontSize',18)
%caxis([0 8]) %for t = 0 only
caxis([0 12])
set(gca,'FontSize',18)
setm(gca,'MLineLocation',60,'PLineLocation',30,'FontSize',14) %FS was 20
setm(gca,'mlabellocation',60,'plabellocation',30,'FontSize',14);
%colormap(gray)
%hold on
