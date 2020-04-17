Gains = InitialGuess.*exp(bestever.x);
% assignGains;
assignGains_novirtmuscle;
OptimParams;
% bdclose('all');
model = 'NeuromuscularModelwReflex2';

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

cost = getCost(model,time,metabolicEnergyWang,metabolicEnergyUmberg,sumOfIdealTorques,sumOfStopTorques,HATPos,swingStateCounts,stepVelocities,stepTimes,stepLengths);
