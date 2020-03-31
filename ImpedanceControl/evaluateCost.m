assignGains;

open('NeuromuscularModelwImpedance');
warning('off','Simulink:Engine:UINotUpdatedDuringRapidAccelSim');
tic;
    sim('NeuromuscularModelwImpedance');
toc

metabolicEnergy
HATPos
sumOfIdealTorques
sumOfStopTorques

statecost = range(swingStateCounts);
impedanceStateCost = range(impedanceCounts);

tconst1 = 1e11;
timecost = tconst1/exp(time);

amputeeMass = 75.25;
costOfTransport = (metabolicEnergy + 0.05*sumOfIdealTorques + ...
    .001*sumOfStopTorques)/(HATPos*amputeeMass);

cost1 = costOfTransport + timecost + statecost + impedanceStateCost;
cost2 = -1*HATPos + 0.0005*sumOfStopTorques + statecost + impedanceStateCost;
cost3 = HATPos;
