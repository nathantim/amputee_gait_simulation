function costs = cmaesParallelSplitRoughSimInput(gainsPop)
global InitialGuess inner_opt_settings model %rtp
%% Data plotting during optimization
%     global dataQueueD
if inner_opt_settings.visual
    dataQueueD = parallel.pool.DataQueue;
    dataQueueD.afterEach(@plotProgressOptimization);
end

%allocate costs vector and paramsets the generation
popSize = size(gainsPop,2);

numTerrains = inner_opt_settings.numTerrains;
terrain_height = inner_opt_settings.terrain_height;
%     rampSlope = 0.0025;
%     [groundX, groundZ, groundTheta] = generateGround('flat');

costs = nan(popSize*numTerrains,1);
%     paramSets = cell(popSize*numTerrains,1);
%     dataStruct = struct;

%create param sets
gainind = 1;
for i = 1:numTerrains:(numTerrains*popSize)
    %set gains
    Gains = InitialGuess.*exp(gainsPop(:,gainind));
    %         Gains = InitialGuess.*exp(gainsPop(:,i));
    in(i) = Simulink.SimulationInput(model);
    in(i) = in(i).setModelParameter('TimeOut', 2*60);
    
    in(i) = in(i).setVariable('GainFGLUst',               Gains( 1),'Workspace',model);
    in(i) = in(i).setVariable('GainFVASst',               Gains( 2),'Workspace',model);
    in(i) = in(i).setVariable('GainFSOLst',               Gains( 3),'Workspace',model);
    in(i) = in(i).setVariable('GainFHAMst',               Gains( 4),'Workspace',model);
    in(i) = in(i).setVariable('LceOffsetBFSHVASst',       Gains( 5),'Workspace',model);
    in(i) = in(i).setVariable('GainLBFSHVASst',           Gains( 6),'Workspace',model);
    in(i) = in(i).setVariable('LceOffsetBFSHst',          Gains( 7),'Workspace',model);
    in(i) = in(i).setVariable('GainLBFSHst',              Gains( 8),'Workspace',model);
    in(i) = in(i).setVariable('GainFGASst',               Gains( 9),'Workspace',model);
    in(i) = in(i).setVariable('GainPhiHATHFLst',          Gains(10),'Workspace',model);
    in(i) = in(i).setVariable('GainDphiHATHFLst',         Gains(11),'Workspace',model);
    in(i) = in(i).setVariable('GainPhiHATGLUst',          Gains(12),'Workspace',model);
    in(i) = in(i).setVariable('GainDphiHATGLUst',         Gains(13),'Workspace',model);
    in(i) = in(i).setVariable('GainSGLUHAMst',            Gains(14),'Workspace',model);
    in(i) = in(i).setVariable('GainSGLUcHFLst',           Gains(15),'Workspace',model);
    in(i) = in(i).setVariable('GainSHAMcHFLst',           Gains(16),'Workspace',model);
    in(i) = in(i).setVariable('GainSHFLcGLUst',           Gains(17),'Workspace',model);
    in(i) = in(i).setVariable('GainSRFcGLUst',            Gains(18),'Workspace',model);
    in(i) = in(i).setVariable('LceOffsetTAst',            Gains(19),'Workspace',model);
    in(i) = in(i).setVariable('GainLTAst',                Gains(20),'Workspace',model);
    in(i) = in(i).setVariable('GainFSOLTAst',             Gains(21),'Workspace',model);
    in(i) = in(i).setVariable('GainLTAsw',                Gains(22),'Workspace',model);
    in(i) = in(i).setVariable('LceOffsetTAsw',            Gains(23),'Workspace',model);
    in(i) = in(i).setVariable('GainLRFHFLsw',             Gains(24),'Workspace',model);
    in(i) = in(i).setVariable('GainVRFHFLsw',             Gains(25),'Workspace',model);
    in(i) = in(i).setVariable('GainLHAMGLUsw',            Gains(26),'Workspace',model);
    in(i) = in(i).setVariable('GainVHAMGLUsw',            Gains(27),'Workspace',model);
    in(i) = in(i).setVariable('GainVRFBFSHsw',            Gains(28),'Workspace',model);
    in(i) = in(i).setVariable('GainVVASRFsw',             Gains(29),'Workspace',model);
    in(i) = in(i).setVariable('GainVBFSHsw',              Gains(30),'Workspace',model);
    in(i) = in(i).setVariable('GainLHAMsw',               Gains(31),'Workspace',model);
    in(i) = in(i).setVariable('GainSHAMBFSHsw',           Gains(32),'Workspace',model);
    in(i) = in(i).setVariable('GainSHAMGASsw',            Gains(33),'Workspace',model);
    in(i) = in(i).setVariable('SHAMthresholdsw',          Gains(34),'Workspace',model);
    in(i) = in(i).setVariable('GainLHFLsw',               Gains(35),'Workspace',model);
    in(i) = in(i).setVariable('GainLGLUsw',               Gains(36),'Workspace',model);
    in(i) = in(i).setVariable('LceOffsetVASsw',           Gains(37),'Workspace',model);
    in(i) = in(i).setVariable('GainLVASsw',               Gains(38),'Workspace',model);
    in(i) = in(i).setVariable('legLengthClr',             Gains(39),'Workspace',model);
    in(i) = in(i).setVariable('simbiconLegAngle0',        Gains(40),'Workspace',model);
    in(i) = in(i).setVariable('simbiconGainD',            Gains(41),'Workspace',model);
    in(i) = in(i).setVariable('simbiconGainV',            Gains(42),'Workspace',model);
    in(i) = in(i).setVariable('phiHATref',                Gains(43),'Workspace',model);
    in(i) = in(i).setVariable('deltaLegAngleThr',         Gains(44),'Workspace',model);
    in(i) = in(i).setVariable('transSupst',               Gains(45),'Workspace',model);
    in(i) = in(i).setVariable('transsw',                  Gains(46),'Workspace',model);
    in(i) = in(i).setVariable('PreStimHFLst',             Gains(47),'Workspace',model);
    in(i) = in(i).setVariable('PreStimGLUst',             Gains(48),'Workspace',model);
    in(i) = in(i).setVariable('PreStimHAMst',             Gains(49),'Workspace',model);
    in(i) = in(i).setVariable('PreStimRFst',              Gains(50),'Workspace',model);
    in(i) = in(i).setVariable('PreStimVASst',             Gains(51),'Workspace',model);
    in(i) = in(i).setVariable('PreStimBFSHst',            Gains(52),'Workspace',model);
    in(i) = in(i).setVariable('PreStimGASst',             Gains(53),'Workspace',model);
    in(i) = in(i).setVariable('PreStimSOLst',             Gains(54),'Workspace',model);
    in(i) = in(i).setVariable('PreStimTAst',              Gains(55),'Workspace',model);
    in(i) = in(i).setVariable('PreStimHFLsw',             Gains(56),'Workspace',model);
    in(i) = in(i).setVariable('PreStimGLUsw',             Gains(57),'Workspace',model);
    in(i) = in(i).setVariable('PreStimHAMsw',             Gains(58),'Workspace',model);
    in(i) = in(i).setVariable('PreStimRFsw',              Gains(59),'Workspace',model);
    in(i) = in(i).setVariable('PreStimVASsw',             Gains(60),'Workspace',model);
    in(i) = in(i).setVariable('PreStimBFSHsw',            Gains(61),'Workspace',model);
    in(i) = in(i).setVariable('PreStimGASsw',             Gains(62),'Workspace',model);
    in(i) = in(i).setVariable('PreStimSOLsw',             Gains(63),'Workspace',model);
    in(i) = in(i).setVariable('PreStimTAsw',              Gains(64),'Workspace',model);
    
    %set ground heights
    for j = 0:(numTerrains-1)
        if j == 0
            [~, groundZ, groundTheta] = generateGround('flat',[],4*j,false);
        else
            [~, groundZ, groundTheta] = generateGround('const', terrain_height, 4*j,false);
        end
        in(i+j) = in(i);
        in(i+j) = in(i+j).setVariable('groundZ',groundZ);
        in(i+j) = in(i+j).setVariable('groundTheta',groundTheta);
        
    end
    gainind = gainind + 1;
end
rng('shuffle');

%simulate each sample and store cost
% dataStruct(length(in)) = struct();

for i = 1:length(in)
    
    mData=out(i).getSimulationMetadata();
    
    if strcmp(mData.ExecutionInfo.StopEvent,'DiagnosticError') || strcmp(mData.ExecutionInfo.StopEvent,'TimeOut')
        disp('Sim was stopped due to error');
        fprintf('Simulation %d was stopped due to error: \n',i);
        disp(out(i).ErrorMessage);
        costs(i) = nan;
    else
        time                = out(i).time;
        metabolicEnergy     = out(i).metabolicEnergy;
        sumOfStopTorques    = out(i).sumOfStopTorques;
        HATPos              = out(i).HATPos;
        stepVelocities      = out(i).stepVelocities;
        stepTimes           = out(i).stepTimes;
        stepLengths         = out(i).stepLengths;
        angularData         = out(i).angularData;
        GaitPhaseData       = out(i).GaitPhaseData;
        musculoData         = out(i).musculoData;
        GRFData             = out(i).GRFData;
        
        kinematics.angularData      = angularData;
        kinematics.GaitPhaseData    = GaitPhaseData;
        kinematics.time             = time;
        kinematics.stepTimes        = stepTimes;
        kinematics.musculoData      = musculoData;
        kinematics.GRFData          = GRFData;
        
        try
            % obtain cost value
            [costs(i), dataStructlocal] = getCost(model,Gains,time,metabolicEnergy,sumOfStopTorques, ...
                HATPos,stepVelocities,stepTimes,stepLengths,...
                inner_opt_settings,true);
            dataStructlocal.kinematics = kinematics;
        catch ME
            save('error_getCost.mat');
            error('Error not possible to evaluate getCost: %s\nIn %s.m line %d',ME.message,mfilename,ME.stack(1).line);
        end
        
        try
            dataStruct(i) = dataStructlocal;
        catch ME
            warning('Error: %s\nIn %s.m line %d',ME.message,mfilename,ME.stack(1).line);
        end
        
        if inner_opt_settings.visual
            printOptInfo(dataStruct(i),false);
        end
        
    end
    
end

%calculate mean across terrains
costs = reshape(costs,numTerrains,popSize); % size(costs) = [numTerrrains, popSize]
isinvalid = sum(isnan(costs))>1;
costs = nanmean(costs);
costs(isinvalid) = nan;

%% send the best outcome of the best gains for plotting, only flat terrain
try
    mingainidx = find(costs == min(costs));
    %         distfrommean = costsall(:,mingainidx) - costs(mingainidx);
    meanterrainidx = 1;%find(abs(distfrommean) == min(abs(distfrommean)));
    
    idx2send = ((mingainidx-1)*numTerrains) + meanterrainidx;
    %     costall = reshape(costsall,1,popSize*numTerrains);
    if inner_opt_settings.visual
        if ~isempty(fieldnames(dataStruct(idx2send)))
            send(dataQueueD,dataStruct(idx2send));
        end
    else
        printOptInfo(dataStruct(idx2send),false);
    end
catch ME
    warning(ME.message);
end
