function cost=evaluateCostParallel(paramStruct)
    try
        simout = sim('NeuromuscularModelwReflex',...
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
    metabolicEnergy = get(simout,'metabolicEnergy');
    sumOfIdealTorques = get(simout,'sumOfIdealTorques');
    sumOfStopTorques = get(simout,'sumOfStopTorques');
    HATPos = get(simout,'HATPos');
    swingStateCounts = get(simout, 'swingStateCounts');

    %{
    if HATPos > 
        cost = nan;
        disp('HATPos > 80')
        return
    end
    
    if HATPos < 0
        cost = nan;
        disp('HATPos < 0')
        return
    end

    if metabolicEnergy < 0
        disp('Metabolic Energy < 0')
        cost = nan;
        return
    end
    
    %compute cost of not using all states
    statecost = 0;
    numSteps = swingStateCounts(1);
    swingStatePercents = swingStateCounts(2:end)/numSteps;
    if sum(swingStatePercents < 0.75)
        statecost = range(swingStateCounts);
    end

    %compute cost of transport
    %{
    tconst1 = 1e11;
    timecost = tconst1/exp(time);

    amputeeMass = 75.25;
    costOfTransport = (metabolicEnergy + 0.1*sumOfIdealTorques + 0.01*sumOfStopTorques)/(HATPos*amputeeMass);
    cost = costOfTransport + timecost + statecost;
    
    
    cost = -1*HATPos + 0.0005*sumOfStopTorques + 0.5*statecost;
    if cost > 0
        cost = nan;
    end
    fprintf('cost: %2.2f, HATPos: %2.2f, stop: %2.2f, statecost: %d \n',...
       cost, HATPos, 0.0005*sumOfStopTorques, statecost)
    %}
    %cost = -1*HATPos;
    %}
    cost = HATPos;
