function [Hf,err_hf,mean_hf] = htflow(Qc,dQc,Tc,rho,mode,plt,err)
%plt 1 = yes plot
%err 1 = yes do error prop
%mode = HPE distribution. 0 for constant, 1 for linear dec., and 2 for exp.

dHf = dQc;

%%-------------------------Heat Flow Calculation-------------------------%%

Qc_t = reshape(Qc(:,5),[72,36]);
%Qc_t = Qc(:,5);
%reorients images to scale with each other
Qc_t = Qc_t';
Qc_t = flipud(Qc_t);

dHf = reshape(dQc(:,6),[72,36]);
dHf = dHf';
dHf = flipud(dHf);
%%figure
%%imagesc(Qc_t)

%%Tc_map = Tc_map';
%%Tc_map = Tc_map.*1000; %km to m

%noa_clip = open('ArcMap_products/Noachian_FINAL_MASK.tif');
%noa_nan = noa_clip.Noachian_FINAL_MASK;
%noa_nan(noa_clip.Noachian_FINAL_MASK >= 3) = NaN;
%noa_nan_binary = noa_nan./2;
%nnb = imresize(noa_nan_binary, [37 73], 'nearest');
%nnb = double(nnb);

%noach_clip = Tc.*nnb;
%noach_clip(noach_clip == 0) = NaN; 
%imagesc(noach_clip)

%replace this value (noach_clip) with Tc for present-day & vice versa below
Tc = imresize(Tc,[36,72],'nearest'); %only needed for larger grid files
Tc_map = Tc.*1000; %km to m
%figure
%imagesc(Tc_map)
rho = imresize(rho,[36,72],'nearest');
rho_map = rho; %units are fine
%figure
%imagesc(rho_map)
Hf = Qc_t;
%figure
%imagesc(Hf)

%% for plotting crustal thickness maps
% figure
% Hf = 0;
% [X,Y] = meshgrid (2.5:5:357.5, -87.5:5:87.5);
% Hftest = imresize(Tc_map,[721 1441]);
% 
% originLat = dm2degrees([0 0]);
% originLon = dm2degrees([180 0]);
% 
% figure('units','normalized','position',[.1 .1 .8 .6])
% axesm('robinson','Origin',[originLat originLon],'FLineWidth',1.3,'GLineWidth',1.3,'GAltitude',10000,'FontSize',9,'GLineStyle','.','MapLonLimit',[0 360],'MapLatLimit',[-90 90])
% %luju had 'eqacylin' instead of 'robinson'. use robinson for manuscript
% %bc it looks cool
% axis off
% framem on
% gridm on
% mlabel on
% plabel on;
% setm(gca,'MLabelParallel',90) %was 90, can choose 0 for robinson
% 
% lonn = [0:0.25:360];
% latt = [90:-0.25:-90];
% [XX YY] = meshgrid(lonn,latt);
% lon = [0:10:360];
% lat = [90:-10:-90];
% [X Y] = meshgrid(lon,lat);
% tt = geoshow(YY,XX,Hftest,'DisplayType','surface');
% 
% hold all
% axis equal
% hold on
% hold all
% zoom(2)
% set(gca,'FontSize',18) 
% tightmap
% %colormap(hsv)
% c = colorbar('southoutside');
% c.Label.String = ['Crustal Thickness'];
% %c.Label.String = '\sigma';
% set(gca,'FontSize',18)
% set(gca,'FontSize',18)
% setm(gca,'MLineLocation',60,'PLineLocation',30,'FontSize',18) %FS was 20
% setm(gca,'mlabellocation',60,'plabellocation',30,'FontSize',18);
% colormap(jet)
% return
%%


if mode == 1
    fprintf('You chose constant HPE distribution')
    md = 'Constant HPE Distribution';
    Hf = Qc_t.*rho_map.*Tc_map;
    
elseif mode == 2
    fprintf('You chose linear decrease HPE distribution')
    md = 'Linear Decrease';
    Hf = Qc_t;
    for i = 1:2592
        %fun = @(y) -((((1/exp(1)).*Qc_t(i))-Qc_t(i))./Tc_map(i)).*y + Qc_t(i);
        fun = @(y) ((((1/exp(1)).*Qc_t(i))-Qc_t(i))./Tc_map(i)).*y + Qc_t(i);
        Hf(i) = integral(fun,0,Tc_map(i)).*rho_map(i);
    end
elseif mode == 3
    fprintf('You chose exponential decrease HPE distribution')
    md = 'Exponential Decrease';
    Hf = Qc_t;
    for i = 1:2592
        %fun = @(y) -Qc_t(i).*exp(-y./Tc_map(i)) + Qc_t(i);
        fun = @(y) Qc_t(i).*exp(-y./Tc_map(i));
        Hf(i) = integral(fun,0,Tc_map(i)).*rho_map(i);
    end
 elseif mode == 4
    fprintf('You chose exponential increase HPE distribution')
    md = 'Exponential Increase';
    Hf = Qc_t;
    for i = 1:2592
        fun = @(y) Qc_t(i).*exp(y./Tc_map(i));
        Hf(i) = integral(fun,0,Tc_map(i)).*rho_map(i);
    end
%  elseif mode == 5
%     fprintf('You chose linear increase HPE distribution')
%     md = 'Linear Increase';
%     Hf = Qc_t;
%     for i = 1:2592
%         fun = @(y) (((exp(1)).*Qc_t(i)-Qc_t(i))./Tc_map(i)).*y + Qc_t(i);
%         %fun = @(y) ((((exp(1).*Qc_t(i))-Qc_t(i))./Tc_map(i)).*y) + Qc_t(i);
%         Hf(i) = integral(fun,0,Tc_map(i)).*rho_map(i);
%     end
end
            
Hf = Hf.*1000; %W/m2 --> mW/m2


if err == 1
    fprintf(' ')
    %page 65 error prop
    %rhotest = reshape(rho_map,[2592,1])
    %tctest = reshape(Tc_map,[2592,1])
    %size(Tc)
    %size(dHf)
%%%%    dHf =  abs(rho_map.*Tc_map).*dHf;%derivative of Hf wrt hp
    %assume it's the same for now,ask for help l8r
    %dHf(:,6) = dq;
end


%%-----------------------------------Plot--------------------------------%%
if plt == 1
    [X,Y] = meshgrid (2.5:5:357.5, -87.5:5:87.5);
    Hftest = imresize(Hf,[721 1441]);

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
    [XX YY] = meshgrid(lonn,latt);
    lon = [0:10:360];
    lat = [90:-10:-90];
    [X Y] = meshgrid(lon,lat);
    tt = geoshow(YY,XX,Hftest,'DisplayType','surface');

    hold all
    axis equal
    hold on
    hold all
    zoom(2)
    set(gca,'FontSize',18) 
    tightmap
    %colormap(hsv)
    c = colorbar('southoutside');
    c.Label.String = ['Crustal Heat Flow [mW/m^2] with ' num2str(md)];
    %c.Label.String = '\sigma';
    set(gca,'FontSize',18)
    caxis([0 8]) %for t = 0 only
    %caxis([0 35])
    set(gca,'FontSize',18)
    setm(gca,'MLineLocation',60,'PLineLocation',30,'FontSize',18) %FS was 20
    setm(gca,'mlabellocation',60,'plabellocation',30,'FontSize',18);
    colormap(jet)
end

%calc = reshape(Hf,2592,1);
%hf_mean = mean(calc,'omitnan')
%hf_median = median(calc,'omitnan')


%mean from karunatillake et al., 2011 eqn 2
testdHf = reshape(dHf,2592,1);
testHf = reshape(Hf,2592,1);
si = testdHf;%standard error of ith datum
ci = testHf; %value of ith datum
N = (length(si));
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

err_hf = 1/(sumdenom);
mean_hf = sumnum/sumdenom;
hf_mean = mean(testHf,'omitnan')

end

