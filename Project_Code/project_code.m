%% Calculating the crustal heat production/Heat Flow using K, Th GRS maps %%
clc
clear all
close all
warning('off','all')

%gets crustal heat production given 3 inputs: u/th ratio, 
    %plotting flag, and error propagation flag (1 = on, 0 = off)
    %last value is time in years. 0 would be present day
%[Qc, dQc,hp_mean,hp_median] = heat_prod(3.8,1,1,4e9);

%fix the flags so you can turn them off

%%---------------------------------------------------------------------%%

%T_c = readmatrix('pc2700_thick.dat');
Tc = readmatrix('Mars-thick-Khan2022-39-2600-2600.dat');
rho = readmatrix('density_grid_2600_N_2600_S.dat');


%turn on for noachian heat flow
%noa_clip = open('ArcMap_products/Noachian_FINAL_MASK.tif');
%noa_nan = noa_clip.Noachian_FINAL_MASK;
%noa_nan(noa_clip.Noachian_FINAL_MASK >= 3) = NaN;
%noa_nan_binary = noa_nan./2;
%nnb = imresize(noa_nan_binary, [37 73], 'nearest');
%nnb = double(nnb);

%noach_clip = Tc.*nnb;
%noach_clip(noach_clip == 0) = NaN; 
%noach_clip = noach_clip./noach_clip;


%stop
for i = 4 %hpe dist
    for j = 3.8%just do 3.8 for now /3:0.1:4
        [Qc, dQc,err_hp,mean_hp] = heat_prod(j,8,1,(0)); %last one is time, 0 for present
        [Hf,err_hf,mean_hf] = htflow(Qc,dQc,Tc,rho,i,8,1);
        %Hf = Hf;
        if i == 1
            Hftest = imresize(Hf,[721 1441]); %for present day
            
            %Hftest = Hf(20:29,36:44); %for TS_subsection + noach mask
            %TS_clip = noach_clip(20:29,36:44);
            %Hftest = Hftest.*TS_clip;
            %x = cdfplot(Hftest(:));
            %x = cdfplot(Hf(:));
            %set(x,'Color', 'm');
            %hold on
            %save("heat_flow_" + "HPE_const_" + "UTh_" + j + "_2700_N_2700_S" + ".dat","Hf",'-ascii') 
            %save("4Ga_heat_flow_HPE_const_UTh_3.8_2900_N_2900_S.dat","Hftest",'-ascii')
            %stop 
        end
        if i == 2
            Hftest = imresize(Hf,[721 1441]);
            
            %Hftest = Hf(20:29,36:44);
            %TS_clip = noach_clip(20:29,36:44);
            %Hftest = Hftest.*TS_clip;
            %x = cdfplot(Hftest(:));
            %x = cdfplot(Hf(:));
            %set(x,'Color', 'b');
            %save("heat_flow_" + "HPE_lin_" + "UTh_" + j + "_2700_N_2700_S" + ".dat","Hf",'-ascii') 
            %save("4Ga_heat_flow_" + "HPE_lin_" + "UTh_" + j + "_2900_N_2900_S" + ".dat","Hftest",'-ascii')
        end
        if i == 3
            Hftest = imresize(Hf,[721 1441]);
            %Hftest = Hf(20:29,36:44);
            %TS_clip = noach_clip(20:29,36:44);
            %Hftest = Hftest.*TS_clip;
            %x = cdfplot(Hftest(:));
            %x = cdfplot(Hf(:));
            %set(x,'Color', 'k');
            %save("heat_flow_" + "HPE_exp_" + "UTh_" + j + "_2700_N_2700_S" + ".dat","Hf",'-ascii') 
            %save("4Ga_heat_flow_" + "HPE_exp_" + "UTh_" + j + "_2900_N_2900_S" + ".dat","Hftest",'-ascii')
        end
        if i == 4
            Hftest = imresize(Hf,[721 1441]);
            %save("heat_flow_" + "HPE_exp_inc_" + "UTh_" + j + "_2900_N_2900_S" + ".dat","Hf",'-ascii') 
            %save("4Ga_heat_flow_" + "HPE_exp_inc_" + "UTh_" + j + "_2900_N_2900_S" + ".dat","Hftest",'-ascii')
        
        
        end

    end
end

stop

%set(gca,'FontSize',18)
%ylabel('Cumulative Probability')
%xlabel('Crustal Heat Flow [mW/m^{2}]')
%h =legend({'Constant HPE Distribution','Linear Decrease','Exponential Decrease'},'Location','southeast');

%Set line of legend in red
%leg_line=findobj(h,'type','Line');
%for i = 1:length(leg_line)
%     set(leg_line(i), 'Color', 'r');
%end
%return



[Qc, dQc] = heat_prod(3,8,1,0);
[Hf] = htflow(Qc,dQc,Tc,rho,0,8,1);
%cdfplot(Hf(:))
%hold on
[Qc, dQc] = heat_prod(3,8,1,0);
[Hf] = htflow(Qc,dQc,Tc,rho,1,8,1);
%cdfplot(Hf(:))
%hold on

[Qc, dQc] = heat_prod(3,8,1,0);
[Hf] = htflow(Qc,dQc,Tc,rho,2,8,1);
%cdfplot(Hf(:))

%legend('HPE: Const, Th/U: 3','HPE: Lin, Th/U: 3','HPE: Exp, Th/U: 3')