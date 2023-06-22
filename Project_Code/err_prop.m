%error propagation test value
%made sure maps were all the same size/shape
clc
clear all
close all
warning('off','all')

mode = 3; %determines HPE dist, 1 = const, 3 = exp

Tc = readmatrix('Mars-thick-Khan2022-39-2700-2900.dat');
rho = readmatrix('density_grid_2900_N_2700_S.dat');
noa_clip = open('ArcMap_products/Noachian_FINAL_MASK.tif');

C_K = csvread('\Users\frizz\Desktop\Code\GRS_Research\GRS_maps\2010_04_29_2x2_K_1461_newfit_SmB5_Masked_Rebin_5x5.csv',5);
C_Th = csvread('\Users\frizz\Desktop\Code\GRS_Research\GRS_maps\2010_05_31_2x2_Th_2615_newfit_ppm_SmB10_Masked_Rebin_5x5.csv',5);
%for renormalization
C_H = csvread('\Users\frizz\Desktop\Code\GRS_Research\GRS_maps\2010_05_03_5x5_H_2223_newfit_CapCor2_SmB10_Masked_Rebin_5x5.csv',5);
C_Cl = csvread('\Users\frizz\Desktop\Code\GRS_Research\GRS_maps\2010_04_29_5x5_Cl_WM_newfit_CapCor2_SmB15_Masked_Rebin_5x5.csv',5);
C_S = csvread('\Users\frizz\Desktop\Code\GRS_Research\GRS_maps\2010_04_29_10x10_S_WM_CapAndScatCor2_SmB25_Masked_Rebin_5x5.csv',5);
skip = 1;


H_U238 = 9.46E-5; %W/kg
H_U235 = 5.69E-4;
H_Th = 2.64E-5;
H_K = 2.92E-5; 

t = 0; %time (years: 0 for present)

tt_u238 = 4.468E9; %half life
tt_u235 = 7.038E8;
tt_th = 1.405E10;
tt_k = 1.21513E9;



%% heat prod calc + error calc %%

C_Th(:,5) = C_Th(:,5).*(1E-6);
    
%%first get H -> H2O and S -> SO3 using molar mass equalization
C_H2O = C_H;
C_S(:,5) = 2.5.*C_S(:,5); %s -> so3 renorm

C_K(:,5) = C_K(:,5).*((100)./(100-C_H2O(:,5)-C_Cl(:,5)-C_S(:,5)));
C_Th(:,5) = C_Th(:,5).*((100)./(100-C_H2O(:,5)-C_Cl(:,5)-C_S(:,5)));

%wt% -> % g/g 
C_K(:,5) = C_K(:,5)./100;

C_U = C_Th;
C_U(:,5) = C_U(:,5)./3.8; %supposed to be 3.8

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

dQc = Qc;





%% HP Err calc %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
sk = C_K(:,6); %err k
sth = C_Th(:,6); %err th
scl = C_Cl(:,6); %err cl
sh = C_H(:,6); %err h
ss = C_S(:,6); %err s

dfk = (H_K)./((100-C_H(:,5)-C_Cl(:,5)-C_S(:,5)).*(1.191e4)); 
dfk_cl = (C_K(:,5).*H_K.*(1.191e-4))./((C_H(:,5) + C_Cl(:,5) + C_S(:,5) -100).^2);
dfk_h = dfk_cl;
dfk_s = dfk_cl.*2.5; %add *2.5 term 

dfth = (100.*H_Th)./(((100-C_H(:,5)-C_Cl(:,5)-C_S(:,5)).*2).*(1e6));
dfth_cl = (C_Th(:,5).*H_Th)./((1e4).*(-C_H(:,5)-C_Cl(:,5)-C_S(:,5)+100).^2);
dfth_h = dfth_cl;
dfth_s = dfth_cl.*2.5; %add *2.5 term
dfu = dfth;

%hp error
sm_hp =  sqrt(((abs(dfk).^2).*(sk).^2) + ((abs(dfk_cl).^2).*(scl).^2) + ((abs(dfk_h).^2).*(sh).^2) + ((abs(dfk_s).^2).*(ss).^2) + ...
    ((abs(dfth).^2).*(sth).^2) + ((abs(dfth_cl).^2).*(scl).^2) + ((abs(dfth_h).^2).*(sh).^2) + ((abs(dfth_s).^2).*(ss).^2)+ ...
    ((((abs(dfu).^2).*(sth).^2)+((abs(dfth_cl).^2).*(scl).^2)+ ((abs(dfth_h).^2).*(sh).^2) + ((abs(dfth_s).^2).*(ss).^2))./3.8.*H_U235.*0.0071)+ ...
    ((((abs(dfu).^2).*(sth).^2)+((abs(dfth_cl).^2).*(scl).^2)+ ((abs(dfth_h).^2).*(sh).^2) + ((abs(dfth_s).^2).*(ss).^2))./3.8.*H_U238.*0.9928));

%MEAN + err of mean
%dQc(:,6) = sm_hp;
%Qc(:,6) = sm_hp;

si = sm_hp;%dQc(:,6);%standard error of ith datum
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

err_hp = 1/sqrt(sumdenom)
mean_hp = sumnum/sumdenom


%% HF + error calc %%
Qc_t = reshape(Qc(:,5),[72,36]);
%Qc_t = Qc(:,5);
%reorients images to scale with each other
Qc_t = Qc_t';
Qc_t = flipud(Qc_t);


%figure
%imagesc(Qc_t)

dHf = sm_hp; %dQc;

Tc = imresize(Tc,[36,72],'nearest'); %only needed for larger grid files
Tc_map = Tc.*1000; %km to m
rho = imresize(rho,[36,72],'nearest');
rho_map = rho; %units are fine

if mode == 1
    fprintf('You chose constant HPE distribution')
    md = 'Constant HPE Distribution';
    Hf = Qc_t.*rho_map.*Tc_map;
    
elseif mode == 2
    fprintf('You chose linear decrease HPE distribution')
    md = 'Linear Decrease';
    Hf = Qc_t;
    for i = 1:2592
        fun = @(y) ((((1/exp(1)).*Qc_t(i))-Qc_t(i))./Tc_map(i)).*y + Qc_t(i);
        Hf(i) = integral(fun,0,Tc_map(i)).*rho_map(i);
    end
elseif mode == 3
    fprintf('You chose exponential decrease HPE distribution')
    md = 'Exponential Decrease';
    Hf = Qc_t;
    for i = 1:2592
        fun = @(y) Qc_t(i).*exp(-y./Tc_map(i));
        Hf(i) = integral(fun,0,Tc_map(i)).*rho_map(i);
    end
end
            
Hf = Hf.*1000; %W/m2 --> mW/m2


%%error calc

%err prop

if mode == 1
    df2 = rho_map.*Tc_map.*1000; %1000 to go from W to mW/m2
elseif mode == 2
    df2 = rho_map.*((Tc_map./2*exp(1)) + Tc_map - (0.5)).*1000;
elseif mode == 3 
    df2 = (-(rho_map.*Tc_map.*1000)./2);
end

%intermed
mapdqc = reshape(sm_hp,72,36);
%reorients images to scale with each other
mapdqc = mapdqc';
mapdqc = flipud(mapdqc);

sm_hf = sqrt((abs(df2).^2).*((mapdqc).^2));
%dHf(:,6) = reshape(sm_hf,2592,1);
%dHf(:,6) = dHf(:,6).*1000; %W/m2 -> mW/m2
figure
imagesc(Hf)
figure
imagesc(sm_hf)
testHf = reshape(Hf,2592,1);
si1 = reshape(sm_hf,2592,1);%standard error of ith datum, order of 1e4?
ci1 = testHf; %value of ith datum
N1 = (length(si1));
sumnum1 = 0.0;
sumdenom1 = 0.0;

for k1=1:N1
    if isnan(ci1(k1))
        sumnum1 = sumnum1;
        sumdenom1 = sumdenom1;
    elseif isnan(si1(k1))
        sumnum1 = sumnum1;
        sumdenom1 = sumdenom1;
    else
       sumnum1 = sumnum1 + (ci1(k1)/(si1(k1)^2));
       sumdenom1 = sumdenom1 + (1/(si1(k1)^2)); 
    end
end

err_hf = 1/sqrt(sumdenom1)%W/m2 to mW/m2
mean_hf = sumnum1/sumdenom1

meann = mean(testHf,'omitnan')
%median = median(testHf,'omitnan')
histogram(Hf)

%% end HF + HF error calc %%