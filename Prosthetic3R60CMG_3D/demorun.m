% function simout = demorun()
model = 'NeuromuscularModel_3R60CMG_3D';
optDir = ['Results' filesep '2020-11-09_11-12_1.2ms_CMG_trip_prevent'];

% load([optDir filesep 'variablescmaes.mat'],'bestever');

% InitialGuess = load([optDir filesep 'initial_gains.mat']);
% InitialGuessCMG = load([optDir filesep 'initial_gainsCMG.mat']);
% GainsSagittal           = InitialGuess.GainsSagittal;
% initConditionsSagittal  = InitialGuess.initConditionsSagittal;
% GainsCoronal            = InitialGuess.GainsCoronal;
% initConditionsCoronal   = InitialGuess.initConditionsCoronal;
% CMGGains = InitialGuessCMG.CMGGains.*exp(bestever.x);




load(['Results' filesep 'v1.2ms_wCMG.mat'])
load(['Results' filesep 'CMGGains_tripprevent.mat'])

innerOptSettings = setInnerOptSettings('eval');
innerOptSettings.optimizationDir = optDir;

BodyMechParams;
ControlParams;
Prosthesis3R60Params;
CMGParams;
OptimParams;
% setInitVar;

% run([innerOptSettings.optimizationDir, filesep, 'BodyMechParamsCapture']);
% run([innerOptSettings.optimizationDir, filesep, 'ControlParamsCapture']);
% run([innerOptSettings.optimizationDir, filesep, 'Prosthesis3R60ParamsCapture']);
% run([innerOptSettings.optimizationDir, filesep, 'CMGParamsCapture']);
% run([innerOptSettings.optimizationDir, filesep, 'OptimParamsCapture']);

load_system(model);

[groundX, groundZ, groundTheta] = generateGround('flat');
dt_visual = 1/1000;
animFrameRate = 30;
    
assignCMGGains;
assignGainsSagittal;
assignGainsCoronal;
assignInit;

targetVel = [1.2,1.2];
stopTimeVec = [20,30];
% obstacleX = [obstacle_x, 100];

%%
warning('off')
rtp = Simulink.BlockDiagram.buildRapidAcceleratorTarget(model);
warning('on');


%%
% paramSets{2} = Simulink.BlockDiagram.modifyTunableParameters(rtp, ...
%         'obstacle_x',     1000);
clearvars in
for idxGains = 1
    in(idxGains) = Simulink.SimulationInput(model);
    in(idxGains) = in(idxGains).setModelParameter('TimeOut', 25*60);
%     in(idxGains) = in(idxGains).setModelParameter('StopTime', char(num2str(stopTimeVec(idxGains))));
%     
    in(idxGains) = in(idxGains).setModelParameter('SimulationMode', 'rapid', ...
        'RapidAcceleratorUpToDateCheck', 'off');
%     in(idxGains) = in(idxGains).setModelParameter('RapidAcceleratorParameterSets', paramSets{idxGains});
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