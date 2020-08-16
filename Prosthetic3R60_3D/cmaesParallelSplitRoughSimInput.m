function costs = cmaesParallelSplitRoughSimInput(gainsPop)
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

    %create param sets
    gainind = 1;
    leftSwingSaggital = [model,'/Neural Control Layer/L Swing Phase (sagittal)'];
    rightSwingSaggital = [model,'/Neural Control Layer/R Swing Phase amp (sagittal)'];
    leftStanceSaggital = [model,'/Neural Control Layer/L Stance Phase (sagittal)'];
    rightStanceSaggital = [model,'/Neural Control Layer/R Stance Phase amp (sagittal)'];
    leftTransSaggital = [model,'/Neural Control Layer/L Stance, Swing, Trans (sagittal)'];
    leftTransSaggital = [model,'/Neural Control Layer/R Stance, Swing, Trans amp (sagittal)'];
    
    for i = 1:numTerrains:(numTerrains*popSize)
        %set gains
        Gains = InitialGuess.*exp(gainsPop(:,gainind));
        in(i) = Simulink.SimulationInput(model);
        in(i).setBlockParameter( ...
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
            'LGainFHABst',               Gains(39), ...
            'LGainPhiHATHABst',          Gains(40), ...
            'LGainDphiHATHABst',         Gains(41), ...
            'LGainPhiHATHADst',          Gains(42), ...
            'LGainDphiHATHADst',         Gains(43), ...
            'LGainSHABcHABst',           Gains(44), ...
            'LGainSHADcHADst',           Gains(45), ...
            'LGainLHABsw',               Gains(46), ...
            'LGainLHADsw',               Gains(47), ...
            'LlegLengthClr',             Gains(48), ...
            'LsimbiconLegAngle0',        Gains(49), ...
            'LsimbiconGainD',            Gains(50), ...
            'LsimbiconGainV',            Gains(51), ...
            'LdeltaLegAngleThr',         Gains(52), ...
            'LsimbiconLegAngle0_C',      Gains(53), ...
            'LsimbiconGainD_C',          Gains(54), ...
            'LsimbiconGainV_C',          Gains(55), ...
            'LtransSupst',               Gains(56), ...
            'Ltranssw',                  Gains(57), ...
            'LtransSupst_C',             Gains(58), ...
            'Ltranssw_C',                Gains(59), ...
            'LPreStimHFLst',             Gains(60), ...
            'LPreStimGLUst',             Gains(61), ...
            'LPreStimHAMst',             Gains(62), ...
            'LPreStimRFst',              Gains(63), ...
            'LPreStimVASst',             Gains(64), ...
            'LPreStimBFSHst',            Gains(65), ...
            'LPreStimGASst',             Gains(66), ...
            'LPreStimSOLst',             Gains(67), ...
            'LPreStimTAst',              Gains(68), ...
            'LPreStimHABst',             Gains(69), ...
            'LPreStimHADst',             Gains(70), ...
            'LPreStimHFLsw',             Gains(71), ...
            'LPreStimGLUsw',             Gains(72), ...
            'LPreStimHAMsw',             Gains(73), ...
            'LPreStimRFsw',              Gains(74), ...
            'LPreStimVASsw',             Gains(75), ...
            'LPreStimBFSHsw',            Gains(76), ...
            'LPreStimGASsw',             Gains(77), ...
            'LPreStimSOLsw',             Gains(78), ...
            'LPreStimTAsw',              Gains(79), ...
            'LPreStimHABsw',             Gains(80), ...
            'LPreStimHADsw',             Gains(81), ...
            'phiHATref',                 Gains(82), ...
            'RGainFGLUst',               Gains(83), ...
            'RGainFHAMst',               Gains(84), ...
            'RGainPhiHATHFLst',          Gains(85), ...
            'RGainDphiHATHFLst',         Gains(86), ...
            'RGainPhiHATGLUst',          Gains(87), ...
            'RGainDphiHATGLUst',         Gains(88), ...
            'RGainSGLUHAMst',            Gains(89), ...
            'RGainSGLUcHFLst',           Gains(90), ...
            'RGainSHAMcHFLst',           Gains(91), ...
            'RGainSHFLcGLUst',           Gains(92), ...
            'RGainSRFcGLUst',            Gains(93), ...
            'RGainLRFHFLsw',             Gains(94), ...
            'RGainVRFHFLsw',             Gains(95), ...
            'RGainLHAMGLUsw',            Gains(96), ...
            'RGainVHAMGLUsw',            Gains(97), ...
            'RGainLHAMsw',               Gains(98),...
            'RGainLHFLsw',               Gains(99), ...
            'RGainLGLUsw',               Gains(100), ...
            'RGainFHABst',               Gains(101), ...
            'RGainPhiHATHABst',          Gains(102), ...
            'RGainDphiHATHABst',         Gains(103), ...
            'RGainPhiHATHADst',          Gains(104), ...
            'RGainDphiHATHADst',         Gains(105), ...
            'RGainSHABcHABst',           Gains(106), ...
            'RGainSHADcHADst',           Gains(107), ...
            'RGainLHABsw',               Gains(108), ...
            'RGainLHADsw',               Gains(109), ...
            'RlegLengthClr',             Gains(110), ...
            'RsimbiconLegAngle0',        Gains(111), ...
            'RsimbiconGainD',            Gains(112), ...
            'RsimbiconGainV',            Gains(113), ...
            'RdeltaLegAngleThr',         Gains(114), ...
            'RsimbiconLegAngle0_C',      Gains(115), ...
            'RsimbiconGainD_C',          Gains(116), ...
            'RsimbiconGainV_C',          Gains(117), ...
            'RtransSupst',               Gains(118), ...
            'Rtranssw',                  Gains(119), ...
            'RtransSupst_C',             Gains(120), ...
            'Rtranssw_C',                Gains(121), ...
            'RPreStimHFLst',             Gains(122), ...
            'RPreStimGLUst',             Gains(123), ...
            'RPreStimHAMst',             Gains(124), ...
            'RPreStimRFst',              Gains(125), ...
            'RPreStimHABst',             Gains(126), ...
            'RPreStimHADst',             Gains(127), ...
            'RPreStimHFLsw',             Gains(128), ...
            'RPreStimGLUsw',             Gains(129), ...
            'RPreStimHAMsw',             Gains(130), ...
            'RPreStimRFsw',              Gains(131), ...
            'RPreStimHABsw',             Gains(132), ...
            'RPreStimHADsw',             Gains(133));

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
        out = parsim(in,'ShowProgress', 'on');
        out(1).logsout.get('time').Values
%         parfor i = 1:length(in)
%             localGains = InitialGuess.*exp(gainsPop(:,ceil(i/numTerrains)));
%             [costs(i),dataStructlocal] = evaluateCostParallel(paramSets{i},model,localGains,inner_opt_settings)
%             if inner_opt_settings.visual
%                 printOptInfo(dataStructlocal,true);
%             end
%             try
%                 if max(contains(fieldnames(dataStructlocal),'timeCost')) 
%                     if  dataStructlocal.timeCost.data == 0
%                         dataStruct(i) = dataStructlocal;
%                     end
%                 end
%             catch ME
%                warning('Error: %s\nIn %s.m line %d',ME.message,mfilename,ME.stack(1).line); 
%             end
%         end
    catch ME
       error(ME.message); 
    end

        
    %calculate mean across terrains
%     costs = reshape(costs,numTerrains,popSize); % size(costs) = [numTerrrains, popSize]
%     isinvalid = sum(isnan(costs))>1;
%     costs = nanmean(costs);
%     costs(isinvalid) = nan;
%     
%     %% send the best outcome of the best gains for plotting, only flat terrain
%     try
%         mingainidx = find(costs == min(costs));
%         %         distfrommean = costsall(:,mingainidx) - costs(mingainidx);
%         meanterrainidx = 1;%find(abs(distfrommean) == min(abs(distfrommean)));
%         
%         idx2send = ((mingainidx-1)*numTerrains) + meanterrainidx;
%         %     costall = reshape(costsall,1,popSize*numTerrains);
%         if inner_opt_settings.visual
%             if ~isempty(fieldnames(dataStruct(idx2send)))
%                 send(dataQueueD,dataStruct(idx2send));
%             end
%         else
%             printOptInfo(dataStruct(idx2send),false);
%         end
%     catch ME
%         warning(ME.message);
%     end

function in = set_gainvalues(in, Gains)
    global DEFAULT_RTP;
    % Modify the parameter value
    parameterSet = Simulink.BlockDiagram.modifyTunableParameters(DEFAULT_RTP, 'Mb', Mb);
    
    % Set the model parameter on the SimulationInput object and return the
    % modified SimulationInput object to be used for simulation
    in = in.setModelParameter('RapidAcceleratorParameterSets', parameterSet);
end
