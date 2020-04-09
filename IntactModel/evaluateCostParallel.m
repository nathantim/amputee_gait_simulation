function cost=evaluateCostParallel(paramStruct)
OptimParams;
    try
        simout = sim('NeuromuscularModel',...
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
    
    if HATPos > 101
        cost = nan;
        disp('HATPos > 101')
        return
    end
    
    if HATPos < 0
        cost = nan;
        disp('HATPos < 0')
        return
    end
    
    if metabolicEnergy < 0
        cost = nan;
        disp('Metabolic Energy < 0')
        return
    end

    if ( min(size(stepVelocities)) == 0 || min(size(stepTimes.signals.values)) == 0 || size(stepVelocities,2) ~= 2 || size(stepTimes.signals.values,2) ~= 2 || ...
            min(size(stepVelocities(stepVelocities~=0))) == 0 ||  min(size(stepTimes.signals.values(stepTimes.signals.values~=0))) == 0) 
        cost = nan;
        disp('No steps')
        return
    end
    
    %compute cost of not using all states
    statecost = 0;
    numSteps = swingStateCounts(1);
    swingStatePercents = swingStateCounts(2:end)/numSteps;
    if sum(swingStatePercents < 0.75)
        statecost = range(swingStateCounts);
    end
    
    if (max(swingStateCounts)+1)/HATPos < 0.7
        cost = nan;
    end
    %{
    %compute cost of transport
    tconst1 = 1e11;
    timecost = tconst1/exp(time);

    amputeeMass = 80;
    costOfTransport = (metabolicEnergy + 0.1*sumOfIdealTorques + .01*sumOfStopTorques)/(HATPos*amputeeMass);
    cost = costOfTransport + timecost + statecost;
    %}

    %{
    cost = -1*HATPos + 0.0005*sumOfStopTorques + 0.5*statecost;
    if cost > 0
        cost = nan;
    end
    fprintf('cost: %2.2f, HATPos: %2.2f, stop: %2.2f, statecost: %d \n',...
       cost, HATPos, 0.0005*sumOfStopTorques, statecost)
    %}
    
    %cost = -1*HATPos;
    velCost = getVelMeasure(stepVelocities(:,1),stepTimes.signals.values(:,1),min_velocity,max_velocity,initiation_steps) + ...
        getVelMeasure(stepVelocities(:,2),stepTimes.signals.values(:,2),min_velocity,max_velocity,initiation_steps);

    cost = 100*velCost;
