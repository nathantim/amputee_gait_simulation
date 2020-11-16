function [cost, dataStruct] = getCost(model,Gains,time,metabolicEnergy,sumOfStopTorques,HATPosVel,stepVelocities,stepTimes,stepLengths,stepNumbers,CMGData,selfCollision,innerOptSettings, b_isParallel)
% GETCOST                           Function calculates the cost function value for the given simulation data
% INPUTS:
%   - model                         Model which is simulated
%   - Gains                         Gains which are used for the model evaluation, this is for saving
%   - time                          Time reached of the simulation
%   - metabolicEnergy               Metabolic energy obtained from the simulation
%   - sumOfStopTorques              Sum of stop torques obtained from the simulation
%   - stepVelocities                unused
%   - stepTimes                     Structure with the step time data from simulation.
%   - stepLengths                   Structure with the step length data from simulation
%   - stepNumbers                   Structure with the number of steps taken in simulation
%   - CMGData                      	Structure with the data from the CMG
%   - selfCollision                 Structure with values obtained from self collision algorithm
%   - innerOptSettings              Optimization settings used
%   - b_isParallel                  Optional, is true during optimization
%
% OUTPUTS:
%   - cost                          Cost function value
%   - dataStruct                    Data structure with all kinds of data, used in PLOTPROGRESSOPTIMIZATION, and PRINTOPTINFO
try
    if nargin < 13
        b_isParallel = false;
    end
    
    if contains(model,'CMG')
        modelType = 'amputeeCMG';
    elseif contains(model,'3R60')
         modelType = 'amputee';
    else
         modelType = 'healthy';
    end
    if ~contains(model,'2D')
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
    
    % x pos only to encourage straight walking
    HATPos = HATPosVel.signals.values(end,1);

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
    massCalc = 80; % kg, mass used for the cost of transportation calculation
    effort_costs = struct;
    
    muscle_exp_models = getExpenditureModels(model);
    if isempty(muscle_exp_models)
        error('No expenditure model in getCost');
    end
    for ii = 1:length(muscle_exp_models)
        effort_costs(ii).name = (muscle_exp_models{ii});
        effort_costs(ii).metabolicEnergy = metabolicEnergy(:,ii);
        effort_costs(ii).costOfTransport = (metabolicEnergy(:,ii))/(HATPos*massCalc);
    end
    
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
    % Check if sufficient steps are made
    if max(stepNumbers.signals.values(:,1)) < innerOptSettings.initiation_steps && max(stepNumbers.signals.values(:,1)) < innerOptSettings.initiation_steps
        velCost = 9999999*( innerOptSettings.initiation_steps/min([max(stepNumbers.signals.values(:,1)),max(stepNumbers.signals.values(:,2))]) );
        fprintf('-- Insufficient steps -- \n')
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
    
    %% Get data from CMG
    try
        maxCMGTorque = max(CMGData.signals.values(:,6));
        maxCMGdeltaH = max(CMGData.signals.values(:,13));
        controlRMSE = sqrt(sum((CMGData.signals.values(:,2)-CMGData.signals.values(:,3)).^2)); %/length(CMGData.signals.values(:,2))
        tripWasActive = max(CMGData.signals.values(:,14));

    catch 
        maxCMGTorque = 0;
        maxCMGdeltaH = 0;
        controlRMSE = 0;
        tripWasActive = 0;
    end
    
    %%
    numberOfCollisions = sum(findpeaks(selfCollision.signals.values(:,end)));
    
    %%
    timeFactor  = innerOptSettings.timeFactor;
    velFactor   = innerOptSettings.velocityFactor;
    CoTFactor   = innerOptSettings.CoTFactor;
    stopTFactor = innerOptSettings.sumStopTorqueFactor;
    CMGdeltaHFactor = innerOptSettings.CMGdeltaHFactor;
    selfCollisionFactor = innerOptSettings.selfCollisionFactor;
    
    cost = timeFactor*timeCost  + velFactor*(velCost) + CoTFactor*costOfTransportForOpt ...
                                + stopTFactor*sumOfStopTorques + CMGdeltaHFactor*maxCMGdeltaH ...
                                + selfCollisionFactor*numberOfCollisions;

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

    % Save some data as .mat file when simulation reached end during optimization
    if b_isParallel && timeCost == 0
        GainsSave = Gains;
        if size(GainsSave,1)>size(GainsSave,2)
            GainsSave = GainsSave';
        end
        try
            workerID = getCurrentWorker().ProcessId;
        catch ME
            workerID = [];
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
   
    
catch ME
    save('ErrorWorkspace');
    error('Error: %s\nIn %s.m line %d',ME.message,ME.stack(1).name,ME.stack(1).line);
end