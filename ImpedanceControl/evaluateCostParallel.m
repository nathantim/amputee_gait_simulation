function cost=evaluateCostParallel(paramStruct)
    
    try
       simout = sim('NeuromuscularModelwImpedance',...
           'RapidAcceleratorParameterSets',paramStruct,...
           'RapidAcceleratorUpToDateCheck','off',...
           'TimeOut',8*60,...
           'SaveOutput','on');
    catch
        cost = nan;
        return
    end

    time = get(simout,'time');
    metabolicEnergy = get(simout,'metabolicEnergy');
    sumOfIdealTorques = get(simout,'sumOfIdealTorques');
    sumOfStopTorques = get(simout,'sumOfStopTorques');
    swingStateCounts = get(simout, 'swingStateCounts');
    impedanceCounts = get(simout, 'impedanceCounts');
    HATPos = get(simout,'HATPos');

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
    
    %{
    if metabolicEnergy < 0
        disp('Metabolic Energy < 0')
        cost = nan;
        return
    end
    %}
    
    statecost = 0;
    numSteps = swingStateCounts(1);
    swingStatePercents = swingStateCounts(2:end)/numSteps;
    if sum(swingStatePercents < 0.75)
        statecost = range(swingStateCounts);
    end

    impedanceStateCost = 0;
    numSteps = impedanceCounts(1);
    impedanceStatePercents = impedanceCounts(2:end)/numSteps;
    if sum(impedanceStatePercents < 0.75)
        impedanceStateCost = range(impedanceCounts);
    end

    %{
    tconst1 = 1e11;
    timecost = tconst1/exp(time);

    amputeeMass = 75.25;
    costOfTransport = (metabolicEnergy + 0.05*sumOfIdealTorques + ...
        .01*sumOfStopTorques)/(HATPos*amputeeMass);
    
    cost = costOfTransport + timecost + statecost + impedanceStateCost;
    %}
    %{
    cost = -1*HATPos + 0.0005*sumOfStopTorques + 0.5*statecost + 0.5*impedanceStateCost;
    if cost > 0
        cost = nan;
    end
    fprintf('cost: %6.2f, HATPos: %5.2f, stop: %6.2f,\n    statecost: %4.1f, impedance cost: %4.1f\n',...
        cost, HATPos, 0.0005*sumOfStopTorques, statecost, impedanceStateCost)
    %}
    %cost = -1*HATPos;
    cost = HATPos
