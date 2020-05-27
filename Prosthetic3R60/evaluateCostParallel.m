function [cost, dataStruct] =evaluateCostParallel(model,paramStruct,Gains)
try
    dataStruct = struct;
    if nargin < 3
        Gains = nan(45,1);
        warning('No gains');
    end
    % OptimParams;
    % model = 'NeuromuscularModelwReflex2';
    try
        simout = sim(model,...
            'SimulationMode','rapid',...
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
    metabolicEnergy = get(simout,'metabolicEnergy');
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
    try
        [cost, dataStruct] = getCost(model,Gains,time,metabolicEnergy,sumOfIdealTorques,sumOfStopTorques,HATPos,swingStateCounts,stepVelocities,stepTimes,stepLengths,1);
    catch ME
        save('error_getCost.mat');
        error('Not possible to evaluate getCost: %s', ME.message);
    end
    
    if isnan(cost)
        return
    end
    
catch
    error('Error: %s\nIn %s.m line %d',ME.message,mfilename,ME.stack(1).line);
end