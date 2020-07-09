function costs = cmaesParallelSplit(gainsPop)
    global rtp InitialGuess 
    %% Data plotting during optimization
%     global dataQueueD
    dataQueueD = parallel.pool.DataQueue;
    dataQueueD.afterEach(@plotProgressOptimization);

    %% allocate costs vector and paramsets the generation
    popSize = size(gainsPop,2);
    costs = nan(1,popSize);
    paramSets = cell(popSize,1);

    %create param sets
    for i = 1:popSize
        Gains = InitialGuess.*exp(gainsPop(:,i));
        paramSets{i} = Simulink.BlockDiagram.modifyTunableParameters(rtp, ...
            'GainFGLUst',               Gains( 1), ...
            'GainFVASst',               Gains( 2), ...
            'GainFSOLst',               Gains( 3), ...
            'GainFHAMst',               Gains( 4), ...
            'LceOffsetBFSHVASst',       Gains( 5), ...
            'GainLBFSHVASst',           Gains( 6), ...
            'LceOffsetBFSHst',          Gains( 7), ...
            'GainLBFSHst',              Gains( 8), ...
            'GainFGASst',               Gains( 9), ...
            'GainPhiHATHFLst',          Gains(10), ...
            'GainDphiHATHFLst',         Gains(11), ...
            'GainPhiHATGLUst',          Gains(12), ...
            'GainDphiHATGLUst',         Gains(13), ...
            'GainSGLUHAMst',            Gains(14), ...
            'GainSGLUcHFLst',           Gains(15), ...
            'GainSHAMcHFLst',           Gains(16), ...
            'GainSHFLcGLUst',           Gains(17),...%);
            'GainSRFcGLUst',            Gains(18), ...
            'LceOffsetTAst',            Gains(19), ...
            'GainLTAst',                Gains(20), ...
            'GainFSOLTAst',             Gains(21), ...
            'GainLTAsw',                Gains(22), ...
            'LceOffsetTAsw',            Gains(23), ...
            'GainLRFHFLsw',             Gains(24), ...
            'GainVRFHFLsw',             Gains(25), ...
            'GainLHAMGLUsw',            Gains(26), ...
            'GainVHAMGLUsw',            Gains(27), ...
            'GainVRFBFSHsw',            Gains(28), ...
            'GainVVASRFsw',             Gains(29), ...
            'GainVBFSHsw',              Gains(30), ...
            'GainLHAMsw',               Gains(31),...
            'GainSHAMBFSHsw',           Gains(32), ...
            'GainSHAMGASsw',            Gains(33), ...
            'SHAMthresholdsw',          Gains(34), ...
            'GainLHFLsw',               Gains(35), ...
            'GainLGLUsw',               Gains(36), ...
            'LceOffsetVASsw',           Gains(37), ...
            'GainLVASsw',               Gains(38), ...
            'legLengthClr',             Gains(39), ...
            'simbiconLegAngle0',        Gains(40), ...
            'simbiconGainD',            Gains(41), ...
            'simbiconGainV',            Gains(42), ...
            'phiHATref',                Gains(43), ...
            'deltaLegAngleThr',         Gains(44), ...
            'transSupst',               Gains(45), ...
            'transsw',                  Gains(46), ...
            'PreStimHFLst',             Gains(47), ...
            'PreStimGLUst',             Gains(48), ...
            'PreStimHAMst',             Gains(49), ...
            'PreStimRFst',              Gains(50), ...
            'PreStimVASst',             Gains(51), ...
            'PreStimBFSHst',            Gains(52), ...
            'PreStimGASst',             Gains(53), ...
            'PreStimSOLst',             Gains(54), ...
            'PreStimTAst',              Gains(55), ...
            'PreStimHFLsw',             Gains(56), ...
            'PreStimGLUsw',             Gains(57), ...
            'PreStimHAMsw',             Gains(58), ...
            'PreStimRFsw',              Gains(59), ...
            'PreStimVASsw',             Gains(60), ...
            'PreStimBFSHsw',            Gains(61), ...
            'PreStimGASsw',             Gains(62), ...
            'PreStimSOLsw',             Gains(63), ...
            'PreStimTAsw',              Gains(64));
    end

    %simulate each sample and store cost
    parfor i = 1:popSize
        localGains = InitialGuess.*exp(gainsPop(:,i));
        [costs(i),dataStruct] = evaluateCostParallel(paramSets{i},localGains)
        if ~isempty(fieldnames(dataStruct))
            send(dataQueueD,dataStruct);
        end
    end

%     for i = 1:popSize
%         Gains = InitialGuess.*exp(gainsPop(:,i));
%         paramSets{i} = Simulink.BlockDiagram.modifyTunableParameters(rtp, ...
%             'GainGAS',               Gains( 1), ...
%             'GainGLU',               Gains( 2), ...
%             'GainHAM',               Gains( 3), ...
%             'GainKneeOverExt',       Gains( 4), ...
%             'GainSOL',               Gains( 5), ...
%             'GainSOLTA',             Gains( 6), ...
%             'GainTA',                Gains( 7), ...
%             'GainVAS',               Gains( 8), ...
%             'Kglu',                  Gains( 9), ...
%             'PosGainGG',             Gains(10), ...
%             'SpeedGainGG',           Gains(11), ...
%             'GainHAMHFL',            Gains(12), ...
%             'GainHFL',               Gains(13), ...
%             'Klean',                 Gains(14), ...
%             'Kham',                  Gains(15), ...
%             'Khfl',                  Gains(16), ...
%             'DeltaSGLU',             Gains(17), ...
%             'DeltaSHFL',             Gains(18));
%     end