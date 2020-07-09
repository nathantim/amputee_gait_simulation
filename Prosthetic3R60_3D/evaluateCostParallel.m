function [cost, dataStruct] =evaluateCostParallel(paramStruct,Gains)
dataStruct = struct;
if nargin < 2
    Gains = nan(30,1);
end
% OptimParams;
model = 'NeuromuscularModel_3R60_3D';
try
    simout = sim(model,...
        'RapidAcceleratorParameterSets',paramStruct,...
        'RapidAcceleratorUpToDateCheck','off',...
        'TimeOut',2*60,...
        'SaveOutput','on');
catch ME
    
    cost = nan;
    disp(Gains');
    disp('Timeout')
    warning(ME.message);
    return
end

time = get(simout,'time');
metabolicEnergy = get(simout,'metabolicEnergy');
% sumOfIdealTorques = get(simout,'sumOfIdealTorques');
sumOfStopTorques = get(simout,'sumOfStopTorques');
HATPos = get(simout,'HATPos');
% swingStateCounts = get(simout, 'swingStateCounts');
stepVelocities = get(simout, 'stepVelocities');
stepTimes = get(simout, 'stepTimes');
stepLengths = get(simout, 'stepLengths');
angularData = get(simout, 'angularData');
GaitPhaseData = get(simout,'GaitPhaseData');
musculoData = get(simout, 'musculoData');
GRFData = get(simout, 'GRFData');

kinematics.angularData = angularData;
kinematics.GaitPhaseData = GaitPhaseData;
kinematics.time = time;
kinematics.stepTimes = stepTimes;
kinematics.musculoData = musculoData;
kinematics.GRFData = GRFData;
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
    [cost, dataStruct] = getCost(model,Gains,time,metabolicEnergy,sumOfStopTorques,HATPos,stepVelocities,stepTimes,stepLengths,1);
    dataStruct.kinematics = kinematics;
catch ME
    save('error_getCost.mat');
    error('Error not possible to evaluate getCost: %s\nIn %s.m line %d',ME.message,mfilename,ME.stack(1).line);
end
if isnan(cost)
    return
end