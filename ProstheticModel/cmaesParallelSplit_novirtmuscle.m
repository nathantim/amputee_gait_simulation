function costs = cmaesParallelSplit_novirtmuscle(gainsPop)
    global rtp InitialGuess
    %allocate costs vector and paramsets the generation
    popSize = size(gainsPop,2);
    costs = nan(1,popSize);
    paramSets = cell(popSize,1);

    %create param sets
    for i = 1:popSize
        Gains = InitialGuess.*exp(gainsPop(:,i));

        paramSets{i} = Simulink.BlockDiagram.modifyTunableParameters(rtp, ...
            'LGainGAS',           Gains( 1), ...
            'LGainGLU',           Gains( 2), ...
            'LGainHAM',           Gains( 3), ...
            'LGainKneeOverExt',   Gains( 4), ...
            'LGainSOL',           Gains( 5), ...
            'LGainSOLTA',         Gains( 6), ...
            'LGainTA',            Gains( 7), ...
            'LGainVAS',           Gains( 8), ...
            'LKglu',              Gains( 9), ...
            'LPosGainGG',         Gains(10), ...
            'LSpeedGainGG',       Gains(11), ...
            'LhipDGain',          Gains(12), ...
            'LhipPGain',          Gains(13), ...
            'LkneeExtendGain',    Gains(14), ...
            'LkneeFlexGain',      Gains(15), ...
            'LkneeHoldGain1',     Gains(16), ...
            'LkneeHoldGain2',     Gains(17), ...
            'LkneeStopGain',      Gains(18), ...
            'LlegAngleFilter',    Gains(19), ...
            'LlegLengthClr',      Gains(20), ...
            'RGainGLU',           Gains(21), ...
            'RGainHAMCut',        Gains(22), ...
            'RKglu',              Gains(23), ...
            'RPosGainGG',         Gains(24), ...
            'RSpeedGainGG',       Gains(25), ...
            'RhipDGain',          Gains(26), ...
            'RhipPGain',          Gains(27), ...
            'RkneeExtendGain',    Gains(28), ...
            'RkneeFlexGain',      Gains(29), ...
            'RkneeHoldGain1',     Gains(30), ...
            'RkneeHoldGain2',     Gains(31), ...
            'RkneeStopGain',      Gains(32), ...
            'RlegAngleFilter',    Gains(33), ...
            'RlegLengthClr',      Gains(34), ...
            'simbiconGainD',      Gains(35), ...
            'simbiconGainV',      Gains(36), ...
            'simbiconLegAngle0',  Gains(37), ...
            'legAngleTgt',        Gains(38), ...
            'RGainGAS',           0, ...
            'RGainHAM',           0, ...
            'RGainKneeOverExt',   0, ...
            'RGainSOL',           0, ...
            'RGainSOLTA',         0, ...
            'RGainTA',            0, ...
            'RGainVAS',           0);
    end

    %simulate each sample and store cost
    parfor i = 1:popSize
        costs(i) = evaluateCostParallel(paramSets{i})
    end
