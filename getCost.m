function [cost, dataStruct] = getCost(model,Gains,time,metabolicEnergy,sumOfIdealTorques,sumOfStopTorques,HATPos,swingStateCounts,stepVelocities,stepTimes,stepLengths, b_isParallel)
if nargin < 12
    b_isParallel = 0;
end
OptimParams;
dataStruct = struct;
% global dataQueueD

%%
if HATPos > 101
    cost = nan;
    disp('HATPos > 101')
    return
elseif HATPos < 0
    cost = nan;
    disp('HATPos < 0')
    return
elseif any(metabolicEnergy < 0)
    cost = nan;
    disp('Metabolic Energy < 0')
    return
elseif ( min(size(stepVelocities)) == 0 || min(size(stepTimes)) == 0 || size(stepVelocities,2) ~= 2 || size(stepTimes,2) ~= 2 || ...
        min(size(stepVelocities(stepVelocities~=0))) == 0 ||  min(size(stepTimes(stepTimes~=0))) == 0)
    cost = nan;
    disp('No steps')
    return
end

%% Calculate cost of transport
amputeeMass = 80; % kg
effort_costs = struct;

muscle_exp_models = getExpenditureModels(model);
for i = 1:length(muscle_exp_models)
   effort_costs(i).name = (muscle_exp_models{i});
   effort_costs(i).metabolicEnergy = metabolicEnergy(:,i);
   effort_costs(i).costOfTransport = (metabolicEnergy(:,i) + 0.1*sumOfIdealTorques + .01*sumOfStopTorques)/(HATPos*amputeeMass);
end

% Decide which to use for optimization
costOfTransportForOpt =  effort_costs(contains(muscle_exp_models,'Umberger (2010)')).costOfTransport; 

%% Calculate time cost
timeSetToRun = str2double(get_param(model,'StopTime'));
timeCost = round(timeSetToRun/time,3)-1;
if timeCost < 0
    timeCost = 0;
end

%% Calculate velocity cost
velCost = getVelMeasure(stepVelocities(:,1),stepTimes(:,1),min_velocity,max_velocity,initiation_steps) + ...
    getVelMeasure(stepVelocities(:,2),stepTimes(:,2),min_velocity,max_velocity,initiation_steps);

%     [distCost, dist_covered] = getDistMeasure(timeSetToRun,stepLengths,min_velocity,max_velocity,dist_slack);

%% Calculate step info
[meanStepLength, ASIStepLength] = getFilterdMean_and_ASI(stepLengths(:,1),stepLengths(:,2),initiation_steps);
[meanStepTime, ASIStepTime] = getFilterdMean_and_ASI(stepTimes(:,1),stepTimes(:,2),initiation_steps);
[meanVel, ASIVel] = getFilterdMean_and_ASI(stepVelocities(:,1),stepVelocities(:,2),initiation_steps);

%%
%     cost = 100000*timeCost  + 1000*(velCost + 0*distCost) + 0.1*costOfTransport;
cost = 100000*timeCost  + 1000*(velCost) + 100*costOfTransportForOpt;

if length(cost) ~= 1
    disp(cost);
    warning('Size cost is not 1');
end
fprintf('-- <strong> t_sim: %2.2f</strong>, Cost: %2.2f, E_m (Wang): %.0f, E_m(Umb10): %.0f, <strong>avg v_step: %2.2f</strong>, avg t_step: %1.2f, avg l_step: %1.2f, ASI l_step: %2.2f, ASI t_step: %2.2f, timeCost: %2.2f, velCost: %2.2f --\n',...
    time, cost, effort_costs(contains(muscle_exp_models,'Wang')).metabolicEnergy, effort_costs(contains(muscle_exp_models,'Umberger (2010)')).metabolicEnergy,...
    meanVel, meanStepTime, meanStepLength,round(ASIStepLength,2),round(ASIStepTime,2), timeCost, velCost);

%% Save when optimizing
if b_isParallel && timeCost == 0
    dataStruct = struct('cost',struct('data',cost,'minimize',1,'info',''),'costOfTransport',struct('data',[effort_costs(:).costOfTransport],'minimize',1,'info',{effort_costs(:).name}),...
        'metabolicEnergy',struct('data',[effort_costs(:).metabolicEnergy],'minimize',1,'info',{effort_costs(:).name}),'sumOfStopTorques',struct('data',sumOfStopTorques,'minimize',1,'info',''),...
        'HATPos',struct('data',HATPos,'minimize',0,'info',''),'vMean',struct('data',meanVel,'minimize',0,'info',''),'tStepMean',struct('data',meanStepTime,'minimize',2,'info',''),...
        'lStepMean',struct('data',meanStepLength,'minimize',2,'info',''),'lStepASI',struct('data',round(ASIStepLength,2),'minimize',2,'info',''),...
        'tStepASI',struct('data',round(ASIStepTime,2),'minimize',2,'info',''));
%     dataStruct = struct('cost',struct('data',cost*rand,'minimize',1,'info',''),'costOfTransport',struct('data',[effort_costs(:).costOfTransport].*rand,'minimize',1,'info',{effort_costs(:).name}),...
%         'metabolicEnergy',struct('data',[effort_costs(:).metabolicEnergy].*rand,'minimize',1,'info',{effort_costs(:).name}),'sumOfStopTorques',struct('data',sumOfStopTorques.*rand,'minimize',1,'info',''),...
%         'HATPos',struct('data',HATPos.*rand,'minimize',0,'info',''),'vMean',struct('data',meanVel.*rand,'minimize',0,'info',''),'tStepMean',struct('data',meanStepTime.*rand,'minimize',2,'info',''),...
%         'lStepMean',struct('data',meanStepLength.*rand,'minimize',2,'info',''),'lStepASI',struct('data',round(ASIStepLength.*rand,2),'minimize',2,'info',''),...
%         'tStepASI',struct('data',round(ASIStepTime.*rand,2),'minimize',2,'info',''));
%     if exist('dataQueueD','var') && ~isempty(dataQueueD)
%         send(dataQueueD,dataStruct);
%     end
    %     try
    GainsSave = Gains;
    if size(GainsSave,1)>size(GainsSave,2)
        GainsSave = GainsSave';
    end
    try
        workerID = getCurrentWorker().ProcessId;
    catch
        workerID = [];
    end
    filename = char(strcat('compareEnergyCost',num2str(workerID),'.mat'));
    if exist(filename,'file') == 2
        exist_vars = load(filename);
        metabolicEnergySave     = [exist_vars.metabolicEnergySave;metabolicEnergy];
        meanVel                 = [exist_vars.meanVel;meanVel];
        meanStepTime            = [exist_vars.meanStepTime;meanStepTime];
        meanStepLength          = [exist_vars.meanStepLength;meanStepLength];
        ASIStepLength           = [exist_vars.ASIStepLength;ASIStepLength];
        ASIStepTime             = [exist_vars.ASIStepTime;ASIStepTime];
        ASIVel                  = [exist_vars.ASIVel;ASIVel];
        costOfTransportSave     = [exist_vars.costOfTransportSave; [effort_costs.costOfTransport] ];
        costT                   = [exist_vars.costT;cost];
        sumOfIdealTorques       = [exist_vars.sumOfIdealTorques;sumOfIdealTorques];
        sumOfStopTorques        = [exist_vars.sumOfStopTorques;sumOfStopTorques];
        HATPos                  = [exist_vars.HATPos;HATPos];
        GainsSave               = [exist_vars.GainsSave;GainsSave];
    else
        costT = cost;
        metabolicEnergySave = metabolicEnergy;
        costOfTransportSave = [effort_costs.costOfTransport];
    end
    
    save(filename,'metabolicEnergySave','meanVel','meanStepTime', 'meanStepLength','costOfTransportSave', ...
        'costT','sumOfIdealTorques','sumOfStopTorques','HATPos','GainsSave','ASIStepLength','ASIStepTime','ASIVel')
end