function costs = cmaesParallelSplitRoughCMG(gainsPop)
global rtp InitialGuess innerOptSettings model
%% Data plotting during optimization
%     global dataQueueD
%     if innerOptSettings.visual
dataQueueD = parallel.pool.DataQueue;
dataQueueD.afterEach(@plotProgressOptimization);
%     end

%allocate costs vector and paramsets the generation
popSize = size(gainsPop,2);

numTerrains = innerOptSettings.numTerrains;
terrain_height = innerOptSettings.terrain_height;
%     rampSlope = 0.0025;
%     [groundX, groundZ, groundTheta] = generateGround('flat');

costs = nan(popSize*numTerrains,1);
paramSets = cell(popSize*numTerrains,1);
%     dataStruct = struct;

%create param sets
gainind = 1;
for ii = 1:numTerrains:(numTerrains*popSize)
    %set gains
    Gains = InitialGuess.*exp(gainsPop(:,gainind));
    %         Gains = InitialGuess.*exp(gainsPop(:,i));
    paramSets{ii} = Simulink.BlockDiagram.modifyTunableParameters(rtp, ...
        'RlegAngleFilter',       Gains( 1), ...
        'RkneeFlexSpeedGain',    Gains( 2), ...
        'RkneeFlexPosGain',      Gains( 3), ...
        'RkneeStopGain',         Gains( 4), ...
        'RkneeExtendGain',       Gains( 5), ...
        'TargetLegAngleTripFlex',Gains( 6), ...
        'RlegLengthClrTrip',     Gains( 7));
    %                     'KpGamma',               Gains( 1), ...
    %             'KiGamma',               Gains( 2), ...
    
    %set ground heights
    for jj = 0:(numTerrains-1)
        if jj == 0
            [~, groundZ, groundTheta] = generateGround('flat',[],4*jj,false);
        else
            [~, groundZ, groundTheta] = generateGround('const', terrain_height, 4*jj,false);
        end
        paramSets{ii+jj} = ...
            Simulink.BlockDiagram.modifyTunableParameters(paramSets{ii}, ...
            'groundZ',     groundZ, ...
            'groundTheta', groundTheta);
        
        in(ii+jj) = Simulink.SimulationInput(model);
        in(ii+jj) = in(ii+jj).setModelParameter('TimeOut', innerOptSettings.timeOut);
        in(ii+jj) = in(ii+jj).setModelParameter('SimulationMode', 'rapid', ...
            'RapidAcceleratorUpToDateCheck', 'off');
        in(ii+jj) = in(ii+jj).setModelParameter('RapidAcceleratorParameterSets', paramSets{ii+jj});
        
    end
    gainind = gainind + 1;
end
rng('shuffle');

%% simulate each sample and store cost
simout = parsim(in, 'ShowProgress', false);

%% Obtain cost and data from simulation
dataStruct(1:length(in)) = struct('modelType',[],'timeCost',struct('data',[],'minimize',1,'info',''),'cost',struct('data',nan,'minimize',1,'info',''),'CoT',struct('data',[],'minimize',1,'info',[]),...
    'E',struct('data',[],'minimize',1,'info',[]),'sumTstop',struct('data',[],'minimize',1,'info',''),...
    'HATPos',struct('data',[],'minimize',0,'info',''),'vMean',struct('data',[],'minimize',0,'info',''),...
    'stepLengthASIstruct',struct('data',[],'minimize',2,'info',''),...
    'stepTimeASIstruct',struct('data',[],'minimize',2,'info',''),'velCost',struct('data',[],'minimize',1,'info',''),'timeVector',struct('data',[],'minimize',1,'info',''),...
    'maxCMGTorque',struct('data',[],'minimize',1,'info',''),'maxCMGdeltaH',struct('data',[],'minimize',1,'info',''),'controlRMSE',struct('data',[],'minimize',1,'info',''),...
    'numberOfCollisions',struct('data',[],'minimize',1,'info',''), ...
    'tripWasActive',struct('data',[],'minimize',1,'info',''),...
    'innerOptSettings',innerOptSettings,'Gains',[],'kinematics',[],'animData3D',[]);

for idx = 1:length(in)
    
    mData=simout(idx).getSimulationMetadata();
    
    if strcmp(mData.ExecutionInfo.StopEvent,'DiagnosticError') 
        disp('Sim was stopped due to error');
        fprintf('Simulation %d was stopped due to error: \n',idx);
        disp(simout(idx).ErrorMessage);
        costs(idx) = nan;
    elseif strcmp(mData.ExecutionInfo.StopEvent,'Timeout')
        fprintf('Simulation %d was stopped due to Timeout: \n',idx);
        costs(idx) = nan;
    else
        time                = simout(idx).time;
        metabolicEnergy     = simout(idx).metabolicEnergy;
        sumOfStopTorques    = simout(idx).sumOfStopTorques;
        HATPosVel           = simout(idx).HATPosVel;
        stepVelocities      = simout(idx).stepVelocities;
        stepTimes           = simout(idx).stepTimes;
        stepLengths         = simout(idx).stepLengths;
        stepNumbers         = simout(idx).stepNumbers;
        angularData         = simout(idx).angularData;
        jointTorquesData    = simout(idx).jointTorquesData;
        GaitPhaseData       = simout(idx).GaitPhaseData;
        musculoData         = simout(idx).musculoData;
        GRFData             = simout(idx).GRFData;
        selfCollision       = simout(idx).selfCollision;
        animData3D          = simout(idx).animData3D;
        
        try
            CMGData          = simout(idx).CMGData;
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
        
        try
            % obtain cost value
            [costs(idx), dataStructlocal] = getCost(model,Gains,time,metabolicEnergy,sumOfStopTorques, ...
                HATPosVel,stepVelocities,stepTimes,stepLengths,...
                stepNumbers, CMGData, selfCollision, innerOptSettings,true);
            dataStructlocal.kinematics = kinematics;
            dataStructlocal.animData3D = animData3D;
        catch ME
            save('error_getCost.mat');
            error('Error not possible to evaluate getCost: %s\nIn %s.m line %d',ME.message,mfilename,ME.stack(1).line);
        end
        
        try
            dataStruct(idx) = dataStructlocal;
            
        catch ME
            warning('Error: %s\nIn %s.m line %d',ME.message, mfilename,ME.stack(1).line);
        end
        if innerOptSettings.visual
            printOptInfo(dataStruct(idx),true);
        end
        
        
    end
    
end


%% calculate mean across terrains
costs = reshape(costs,numTerrains,popSize); % size(costs) = [numTerrrains, popSize]
isinvalid = sum(isnan(costs))>1;
costs = nanmean(costs,1);
costs(isinvalid) = nan;

%% send the best outcome of the best gains for plotting, only flat terrain
try
    mingainidx = find(costs == min(costs));
    if isempty(mingainidx)
        mingainidx = 1;
    end
    %         distfrommean = costsall(:,mingainidx) - costs(mingainidx);
    meanterrainidx = 1;%find(abs(distfrommean) == min(abs(distfrommean)));
    
    idx2send = ((mingainidx-1)*numTerrains) + meanterrainidx;
    %     costall = reshape(costsall,1,popSize*numTerrains);
    if innerOptSettings.visual
        if ~isempty(fieldnames(dataStruct(idx2send)))
            dataStruct(idx2send).optimCost = costs(mingainidx);
            send(dataQueueD,dataStruct(idx2send));
        end
    else
        printOptInfo(dataStruct(idx2send),false);
    end
catch ME
    warning(ME.message);
end
