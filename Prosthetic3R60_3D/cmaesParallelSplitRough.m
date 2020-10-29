function costs = cmaesParallelSplitRough(gainsPop)
global rtp InitialGuess innerOptSettings model
%% Data plotting during optimization
%     global dataQueueD
if innerOptSettings.visual
    dataQueueD = parallel.pool.DataQueue;
    dataQueueD.afterEach(@plotProgressOptimization);
end

%allocate costs vector and paramsets the generation
popSize = size(gainsPop,2);

numTerrains = innerOptSettings.numTerrains;
terrain_height = innerOptSettings.terrain_height;
%     rampSlope = 0.0025;
%     [groundX, groundZ, groundTheta] = generateGround('flat');

costs = nan(popSize*numTerrains,1);
paramSets = cell(popSize*numTerrains,1);

%create param sets
gainind = 1;
for ii = 1:numTerrains:(numTerrains*popSize)
    %set gains
    Gains = InitialGuess.*exp(gainsPop(:,gainind));
    paramSets{ii} = Simulink.BlockDiagram.modifyTunableParameters(rtp, ...
        'LGainFGLUst',               Gains( 1), ...
        'LGainFVASst',               Gains( 2), ...
        'LGainFSOLst',               Gains( 3), ...
        'LGainFHAMst',               Gains( 4), ...
        'LLceOffsetBFSHVASst',       Gains( 5), ...
        'LGainLBFSHVASst',           Gains( 6), ...
        'LLceOffsetBFSHst',          Gains( 7), ...
        'LGainLBFSHst',              Gains( 8), ...
        'LGainFGASst',               Gains( 9), ...
        'LGainPhiHATHFLst',          Gains(10), ...
        'LGainDphiHATHFLst',         Gains(11), ...
        'LGainPhiHATGLUst',          Gains(12), ...
        'LGainDphiHATGLUst',         Gains(13), ...
        'LGainSGLUHAMst',            Gains(14), ...
        'LGainSGLUcHFLst',           Gains(15), ...
        'LGainSHAMcHFLst',           Gains(16), ...
        'LGainSHFLcGLUst',           Gains(17),...
        'LGainSRFcGLUst',            Gains(18), ...
        'LLceOffsetTAst',            Gains(19), ...
        'LGainLTAst',                Gains(20), ...
        'LGainFSOLTAst',             Gains(21), ...
        'LGainLTAsw',                Gains(22), ...
        'LLceOffsetTAsw',            Gains(23), ...
        'LGainLRFHFLsw',             Gains(24), ...
        'LGainVRFHFLsw',             Gains(25), ...
        'LGainLHAMGLUsw',            Gains(26), ...
        'LGainVHAMGLUsw',            Gains(27), ...
        'LGainVRFBFSHsw',            Gains(28), ...
        'LGainVVASRFsw',             Gains(29), ...
        'LGainVBFSHsw',              Gains(30), ...
        'LGainLHAMsw',               Gains(31),...
        'LGainSHAMBFSHsw',           Gains(32), ...
        'LGainSHAMGASsw',            Gains(33), ...
        'LSHAMthresholdsw',          Gains(34), ...
        'LGainLHFLsw',               Gains(35), ...
        'LGainLGLUsw',               Gains(36), ...
        'LLceOffsetVASsw',           Gains(37), ...
        'LGainLVASsw',               Gains(38), ...
        'LlegLengthClr',             Gains(39), ...
        'LsimbiconLegAngle0',        Gains(40), ...
        'LsimbiconGainD',            Gains(41), ...
        'LsimbiconGainV',            Gains(42), ...
        'LdeltaLegAngleThr',         Gains(43), ...
        'LtransSupst',               Gains(44), ...
        'Ltranssw',                  Gains(45), ...
        'LPreStimHFLst',             Gains(46), ...
        'LPreStimGLUst',             Gains(47), ...
        'LPreStimHAMst',             Gains(48), ...
        'LPreStimRFst',              Gains(49), ...
        'LPreStimVASst',             Gains(50), ...
        'LPreStimBFSHst',            Gains(51), ...
        'LPreStimGASst',             Gains(52), ...
        'LPreStimSOLst',             Gains(53), ...
        'LPreStimTAst',              Gains(54), ...
        'LPreStimHFLsw',             Gains(55), ...
        'LPreStimGLUsw',             Gains(56), ...
        'LPreStimHAMsw',             Gains(57), ...
        'LPreStimRFsw',              Gains(58), ...
        'LPreStimVASsw',             Gains(59), ...
        'LPreStimBFSHsw',            Gains(60), ...
        'LPreStimGASsw',             Gains(61), ...
        'LPreStimSOLsw',             Gains(62), ...
        'LPreStimTAsw',              Gains(63), ...
        'RGainFGLUst',               Gains(64), ...
        'RGainFHAMst',               Gains(65), ...
        'RGainPhiHATHFLst',          Gains(66), ...
        'RGainDphiHATHFLst',         Gains(67), ...
        'RGainPhiHATGLUst',          Gains(68), ...
        'RGainDphiHATGLUst',         Gains(69), ...
        'RGainSGLUHAMst',            Gains(70), ...
        'RGainSGLUcHFLst',           Gains(71), ...
        'RGainSHAMcHFLst',           Gains(72), ...
        'RGainSHFLcGLUst',           Gains(73), ...
        'RGainSRFcGLUst',            Gains(74), ...
        'RGainLRFHFLsw',             Gains(75), ...
        'RGainVRFHFLsw',             Gains(76), ...
        'RGainLHAMGLUsw',            Gains(77), ...
        'RGainVHAMGLUsw',            Gains(78), ...
        'RGainLHAMsw',               Gains(79),...
        'RGainLHFLsw',               Gains(80), ...
        'RGainLGLUsw',               Gains(81), ...
        'RlegLengthClr',             Gains(82), ...
        'RsimbiconLegAngle0',        Gains(83), ...
        'RsimbiconGainD',            Gains(84), ...
        'RsimbiconGainV',            Gains(85), ...
        'RdeltaLegAngleThr',         Gains(86), ...
        'RtransSupst',               Gains(87), ...
        'Rtranssw',                  Gains(88), ...
        'RPreStimHFLst',             Gains(89), ...
        'RPreStimGLUst',             Gains(90), ...
        'RPreStimHAMst',             Gains(91), ...
        'RPreStimRFst',              Gains(92), ...
        'RPreStimHFLsw',             Gains(93), ...
        'RPreStimGLUsw',             Gains(94), ...
        'RPreStimHAMsw',             Gains(95), ...
        'RPreStimRFsw',              Gains(96), ...
        'phiHATref',                 Gains(97), ...
        'vxInit',                    Gains(98), ...
        'LphiHip0',                  Gains(99), ...
        'LphiKnee0',                 Gains(100), ...
        'LphiAnkle0',                Gains(101), ...
        'RphiHip0',                  Gains(102), ...
        'LTargetAngleInit',          Gains(103), ...
        'LPreStimHFLinit',           Gains(104), ...
        'LPreStimGLUinit',           Gains(105), ...
        'LPreStimHAMinit',           Gains(106), ...
        'LPreStimRFinit',            Gains(107), ...
        'LPreStimVASinit',           Gains(108), ...
        'LPreStimBFSHinit',          Gains(109), ...
        'LPreStimGASinit',           Gains(110), ...
        'LPreStimSOLinit',           Gains(111), ...
        'LPreStimTAinit',            Gains(112), ...
        'RTargetAngleInit',          Gains(113), ...
        'RPreStimHFLinit',           Gains(114), ...
        'RPreStimGLUinit',           Gains(115), ...
        'RPreStimHAMinit',           Gains(116), ...
        'RPreStimRFinit',            Gains(117), ...
        'LGainFHABst',               Gains(118), ...
        'LGainPhiHATHABst',          Gains(119), ...
        'LGainDphiHATHABst',         Gains(120), ...
        'LGainPhiHATHADst',          Gains(121), ...
        'LGainDphiHATHADst',         Gains(122), ...
        'LGainSHABcHABst',           Gains(123), ...
        'LGainSHADcHADst',           Gains(124), ...
        'LGainLHABsw',               Gains(125), ...
        'LGainLHADsw',               Gains(126), ...
        'LsimbiconLegAngle0_C',      Gains(127), ...
        'LsimbiconGainD_C',          Gains(128), ...
        'LsimbiconGainV_C',          Gains(129), ...
        'LheadingGain',              Gains(130), ...
        'LheadingIntGain',              Gains(131), ...
        'LtransSupst_C',             Gains(132), ...
        'Ltranssw_C',                Gains(133), ...
        'LPreStimHABst',             Gains(134), ...
        'LPreStimHADst',             Gains(135), ...
        'LPreStimHABsw',             Gains(136), ...
        'LPreStimHADsw',             Gains(137), ...
        'RGainFHABst',               Gains(138), ...
        'RGainPhiHATHABst',          Gains(139), ...
        'RGainDphiHATHABst',         Gains(140), ...
        'RGainPhiHATHADst',          Gains(141), ...
        'RGainDphiHATHADst',         Gains(142), ...
        'RGainSHABcHABst',           Gains(143), ...
        'RGainSHADcHADst',           Gains(144), ...
        'RGainLHABsw',               Gains(145), ...
        'RGainLHADsw',               Gains(146), ...
        'RsimbiconLegAngle0_C',      Gains(147), ...
        'RsimbiconGainD_C',          Gains(148), ...
        'RsimbiconGainV_C',          Gains(149), ...
        'RheadingGain',              Gains(150), ...
        'RheadingIntGain',              Gains(151), ...
        'RtransSupst_C',             Gains(152), ...
        'Rtranssw_C',                Gains(153), ...
        'RPreStimHABst',             Gains(154), ...
        'RPreStimHADst',             Gains(155), ...
        'RPreStimHABsw',             Gains(156), ...
        'RPreStimHADsw',             Gains(157), ...
        'vyInit',                    Gains(158), ...
        'rollInit',                  Gains(159), ...
        'LphiHipR0',                 Gains(160), ...
        'RphiHipR0',                 Gains(161), ...
        'LTargetAngleRInit',         Gains(162), ...
        'LPreStimHABinit',           Gains(163), ...
        'LPreStimHADinit',           Gains(164), ...
        'RTargetAngleRInit',         Gains(165), ...
        'RPreStimHABinit',           Gains(166), ...
        'RPreStimHADinit',           Gains(167));
    
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

%simulate each sample and store cost
simout = parsim(in, 'ShowProgress', true);



for idx = 1:length(in)
    
    mData=out(idx).getSimulationMetadata();
    
    if strcmp(mData.ExecutionInfo.StopEvent,'DiagnosticError') || strcmp(mData.ExecutionInfo.StopEvent,'TimeOut')
        disp('Sim was stopped due to error');
        fprintf('Simulation %d was stopped due to error: \n',idx);
        disp(out(idx).ErrorMessage);
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
            warning('Error: %s\nIn %s.m line %d',ME.message,mfilename,ME.stack(1).line);
        end
        
        if inner_opt_settings.visual
            printOptInfo(dataStruct(idx),true);
        end
        
    end
    
end


%calculate mean across terrains
costs = reshape(costs,numTerrains,popSize); % size(costs) = [numTerrrains, popSize]
isinvalid = sum(isnan(costs))>1;
costs = nanmean(costs,1);
costs(isinvalid) = nan;

%% send the best outcome of the best gains for plotting, only flat terrain
try
    mingainidx = find(costs == min(costs));
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
