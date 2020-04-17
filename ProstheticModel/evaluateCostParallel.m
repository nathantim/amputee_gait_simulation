function cost=evaluateCostParallel(paramStruct)
model = 'NeuromuscularModelwReflex2';

OptimParams;
try
    simout = sim(model,...
        'RapidAcceleratorParameterSets',paramStruct,...
        'RapidAcceleratorUpToDateCheck','off',...
        'TimeOut',10*60,...
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

cost = getCost(model,time,metabolicEnergyWang,metabolicEnergyUmberg,sumOfIdealTorques,sumOfStopTorques,HATPos,swingStateCounts,stepVelocities,stepTimes,stepLengths);
if isnan(cost)
    return
end