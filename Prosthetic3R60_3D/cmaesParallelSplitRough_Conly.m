function costs = cmaesParallelSplitRough_Conly(gainsPop)
global InitialGuess inner_opt_settings model rtp
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

for i = 1:numTerrains:(numTerrains*popSize)
    %set gains
    Gains = InitialGuess.*exp(gainsPop(:,gainind));

    
    paramSets{i} = Simulink.BlockDiagram.modifyTunableParameters(rtp, ...
    'LGainFHABst',               Gains(1), ...
    'LGainPhiHATHABst',          Gains(2), ...
    'LGainDphiHATHABst',         Gains(3), ...
    'LGainPhiHATHADst',          Gains(4), ...
    'LGainDphiHATHADst',         Gains(5), ...
    'LGainSHABcHABst',           Gains(6), ...
    'LGainSHADcHADst',           Gains(7), ...
    'LGainLHABsw',               Gains(8), ...
    'LGainLHADsw',               Gains(9), ...
    'LsimbiconLegAngle0_C',      Gains(10), ...
    'LsimbiconGainD_C',          Gains(11), ...
    'LsimbiconGainV_C',          Gains(12), ...
    'LtransSupst_C',             Gains(13), ...
    'Ltranssw_C',                Gains(14), ...
    'LPreStimHABst',             Gains(15), ...
    'LPreStimHADst',             Gains(16), ...
    'LPreStimHABsw',             Gains(17), ...
    'LPreStimHADsw',             Gains(18), ...
    'RGainFHABst',               Gains(19), ...
    'RGainPhiHATHABst',          Gains(20), ...
    'RGainDphiHATHABst',         Gains(21), ...
    'RGainPhiHATHADst',          Gains(22), ...
    'RGainDphiHATHADst',         Gains(23), ...
    'RGainSHABcHABst',           Gains(24), ...
    'RGainSHADcHADst',           Gains(25), ...
    'RGainLHABsw',               Gains(26), ...
    'RGainLHADsw',               Gains(27), ...
    'RsimbiconLegAngle0_C',      Gains(28), ...
    'RsimbiconGainD_C',          Gains(29), ...
    'RsimbiconGainV_C',          Gains(30), ...
    'RtransSupst_C',             Gains(31), ...
    'Rtranssw_C',                Gains(32), ...
    'RPreStimHABst',             Gains(33), ...
    'RPreStimHADst',             Gains(34), ...
    'RPreStimHABsw',             Gains(35), ...
    'RPreStimHADsw',             Gains(36));
    
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
            [costs(i),dataStructlocal] = evaluateCostParallel(paramSets{i},model,localGains,inner_opt_settings);
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

