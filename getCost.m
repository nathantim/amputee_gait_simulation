function cost = getCost(model,Gains,time,metabolicEnergyWang,metabolicEnergyUmberg,sumOfIdealTorques,sumOfStopTorques,HATPos,swingStateCounts,stepVelocities,stepTimes,stepLengths, b_isParallel)
if nargin < 13
    b_isParallel = 0;
end
OptimParams;
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

if metabolicEnergyWang < 0
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

%     if (max(swingStateCounts)+1)/HATPos < 0.7
%         cost = nan;
%     end

%compute cost of transport
tconst1 = 1e11;
%     timecost = tconst1/exp(time);

amputeeMass = 80;
costOfTransportWang = (metabolicEnergyWang + 0.1*sumOfIdealTorques + .01*sumOfStopTorques)/(HATPos*amputeeMass);
costOfTransportUmberg = (metabolicEnergyUmberg + 0.1*sumOfIdealTorques + .01*sumOfStopTorques)/(HATPos*amputeeMass);

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
leftStrideLengths = stepLengths(stepLengths(:,1)~=0,1);
rightStrideLengths = stepLengths(stepLengths(:,2)~=0,2);
meanStrideLength = mean( [mean(leftStrideLengths(initiation_steps:end)), mean(rightStrideLengths(initiation_steps:end))]);

leftStrideTimes = stepTimes.signals.values(stepTimes.signals.values(:,1)~=0,1);
rightStrideTimes = stepTimes.signals.values(stepTimes.signals.values(:,2)~=0,2);
meanStrideTime = mean( [mean(leftStrideTimes(initiation_steps:end)), mean(rightStrideTimes(initiation_steps:end))]);


timeSetToRun = str2double(get_param(model,'StopTime'));
Tsim = stepTimes.time(end);

timeCost = round(timeSetToRun/Tsim,3)-1;
if timeCost < 0
    timeCost = 0;
end

velCost = getVelMeasure(stepVelocities(:,1),stepTimes.signals.values(:,1),min_velocity,max_velocity,initiation_steps) + ...
    getVelMeasure(stepVelocities(:,2),stepTimes.signals.values(:,2),min_velocity,max_velocity,initiation_steps);
meanVel = 1/2*(mean(stepVelocities(stepVelocities(:,1)~=0,1)) + mean(stepVelocities(stepVelocities(:,2)~=0,2)));

%     [distCost, dist_covered] = getDistMeasure(timeSetToRun,stepLengths,min_velocity,max_velocity,dist_slack);

%     cost = 100000*timeCost  + 1000*(velCost + 0*distCost) + 0.1*costOfTransport;
cost = 100000*timeCost  + 1000*(velCost) + 100*costOfTransportUmberg;
if length(cost) ~= 1
    disp(cost);
    warning('Size cost is not 1');
end
fprintf('-- <strong> sim time: %2.2f</strong>, Cost: %2.2f, timeCost: %2.2f, velCost: %2.2f, avg velocity: %2.2f, Metabolic Energy (Wang): %6.2f, Metabolic Energy (Umberg): %6.2f, avg stride time: %1.2f, avg stride length: %1.2f --\n',...
    Tsim, cost, timeCost, velCost, meanVel, metabolicEnergyWang, metabolicEnergyUmberg, meanStrideTime, meanStrideLength);

if b_isParallel && timeCost == 0
%     try
GainsSave = Gains;
if size(GainsSave,1)>size(GainsSave,2)
   GainsSave = GainsSave'; 
end
        filename = char(strcat('compareEnergyCost',num2str(getCurrentWorker().ProcessId),'.mat'));
        if exist(filename,'file') == 2
            exist_vars = load(filename);
            metabolicEnergyWang     = [exist_vars.metabolicEnergyWang;metabolicEnergyWang];
            metabolicEnergyUmberg   = [exist_vars.metabolicEnergyUmberg;metabolicEnergyUmberg];
            meanVel                 = [exist_vars.meanVel;meanVel];
            meanStrideTime          = [exist_vars.meanStrideTime;meanStrideTime];
            meanStrideLength        = [exist_vars.meanStrideLength;meanStrideLength];
            costOfTransportWang     = [exist_vars.costOfTransportWang;costOfTransportWang];
            costOfTransportUmberg   = [exist_vars.costOfTransportUmberg;costOfTransportUmberg];
            costT                   = [exist_vars.costT;cost];
            sumOfIdealTorques       = [exist_vars.sumOfIdealTorques;sumOfIdealTorques];
            sumOfStopTorques        = [exist_vars.sumOfStopTorques;sumOfStopTorques];
            HATPos                  = [exist_vars.HATPos;HATPos];
            GainsSave               = [exist_vars.GainsSave;GainsSave];
        else 
            costT = cost;
        end
        
        save(filename,'metabolicEnergyWang','metabolicEnergyUmberg','meanVel','meanStrideTime', 'meanStrideLength','costOfTransportWang','costOfTransportUmberg', ...
            'costT','sumOfIdealTorques','sumOfStopTorques','HATPos','GainsSave')
%     catch
%         fprintf('Something went wrong with opening or saving the file, parallel worker id: %d\n',(getCurrentWorker().ProcessId));
%     end
end