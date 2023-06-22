%for plotting:
%https://www.mathworks.com/help/matlab/ref/heatmap.html

close all
clear all

densities = {'2600 N,S' '2700N/2600S' '2800N/2600S' '2700 N,S' '2800N/2700S' '2900N/2700S' '2800 N,S' '2900N/2800S' '2900 N,S'};
%densities = densities';
T_K = 309;%taylor 2013 K
T_Th = 0.058;%Taylor 2013 Th
frac_K_th_h1 = [0.44 0.41
    0.42 0.39
    0.40 0.38 
    0.47 0.44
    0.45 0.42
    0.42 0.39
    0.51 0.47
    0.48 0.45
    0.55 0.52]; %for homogeneous crustal column
frac_K_th_e1 = [
    0.76 0.71 %26-26
    0.73 0.68 %27-26
    0.69 0.65 %28-26
    0.81 0.76 %27-27
    0.77 0.72 %28-27
    0.72 0.68 %29-27
    0.87 0.81 %28-28
    0.82 0.76 %29-28
    0.95 0.89]; %29-29 for exp HPE dist
%this is exp decrease)
frac_K_th_z1 = [
    0.24 0.22
    0.23 0.21
    0.22 0.20
    0.26 0.24
    0.24 0.23
    0.23 0.21
    0.28 0.26
    0.26 0.24
    0.30 0.28];

%h2 and e2 are yoshizaki/mcdonough values
frac_K_th_h2 = [0.38 0.35 %26-26
    0.36 0.34 %27-26
    0.35 0.32 %28-26
    0.41 0.38 %27-27
    0.38 0.36 %28-27
    0.36 0.34 %29-27
    0.44 0.40 %28-28
    0.41 0.38 %29-28
    0.47 0.44]; %29-29 for homog HPE dist %for exp crustal column
frac_K_th_e2 = [
    0.65 0.61 %26-26
    0.62 0.58 %27-26
    0.59 0.55 %28-26
    0.69 0.65 %27-27
    0.66 0.61 %28-27
    0.62 0.58 %29-27
    0.75 0.69 %28-28
    0.70 0.65 %29-28
    0.81 0.76]; %29-29 for +exp HPE dist
frac_K_th_z2 = [0.24 0.22
    0.23 0.21
    0.22 0.20
    0.26 0.24
    0.24 0.23
    0.23 0.21
    0.28 0.26
    0.26 0.24
    0.30 0.28];
tc = [49.1
    46.1
    43.0
    50.5
    47.0
    43.5
    52.5
    48.4
    55.3]; %Tc in km

figure
subplot(1,2,1)
scatter(tc,frac_K_th_h1(:,1).*100,'filled','MarkerFaceColor',"#808080")
hold on
scatter(tc,frac_K_th_h1(:,2).*100,'filled','MarkerFaceColor',"black")
hold on
scatter(tc,frac_K_th_e1(:,1).*100,'filled','MarkerFaceColor',"#EDB120")
scatter(tc,frac_K_th_e1(:,2).*100,'filled','MarkerFaceColor',"#D95319")
hold on
scatter(tc,frac_K_th_z1(:,1).*100,'filled','MarkerFaceColor',"magenta")
scatter(tc,frac_K_th_z1(:,2).*100,'filled','MarkerFaceColor',"#7E2F8E")
axis square
box on
ylim([10,100])
xlim([42,56])
%legend('Potassium','Thorium','Location','northwest')
xlabel('Average Crustal Thickness [km]')
ylabel('Percent HPE in Crust')
title("Taylor (2013)")

subplot(1,2,2)
scatter(tc,frac_K_th_h2(:,1).*100,'filled','MarkerFaceColor',"#808080")
hold on
scatter(tc,frac_K_th_h2(:,2).*100,'filled','MarkerFaceColor',"black")
hold on
scatter(tc,frac_K_th_e2(:,1).*100,'filled','MarkerFaceColor',"#EDB120")
scatter(tc,frac_K_th_e2(:,2).*100,'filled','MarkerFaceColor',"#D95319")
hold on
scatter(tc,frac_K_th_z2(:,1).*100,'filled','MarkerFaceColor',"magenta")
scatter(tc,frac_K_th_z2(:,2).*100,'filled','MarkerFaceColor',"#7E2F8E")
axis square
box on
ylim([10,100])
xlim([42,56])
xlabel('Average Crustal Thickness [km]')
ylabel('Percent HPE in Crust')
title('Yoshizaki & McDonough (2020)')
%stop


figure
subplot(1,2,1)
xx = {'% K' '% Th'};
%tbl = table(frac_K,frac_Th);
%plot(tbl.densities,tbl,frac_Th)
h1 = heatmap(xx,densities,(frac_K_th_e1.*100))

ylabel('Crustal Density Model [kg m-3]')
title('Taylor (2013)')

subplot(1,2,2)
xx = {'% K' '% Th'};
%tbl = table(frac_K,frac_Th);
%plot(tbl.densities,tbl,frac_Th)
h2 = heatmap(xx,densities,(frac_K_th_e2.*100))

ylabel('Crustal Density Model [kg m-3]')
title('Yoshizaki & McDonough (2020)')