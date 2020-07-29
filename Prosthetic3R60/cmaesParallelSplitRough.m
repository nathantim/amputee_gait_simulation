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
            [costs(i),dataStructlocal] = evaluateCostParallel(paramSets{i},model,localGains)
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
    if inner_opt_settings.visual
        try
            mingainidx = find(costs == min(costs));
            %         distfrommean = costsall(:,mingainidx) - costs(mingainidx);
            meanterrainidx = 1;%find(abs(distfrommean) == min(abs(distfrommean)));
            
            idx2send = ((mingainidx-1)*numTerrains) + meanterrainidx;
            %     costall = reshape(costsall,1,popSize*numTerrains);
            if ~isempty(fieldnames(dataStruct(idx2send)))
                send(dataQueueD,dataStruct(idx2send));
            end
        catch ME
            warning(ME.message);
        end
    end
