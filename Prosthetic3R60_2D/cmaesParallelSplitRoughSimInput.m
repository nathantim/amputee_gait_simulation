function costs = cmaesParallelSplitRough(gainsPop)
global rtp InitialGuess inner_opt_settings model
%% Data plotting during optimization
%     global dataQueueD
%     if inner_opt_settings.visual
dataQueueD = parallel.pool.DataQueue;
dataQueueD.afterEach(@plotProgressOptimization);
%     end

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
%     leftSwingSaggital = [model,'/Neural Control Layer/L Swing Phase (sagittal)'];
%     rightSwingSaggital = [model,'/Neural Control Layer/R Swing Phase amp (sagittal)'];
%     leftStanceSaggital = [model,'/Neural Control Layer/L Stance Phase (sagittal)'];
%     rightStanceSaggital = [model,'/Neural Control Layer/R Stance Phase amp (sagittal)'];
%     leftTransSaggital = [model,'/Neural Control Layer/L Stance, Swing, Trans (sagittal)'];
%     leftTransSaggital = [model,'/Neural Control Layer/R Stance, Swing, Trans amp (sagittal)'];


for i = 1:numTerrains:(numTerrains*popSize)
    %set gains
    Gains = InitialGuess.*exp(gainsPop(:,gainind));
    %         Gains = InitialGuess.*exp(gainsPop(:,i));
    in(i) = Simulink.SimulationInput(model);
    %in(i) = in(i).setModelParameter('SimulationMode','accelerator');
    
    in(i) = in(i).setVariable('LGainFGLUst',               Gains( 1),'Workspace',model);
    in(i) = in(i).setVariable('LGainFVASst',               Gains( 2),'Workspace',model);
    in(i) = in(i).setVariable('LGainFSOLst',               Gains( 3),'Workspace',model);
    in(i) = in(i).setVariable('LGainFHAMst',               Gains( 4),'Workspace',model);
    in(i) = in(i).setVariable('LLceOffsetBFSHVASst',       Gains( 5),'Workspace',model);
    in(i) = in(i).setVariable('LGainLBFSHVASst',           Gains( 6),'Workspace',model);
    in(i) = in(i).setVariable('LLceOffsetBFSHst',          Gains( 7),'Workspace',model);
    in(i) = in(i).setVariable('LGainLBFSHst',              Gains( 8),'Workspace',model);
    in(i) = in(i).setVariable('LGainFGASst',               Gains( 9),'Workspace',model);
    in(i) = in(i).setVariable('LGainPhiHATHFLst',          Gains(10),'Workspace',model);
    in(i) = in(i).setVariable('LGainDphiHATHFLst',         Gains(11),'Workspace',model);
    in(i) = in(i).setVariable('LGainPhiHATGLUst',          Gains(12),'Workspace',model);
    in(i) = in(i).setVariable('LGainDphiHATGLUst',         Gains(13),'Workspace',model);
    in(i) = in(i).setVariable('LGainSGLUHAMst',            Gains(14),'Workspace',model);
    in(i) = in(i).setVariable('LGainSGLUcHFLst',           Gains(15),'Workspace',model);
    in(i) = in(i).setVariable('LGainSHAMcHFLst',           Gains(16),'Workspace',model);
    in(i) = in(i).setVariable('LGainSHFLcGLUst',           Gains(17),'Workspace',model);
    in(i) = in(i).setVariable('LGainSRFcGLUst',            Gains(18),'Workspace',model);
    in(i) = in(i).setVariable('LLceOffsetTAst',            Gains(19),'Workspace',model);
    in(i) = in(i).setVariable('LGainLTAst',                Gains(20),'Workspace',model);
    in(i) = in(i).setVariable('LGainFSOLTAst',             Gains(21),'Workspace',model);
    in(i) = in(i).setVariable('LGainLTAsw',                Gains(22),'Workspace',model);
    in(i) = in(i).setVariable('LLceOffsetTAsw',            Gains(23),'Workspace',model);
    in(i) = in(i).setVariable('LGainLRFHFLsw',             Gains(24),'Workspace',model);
    in(i) = in(i).setVariable('LGainVRFHFLsw',             Gains(25),'Workspace',model);
    in(i) = in(i).setVariable('LGainLHAMGLUsw',            Gains(26),'Workspace',model);
    in(i) = in(i).setVariable('LGainVHAMGLUsw',            Gains(27),'Workspace',model);
    in(i) = in(i).setVariable('LGainVRFBFSHsw',            Gains(28),'Workspace',model);
    in(i) = in(i).setVariable('LGainVVASRFsw',             Gains(29),'Workspace',model);
    in(i) = in(i).setVariable('LGainVBFSHsw',              Gains(30),'Workspace',model);
    in(i) = in(i).setVariable('LGainLHAMsw',               Gains(31),'Workspace',model);
    in(i) = in(i).setVariable('LGainSHAMBFSHsw',           Gains(32),'Workspace',model);
    in(i) = in(i).setVariable('LGainSHAMGASsw',            Gains(33),'Workspace',model);
    in(i) = in(i).setVariable('LSHAMthresholdsw',          Gains(34),'Workspace',model);
    in(i) = in(i).setVariable('LGainLHFLsw',               Gains(35),'Workspace',model);
    in(i) = in(i).setVariable('LGainLGLUsw',               Gains(36),'Workspace',model);
    in(i) = in(i).setVariable('LLceOffsetVASsw',           Gains(37),'Workspace',model);
    in(i) = in(i).setVariable('LGainLVASsw',               Gains(38),'Workspace',model);
    in(i) = in(i).setVariable('LlegLengthClr',             Gains(39),'Workspace',model);
    in(i) = in(i).setVariable('LsimbiconLegAngle0',        Gains(40),'Workspace',model);
    in(i) = in(i).setVariable('LsimbiconGainD',            Gains(41),'Workspace',model);
    in(i) = in(i).setVariable('LsimbiconGainV',            Gains(42),'Workspace',model);
    in(i) = in(i).setVariable('LdeltaLegAngleThr',         Gains(43),'Workspace',model);
    in(i) = in(i).setVariable('LtransSupst',               Gains(44),'Workspace',model);
    in(i) = in(i).setVariable('Ltranssw',                  Gains(45),'Workspace',model);
    in(i) = in(i).setVariable('LPreStimHFLst',             Gains(46),'Workspace',model);
    in(i) = in(i).setVariable('LPreStimGLUst',             Gains(47),'Workspace',model);
    in(i) = in(i).setVariable('LPreStimHAMst',             Gains(48),'Workspace',model);
    in(i) = in(i).setVariable('LPreStimRFst',              Gains(49),'Workspace',model);
    in(i) = in(i).setVariable('LPreStimVASst',             Gains(50),'Workspace',model);
    in(i) = in(i).setVariable('LPreStimBFSHst',            Gains(51),'Workspace',model);
    in(i) = in(i).setVariable('LPreStimGASst',             Gains(52),'Workspace',model);
    in(i) = in(i).setVariable('LPreStimSOLst',             Gains(53),'Workspace',model);
    in(i) = in(i).setVariable('LPreStimTAst',              Gains(54),'Workspace',model);
    in(i) = in(i).setVariable('LPreStimHFLsw',             Gains(55),'Workspace',model);
    in(i) = in(i).setVariable('LPreStimGLUsw',             Gains(56),'Workspace',model);
    in(i) = in(i).setVariable('LPreStimHAMsw',             Gains(57),'Workspace',model);
    in(i) = in(i).setVariable('LPreStimRFsw',              Gains(58),'Workspace',model);
    in(i) = in(i).setVariable('LPreStimVASsw',             Gains(59),'Workspace',model);
    in(i) = in(i).setVariable('LPreStimBFSHsw',            Gains(60),'Workspace',model);
    in(i) = in(i).setVariable('LPreStimGASsw',             Gains(61),'Workspace',model);
    in(i) = in(i).setVariable('LPreStimSOLsw',             Gains(62),'Workspace',model);
    in(i) = in(i).setVariable('LPreStimTAsw',              Gains(63),'Workspace',model);
    in(i) = in(i).setVariable('phiHATref',                 Gains(64),'Workspace',model);
    in(i) = in(i).setVariable('RGainFGLUst',               Gains(65),'Workspace',model);
    in(i) = in(i).setVariable('RGainFHAMst',               Gains(66),'Workspace',model);
    in(i) = in(i).setVariable('RGainPhiHATHFLst',          Gains(67),'Workspace',model);
    in(i) = in(i).setVariable('RGainDphiHATHFLst',         Gains(68),'Workspace',model);
    in(i) = in(i).setVariable('RGainPhiHATGLUst',          Gains(69),'Workspace',model);
    in(i) = in(i).setVariable('RGainDphiHATGLUst',         Gains(70),'Workspace',model);
    in(i) = in(i).setVariable('RGainSGLUHAMst',            Gains(71),'Workspace',model);
    in(i) = in(i).setVariable('RGainSGLUcHFLst',           Gains(72),'Workspace',model);
    in(i) = in(i).setVariable('RGainSHAMcHFLst',           Gains(73),'Workspace',model);
    in(i) = in(i).setVariable('RGainSHFLcGLUst',           Gains(74),'Workspace',model);
    in(i) = in(i).setVariable('RGainSRFcGLUst',            Gains(75),'Workspace',model);
    in(i) = in(i).setVariable('RGainLRFHFLsw',             Gains(76),'Workspace',model);
    in(i) = in(i).setVariable('RGainVRFHFLsw',             Gains(77),'Workspace',model);
    in(i) = in(i).setVariable('RGainLHAMGLUsw',            Gains(78),'Workspace',model);
    in(i) = in(i).setVariable('RGainVHAMGLUsw',            Gains(79),'Workspace',model);
    in(i) = in(i).setVariable('RGainLHAMsw',               Gains(80),'Workspace',model);
    in(i) = in(i).setVariable('RGainLHFLsw',               Gains(81),'Workspace',model);
    in(i) = in(i).setVariable('RGainLGLUsw',               Gains(82),'Workspace',model);
    in(i) = in(i).setVariable('RlegLengthClr',             Gains(83),'Workspace',model);
    in(i) = in(i).setVariable('RsimbiconLegAngle0',        Gains(84),'Workspace',model);
    in(i) = in(i).setVariable('RsimbiconGainD',            Gains(85),'Workspace',model);
    in(i) = in(i).setVariable('RsimbiconGainV',            Gains(86),'Workspace',model);
    in(i) = in(i).setVariable('RdeltaLegAngleThr',         Gains(87),'Workspace',model);
    in(i) = in(i).setVariable('RtransSupst',               Gains(88),'Workspace',model);
    in(i) = in(i).setVariable('Rtranssw',                  Gains(89),'Workspace',model);
    in(i) = in(i).setVariable('RPreStimHFLst',             Gains(90),'Workspace',model);
    in(i) = in(i).setVariable('RPreStimGLUst',             Gains(91),'Workspace',model);
    in(i) = in(i).setVariable('RPreStimHAMst',             Gains(92),'Workspace',model);
    in(i) = in(i).setVariable('RPreStimRFst',              Gains(93),'Workspace',model);
    in(i) = in(i).setVariable('RPreStimHFLsw',             Gains(94),'Workspace',model);
    in(i) = in(i).setVariable('RPreStimGLUsw',             Gains(95),'Workspace',model);
    in(i) = in(i).setVariable('RPreStimHAMsw',             Gains(96),'Workspace',model);
    in(i) = in(i).setVariable('RPreStimRFsw',              Gains(97),'Workspace',model);
    
    prepend = 'NeuromuscularModel_3R60_2D/Neural Control Layer/';
    %in(i) = in(i).setBlockParameter(    [prepend,'SDelay20'],'InitialOutput', char(string(Gains(46))), ... %LPreStimHFLst
    %                                    [prepend,'SDelay21'],'InitialOutput', char(string(Gains(47))), ... %LPreStimGLUst
    %                                    [prepend,'SDelay22'],'InitialOutput', char(string(Gains(48))), ... %LPreStimHAMst
    %                                    [prepend,'SDelay23'],'InitialOutput', char(string(Gains(49))), ... %LPreStimRFst
    %                                    [prepend,'MDelay9'] ,'InitialOutput', char(string(Gains(50))), ... %LPreStimVASst
    %                                    [prepend,'MDelay10'],'InitialOutput', char(string(Gains(51))), ... %LPreStimBFSHst
    %                                    [prepend,'LDelay11'],'InitialOutput', char(string(Gains(52))), ... %LPreStimGASst
    %                                    [prepend,'LDelay9'] ,'InitialOutput', char(string(Gains(53))), ... %LPreStimSOLst
    %                                    [prepend,'LDelay10'],'InitialOutput', char(string(Gains(54))), ... %LPreStimTAst
    %                                    [prepend,'SDelay24'],'InitialOutput', char(string(Gains(94))), ... %RPreStimHFLsw
    %                                    [prepend,'SDelay25'],'InitialOutput', char(string(Gains(95))), ... %RPreStimGLUsw
    %                                    [prepend,'SDelay26'],'InitialOutput', char(string(Gains(96))), ... %RPreStimHAMsw
    %                                    [prepend,'SDelay27'],'InitialOutput', char(string(Gains(97)))); ... %RPreStimRFsw
    
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
out = parsim(in, 'ShowProgress', true,'TimeOut',2*60,'TransferBaseWorkspaceVariables',true,'UseFastRestart',true);

% 	mData=out(1).getSimulationMetadata();
% 	try
% 		disp(mData.ExecutionInfo);
% 	catch
% 	end
% 	try
% 		disp(mData.ExecutionInfo.StopEvent);
% 		disp(mData.ExecutionInfo.ErrorDiagnostic);
% 	catch
%     end

%                 elseif strcmp(mData.ExecutionInfo.StopEvent,'TimeOut')
%                 disp('Sim was stopped due to time out');
%             elseif strcmp(mData.ExecutionInfo.StopEvent,'ReachedStopTime')
%                 disp('Sim was stopped due to reaching stop time');
%             elseif strcmp(mData.ExecutionInfo.StopEvent,'ModelStop')
%                 disp('Sim was stopped due to model stop');

dataStruct(length(in)) = struct();

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