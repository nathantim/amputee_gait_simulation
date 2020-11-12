function costs = cmaesParallelSplit(gainsPop)
% CMAESPARALLELSPLIT            Function that simulates the model with a certain set of gains which are coming from the cmaes optimization
% INPUTS:
%   - gainsPop                  Set of gains for which the model should be evaluated
%
% OUTPUTS:
%   - costs                     Cost function values for each set of gains
%%
global rtp InitialGuess  inner_opt_settings model

%% Data plotting during optimization
if inner_opt_settings.visual
    dataQueueD = parallel.pool.DataQueue;
    dataQueueD.afterEach(@plotProgressOptimization);
end

%allocate costs vector and paramsets the generation
popSize = size(gainsPop,2);

numTerrains = inner_opt_settings.numTerrains;
terrain_height = inner_opt_settings.terrain_height;


costs = nan(popSize*numTerrains,1);
paramSets = cell(popSize*numTerrains,1);

%create param sets
gainind = 1;
for ii = 1:numTerrains:(numTerrains*popSize)
    
    %set gains
    Gains = InitialGuess.*exp(gainsPop(:,gainind));
    paramSets{ii} = setRtpParamset(rtp,Gains);
    
    %set ground heights
    for j = 0:(numTerrains-1)
        if j == 0
            [~, groundZ, groundTheta] = generateGround('flat',[],4*j,false);
        else
            [~, groundZ, groundTheta] = generateGround('const', terrain_height, 4*j,false);
        end
        paramSets{ii+j} = ...
            Simulink.BlockDiagram.modifyTunableParameters(paramSets{ii}, ...
            'groundZ',     groundZ, ...
            'groundTheta', groundTheta);
    end
    gainind = gainind + 1;
end
rng('shuffle');

%simulate each sample and store cost
try
    parfor (ii = 1:length(paramSets),inner_opt_settings.numParWorkers)
        localGains = InitialGuess.*exp(gainsPop(:,ceil(ii/numTerrains)));
        [costs(ii),dataStructlocal] = evaluateCostParallel(paramSets{ii},model,localGains,inner_opt_settings);
        if inner_opt_settings.visual
            printOptInfo(dataStructlocal,true);
        end
        try
            if max(contains(fieldnames(dataStructlocal),'timeCost'))
                if  dataStructlocal.timeCost.data == 0
                    dataStruct(ii) = dataStructlocal;
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
            dataStruct(idx2send).optimCost = costs(mingainidx);
            send(dataQueueD,dataStruct(idx2send));
        end
    else
        printOptInfo(dataStruct(idx2send),false);
    end
catch ME
    warning(ME.message);
end