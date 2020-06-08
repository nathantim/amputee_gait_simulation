% clc;
%%
tempstring = strsplit(opts.UserData,' ');
dataFile = tempstring{end};
InitialGuessFile = load(dataFile); 

Gains = InitialGuessFile.Gains.*exp(bestever.x);
% load('Results/Flat/GeyerHerrInit.mat');
% load('Results/Flat/optandGeyerHerrInit.mat');
% load('Results/Flat/SCONE.mat');
% load('Results/Flat/v_0.5m_s.mat');
% load('Results/Flat/v_0.8m_s.mat');
% load('Results/Flat/v_1.1m_s.mat');
% load('Results/Flat/v_1.4m_s.mat');
% compareenergies = load('compareEnergyCostTotal.mat');

% 
% idx_minCost = find(compareenergies.cost==min(compareenergies.cost),1,'first');
% Gains2 = compareenergies.Gains(idx_minCost,:)';
% 
% [Gains,Gains2]


%%
assignGains;
dt_visual = 1/30;
model = 'NeuromuscularModel';
%open('NeuromuscularModel');

warning('off');
tic;
sim(model)
toc;
warning('on');

%%
cost = getCost(model,Gains,time,metabolicEnergy,sumOfIdealTorques,sumOfStopTorques,HATPos,swingStateCounts,stepVelocities,stepTimes,stepLengths,0);
