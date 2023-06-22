%% Calculating the crustal heat production using K, Th GRS maps %%

function [Qc,dQc,err_hp,mean_hp] = heat_prod(uth, plt, err,time) 
%u/th ratio
%plotting flag
%error flag
%t is the time in years

dQc = 1; %if err flag not on
C_K = csvread('\Users\frizz\Desktop\Code\GRS_Research\GRS_maps\2010_04_29_2x2_K_1461_newfit_SmB5_Masked_Rebin_5x5.csv',5);
C_Th = csvread('\Users\frizz\Desktop\Code\GRS_Research\GRS_maps\2010_05_31_2x2_Th_2615_newfit_ppm_SmB10_Masked_Rebin_5x5.csv',5);
%for renormalization
C_H = csvread('\Users\frizz\Desktop\Code\GRS_Research\GRS_maps\2010_05_03_5x5_H_2223_newfit_CapCor2_SmB10_Masked_Rebin_5x5.csv',5);
C_Cl = csvread('\Users\frizz\Desktop\Code\GRS_Research\GRS_maps\2010_04_29_5x5_Cl_WM_newfit_CapCor2_SmB15_Masked_Rebin_5x5.csv',5);
C_S = csvread('\Users\frizz\Desktop\Code\GRS_Research\GRS_maps\2010_04_29_10x10_S_WM_CapAndScatCor2_SmB25_Masked_Rebin_5x5.csv',5);
skip = 1;

%%----------Heat release constants from Turcotte & Schubert 2001----------%%
H_U238 = 9.46E-5; %W/kg
H_U235 = 5.69E-4;
H_Th = 2.64E-5;
H_K = 2.92E-5; 

t = time; %time (years: 0 for present)

tt_u238 = 4.468E9; %half life
tt_u235 = 7.038E8;
tt_th = 1.405E10;
tt_k = 1.21513E9;
%-------------------------------------------------------------------------%

%%----------------------Error Propagation--------------------------------%%
if err == 1
    dQc = C_Th;
    %(4/4/21): INCLUDE ERROR PROP FOR RENORM CALC
    %c1 = H_U238*0.9928*(1E-6)*(1/3.8)*1.01;
    %c2 = H_U235*0.0071*(1E-6)*(1/3.8)*1.01;
    %c3 = H_Th*(1E-6)*1.01;
    %c4 = H_K*(1/100)*(1.01)*(1.19E-4);
    %b1 = c1+c2+c3;
    %dTh = C_Th;
    %dTh(:,6) = b1.*C_Th(:,6);
    %dK = C_K;
    %dK(:,6) = c4.*dK(:,6);
    %dQc = sqrt((dTh.^2)+(dK.^2));
    %fprintf('still working on updating this')
end

%%---------scaling/weighting of maps here--------------------------------%%
% turn Th into % calculation
C_Th(:,5) = C_Th(:,5).*(1E-6);
    
%% first get H -> H2O and S -> SO3 using molar mass equalization
C_H2O = C_H;
C_S(:,5) = 2.5.*C_S(:,5); %s -> so3 renorm

C_K(:,5) = C_K(:,5).*((100)./(100-C_H2O(:,5)-C_Cl(:,5)-C_S(:,5)));
C_Th(:,5) = C_Th(:,5).*((100)./(100-C_H2O(:,5)-C_Cl(:,5)-C_S(:,5)));

%wt% -> % ?
C_K(:,5) = C_K(:,5)./100;

C_U = C_Th;
C_U(:,5) = C_U(:,5)./uth; %supposed to be 3.8

%%----------------------Heat Prod Calc-----------------------------------%%
Qc = C_Th;
Qc(:,5) = ((0.9928.*C_U(:,5).*H_U238.*exp((t.*log(2))/(tt_u238))) + ...
    (0.0071.*C_U(:,5).*H_U235.*exp((t.*log(2))/(tt_u235))) ...
    + (C_Th(:,5).*H_Th.*exp((t.*log(2))/(tt_th))) ...
    + ((1.191E-4).*C_K(:,5).*H_K.*exp((t.*log(2))/(tt_k))));

for i = 1:length(Qc); %for skipping NaN values
if Qc(i,5) == 0 ;
    Qc(i,5) = NaN;
else 
    Qc(i,5) = Qc(i,5);
end
skip = skip+1;
end

if plt == 1
    [X,Y] = meshgrid (2.5:5:357.5, -87.5:5:87.5);
    Gridded_abundanceQc = (Qc(:,5)); 
    Gridded_abundanceQc = reshape(Gridded_abundanceQc,72,36);

    test= imresize(Gridded_abundanceQc',[721 1441]);
    test = flipud(test);

    originLat = dm2degrees([0 0]);
    originLon = dm2degrees([180 0]);

    figure('units','normalized','position',[.1 .1 .8 .6])
    axesm('eqacylin','Origin',[originLat originLon],'FLineWidth',1.3,'GLineWidth',1.3,'GAltitude',10000,'FontSize',9,'GLineStyle','.','MapLonLimit',[0 360],'MapLatLimit',[-90 90])
    axis off
    framem on
    gridm on
    mlabel on
    plabel on;
    setm(gca,'MLabelParallel',90)

    lonn = [0:0.25:360];
    latt = [90:-0.25:-90];
    [XX YY] = meshgrid(lonn,latt);
    lon = [0:10:360];
    lat = [90:-10:-90];
    [X Y] = meshgrid(lon,lat);
    tt = geoshow(YY,XX,test,'DisplayType','surface');

    hold all
    axis equal
    hold on
    hold all
    zoom(2)
    set(gca,'FontSize',20) %13
    tightmap
    colormap(hsv)
    c = colorbar('southoutside');
    set(gca,'FontSize',20) %15
    c.Label.String = ['Crustal Heat Production Qc [W/kg] for Th/U = ' num2str(uth)];
    %c.Label.String = '\sigma';
    set(gca,'FontSize',20) %15
    if t == 0
        caxis([2.5e-11 7e-11]) %only turn this on if you need to define the color axes
    end
    set(gca,'FontSize',20)%13
    setm(gca,'MLineLocation',60,'PLineLocation',30,'FontSize',15) %FS was 13
    setm(gca,'mlabellocation',60,'plabellocation',30,'FontSize',15);
    colormap(jet)
end    
hp_mean = mean(Qc(:,5),'omitnan');
%hp_median = median(Qc(:,5),'omitnan')

si = dQc(:,6);%standard error of ith datum
ci = Qc(:,5); %value of ith datum
N = length(Qc(:,5));
sumnum = 0.0;
sumdenom = 0.0;

for k=1:N
    if isnan(ci(k))
        sumnum = sumnum;
        sumdenom = sumdenom;
    else
       sumnum = sumnum + (ci(k)/(si(k)^2));
       sumdenom = sumdenom + (1/(si(k)^2)); 
    end
end

err_hp = 1/(sumdenom);
mean_hp = sumnum/sumdenom;

end
