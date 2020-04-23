clc;
%%
% Gains = InitialGuess.*exp(bestever.x);
load('Results/Flat/v_1.4m_s.mat');
% compareenergies = load('compareEnergyCostTotal.mat');

% idx_minUmb = find(compareenergies.metabolicEnergyUmberg==min(compareenergies.metabolicEnergyUmberg),1,'first');
% disp([compareenergies.costT(idx_minUmb),compareenergies.metabolicEnergyUmberg(idx_minUmb),compareenergies.metabolicEnergyWang(idx_minUmb)]);
% Gains = compareenergies.GainsSave(idx_minUmb,:)';

% idx_minWang = find(compareenergies.metabolicEnergyWang==min(compareenergies.metabolicEnergyWang),1,'first');
% Gains = compareenergies.GainsSave(idx_minWang,:)';
% disp([compareenergies.costT(idx_minWang),compareenergies.metabolicEnergyUmberg(idx_minWang),compareenergies.metabolicEnergyWang(idx_minWang)]);

%%
assignGains;
model = 'NeuromuscularModel';
%open('NeuromuscularModel');

tic;
sim(model)
toc;


%%
cost = getCost(model,Gains,time,metabolicEnergy,sumOfIdealTorques,sumOfStopTorques,HATPos,swingStateCounts,stepVelocities,stepTimes,stepLengths);
