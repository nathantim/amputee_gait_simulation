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
        in(i) = in(i).setModelParameter('SimulationMode','accelerator');
        
        in(i) = in(i).setVariable('LGainFGLUst',               Gains( 1));
        in(i) = in(i).setVariable('LGainFVASst',               Gains( 2));
        in(i) = in(i).setVariable('LGainFSOLst',               Gains( 3));
        in(i) = in(i).setVariable('LGainFHAMst',               Gains( 4));
        in(i) = in(i).setVariable('LLceOffsetBFSHVASst',       Gains( 5));
        in(i) = in(i).setVariable('LGainLBFSHVASst',           Gains( 6));
        in(i) = in(i).setVariable('LLceOffsetBFSHst',          Gains( 7));
        in(i) = in(i).setVariable('LGainLBFSHst',              Gains( 8));
        in(i) = in(i).setVariable('LGainFGASst',               Gains( 9));
        in(i) = in(i).setVariable('LGainPhiHATHFLst',          Gains(10));
        in(i) = in(i).setVariable('LGainDphiHATHFLst',         Gains(11));
        in(i) = in(i).setVariable('LGainPhiHATGLUst',          Gains(12));
        in(i) = in(i).setVariable('LGainDphiHATGLUst',         Gains(13));
        in(i) = in(i).setVariable('LGainSGLUHAMst',            Gains(14));
        in(i) = in(i).setVariable('LGainSGLUcHFLst',           Gains(15));
        in(i) = in(i).setVariable('LGainSHAMcHFLst',           Gains(16));
        in(i) = in(i).setVariable('LGainSHFLcGLUst',           Gains(17));
        in(i) = in(i).setVariable('LGainSRFcGLUst',            Gains(18));
        in(i) = in(i).setVariable('LLceOffsetTAst',            Gains(19));
        in(i) = in(i).setVariable('LGainLTAst',                Gains(20));
        in(i) = in(i).setVariable('LGainFSOLTAst',             Gains(21));
        in(i) = in(i).setVariable('LGainLTAsw',                Gains(22));
        in(i) = in(i).setVariable('LLceOffsetTAsw',            Gains(23));
        in(i) = in(i).setVariable('LGainLRFHFLsw',             Gains(24));
        in(i) = in(i).setVariable('LGainVRFHFLsw',             Gains(25));
        in(i) = in(i).setVariable('LGainLHAMGLUsw',            Gains(26));
        in(i) = in(i).setVariable('LGainVHAMGLUsw',            Gains(27));
        in(i) = in(i).setVariable('LGainVRFBFSHsw',            Gains(28));
        in(i) = in(i).setVariable('LGainVVASRFsw',             Gains(29));
        in(i) = in(i).setVariable('LGainVBFSHsw',              Gains(30));
        in(i) = in(i).setVariable('LGainLHAMsw',               Gains(31));
        in(i) = in(i).setVariable('LGainSHAMBFSHsw',           Gains(32));
        in(i) = in(i).setVariable('LGainSHAMGASsw',            Gains(33));
        in(i) = in(i).setVariable('LSHAMthresholdsw',          Gains(34));
        in(i) = in(i).setVariable('LGainLHFLsw',               Gains(35));
        in(i) = in(i).setVariable('LGainLGLUsw',               Gains(36));
        in(i) = in(i).setVariable('LLceOffsetVASsw',           Gains(37));
        in(i) = in(i).setVariable('LGainLVASsw',               Gains(38));
        in(i) = in(i).setVariable('LlegLengthClr',             Gains(39));
        in(i) = in(i).setVariable('LsimbiconLegAngle0',        Gains(40));
        in(i) = in(i).setVariable('LsimbiconGainD',            Gains(41));
        in(i) = in(i).setVariable('LsimbiconGainV',            Gains(42));
        in(i) = in(i).setVariable('LdeltaLegAngleThr',         Gains(43));
        in(i) = in(i).setVariable('LtransSupst',               Gains(44));
        in(i) = in(i).setVariable('Ltranssw',                  Gains(45));
        in(i) = in(i).setVariable('LPreStimHFLst',             Gains(46));
        in(i) = in(i).setVariable('LPreStimGLUst',             Gains(47));
        in(i) = in(i).setVariable('LPreStimHAMst',             Gains(48));
        in(i) = in(i).setVariable('LPreStimRFst',              Gains(49));
        in(i) = in(i).setVariable('LPreStimVASst',             Gains(50));
        in(i) = in(i).setVariable('LPreStimBFSHst',            Gains(51));
        in(i) = in(i).setVariable('LPreStimGASst',             Gains(52));
        in(i) = in(i).setVariable('LPreStimSOLst',             Gains(53));
        in(i) = in(i).setVariable('LPreStimTAst',              Gains(54));
        in(i) = in(i).setVariable('LPreStimHFLsw',             Gains(55));
        in(i) = in(i).setVariable('LPreStimGLUsw',             Gains(56));
        in(i) = in(i).setVariable('LPreStimHAMsw',             Gains(57));
        in(i) = in(i).setVariable('LPreStimRFsw',              Gains(58));
        in(i) = in(i).setVariable('LPreStimVASsw',             Gains(59));
        in(i) = in(i).setVariable('LPreStimBFSHsw',            Gains(60));
        in(i) = in(i).setVariable('LPreStimGASsw',             Gains(61));
        in(i) = in(i).setVariable('LPreStimSOLsw',             Gains(62));
        in(i) = in(i).setVariable('LPreStimTAsw',              Gains(63));
        in(i) = in(i).setVariable('phiHATref',                 Gains(64));
        in(i) = in(i).setVariable('RGainFGLUst',               Gains(65));
        in(i) = in(i).setVariable('RGainFHAMst',               Gains(66));
        in(i) = in(i).setVariable('RGainPhiHATHFLst',          Gains(67));
        in(i) = in(i).setVariable('RGainDphiHATHFLst',         Gains(68));
        in(i) = in(i).setVariable('RGainPhiHATGLUst',          Gains(69));
        in(i) = in(i).setVariable('RGainDphiHATGLUst',         Gains(70));
        in(i) = in(i).setVariable('RGainSGLUHAMst',            Gains(71));
        in(i) = in(i).setVariable('RGainSGLUcHFLst',           Gains(72));
        in(i) = in(i).setVariable('RGainSHAMcHFLst',           Gains(73));
        in(i) = in(i).setVariable('RGainSHFLcGLUst',           Gains(74));
        in(i) = in(i).setVariable('RGainSRFcGLUst',            Gains(75));
        in(i) = in(i).setVariable('RGainLRFHFLsw',             Gains(76));
        in(i) = in(i).setVariable('RGainVRFHFLsw',             Gains(77));
        in(i) = in(i).setVariable('RGainLHAMGLUsw',            Gains(78));
        in(i) = in(i).setVariable('RGainVHAMGLUsw',            Gains(79));
        in(i) = in(i).setVariable('RGainLHAMsw',               Gains(80));
        in(i) = in(i).setVariable('RGainLHFLsw',               Gains(81));
        in(i) = in(i).setVariable('RGainLGLUsw',               Gains(82));
        in(i) = in(i).setVariable('RlegLengthClr',             Gains(83));
        in(i) = in(i).setVariable('RsimbiconLegAngle0',        Gains(84));
        in(i) = in(i).setVariable('RsimbiconGainD',            Gains(85));
        in(i) = in(i).setVariable('RsimbiconGainV',            Gains(86));
        in(i) = in(i).setVariable('RdeltaLegAngleThr',         Gains(87));
        in(i) = in(i).setVariable('RtransSupst',               Gains(88));
        in(i) = in(i).setVariable('Rtranssw',                  Gains(89));
        in(i) = in(i).setVariable('RPreStimHFLst',             Gains(90));
        in(i) = in(i).setVariable('RPreStimGLUst',             Gains(91));
        in(i) = in(i).setVariable('RPreStimHAMst',             Gains(92));
        in(i) = in(i).setVariable('RPreStimRFst',              Gains(93));
        in(i) = in(i).setVariable('RPreStimHFLsw',             Gains(94));
        in(i) = in(i).setVariable('RPreStimGLUsw',             Gains(95));
        in(i) = in(i).setVariable('RPreStimHAMsw',             Gains(96));
        in(i) = in(i).setVariable('RPreStimRFsw',              Gains(97));

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
    out = parsim(in, 'ShowProgress', 'on');
    for i = 1:length(in)
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
            dataStruct.kinematics = kinematics;
        catch ME
            save('error_getCost.mat');
            error('Error not possible to evaluate getCost: %s\nIn %s.m line %d',ME.message,mfilename,ME.stack(1).line);
        end
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
    
