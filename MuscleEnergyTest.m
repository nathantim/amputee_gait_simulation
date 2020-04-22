clear all; close all; clc;
%%
BodyMechParams;
Ahill = 0.25;
gmax = 1.5;
% Fmax = FmaxSOL;
% lopt = loptSOL;
% vmax = vmaxSOL;
% lslack = lslackSOL;
% FT = FT_SOL;

% Koelewijn
Fmax = 4000;
lopt = 0.055;
vmax = 12; % maximum contraction velocity [lopt/s]
lslack = 0.245;
FT = 20;
w = 1.039;

% % Miller
% Fmax = 3842;
% lopt = 0.044;
% vmax = 12; % maximum contraction velocity [lopt/s]
% lslack = 0.282;
% FT = 14;
% w = 1.11;

%%
% Type of muscle movement: shortening/isometric/lengthening (-1/0/1)
muscle_movement_values = [-1;0;1];
stimulations_val = [0.05;0.25;0.5;0.75;1];
% stimulations_val = 0.05;


model = 'MuscleEnergyTestModel';
tic;
for j = 1:length(muscle_movement_values)
    muscle_movement = muscle_movement_values(j);
    for i = 1:length(stimulations_val)
        stim_val = stimulations_val(i);
        fprintf('--Muscle movement value: %d, Stimulation value: %.2f --\n',muscle_movement,stim_val)
        
        sim(model);
%         
%         if round(activationData(end),3) ~= stim_val
%             error('Activation level did not reach desired level');
%         end
        
        powerValues(i,:,j) = powerData(end,:);
        
    end
end
toc;

%%
figure();
barPlots(1) = subplot(1,3,1);
bar(powerValues(:,:,1)');
title('shortening');
yaxis([0 800]);
barPlots(2) = subplot(1,3,2);
bar(powerValues(:,:,2)');
title('Isometric');
yaxis([0 150]);
barPlots(3) = subplot(1,3,3);
bar(powerValues(:,:,3)');
title('Lengthening');
yaxis([-400 400]);


legend(barPlots(1),'a = 0.05','a = 0.25','a = 0.50','a = 0.75','a = 1','Location','northwest');

str={'Wang 2012', 'Umberger 2003', 'Umberger 2010', 'Umberger 2003 T&G'};
angle = 40;
for k = 1:length(barPlots)
    
set(barPlots(k), 'XTickLabel',str, 'XTick',1:numel(str))

xtickangle(barPlots(k),angle)

end

%%
% vce = -1:1/12:0; % 1/(vmax*lopt)
% g_vce = zeros(size(vce));
% fv_vce = zeros(size(vce));
% for k = 1:length(vce)
%     c = 1 * Ahill * (gmax-1) / (Ahill+1);
%     if vce(k)<0
%         g_vce(k) = (1 + vce(k))/(1-vce(k)/Ahill);
%         fv_vce(k) = (-1-vce(k))/(-1+K*vce(k));
%     else
%         g_vce(k) = (gmax*vce(k)+c)/(vce(k)+c);
%         fv_vce(k) = N + (N-1)* (-1+vce(k))/(7.65*K*vce(k)+1);
%     end
% end
% a = 1;
% f_lce = 1;
% f_g_ce = a*f_lce*g_vce;
% f_fv_ce = a*f_lce*fv_vce;
% F_g_ce = a*f_lce*g_vce*Fmax;
% F_fv_ce = a*f_lce*fv_vce*Fmax;
% plot(vce,F_g_ce.*vce,vce,F_fv_ce.*vce)