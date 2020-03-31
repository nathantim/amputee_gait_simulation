assignGains

%open('NeuromuscularModel');
tic;
sim('NeuromuscularModel');
toc;

time
metabolicEnergy
sumOfIdealTorques
sumOfStopTorques
swingStateCounts 
HATPos

%compute cost of not using all states
statecost = 0;
numSteps = swingStateCounts(1);
swingStatePercents = swingStateCounts(2:end)/numSteps;
if sum(swingStatePercents < 0.75)
    statecost = range(swingStateCounts);
end

%compute cost of transport
tconst1 = 1e11;
timecost = tconst1/exp(time);
amputeeMass = 80;
costOfTransport = (metabolicEnergy + 0.1*sumOfIdealTorques + .1*sumOfStopTorques)/(HATPos*amputeeMass);

EnergyCost = costOfTransport + timecost + statecost
RobustnessCost = -1*HATPos + 0.0005*sumOfStopTorques + 0.5*statecost
HATPos
