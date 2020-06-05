function [cost, dataStruct] =evaluateCostParallel(paramStruct,Gains)
dataStruct = struct;
if nargin < 2
    Gains = nan(14,1);
end
% OptimParams;
model = 'NeuromuscularModel';
try
    simout = sim(model,...
        'RapidAcceleratorParameterSets',paramStruct,...
        'RapidAcceleratorUpToDateCheck','off',...
        'TimeOut',2*60,...
        'SaveOutput','on');
catch
    cost = nan;
    disp('Timeout')
    disp(Gains');
    return
end

time = get(simout,'time');
metabolicEnergy = get(simout,'metabolicEnergy');
sumOfIdealTorques = get(simout,'sumOfIdealTorques');
sumOfStopTorques = get(simout,'sumOfStopTorques');
HATPos = get(simout,'HATPos');
swingStateCounts = get(simout, 'swingStateCounts');
stepVelocities = get(simout, 'stepVelocities');
stepTimes = get(simout, 'stepTimes');
stepLengths = get(simout, 'stepLengths');
angularData = get(simout, 'angularData');
GaitPhaseData = get(simout,'GaitPhaseData');
kinematics.angularData = angularData;
kinematics.GaitPhaseData = GaitPhaseData;
kinematics.time = time;
kinematics.stepTimes = stepTimes;
%     if ~bisProperDistCovered(stepTimes.time(end),stepLengths,min_velocity,max_velocity,dist_slack)
%         cost = nan;
%         disp('Not enough distance covered')
%         return
%     end

%compute cost of not using all states


%     if (max(swingStateCounts)+1)/HATPos < 0.7
%         cost = nan;
%     end
try
    [cost, dataStruct] = getCost(model,Gains,time,metabolicEnergy,sumOfIdealTorques,sumOfStopTorques,HATPos,swingStateCounts,stepVelocities,stepTimes,stepLengths,1);
    dataStruct.kinematics = kinematics;
catch
    save('error_getCost.mat');
    error('Not possible to evaluate getCost');
end
if isnan(cost)
    return
end