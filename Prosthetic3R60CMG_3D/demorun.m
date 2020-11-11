% function simout = demorun()
model = 'NeuromuscularModel_3R60CMG_3D';

load(['Results' filesep 'v1.2ms_wCMG.mat'])
load(['Results' filesep 'CMGGains_tripprevent.mat'])

innerOptSettings = setInnerOptSettings('eval');

BodyMechParams;
ControlParams;
Prosthesis3R60Params;
CMGParams;
OptimParams;


load_system(model);

[groundX, groundZ, groundTheta] = generateGround('flat');
dt_visual = 1/1000;
animFrameRate = 30;
    
assignCMGGains;
assignGainsSagittal;
assignGainsCoronal;
assignInit;

targetVel = [1.2,1.2,1.2];
stopTimeVec = [20,20,30];
obstacleX = [obstacle_x, obstacle_x, 1000];
tripDetectThresh = [tripDetectThreshold, tripDetectThreshold*1E9, tripDetectThreshold*1E9];

%%
warning('off')
rtp = Simulink.BlockDiagram.buildRapidAcceleratorTarget(model);
warning('on');

%%
clearvars in
for idxGains = 1:length(obstacleX)
    in(idxGains) = Simulink.SimulationInput(model);
    in(idxGains) = in(idxGains).setModelParameter('TimeOut', 25*60);
    in(idxGains) = in(idxGains).setModelParameter('StopTime', char(num2str(stopTimeVec(idxGains))));
    paramSets{idxGains} = Simulink.BlockDiagram.modifyTunableParameters(rtp, ...
                        'obstacle_x',     obstacleX(idxGains), ...
                        'tripDetectThreshold', tripDetectThresh(idxGains));
    in(idxGains) = in(idxGains).setModelParameter('SimulationMode', 'rapid', ...
        'RapidAcceleratorUpToDateCheck', 'off');
    in(idxGains) = in(idxGains).setModelParameter('RapidAcceleratorParameterSets', paramSets{idxGains});
end


%%
simout = parsim(in, 'ShowProgress', true);

%%
for idxSim = 1:length(simout)
    innerOptSettings.target_velocity    = targetVel(idxSim);
    innerOptSettings.min_velocity       = targetVel(idxSim);
    innerOptSettings.max_velocity       = targetVel(idxSim);
    mData=simout(idxSim).getSimulationMetadata();
    
    if strcmp(mData.ExecutionInfo.StopEvent,'DiagnosticError')
        disp('Sim was stopped due to error');
        fprintf('Simulation %d was stopped due to error: \n',idxSim);
        disp(simout(idxSim).ErrorMessage);
    elseif strcmp(mData.ExecutionInfo.StopEvent,'Timeout')
        fprintf('Simulation %d was stopped due to Timeout: \n',idxSim);
    else
        [~, dataStructLocal] = getCost(model,[],simout(idxSim).time,simout(idxSim).metabolicEnergy,simout(idxSim).sumOfStopTorques,simout(idxSim).HATPosVel,simout(idxSim).stepVelocities,simout(idxSim).stepTimes,simout(idxSim).stepLengths,simout(idxSim).stepNumbers,simout(idxSim).CMGData,simout(idxSim).selfCollision,innerOptSettings,0);
        printOptInfo(dataStructLocal,true);
    end
end