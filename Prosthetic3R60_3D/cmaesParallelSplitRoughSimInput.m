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
%     paramSets = cell(popSize*numTerrains,1);

    %create param sets
    gainind = 1;
     
    for i = 1:numTerrains:(numTerrains*popSize)
        %set gains
        Gains = InitialGuess.*exp(gainsPop(:,gainind));
        in(i) = Simulink.SimulationInput(model);
        
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
        in(i) = in(i).setVariable('LGainFHABst',               Gains(39),'Workspace',model);
        in(i) = in(i).setVariable('LGainPhiHATHABst',          Gains(40),'Workspace',model);
        in(i) = in(i).setVariable('LGainDphiHATHABst',         Gains(41),'Workspace',model);
        in(i) = in(i).setVariable('LGainPhiHATHADst',          Gains(42),'Workspace',model);
        in(i) = in(i).setVariable('LGainDphiHATHADst',         Gains(43),'Workspace',model);
        in(i) = in(i).setVariable('LGainSHABcHABst',           Gains(44),'Workspace',model);
        in(i) = in(i).setVariable('LGainSHADcHADst',           Gains(45),'Workspace',model);
        in(i) = in(i).setVariable('LGainLHABsw',               Gains(46),'Workspace',model);
        in(i) = in(i).setVariable('LGainLHADsw',               Gains(47),'Workspace',model);
        in(i) = in(i).setVariable('LlegLengthClr',             Gains(48),'Workspace',model);
        in(i) = in(i).setVariable('LsimbiconLegAngle0',        Gains(49),'Workspace',model);
        in(i) = in(i).setVariable('LsimbiconGainD',            Gains(50),'Workspace',model);
        in(i) = in(i).setVariable('LsimbiconGainV',            Gains(51),'Workspace',model);
        in(i) = in(i).setVariable('LdeltaLegAngleThr',         Gains(52),'Workspace',model);
        in(i) = in(i).setVariable('LsimbiconLegAngle0_C',      Gains(53),'Workspace',model);
        in(i) = in(i).setVariable('LsimbiconGainD_C',          Gains(54),'Workspace',model);
        in(i) = in(i).setVariable('LsimbiconGainV_C',          Gains(55),'Workspace',model);
        in(i) = in(i).setVariable('LtransSupst',               Gains(56),'Workspace',model);
        in(i) = in(i).setVariable('Ltranssw',                  Gains(57),'Workspace',model);
        in(i) = in(i).setVariable('LtransSupst_C',             Gains(58),'Workspace',model);
        in(i) = in(i).setVariable('Ltranssw_C',                Gains(59),'Workspace',model);
        in(i) = in(i).setVariable('LPreStimHFLst',             Gains(60),'Workspace',model);
        in(i) = in(i).setVariable('LPreStimGLUst',             Gains(61),'Workspace',model);
        in(i) = in(i).setVariable('LPreStimHAMst',             Gains(62),'Workspace',model);
        in(i) = in(i).setVariable('LPreStimRFst',              Gains(63),'Workspace',model);
        in(i) = in(i).setVariable('LPreStimVASst',             Gains(64),'Workspace',model);
        in(i) = in(i).setVariable('LPreStimBFSHst',            Gains(65),'Workspace',model);
        in(i) = in(i).setVariable('LPreStimGASst',             Gains(66),'Workspace',model);
        in(i) = in(i).setVariable('LPreStimSOLst',             Gains(67),'Workspace',model);
        in(i) = in(i).setVariable('LPreStimTAst',              Gains(68),'Workspace',model);
        in(i) = in(i).setVariable('LPreStimHABst',             Gains(69),'Workspace',model);
        in(i) = in(i).setVariable('LPreStimHADst',             Gains(70),'Workspace',model);
        in(i) = in(i).setVariable('LPreStimHFLsw',             Gains(71),'Workspace',model);
        in(i) = in(i).setVariable('LPreStimGLUsw',             Gains(72),'Workspace',model);
        in(i) = in(i).setVariable('LPreStimHAMsw',             Gains(73),'Workspace',model);
        in(i) = in(i).setVariable('LPreStimRFsw',              Gains(74),'Workspace',model);
        in(i) = in(i).setVariable('LPreStimVASsw',             Gains(75),'Workspace',model);
        in(i) = in(i).setVariable('LPreStimBFSHsw',            Gains(76),'Workspace',model);
        in(i) = in(i).setVariable('LPreStimGASsw',             Gains(77),'Workspace',model);
        in(i) = in(i).setVariable('LPreStimSOLsw',             Gains(78),'Workspace',model);
        in(i) = in(i).setVariable('LPreStimTAsw',              Gains(79),'Workspace',model);
        in(i) = in(i).setVariable('LPreStimHABsw',             Gains(80),'Workspace',model);
        in(i) = in(i).setVariable('LPreStimHADsw',             Gains(81),'Workspace',model);
        in(i) = in(i).setVariable('phiHATref',                 Gains(82),'Workspace',model);
        in(i) = in(i).setVariable('RGainFGLUst',               Gains(83),'Workspace',model);
        in(i) = in(i).setVariable('RGainFHAMst',               Gains(84),'Workspace',model);
        in(i) = in(i).setVariable('RGainPhiHATHFLst',          Gains(85),'Workspace',model);
        in(i) = in(i).setVariable('RGainDphiHATHFLst',         Gains(86),'Workspace',model);
        in(i) = in(i).setVariable('RGainPhiHATGLUst',          Gains(87),'Workspace',model);
        in(i) = in(i).setVariable('RGainDphiHATGLUst',         Gains(88),'Workspace',model);
        in(i) = in(i).setVariable('RGainSGLUHAMst',            Gains(89),'Workspace',model);
        in(i) = in(i).setVariable('RGainSGLUcHFLst',           Gains(90),'Workspace',model);
        in(i) = in(i).setVariable('RGainSHAMcHFLst',           Gains(91),'Workspace',model);
        in(i) = in(i).setVariable('RGainSHFLcGLUst',           Gains(92),'Workspace',model);
        in(i) = in(i).setVariable('RGainSRFcGLUst',            Gains(93),'Workspace',model);
        in(i) = in(i).setVariable('RGainLRFHFLsw',             Gains(94),'Workspace',model);
        in(i) = in(i).setVariable('RGainVRFHFLsw',             Gains(95),'Workspace',model);
        in(i) = in(i).setVariable('RGainLHAMGLUsw',            Gains(96),'Workspace',model);
        in(i) = in(i).setVariable('RGainVHAMGLUsw',            Gains(97),'Workspace',model);
        in(i) = in(i).setVariable('RGainLHAMsw',               Gains(98),'Workspace',model);
        in(i) = in(i).setVariable('RGainLHFLsw',               Gains(99),'Workspace',model);
        in(i) = in(i).setVariable('RGainLGLUsw',               Gains(100),'Workspace',model);
        in(i) = in(i).setVariable('RGainFHABst',               Gains(101),'Workspace',model);
        in(i) = in(i).setVariable('RGainPhiHATHABst',          Gains(102),'Workspace',model);
        in(i) = in(i).setVariable('RGainDphiHATHABst',         Gains(103),'Workspace',model);
        in(i) = in(i).setVariable('RGainPhiHATHADst',          Gains(104),'Workspace',model);
        in(i) = in(i).setVariable('RGainDphiHATHADst',         Gains(105),'Workspace',model);
        in(i) = in(i).setVariable('RGainSHABcHABst',           Gains(106),'Workspace',model);
        in(i) = in(i).setVariable('RGainSHADcHADst',           Gains(107),'Workspace',model);
        in(i) = in(i).setVariable('RGainLHABsw',               Gains(108),'Workspace',model);
        in(i) = in(i).setVariable('RGainLHADsw',               Gains(109),'Workspace',model);
        in(i) = in(i).setVariable('RlegLengthClr',             Gains(110),'Workspace',model);
        in(i) = in(i).setVariable('RsimbiconLegAngle0',        Gains(111),'Workspace',model);
        in(i) = in(i).setVariable('RsimbiconGainD',            Gains(112),'Workspace',model);
        in(i) = in(i).setVariable('RsimbiconGainV',            Gains(113),'Workspace',model);
        in(i) = in(i).setVariable('RdeltaLegAngleThr',         Gains(114),'Workspace',model);
        in(i) = in(i).setVariable('RsimbiconLegAngle0_C',      Gains(115),'Workspace',model);
        in(i) = in(i).setVariable('RsimbiconGainD_C',          Gains(116),'Workspace',model);
        in(i) = in(i).setVariable('RsimbiconGainV_C',          Gains(117),'Workspace',model);
        in(i) = in(i).setVariable('RtransSupst',               Gains(118),'Workspace',model);
        in(i) = in(i).setVariable('Rtranssw',                  Gains(119),'Workspace',model);
        in(i) = in(i).setVariable('RtransSupst_C',             Gains(120),'Workspace',model);
        in(i) = in(i).setVariable('Rtranssw_C',                Gains(121),'Workspace',model);
        in(i) = in(i).setVariable('RPreStimHFLst',             Gains(122),'Workspace',model);
        in(i) = in(i).setVariable('RPreStimGLUst',             Gains(123),'Workspace',model);
        in(i) = in(i).setVariable('RPreStimHAMst',             Gains(124),'Workspace',model);
        in(i) = in(i).setVariable('RPreStimRFst',              Gains(125),'Workspace',model);
        in(i) = in(i).setVariable('RPreStimHABst',             Gains(126),'Workspace',model);
        in(i) = in(i).setVariable('RPreStimHADst',             Gains(127),'Workspace',model);
        in(i) = in(i).setVariable('RPreStimHFLsw',             Gains(128),'Workspace',model);
        in(i) = in(i).setVariable('RPreStimGLUsw',             Gains(129),'Workspace',model);
        in(i) = in(i).setVariable('RPreStimHAMsw',             Gains(130),'Workspace',model);
        in(i) = in(i).setVariable('RPreStimRFsw',              Gains(131),'Workspace',model);
        in(i) = in(i).setVariable('RPreStimHABsw',             Gains(132),'Workspace',model);
        in(i) = in(i).setVariable('RPreStimHADsw',             Gains(133),'Workspace',model);
        
        prepend = 'NeuromuscularModel_3R60_2D/Neural Control Layer/';
        in(i) = in(i).setBlockParameter(    [prepend,'SDelay20'],'InitialOutput', char(string(Gains(46))), ... %LPreStimHFLst
                                            [prepend,'SDelay21'],'InitialOutput', char(string(Gains(47))), ... %LPreStimGLUst
                                            [prepend,'SDelay22'],'InitialOutput', char(string(Gains(48))), ... %LPreStimHAMst
                                            [prepend,'SDelay23'],'InitialOutput', char(string(Gains(49))), ... %LPreStimRFst
                                            [prepend,'MDelay9'] ,'InitialOutput', char(string(Gains(50))), ... %LPreStimVASst
                                            [prepend,'MDelay10'],'InitialOutput', char(string(Gains(51))), ... %LPreStimBFSHst
                                            [prepend,'LDelay11'],'InitialOutput', char(string(Gains(52))), ... %LPreStimGASst
                                            [prepend,'LDelay9'] ,'InitialOutput', char(string(Gains(53))), ... %LPreStimSOLst
                                            [prepend,'LDelay10'],'InitialOutput', char(string(Gains(54))), ... %LPreStimTAst
                                            [prepend,'SDelay24'],'InitialOutput', char(string(Gains(94))), ... %RPreStimHFLsw
                                            [prepend,'SDelay25'],'InitialOutput', char(string(Gains(95))), ... %RPreStimGLUsw
                                            [prepend,'SDelay26'],'InitialOutput', char(string(Gains(96))), ... %RPreStimHAMsw
                                            [prepend,'SDelay27'],'InitialOutput', char(string(Gains(97)))); ... %RPreStimRFsw
           
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
    out = parsim(in, 'ShowProgress', true,'TransferBaseWorkspaceVariables',true,'UseFastRestart',true);

    for i = 1:length(in)
        fprintf('Error Message of %d: \n',i);
        disp(out(i).ErrorMessage);
        time = out(i).time;
        metabolicEnergy = out(i).metabolicEnergy;
        sumOfStopTorques = out(i).sumOfStopTorques;
        HATPos = out(i).HATPos;
        stepVelocities = out(i).stepVelocities;
        stepTimes = out(i).stepTimes;
        stepLengths = out(i).stepLengths;
        angularData = out(i).angularData;
        GaitPhaseData = out(i).GaitPhaseData;
        musculoData = out(i).musculoData;
        GRFData = out(i).GRFData;
        
        
        kinematics.angularData = angularData;
        kinematics.GaitPhaseData = GaitPhaseData;
        kinematics.time = time;
        kinematics.stepTimes = stepTimes;
        kinematics.musculoData = musculoData;
        kinematics.GRFData = GRFData;
        try
            [costs(i), dataStructlocal] = getCost(model,Gains,time,metabolicEnergy,sumOfStopTorques, ...
                HATPos,stepVelocities,stepTimes,stepLengths,...
                inner_opt_settings,true);
            dataStructlocal.kinematics = kinematics;
        catch ME
            save('error_getCost.mat');
            error('Error not possible to evaluate getCost: %s\nIn %s.m line %d',ME.message,mfilename,ME.stack(1).line);
        end
        if ~inner_opt_settings.visual
            printOptInfo(dataStructlocal,false);
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
    %     try
    %         parfor (i = 1:length(paramSets),inner_opt_settings.numParWorkers)
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
    %     catch ME
    %        error(ME.message);
    %     end
    
    
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
