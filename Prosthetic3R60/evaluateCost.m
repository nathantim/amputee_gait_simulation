clc;
%%
tempstring = strsplit(opts.UserData,' ');
dataFile = tempstring{end};
InitialGuessFile = load(dataFile); 

Gains = InitialGuessFile.Gains(1:45).*exp(bestever.x);
% load('Results/Flat/v_0.5m_s.mat');
% load('Results/Flat/v_0.8m_s.mat');
% load('Results/Flat/v_1.1m_s.mat');
% load('Results/Flat/v_1.4m_s.mat');
% compareenergies = load('compareEnergyCostTotal_Umb10_prost.mat');

% 
% idx_minCost = find(compareenergies.cost==min(compareenergies.cost),1,'first');
% Gains = compareenergies.Gains(idx_minCost,:)';
% 
% [Gains,Gains2]


%%
assignGains;
dt_visual = 1/30;
model = 'NeuromuscularModelwReflex2';
load_system(model)
%open('NeuromuscularModelwReflex2');
set_param(model,'SimulationMode','Normal');
set_param(model,'StopTime','30');

tic;
sim(model)
toc;


%%
try
    cost = getCost(model,Gains,time,metabolicEnergy,sumOfIdealTorques,sumOfStopTorques,HATPos,swingStateCounts,stepVelocities,stepTimes,stepLengths,1);
catch ME
    error('Not possible to evaluate %s: \n%s ', mfilename, ME.message);
end


