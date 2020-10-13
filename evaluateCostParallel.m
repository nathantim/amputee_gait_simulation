function [cost, dataStruct] = evaluateCostParallel(paramStruct,model,Gains,inner_opt_settings)
dataStruct = struct('cost',struct('data',nan,'minimize',1,'info',''));
if nargin < 2
    Gains = nan(64,1);
end
% OptimParams;
% modellocal = 'NeuromuscularModel2D';
try
    simout = sim(model,...
        'RapidAcceleratorParameterSets',paramStruct,...
        'RapidAcceleratorUpToDateCheck','off',...
        'TimeOut',20*60,...
        'SaveOutput','on');
catch ME
    cost = nan;
    disp('Timeout')
%     disp(Gains');
    disp(ME.message);
    return
end

if contains(simout.SimulationMetadata.ExecutionInfo.StopEvent,'Timeout')
    cost = nan;
    disp('Timeout')
    return
end

time = get(simout,'time');
metabolicEnergy = get(simout,'metabolicEnergy');
% sumOfIdealTorques = get(simout,'sumOfIdealTorques');
sumOfStopTorques = get(simout,'sumOfStopTorques');
HATPosVel = get(simout,'HATPosVel');
% swingStateCounts = get(simout, 'swingStateCounts');
stepVelocities = get(simout, 'stepVelocities');
stepTimes = get(simout, 'stepTimes');
stepLengths = get(simout, 'stepLengths');
stepNumbers = get(simout, 'stepNumbers');
angularData = get(simout, 'angularData');
GaitPhaseData = get(simout,'GaitPhaseData');
jointTorquesData = get(simout, 'jointTorquesData');
musculoData = get(simout, 'musculoData');
GRFData = get(simout, 'GRFData');
selfCollision = get(simout, 'selfCollision');
try
    CMGData = get(simout, 'CMGData');
catch
    CMGData = [];
end

kinematics.angularData = angularData;
kinematics.GaitPhaseData = GaitPhaseData;
kinematics.time = time;
kinematics.stepTimes = stepTimes;
kinematics.musculoData = musculoData;
kinematics.GRFData = GRFData;
kinematics.CMGData = CMGData;
kinematics.jointTorquesData = jointTorquesData;
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
    [cost, dataStruct] = getCost(model,Gains,time,metabolicEnergy,sumOfStopTorques, ...
                                HATPosVel,stepVelocities,stepTimes,stepLengths,...
                                 stepNumbers, CMGData, selfCollision, inner_opt_settings,true);
    dataStruct.kinematics = kinematics;
catch ME
    save('error_getCost.mat');
    error('Error not possible to evaluate getCost: %s\nIn %s.m line %d',ME.message,mfilename,ME.stack(1).line);
end
if isnan(cost)
    return
end