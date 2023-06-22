close all
clear all

C_K = csvread('\Users\frizz\Desktop\Code\GRS_Research\GRS_maps\2010_04_29_2x2_K_1461_newfit_SmB5_Masked_Rebin_5x5.csv',5);
C_Th = csvread('\Users\frizz\Desktop\Code\GRS_Research\GRS_maps\2010_05_31_2x2_Th_2615_newfit_ppm_SmB10_Masked_Rebin_5x5.csv',5);
skip = 1;



for i = 1:length(C_Th); %for skipping NaN values
if C_Th(i,5) == 0 ;
    C_Th(i,5) = NaN;
else 
    C_Th(i,5) = C_Th(i,5);
end
skip = skip+1;
end

for i = 1:length(C_K); %for skipping NaN values
if C_K(i,5) == 0 ;
    C_K(i,5) = NaN;
else 
    C_K(i,5) = C_K(i,5);
end
skip = skip+1;
end

%%% CHANGE THESE %%%
pcrust = 2600; %density of crust
Tc = readmatrix('Mars-thick-Khan2022-39-2600-2600.dat');
%%%  %%%  %%%  %%%  %%%
Tc = imresize(Tc,[36,72],'nearest'); %only needed for larger grid files
Tc_map = Tc.*1000; %km to m


%mean from karunatillake et al., 2011 eqn 2
si_k = C_K(:,6);%standard error of ith datum
ci_k = C_K(:,5); %value of ith datum
N = length(C_K(:,5));
sumnum = 0.0;
sumdenom = 0.0;

for k=1:N
    if isnan(ci_k(k))
        sumnum = sumnum;
        sumdenom = sumdenom;
    else
       sumnum = sumnum + (ci_k(k)/(si_k(k)^2));
       sumdenom = sumdenom + (1/(si_k(k)^2)); 
    end
end

err_k = 1/sqrt(sumdenom);
mean_k = sumnum/sumdenom;

%K is wt%
mean_k = mean_k.*1e4; %--> ppm
err_k = err_k.*1e4;


%now for Th
si_th = C_Th(:,6);
ci_th = C_Th(:,5);
N1 = length(C_Th(:,5));
sumnum1 = 0.0;
sumdenom1 = 0.0;

for k1 = 1:N1
    if isnan(ci_th(k1))
        sumnum1 = sumnum1;
        sumdenom1= sumdenom1;
    else
        sumnum1 = sumnum1 + (ci_th(k1)/(si_th(k1)^2));
        sumdenom1 = sumdenom1 + (1/(si_th(k1)^2));
    end
end
err_th = 1/sqrt(sumdenom1);
mean_th = sumnum1/sumdenom1;


mk = mean_k;
mth = mean_th;




Rmars = 3389.5*1000; %m, Siedelmann 2007
Rcore = 1830*1000; %according to Stahler 2021 
Rcrust = mean(Tc_map(:),'omitnan'); %average Tc for my model
pmant = 3380; %density of mantle, Wieczorek 2022 khan2022 model


%for exp inc
fun = @(y) mk.*exp(y./Rcrust);
mk = integral(fun,0,Rcrust)./Rcrust;

fun1 = @(y) mth.*exp(y./Rcrust);
mth = integral(fun1,0,Rcrust)./Rcrust;


%equations from Black et al., 2022
mcrust = pcrust*((4/3)*pi*((Rmars)^3 - (Rmars-Rcrust)^3));
mmantle = pmant*((4/3)*pi*((Rmars-Rcrust)^3 - (Rcore^3)));



%BSth = 0.058; %Taylor 2013, ppm 
BSth = 0.068; %Yoshizaki 2020
%BSk = 309; %taylor 2013, ppm
BSk = 360; %yoshizaki 2020
%BSth = ; %Kahn et al., 2022
Cth = (BSth*(mcrust+mmantle)-Rcrust*mcrust)/mmantle; %concentration in mantle

%translate back to wt%
%Kwt = mk_exp/1e4;
Kwt = mk/1e4;
%Thwt = mth_exp/1e4;
Thwt = mth/1e4;
BSEthwt = BSth./1e4;
BSEkwt = BSk./1e4;

mThcrust = Thwt*mcrust;
mKcrust = Kwt*mcrust;
mThtot = BSEthwt * (mcrust+mmantle);
mKtot = BSEkwt * (mcrust+mmantle);


fracK = mKcrust/mKtot
fracTh = mThcrust/mThtot
%create table with varying Tc/rho and different HPE distributions




%test plot
