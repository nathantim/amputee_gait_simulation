clc;
Gains = InitialGuess.*exp(bestever.x);
assignGains;
OptimParams;
model = 'NeuromuscularModel';
%open('NeuromuscularModel');
tic;
sim(model);
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

if ( min(size(stepVelocities)) == 0 || min(size(stepTimes.signals.values)) == 0 || size(stepVelocities,2) ~= 2 || size(stepTimes.signals.values,2) ~= 2 || ...
        min(size(stepVelocities(stepVelocities~=0))) == 0 ||  min(size(stepTimes.signals.values(stepTimes.signals.values~=0))) == 0)
    disp('No steps')
end
    
%compute cost of transport
tconst1 = 1e11;
timecost = tconst1/exp(time);
amputeeMass = 80;
costOfTransport = (metabolicEnergy + 0.1*sumOfIdealTorques + .1*sumOfStopTorques)/(HATPos*amputeeMass);

numSteps;
EnergyCost = costOfTransport + timecost + statecost;
RobustnessCost = -1*HATPos + 0.0005*sumOfStopTorques + 0.5*statecost;
HATPos;

leftStrideLengths = stepLengths(stepLengths(:,1)~=0,1);
rightStrideLengths = stepLengths(stepLengths(:,2)~=0,2);
meanStrideLength = mean( [mean(leftStrideLengths(initiation_steps:end)), mean(rightStrideLengths(initiation_steps:end))]);

leftStrideTimes = stepTimes.signals.values(stepTimes.signals.values(:,1)~=0,1);
rightStrideTimes = stepTimes.signals.values(stepTimes.signals.values(:,2)~=0,2);
meanStrideTime = mean( [mean(leftStrideTimes(initiation_steps:end)), mean(rightStrideTimes(initiation_steps:end))]);

timeSetToRun = str2double(get_param(model,'StopTime'));
Tsim = stepTimes.time(end);
timeCost = timeSetToRun/Tsim-1;

 velCost = getVelMeasure(stepVelocities(:,1),stepTimes.signals.values(:,1),min_velocity,max_velocity,initiation_steps) + ...
        getVelMeasure(stepVelocities(:,2),stepTimes.signals.values(:,2),min_velocity,max_velocity,initiation_steps);

[distCost, dist_covered] = getDistMeasure(stepTimes.time(end),stepLengths,min_velocity,max_velocity,dist_slack);
meanVel = 1/2*(mean(stepVelocities(stepVelocities(:,1)~=0,1)) + mean(stepVelocities(stepVelocities(:,2)~=0,2)));

%     cost = 100000*timeCost  + 1000*(velCost + 0*distCost) + 0.1*costOfTransport;
cost = 100000*timeCost  + 1000*velCost + 100*costOfTransport;
fprintf('-- <strong> sim time: %2.2f</strong>, Cost: %2.2f, timeCost: %2.2f, velCost: %2.2f, avg velocity: %2.2f, Cost of Transport: %6.2f, avg stride time: %1.2f, , avg stride length: %1.2f --\n',...
       Tsim, cost, timeCost, velCost, meanVel, costOfTransport, meanStrideTime, meanStrideLength);