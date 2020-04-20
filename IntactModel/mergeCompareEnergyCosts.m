clear all; clc;
%%
P = pwd;
S = dir(fullfile(P,'*.mat'));
N = {S.name};
X = ~cellfun('isempty',strfind(N,'compareEnergyCost'));
filesIDX = find(X~=0);

%%
for i = 1:length(filesIDX)
    filename = fullfile(P,N{filesIDX(i)});
    exist_vars = load(filename);
    if exist('metabolicEnergyWang','var') == 1
        metabolicEnergyWang     = [metabolicEnergyWang;exist_vars.metabolicEnergyWang];
        metabolicEnergyUmberg   = [metabolicEnergyUmberg;exist_vars.metabolicEnergyUmberg];
        meanVel                 = [meanVel;exist_vars.meanVel];
        meanStrideTime          = [meanStrideTime;exist_vars.meanStrideTime];
        meanStrideLength        = [meanStrideLength;exist_vars.meanStrideLength];
        costOfTransportWang     = [costOfTransportWang;exist_vars.costOfTransportWang];
        costOfTransportUmberg   = [costOfTransportUmberg;exist_vars.costOfTransportUmberg];
        costT                   = [costT;exist_vars.costT];
        sumOfIdealTorques       = [sumOfIdealTorques;exist_vars.sumOfIdealTorques];
        sumOfStopTorques        = [sumOfStopTorques;exist_vars.sumOfStopTorques];
        HATPos                  = [HATPos;exist_vars.HATPos];
        GainsSave               = [GainsSave;exist_vars.GainsSave];
    else
        metabolicEnergyWang     = [exist_vars.metabolicEnergyWang];
        metabolicEnergyUmberg   = [exist_vars.metabolicEnergyUmberg];
        meanVel                 = [exist_vars.meanVel];
        meanStrideTime          = [exist_vars.meanStrideTime];
        meanStrideLength        = [exist_vars.meanStrideLength];
        costOfTransportWang     = [exist_vars.costOfTransportWang];
        costOfTransportUmberg   = [exist_vars.costOfTransportUmberg];
        costT                   = [exist_vars.costT];
        sumOfIdealTorques       = [exist_vars.sumOfIdealTorques];
        sumOfStopTorques        = [exist_vars.sumOfStopTorques];
        HATPos                  = [exist_vars.HATPos];
        GainsSave               = [exist_vars.GainsSave];
    end
    
end

save('compareEnergyCostTotal.mat','metabolicEnergyWang','metabolicEnergyUmberg','meanVel','meanStrideTime', 'meanStrideLength','costOfTransportWang','costOfTransportUmberg', ...
    'costT','sumOfIdealTorques','sumOfStopTorques','HATPos','GainsSave');

%%
varnames = {'E_m Umb','E_m Wang','S t_i','S t_s','v_a_v_g'};
% corrplot([metabolicEnergyUmberg,metabolicEnergyWang],'varnames',varnames(1:2));
corrplot([metabolicEnergyUmberg,metabolicEnergyWang,sumOfIdealTorques,sumOfStopTorques,meanVel],'varnames',varnames);