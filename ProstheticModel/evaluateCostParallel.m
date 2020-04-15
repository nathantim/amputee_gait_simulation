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
    metabolicEnergy = get(simout,'metabolicEnergy');
    sumOfIdealTorques = get(simout,'sumOfIdealTorques');
    sumOfStopTorques = get(simout,'sumOfStopTorques');
    HATPos = get(simout,'HATPos');
    swingStateCounts = get(simout, 'swingStateCounts');
    stepVelocities = get(simout, 'stepVelocities');
    stepTimes = get(simout, 'stepTimes');
    stepLengths = get(simout, 'stepLengths');
    
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
   
%     if ~bisProperDistCovered(stepTimes.time(end),stepLengths,min_velocity,max_velocity,dist_slack)
%         cost = nan;
%         disp('Not enough distance covered')
%         return
%     end
    
    %compute cost of not using all states
    statecost = 0;
    numSteps = swingStateCounts(1);
    swingStatePercents = swingStateCounts(2:end)/numSteps;
    if sum(swingStatePercents < 0.75)
        statecost = range(swingStateCounts);
    end
    
%     if (max(swingStateCounts)+1)/HATPos < 0.7
%         cost = nan;
%     end
    
    %compute cost of transport
    tconst1 = 1e11;
%     timecost = tconst1/exp(time);

    amputeeMass = 80;
    costOfTransport = (metabolicEnergy + 0.1*sumOfIdealTorques + .01*sumOfStopTorques)/(HATPos*amputeeMass);
%     cost = costOfTransport + timecost + statecost;
    

    %{
    cost = -1*HATPos + 0.0005*sumOfStopTorques + 0.5*statecost;
    if cost > 0
        cost = nan;
    end
    fprintf('cost: %2.2f, HATPos: %2.2f, stop: %2.2f, statecost: %d \n',...
       cost, HATPos, 0.0005*sumOfStopTorques, statecost)
    %}
    
    %cost = -1*HATPos;
    leftStepLengths = stepLengths(stepLengths(:,1)~=0,1);
    rightStepLengths = stepLengths(stepLengths(:,2)~=0,2);
    meanStepLength = mean( [mean(leftStepLengths(initiation_steps:end)), mean(rightStepLengths(initiation_steps:end))]);
    
    leftStepTimes = stepTimes.signals.values(stepTimes.signals.values(:,1)~=0,1);
    rightStepTimes = stepTimes.signals.values(stepTimes.signals.values(:,2)~=0,2);
    meanStepTime = mean( [mean(leftStepTimes(initiation_steps:end)), mean(rightStepTimes(initiation_steps:end))]);


    timeSetToRun = str2double(get_param(model,'StopTime'));
    Tsim = stepTimes.time(end);
    
    timeCost = round(timeSetToRun/Tsim,3)-1;
    if timeCost < 0
        timeCost = 0;
    end
    
    velCost = getVelMeasure(stepVelocities(:,1),stepTimes.signals.values(:,1),min_velocity,max_velocity,initiation_steps) + ...
        getVelMeasure(stepVelocities(:,2),stepTimes.signals.values(:,2),min_velocity,max_velocity,initiation_steps);
    meanVel = 1/2*(mean(stepVelocities(stepVelocities(:,1)~=0,1)) + mean(stepVelocities(stepVelocities(:,2)~=0,2)));
    
    [distCost, dist_covered] = getDistMeasure(timeSetToRun,stepLengths,min_velocity,max_velocity,dist_slack);
    
%     cost = 100000*timeCost  + 1000*(velCost + 0*distCost) + 0.1*costOfTransport;
    cost = 100000*timeCost  + 1000*(velCost) + 100*costOfTransport;
    fprintf('-- <strong> sim time: %2.2f</strong>, Cost: %2.2f, timeCost: %2.2f, velCost: %2.2f, avg velocity: %2.2f, Cost of Transport: %6.2f, avg step time: %1.2f, , avg step length: %1.2f --\n',...
       Tsim, cost, timeCost, velCost, meanVel, costOfTransport, meanStepTime, meanStepLength);