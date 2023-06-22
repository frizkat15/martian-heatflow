%for plotting:
%https://www.mathworks.com/help/matlab/ref/heatmap.html

close all
clear all

densities = {'2600 N,S (49.1)' '2700N/2600S (46.1)' '2800N/2600S (43.0)' '2900N/2600S (39.9)' '2700 N,S (50.5)' '2800N/2700S (47.0)' '2900N/2700S (43.5)' '2800 N,S (52.5)' '2900N/2800S (48.4)' '2900 N,S (55.3)'};
%densities = densities';
T_K = 309;%taylor 2013 K
T_Th = 0.058;%Taylor 2013 Th
frac_K_th_h1 = [0.44 0.41
    0.42 0.39
    0.40 0.38 
    0.38 0.36
    0.47 0.44
    0.45 0.42
    0.42 0.39
    0.51 0.47
    0.48 0.45
    0.55 0.52]; %for homogeneous crustal column
frac_K_th_e1 = [0.28 0.26 %26-26
    0.27 0.25 %27-26
    0.25 0.24 %28-26
    0.24 0.23 %29-26
    0.30 0.28 %27-27
    0.28 0.26 %28-27
    0.27 0.25 %29-27
    0.32 0.30 %28-28
    0.30 0.28 %29-28
    0.35 0.33]; %29-29 for exp HPE dist
frac_K_th_e2 = [0.24 0.22
    0.23 0.21
    0.22 0.20
    0.21 0.19
    0.26 0.24
    0.24 0.23
    0.23 0.21
    0.28 0.26
    0.26 0.24
    0.30 0.28]; %for exp crustal column
frac_K_th_h2 = [0.38 0.35 %26-26
    0.36 0.34 %27-26
    0.35 0.32 %28-26
    0.33 0.30 %29-26
    0.41 0.38 %27-27
    0.38 0.36 %28-27
    0.36 0.34 %29-27
    0.44 0.40 %28-28
    0.41 0.38 %29-28
    0.47 0.44]; %29-29 for homog HPE dist
tc = [49.1
    46.1
    43.0
    39.9
    50.5
    47.0
    43.5
    52.5
    48.4
    55.3]; %Tc in km
%frac_K = frac_K';
%frac_Th = {0.4133, 0.3950 0.3757 0.3554 0.4411 0.4179 0.3937 0.4742 0.4445 0.5161};
%frac_Th = frac_Th';

figure
subplot(1,2,1)
scatter(tc,frac_K_th_h1(:,1).*100,'filled','MarkerFaceColor',"#EDB120")
hold on
scatter(tc,frac_K_th_h1(:,2).*100,'filled','MarkerFaceColor',"#D95319")
hold on
scatter(tc,frac_K_th_e1(:,1).*100,'filled','MarkerFaceColor',"magenta")
scatter(tc,frac_K_th_e1(:,2).*100,'filled','MarkerFaceColor',"#7E2F8E")
axis square
box on
ylim([10,60])
legend('Potassium (H)','Thorium (H)','Potassium (E)','Thorium (E)','Location','northwest')
xlabel('Crustal Thickness [km]')
ylabel('Percent HPE in Crust')
title("Taylor, 2013")

subplot(1,2,2)
scatter(tc,frac_K_th_h2(:,1).*100,'filled','MarkerFaceColor',"#EDB120")
hold on
scatter(tc,frac_K_th_h2(:,2).*100,'filled','MarkerFaceColor',"#D95319")
hold on
scatter(tc,frac_K_th_e2(:,1).*100,'filled','MarkerFaceColor',"magenta")
scatter(tc,frac_K_th_e2(:,2).*100,'filled','MarkerFaceColor',"#7E2F8E")
axis square
box on
ylim([10,60])
xlabel('Crustal Thickness [km]')
ylabel('Percent HPE in Crust')
title('Yoshizaki & McDonough, 2020')
%stop


figure
subplot(1,2,1)
xx = {'% K' '% Th'};
%tbl = table(frac_K,frac_Th);
%plot(tbl.densities,tbl,frac_Th)
h1 = heatmap(xx,densities,(frac_K_th_h1.*100))

ylabel('Crustal Density [kg m-3] (avg. Tc [km])')
title('Homogeneous Crustal HPE Distribution')

subplot(1,2,2)
xx = {'% K' '% Th'};
%tbl = table(frac_K,frac_Th);
%plot(tbl.densities,tbl,frac_Th)
h2 = heatmap(xx,densities,(frac_K_th_e1.*100))

ylabel('Crustal Density [kg m-3] (avg. Tc [km])')
title('Exponential Crustal HPE Distribution')