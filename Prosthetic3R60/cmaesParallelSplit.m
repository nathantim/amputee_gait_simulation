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
            'phiHATref',                 Gains(64), ...
            'RGainFGLUst',               Gains(65), ...
            'RGainFHAMst',               Gains(66), ...
            'RGainPhiHATHFLst',          Gains(67), ...
            'RGainDphiHATHFLst',         Gains(68), ...
            'RGainPhiHATGLUst',          Gains(69), ...
            'RGainDphiHATGLUst',         Gains(70), ...
            'RGainSGLUHAMst',            Gains(71), ...
            'RGainSGLUcHFLst',           Gains(72), ...
            'RGainSHAMcHFLst',           Gains(73), ...
            'RGainSHFLcGLUst',           Gains(74), ...
            'RGainSRFcGLUst',            Gains(75), ...
            'RGainLRFHFLsw',             Gains(76), ...
            'RGainVRFHFLsw',             Gains(77), ...
            'RGainLHAMGLUsw',            Gains(78), ...
            'RGainVHAMGLUsw',            Gains(79), ...
            'RGainLHAMsw',               Gains(80),...
            'RGainLHFLsw',               Gains(81), ...
            'RGainLGLUsw',               Gains(82), ...
            'RlegLengthClr',             Gains(83), ...
            'RsimbiconLegAngle0',        Gains(84), ...
            'RsimbiconGainD',            Gains(85), ...
            'RsimbiconGainV',            Gains(86), ...
            'RdeltaLegAngleThr',         Gains(87), ...
            'RtransSupst',               Gains(88), ...
            'Rtranssw',                  Gains(89), ...
            'RPreStimHFLst',             Gains(90), ...
            'RPreStimGLUst',             Gains(91), ...
            'RPreStimHAMst',             Gains(92), ...
            'RPreStimRFst',              Gains(93), ...
            'RPreStimHFLsw',             Gains(94), ...
            'RPreStimGLUsw',             Gains(95), ...
            'RPreStimHAMsw',             Gains(96), ...
            'RPreStimRFsw',              Gains(97));
    end

    %simulate each sample and store cost
    parfor i = 1:popSize
        localGains = InitialGuess.*exp(gainsPop(:,i));
        [costs(i),dataStruct] = evaluateCostParallel(paramSets{i},localGains)
        if ~isempty(fieldnames(dataStruct))
            send(dataQueueD,dataStruct);
        end
    end

