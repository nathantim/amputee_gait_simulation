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
% load('Results/Flat/optUmb10stanceswing1_3ms_prestim.mat');

% compareenergies = load('compareEnergyCostTotal.mat');

% 
% idx_minCost = find(compareenergies.cost==min(compareenergies.cost),1,'first');
% Gains2 = compareenergies.Gains(idx_minCost,:)';
% 
% [Gains,Gains2]
% Gains(1) = 0.8*Gains(1);
% Gains(5) = 0.8*Gains(5);
% Gains(4) = 4*Gains(4);
% Gains(8) = 0.3*Gains(8);
% Gains(3) = 2*Gains(3);
% Gains(3) = 20*Gains(3);
% Gains(25) = 0.04;
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
[cost, dataStruct] = getCost(model,Gains,time,metabolicEnergy,sumOfIdealTorques,sumOfStopTorques,HATPos,swingStateCounts,stepVelocities,stepTimes,stepLengths,1);
%%
% kinematics.angularData = angularData;
% kinematics.GaitPhaseData = GaitPhaseData;
% kinematics.time = time;
% kinematics.stepTimes = stepTimes;
% kinematics.musculoData = musculoData;
% kinematics.GRFData = GRFData;
% dataStruct.kinematics = kinematics;
% save('dataStruct.mat','dataStruct')
% 
% %%
set(0, 'DefaultFigureHitTest','on');
set(0, 'DefaultAxesHitTest','on','DefaultAxesPickableParts','all');
set(0, 'DefaultLineHitTest','on','DefaultLinePickableParts','all');
set(0, 'DefaultPatchHitTest','on','DefaultPatchPickableParts','all');
set(0, 'DefaultStairHitTest','on','DefaultStairPickableParts','all');
set(0, 'DefaultLegendHitTest','on','DefaultLegendPickableParts','all');