% Simulation 1: Trip prevention
% Simulation 2: Trip fall
% Simulation 3: Gait with active CMG
% Simulation 4: Gait with inactive CMG

%%
model = 'NeuromuscularModel_3R60CMG_3D';

load(['Results' filesep 'v1.2ms_wCMG.mat'])
load(['Results' filesep 'CMGGains_tripprevent.mat'])

innerOptSettings = setInnerOptSettings(model,'resume','eval','targetVelocity',1.2);

BodyMechParams;
ControlParams;
Prosthesis3R60Params;
CMGParams;

load_system(model);
set_param(strcat(model,'/Body Mechanics Layer/Obstacle'),'Commented','off');

[groundX, groundZ, groundTheta] = generateGround('flat');
dt_visual = 1/1000;
animFrameRate = 30;
    
assignCMGGains;
assignGainsSagittal;
assignGainsCoronal;
assignInit;

CMGcostFactor = [innerOptSettings.CMGdeltaHFactor,innerOptSettings.CMGdeltaHFactor,0,0];
save_system(model);

%%
warning('off')
rtp = Simulink.BlockDiagram.buildRapidAcceleratorTarget(model);
warning('on');

%%
clearvars in paramSets
paramSets{1} = {};
% paramSets{2} = Simulink.BlockDiagram.modifyTunableParameters(rtp, ...
%                         'RkneeFlexSpeedGain', 0, ...
%                         'RkneeFlexPosGain', 0, ...
%                         'RkneeStopGain', 0, ...
%                         'RkneeExtendGain', 0, ...
%                         'tripDetectThreshold', tripDetectThreshold);
                    
for idxGains = 1:length(paramSets)
    in(idxGains) = Simulink.SimulationInput(model);
    in(idxGains) = in(idxGains).setModelParameter('TimeOut', 35*60);
    in(idxGains) = in(idxGains).setModelParameter('StopTime', '20');
    in(idxGains) = in(idxGains).setModelParameter('SimulationMode', 'rapid', ...
        'RapidAcceleratorUpToDateCheck', 'off');
    in(idxGains) = in(idxGains).setModelParameter('RapidAcceleratorParameterSets', paramSets{idxGains});
end


%%
simout(1:length(paramSets)) = parsim(in, 'ShowProgress', true);

%%
% load_system(model);
% set_param(strcat(model,'/Body Mechanics Layer/Obstacle'),'Commented','on');
% save_system(model);
% clearvars rtp in paramSets
% warning('off')
% rtp = Simulink.BlockDiagram.buildRapidAcceleratorTarget(model);
% warning('on');
% 
% %%
% paramSets{1} = Simulink.BlockDiagram.modifyTunableParameters(rtp, ...
%                         'tripDetectThreshold', tripDetectThreshold*1E9);
% paramSets{2} = Simulink.BlockDiagram.modifyTunableParameters(rtp, ...
%                         'tripDetectThreshold', tripDetectThreshold*1E9, ...
%                          'KpGamma', 0, ...
%                         'KiGamma', 0, ...
%                         'KpGammaReset', 0, ...
%                         'KdGammaReset', 0, ...
%                         'omegaRef', 0);                    
% for idxGains = 1:length(paramSets)
%     in(idxGains) = Simulink.SimulationInput(model);
%     in(idxGains) = in(idxGains).setModelParameter('TimeOut', 35*60);
%     in(idxGains) = in(idxGains).setModelParameter('StopTime', '30');
%     in(idxGains) = in(idxGains).setModelParameter('SimulationMode', 'rapid', ...
%         'RapidAcceleratorUpToDateCheck', 'off');
%     in(idxGains) = in(idxGains).setModelParameter('RapidAcceleratorParameterSets', paramSets{idxGains});
% end
% 
% %%
% simout((length(simout)+1):(length(simout)+paramSets)) = parsim(in, 'ShowProgress', true);

%%
for idxSim = 1:length(simout)
    innerOptSettings.CMGdeltaHFactor   = CMGcostFactor(idxSim);
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