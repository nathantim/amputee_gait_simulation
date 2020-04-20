clc;
% Gains = InitialGuess.*exp(bestever.x);
load('Results/Flat/v_1.4m_s.mat');
assignGains;
model = 'NeuromuscularModel';
%open('NeuromuscularModel');

tic;
sim(model)
toc;

% time;
% metabolicEnergyWang;
% metabolicEnergyUmberg;
% sumOfIdealTorques;
% sumOfStopTorques;
% swingStateCounts ;
% HATPos;

cost = getCost(model,Gains,time,metabolicEnergyWang,metabolicEnergyUmberg,sumOfIdealTorques,sumOfStopTorques,HATPos,swingStateCounts,stepVelocities,stepTimes,stepLengths);
