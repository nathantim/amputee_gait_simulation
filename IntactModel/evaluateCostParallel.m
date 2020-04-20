function cost=evaluateCostParallel(paramStruct,Gains)
if nargin < 2
    Gains = nan(23,1);
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
    return
end

time = get(simout,'time');
metabolicEnergyWang = get(simout,'metabolicEnergyWang');
metabolicEnergyUmberg = get(simout,'metabolicEnergyUmberg');
sumOfIdealTorques = get(simout,'sumOfIdealTorques');
sumOfStopTorques = get(simout,'sumOfStopTorques');
HATPos = get(simout,'HATPos');
swingStateCounts = get(simout, 'swingStateCounts');
stepVelocities = get(simout, 'stepVelocities');
stepTimes = get(simout, 'stepTimes');
stepLengths = get(simout, 'stepLengths');



%     if ~bisProperDistCovered(stepTimes.time(end),stepLengths,min_velocity,max_velocity,dist_slack)
%         cost = nan;
%         disp('Not enough distance covered')
%         return
%     end

%compute cost of not using all states


%     if (max(swingStateCounts)+1)/HATPos < 0.7
%         cost = nan;
%     end

cost = getCost(model,Gains,time,metabolicEnergyWang,metabolicEnergyUmberg,sumOfIdealTorques,sumOfStopTorques,HATPos,swingStateCounts,stepVelocities,stepTimes,stepLengths,1);
if isnan(cost)
    return
end