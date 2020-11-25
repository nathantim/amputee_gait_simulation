% Simulation 1: Healthy gait at 0.9m/s
% Simulation 2: Healthy gait at 1.2m/s
%%
model = 'NeuromuscularModel3D';
gainfiles = {'v0.9ms.mat', 'v1.2ms.mat'};
targetVel = [0.9, 1.2];
[groundX, groundZ, groundTheta] = generateGround('flat');
dt_visual = 1/1000;
animFrameRate = 30;
load(['Results' filesep gainfiles{1}]);
BodyMechParams;
ControlParams;
innerOptSettings = setInnerOptSettings(model,'resume','eval');

assignGainsSagittal;
assignGainsCoronal;
assignInit;
load_system(model);
warning('off')
rtp = Simulink.BlockDiagram.buildRapidAcceleratorTarget(model);
warning('on');

%%
clearvars in
for idxGains = 1:length(gainfiles)
    
    load(['Results' filesep gainfiles{idxGains}])    
    Gains = [GainsSagittal;initConditionsSagittal;...
				GainsCoronal; initConditionsCoronal];
    paramSets{idxGains} = setRtpParamset(rtp,Gains);
    
    in(idxGains) = Simulink.SimulationInput(model);
    in(idxGains) = in(idxGains).setModelParameter('TimeOut', 10*60);
    in(idxGains) = in(idxGains).setModelParameter('SimulationMode', 'rapid', ...
        'RapidAcceleratorUpToDateCheck', 'off');
    in(idxGains) = in(idxGains).setModelParameter('RapidAcceleratorParameterSets', paramSets{idxGains});
    
end

%%
simout = parsim(in, 'ShowProgress', true);

%%
for idxSim = 1:length(simout)
    innerOptSettings.targetVelocity    = targetVel(idxSim);
    innerOptSettings.minVelocity       = targetVel(idxSim);
    innerOptSettings.maxVelocity       = targetVel(idxSim);
    mData=simout(idxSim).getSimulationMetadata();
    
    if strcmp(mData.ExecutionInfo.StopEvent,'DiagnosticError')
        disp('Sim was stopped due to error');
        fprintf('Simulation %d was stopped due to error: \n',idxSim);
        disp(simout(idxSim).ErrorMessage);
    elseif strcmp(mData.ExecutionInfo.StopEvent,'Timeout')
        fprintf('Simulation %d was stopped due to Timeout: \n',idxSim);
    else
        [~, dataStructLocal] = getCost(model,[],simout(idxSim).time,simout(idxSim).metabolicEnergy,simout(idxSim).sumOfStopTorques,simout(idxSim).HATPosVel,...
                                                simout(idxSim).stepTimes,simout(idxSim).stepLengths,simout(idxSim).stepNumbers,simout(idxSim).CMGData,mData.ExecutionInfo.StopEvent,...
                                                innerOptSettings,0);
       printOptInfo(dataStructLocal,true);
    end
end

%%
close_system(model);