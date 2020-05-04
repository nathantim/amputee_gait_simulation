clear all; clc;
%%
P = pwd;
S = dir(fullfile(P,'*.mat'));
N = {S.name};
X = contains(N,'compareEnergyCost') .* ~contains(N,'total') .* ~contains(N,'Total');
filesIDX = find(X~=0);

%%
for i = 1:length(filesIDX)
    filename = fullfile(P,N{filesIDX(i)});
    exist_vars = load(filename);
    if exist('metabolicEnergy','var') == 1
        metabolicEnergy         = [metabolicEnergy;exist_vars.metabolicEnergySave];
        meanVel                 = [meanVel;exist_vars.meanVel];
        meanStepTime            = [meanStepTime;exist_vars.meanStepTime];
        meanStepLength          = [meanStepLength;exist_vars.meanStepLength];
        costOfTransport         = [costOfTransport;exist_vars.costOfTransportSave];
        cost                    = [cost;exist_vars.costT];
        sumOfIdealTorques       = [sumOfIdealTorques;exist_vars.sumOfIdealTorques];
        sumOfStopTorques        = [sumOfStopTorques;exist_vars.sumOfStopTorques];
        HATPos                  = [HATPos;exist_vars.HATPos];
        Gains                   = [Gains;exist_vars.GainsSave];
        ASIStepLength           = [ASIStepLength; exist_vars.ASIStepLength]; 
        ASIStepTime             = [ASIStepTime; exist_vars.ASIStepTime];
        ASIVel                  = [ASIVel; exist_vars.ASIVel];

    else
        metabolicEnergy         = [exist_vars.metabolicEnergySave];
        meanVel                 = [exist_vars.meanVel];
        meanStepTime            = [exist_vars.meanStepTime];
        meanStepLength          = [exist_vars.meanStepLength];
        costOfTransport         = [exist_vars.costOfTransportSave];
        cost                    = [exist_vars.costT];
        sumOfIdealTorques       = [exist_vars.sumOfIdealTorques];
        sumOfStopTorques        = [exist_vars.sumOfStopTorques];
        HATPos                  = [exist_vars.HATPos];
        Gains                   = [exist_vars.GainsSave];
        ASIStepLength           = [exist_vars.ASIStepLength];
        ASIStepTime             = [exist_vars.ASIStepTime];
        ASIVel                  = [exist_vars.ASIVel];
    end
    
end

save('compareEnergyCostTotalUMB2003TG.mat','metabolicEnergy','meanVel','meanStepTime', 'meanStepLength','costOfTransport', ...
    'cost','sumOfIdealTorques','sumOfStopTorques','HATPos','Gains','ASIStepLength','ASIStepTime','ASIVel');

%%
% varnames = {'E_m Umb','E_m Wang','S t_i','S t_s','v_a_v_g'};
% % corrplot([metabolicEnergyUmberg,metabolicEnergyWang],'varnames',varnames(1:2));
% corrplot([metabolicEnergyUmberg,metabolicEnergyWang,sumOfIdealTorques,sumOfStopTorques,meanVel],'varnames',varnames);