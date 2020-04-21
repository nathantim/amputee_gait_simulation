clear all; close all; clc;
%%
BodyMechParams;

% Fmax = FmaxSOL;
% lopt = loptSOL;
% vmax = vmaxSOL;
% lslack = lslackSOL;
% FT = FT_SOL;

Fmax = 4000;
lopt = 0.055;
vmax = 12; % maximum contraction velocity [lopt/s]
lslack = 0.245;
FT = 20;

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
barPlots(2) = subplot(1,3,2);
bar(powerValues(:,:,2)');
title('Isometric');
barPlots(3) = subplot(1,3,3);
bar(powerValues(:,:,3)');
title('Lengthening');


legend('a = 0.05','a = 0.25','a = 0.50','a = 0.75','a = 1','Location','northwest');

str={'Wang 2012', 'Umberger 2003', 'Umberger 2010', 'Umberger 2003 T&G'};
angle = 40;
for k = 1:length(barPlots)
    
set(barPlots(k), 'XTickLabel',str, 'XTick',1:numel(str))

xtickangle(barPlots(k),angle)

end