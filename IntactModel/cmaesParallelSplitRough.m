function costs = cmaesParallelSplitRough(gainsPop)
    global rtp InitialGuess inner_opt_settings model
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
    paramSets = cell(popSize*numTerrains,1);
%     dataStruct = struct;

%create param sets
    gainind = 1;
    for i = 1:numTerrains:(numTerrains*popSize)
        %set gains
        Gains = InitialGuess.*exp(gainsPop(:,gainind));
%         Gains = InitialGuess.*exp(gainsPop(:,i));
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
            'GainSHFLcGLUst',           Gains(17), ...
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

        %set ground heights
        for j = 0:(numTerrains-1)
            if j == 0
                [~, groundZ, groundTheta] = generateGround('flat',[],4*j,false);
            else
                [~, groundZ, groundTheta] = generateGround('const', terrain_height, 4*j,false);
            end
            paramSets{i+j} = ...
                Simulink.BlockDiagram.modifyTunableParameters(paramSets{i}, ...
                'groundZ',     groundZ, ...
                'groundTheta', groundTheta);
        end
        gainind = gainind + 1;
    end
    rng('shuffle');

    %simulate each sample and store cost
    try
        parfor (i = 1:length(paramSets),inner_opt_settings.numParWorkers)
            localGains = InitialGuess.*exp(gainsPop(:,ceil(i/numTerrains)));
            [costs(i),dataStructlocal] = evaluateCostParallel(paramSets{i},model,localGains,inner_opt_settings)
            if inner_opt_settings.visual
                printOptInfo(dataStructlocal,true);
            end
            try
                if max(contains(fieldnames(dataStructlocal),'timeCost')) 
                    if  dataStructlocal.timeCost.data == 0
                        dataStruct(i) = dataStructlocal;
                    end
                end
            catch ME
               warning('Error: %s\nIn %s.m line %d',ME.message,mfilename,ME.stack(1).line); 
            end
        end
    catch ME
       error(ME.message); 
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
