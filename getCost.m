function [cost, dataStruct] = getCost(model,Gains,time,metabolicEnergy,sumOfStopTorques,HATPosVel,stepVelocities,stepTimes,stepLengths,stepNumbers,CMGData,selfCollision,innerOptSettings, b_isParallel)
try
    if nargin < 13
        b_isParallel = false;
    end
    
    if contains(model,'3R60')
         modelType = 'prosthetic';
    else
         modelType = 'healthy';
    end
    if contains(model,'3D')
         modelType = [modelType, '3D'];
    else
         modelType = [modelType, '2D'];
    end
    modelType = [modelType, char(num2str(innerOptSettings.target_velocity)) 'ms'];
    
    dataStruct = struct('modelType',[],'timeCost',struct('data',[],'minimize',1,'info',''),'cost',struct('data',nan,'minimize',1,'info',''),'CoT',struct('data',[],'minimize',1,'info',[]),...
        'E',struct('data',[],'minimize',1,'info',[]),'sumTstop',struct('data',[],'minimize',1,'info',''),...
        'HATPos',struct('data',[],'minimize',0,'info',''),'vMean',struct('data',[],'minimize',0,'info',''),...
        'stepLengthASIstruct',struct('data',[],'minimize',2,'info',''),...
        'stepTimeASIstruct',struct('data',[],'minimize',2,'info',''),'velCost',struct('data',[],'minimize',1,'info',''),'timeVector',struct('data',[],'minimize',1,'info',''),...
        'maxCMGTorque',struct('data',[],'minimize',1,'info',''),'maxCMGdeltaH',struct('data',[],'minimize',1,'info',''),'controlRMSE',struct('data',[],'minimize',1,'info',''),...
        'numberOfCollisions',struct('data',[],'minimize',1,'info',''), ...
        'tripWasActive',struct('data',[],'minimize',1,'info',''),...
        'innerOptSettings',innerOptSettings,'Gains',[],'kinematics',[],'animData3D',[]);
    
    % x pos only
    HATPos = HATPosVel.signals.values(end,1);%norm(HATPosVel.signals.values(end,[1,2]));
%     HATPos = norm(HATPosVel.signals.values(end,[1,2]));
    %%
    if HATPos > 101
        cost = nan;
        fprintf('-- HATPos > 101 --')
        return
    elseif HATPos < 0
        cost = nan;
        fprintf('-- HATPos < 0 --')
        return
    elseif any(metabolicEnergy < 0)
        cost = nan;
        fprintf('-- Metabolic Energy < 0 --')
        return 
    end
    
    %% Calculate cost of transport
    amputeeMass = 80; % kg
    effort_costs = struct;
    
    muscle_exp_models = getExpenditureModels(model);
    if isempty(muscle_exp_models)
        error('No expenditure model in getCost');
    end
    for i = 1:length(muscle_exp_models)
        effort_costs(i).name = (muscle_exp_models{i});
        effort_costs(i).metabolicEnergy = metabolicEnergy(:,i);
        effort_costs(i).costOfTransport = (metabolicEnergy(:,i))/(HATPos*amputeeMass);
    end
    
    % Decide which to use for optimization, 
    % Umberger (2003), Umberger (2003) TG, Umberger (2010), Wang (2012)
%     opt_exp_model = 'Umberger (2010)';
    opt_exp_model = innerOptSettings.expenditure_model;
    costOfTransportForOpt =  effort_costs(contains(muscle_exp_models,opt_exp_model)).costOfTransport;
    if isempty(costOfTransportForOpt)
        disp(effort_costs(:));
        error('Empty cost of transport')
    end
    
    %% Calculate time cost
    timeSetToRun = str2double(get_param(model,'StopTime'));
    timeCost = round(timeSetToRun/time(end),3)-1;
    if timeCost < 0
        timeCost = 0;
    end
    
    %% 
    if max(stepNumbers.signals.values(:,1)) < innerOptSettings.initiation_steps && max(stepNumbers.signals.values(:,1)) < innerOptSettings.initiation_steps
        velCost = 9999999*( innerOptSettings.initiation_steps/min([max(stepNumbers.signals.values(:,1)),max(stepNumbers.signals.values(:,2))]) );
        fprintf('-- Insufficient steps --')
        meanVel = nan;
        ASIVel.ASImean = nan;
        stepLengthASIstruct.ASImean = nan;
        stepTimeASIstruct.ASImean = nan;
    else
        %% Calculate velocity cost
        [velCost,meanVel, ASIVel] = getVelMeasure(HATPosVel,stepNumbers,innerOptSettings.min_velocity,innerOptSettings.max_velocity,innerOptSettings.initiation_steps);
        
        %% Calculate step info
        stepLengthASIstruct = getFilterdMean_and_ASI(findpeaks(stepLengths.signals.values(:,1)),findpeaks(stepLengths.signals.values(:,2)),innerOptSettings.initiation_steps);
        stepTimeASIstruct = getFilterdMean_and_ASI(findpeaks(stepTimes.signals.values(:,1)),findpeaks(stepTimes.signals.values(:,2)),innerOptSettings.initiation_steps);
        
    end
    %%
    try
        maxCMGTorque = max(CMGData.signals.values(:,6));
%         maxTotalTorque = abs(CMGData.time(idx),CMGData.signals.values(:,6));
        maxCMGdeltaH = max(CMGData.signals.values(:,13));
        controlRMSE = sqrt(sum((CMGData.signals.values(:,2)-CMGData.signals.values(:,3)).^2)); %/length(CMGData.signals.values(:,2))
        tripWasActive = max(CMGData.signals.values(:,14));
%         if tripWasActive == 0 
%             cost = nan;
%             disp('No trip');
%             return
%         end
    catch 
        maxCMGTorque = 0;
        maxCMGdeltaH = 0;
        controlRMSE = 0;
        tripWasActive = 0;
    end
    
    %%
%     b_collisionHappend = selfCollision.signals.values(:,end);
    numberOfCollisions = sum(findpeaks(selfCollision.signals.values(:,end)));
    
    %%
    %     cost = 100000*timeCost  + 1000*(velCost + 0*distCost) + 0.1*costOfTransport;
%     cost = 100000*timeCost  + 1000*(velCost) + 100*costOfTransportForOpt + .01*sumOfStopTorques;
%11-6-2020_19:49
    timeFactor  = innerOptSettings.timeFactor;
    velFactor   = innerOptSettings.velocityFactor;
    CoTFactor   = innerOptSettings.CoTFactor;
    stopTFactor = innerOptSettings.sumStopTorqueFactor;
    CMGTorqueFactor = innerOptSettings.CMGTorqueFactor;
    CMGdeltaHFactor = innerOptSettings.CMGdeltaHFactor;
    ControlRMSEFactor = innerOptSettings.ControlRMSEFactor;
    selfCollisionFactor = innerOptSettings.selfCollisionFactor;
    
    cost = timeFactor*timeCost  + velFactor*(velCost) + CoTFactor*costOfTransportForOpt ...
                + stopTFactor*sumOfStopTorques + CMGTorqueFactor*maxCMGTorque + CMGdeltaHFactor*maxCMGdeltaH ...
                + ControlRMSEFactor*controlRMSE + selfCollisionFactor*numberOfCollisions;

    if length(cost) ~= 1
        disp(cost);
        warning('Size cost is not 1');
    end
    
    
    %% Save when optimizing
    
    dataStruct = struct('modelType',modelType,'timeCost',struct('data',timeCost,'minimize',1,'info',''),'cost',struct('data',cost,'minimize',1,'info',''),'CoT',struct('data',[effort_costs(:).costOfTransport]','minimize',1,'info',char({effort_costs(:).name})),...
        'E',struct('data',[effort_costs(:).metabolicEnergy]','minimize',1,'info',char({effort_costs(:).name})),'sumTstop',struct('data',sumOfStopTorques,'minimize',1,'info',''),...
        'HATPos',struct('data',HATPos,'minimize',0,'info',''),'vMean',struct('data',meanVel,'minimize',0,'info',''),...
        'stepLengthASIstruct',struct('data',stepLengthASIstruct,'minimize',2,'info',''),...
        'stepTimeASIstruct',struct('data',stepTimeASIstruct,'minimize',2,'info',''),'velCost',struct('data',velCost,'minimize',1,'info',''),'timeVector',struct('data',time,'minimize',1,'info',''),...
        'maxCMGTorque',struct('data',maxCMGTorque,'minimize',1,'info',''),'maxCMGdeltaH',struct('data',maxCMGdeltaH,'minimize',1,'info',''),'controlRMSE',struct('data',controlRMSE,'minimize',1,'info',''),...
        'numberOfCollisions',struct('data',numberOfCollisions,'minimize',1,'info',''), ...
        'tripWasActive',struct('data',tripWasActive,'minimize',1,'info',''),...
        'innerOptSettings',innerOptSettings,'Gains',Gains);

    if b_isParallel && timeCost == 0
        GainsSave = Gains;
        if size(GainsSave,1)>size(GainsSave,2)
            GainsSave = GainsSave';
        end
        try
            workerID = getCurrentWorker().ProcessId;
        catch ME
            workerID = [];
%             warning(strcat(char(ME.message)," In ", mfilename, " line ", num2str(ME.stack(1).line)));
        end
        filename = [innerOptSettings.optimizationDir filesep char(strcat('compareEnergyCost',num2str(workerID),'.mat'))];
        if exist(filename,'file') == 2
            exist_vars = load(filename);
            metabolicEnergySave     = [exist_vars.metabolicEnergySave;metabolicEnergy];
            meanVel                 = [exist_vars.meanVel;meanVel];
            stepLengthASImean       = [exist_vars.stepLengthASImean;stepLengthASIstruct.ASImean];
            stepTimeASImean         = [exist_vars.stepTimeASImean;stepTimeASIstruct.ASImean];
            costOfTransportSave     = [exist_vars.costOfTransportSave; [effort_costs.costOfTransport] ];
            costT                   = [exist_vars.costT;cost];
            %             sumOfIdealTorques       = [exist_vars.sumOfIdealTorques;sumOfIdealTorques];
            sumOfStopTorques        = [exist_vars.sumOfStopTorques;sumOfStopTorques];
            HATPos                  = [exist_vars.HATPos;HATPos];
            GainsSave               = [exist_vars.GainsSave;GainsSave];
            timeCostSave            = [exist_vars.timeCostSave;timeCost];
            maxCMGTorqueSave        = [exist_vars.maxCMGTorqueSave;maxCMGTorque];
            maxCMGdeltaHSave        = [exist_vars.maxCMGdeltaHSave;maxCMGdeltaH];
            dateSave = [exist_vars.dateSave(:); {char(datestr(now,'yyyy-mm-dd_HH-MM'))}];
        else
            costT = cost;
            metabolicEnergySave = metabolicEnergy;
            costOfTransportSave = [effort_costs.costOfTransport];
            timeCostSave            = [timeCost];
            maxCMGTorqueSave    = [maxCMGTorque];
            maxCMGdeltaHSave        = [maxCMGdeltaH];
             stepLengthASImean       = [stepLengthASIstruct.ASImean];
            stepTimeASImean         = [stepTimeASIstruct.ASImean];
            dateSave = {char(datestr(now,'yyyy-mm-dd_HH-MM'))};

        end
        
        save(filename,'metabolicEnergySave','meanVel','stepTimeASImean', 'stepLengthASImean','costOfTransportSave', ...
            'costT','dateSave','maxCMGdeltaHSave','maxCMGTorqueSave','sumOfStopTorques','HATPos','GainsSave','timeCostSave')
    end
   
    
    %     fprintf('-- <strong> t_sim: %2.2f</strong>, Cost: %2.2f, E_m (Wang): %.0f, E_m(Umb10): %.0f, <strong>avg v_step: %2.2f</strong>, avg t_step: %1.2f, avg l_step: %1.2f, ASI l_step: %2.2f, ASI t_step: %2.2f, timeCost: %2.2f, velCost: %2.2f --\n',...
%         time(end), cost, effort_costs(contains(muscle_exp_models,'Wang')).metabolicEnergy, effort_costs(contains(muscle_exp_models,'Umberger (2010)')).metabolicEnergy,...
%         meanVel, meanStepTime, meanStepLength,round(ASIStepLength,2),round(ASIStepTime,2), timeCost, velCost);
    
% printOptInfo(dataStruct,true);
catch ME
    save('ErrorWorkspace');
    error('Error: %s\nIn %s.m line %d',ME.message,ME.stack(1).name,ME.stack(1).line);
end