function costs = cmaesParallelSplitRoughCMG(gainsPop)
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
    paramSets = cell(popSize*numTerrains,1);
%     dataStruct = struct;

%create param sets
    gainind = 1;
    for i = 1:numTerrains:(numTerrains*popSize)
        %set gains
        Gains = InitialGuess.*exp(gainsPop(:,gainind));
%         Gains = InitialGuess.*exp(gainsPop(:,i));
        paramSets{i} = Simulink.BlockDiagram.modifyTunableParameters(rtp, ...
            'RlegAngleFilter',       Gains( 1), ...
            'RkneeFlexSpeedGain',    Gains( 2), ...
            'RkneeFlexPosGain',      Gains( 3), ...
            'RkneeStopGain',         Gains( 4), ...
            'RkneeExtendGain',       Gains( 5), ...
            'TargetLegAngleTripFlex',Gains( 6));
%                     'KpGamma',               Gains( 1), ...
%             'KiGamma',               Gains( 2), ...

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
%     isinvalid = sum(isnan(costs))>1;
%     costs = nanmean(costs,1);
%     costs(isinvalid) = nan;
    
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
    
