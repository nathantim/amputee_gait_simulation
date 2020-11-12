% Simulation 1: Trip prevention
% Simulation 2: Gait with active CMG
% Simulation 3: Trip fall
% Simulation 4: Gait with inactive CMG

%%
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

targetVel = [1.2,1.2,1.2,1.2];
CMGcostFactor = [innerOptSettings.CMGdeltaHFactor,0,innerOptSettings.CMGdeltaHFactor,1.2];
stopTimeVec = [20,30,20,30];
tripDetectThresh = [tripDetectThreshold, tripDetectThreshold, tripDetectThreshold*1E9];

%%
warning('off')
rtp = Simulink.BlockDiagram.buildRapidAcceleratorTarget(model);
warning('on');

%%
clearvars in
paramSets{2} = Simulink.BlockDiagram.modifyTunableParameters(rtp, ...
                        'obstacle_x',     1000, ...
                        'obstacle_y',     1000, ...
                        'tripDetectThreshold', tripDetectThreshold*1E9);
paramSets{3} = Simulink.BlockDiagram.modifyTunableParameters(rtp, ...
                        'obstacle_x', obstacle_x,...
                        'obstacle_y',     obstacle_y, ...
                        'RkneeFlexSpeedGain', 0, ...
                        'RkneeFlexPosGain', 0, ...
                        'RkneeStopGain', 0, ...
                        'RkneeExtendGain', 0, ...
                        'tripDetectThreshold', tripDetectThreshold);
paramSets{4} = Simulink.BlockDiagram.modifyTunableParameters(rtp, ...
                        'obstacle_x',     1000, ...
                        'obstacle_y',     1000, ...
                        'tripDetectThreshold', tripDetectThreshold*1E9, ...
                         'KpGamma', 0, ...
                        'KiGamma', 0, ...
                        'KpGammaReset', 0, ...
                        'KdGammaReset', 0, ...
                        'omegaRef', 0);                    
for idxGains = 1:length(paramSets)
    in(idxGains) = Simulink.SimulationInput(model);
    in(idxGains) = in(idxGains).setModelParameter('TimeOut', 35*60);
    in(idxGains) = in(idxGains).setModelParameter('StopTime', char(num2str(stopTimeVec(idxGains))));
    
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
    setInnerOptSettings.CMGdeltaHFactor = CMGcostFactor(idxSim);
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