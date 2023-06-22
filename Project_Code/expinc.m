%% EXP INCREASE SCENARIO %%
clc
clear all
close all
warning('off','all')

Tc = readmatrix('Mars-thick-Khan2022-39-2900-2900.dat');
rho = readmatrix('density_grid_2900_N_2900_S.dat');


for i = 4:5 
    for j = 3.8
        [Qc, dQc,err_hp,mean_hp] = heat_prod(j,8,1,(0)); %last one is time, 0 for present
        [Hf,err_hf,mean_hf] = htflow(Qc,dQc,Tc,rho,i,8,1);

        if i == 4
            %Hftest = imresize(Hf,[721 1441]);
        %save("heat_flow_" + "HPE_expinc_" + "3.8" + "_2700_N_2700_S" + ".dat","Hf",'-ascii') 
%         [X,Y] = meshgrid (2.5:5:357.5, -87.5:5:87.5);
%         originLat = dm2degrees([0 0]);
%         originLon = dm2degrees([180 0]);
%         Hf = flipud(Hf);
%         figure('units','normalized','position',[.1 .1 .8 .6])
%         axesm('robinson','Origin',[originLat originLon],'FLineWidth',1.3,'GLineWidth',1.3,'GAltitude',10000,'FontSize',9,'GLineStyle','.','MapLonLimit',[0 360],'MapLatLimit',[-60 60])
%         axis off
%         framem on
%         gridm on
%         mlabel on
%         plabel on;
%         setm(gca,'MLabelParallel',90)
%         tt = geoshow(Y,X,Hf,'DisplayType','texturemap');
%         hold all
%         axis equal
%         hold on
%         hold all
%         zoom(2)
%         set(gca,'FontSize',20) %13
%         tightmap
%         %caxis([4000 8000])
%         c = colorbar('southoutside');
%         set(gca,'FontSize',20) %15
%         c.Label.String = ['Heat Flow (Exp Inc) [mW/m^3]'];
%         %c.Label.String = '\sigma';
%         set(gca,'FontSize',20) %15
%         set(gca,'FontSize',20)%13
%         setm(gca,'MLineLocation',60,'PLineLocation',30,'FontSize',15) %FS was 13
%         setm(gca,'mlabellocation',60,'plabellocation',30,'FontSize',15);
%         colormap(jet)

        end


        if i == 5
           %save("heat_flow_" + "HPE_lininc_" + "3.8" + "_2700_N_2700_S" + ".dat","Hf",'-ascii') 
%        [X,Y] = meshgrid (2.5:5:357.5, -87.5:5:87.5);
%         originLat = dm2degrees([0 0]);
%         originLon = dm2degrees([180 0]);
%         Hf = flipud(Hf);
%         figure('units','normalized','position',[.1 .1 .8 .6])
%         axesm('robinson','Origin',[originLat originLon],'FLineWidth',1.3,'GLineWidth',1.3,'GAltitude',10000,'FontSize',9,'GLineStyle','.','MapLonLimit',[0 360],'MapLatLimit',[-60 60])
%         axis off
%         framem on
%         gridm on
%         mlabel on
%         plabel on;
%         setm(gca,'MLabelParallel',90)
%         tt = geoshow(Y,X,Hf,'DisplayType','texturemap');
% 
%         hold all
%         axis equal
%         hold on
%         hold all
%         zoom(2)
%         set(gca,'FontSize',20) %13
%         tightmap
%         %caxis([4000 8000])
%         c = colorbar('southoutside');
%         set(gca,'FontSize',20) %15
%         c.Label.String = ['Heat Flow (Linear Inc) [mW/m^3]'];
%         %c.Label.String = '\sigma';
%         set(gca,'FontSize',20) %15
%         set(gca,'FontSize',20)%13
%         setm(gca,'MLineLocation',60,'PLineLocation',30,'FontSize',15) %FS was 13
%         setm(gca,'mlabellocation',60,'plabellocation',30,'FontSize',15);
%         colormap(jet)
 
        end
    end
end

   