if  (input("Do you want to clear the data? (1/0)   "))
    %     close all;
    clearvars;  clc;
end

%%
if input("Load from optimization folder? (1/0)   " )
    innerOptSettings = setInnerOptSettings('yes');
    disp(innerOptSettings.optimizationDir);
    
    
    load([innerOptSettings.optimizationDir filesep 'variablescmaes.mat'],'bestever');
    InitialGuess = load([innerOptSettings.optimizationDir filesep 'initial_gains.mat']);
    idx1 = length(InitialGuess.GainsSagittal);
    idx2 = idx1 + length(InitialGuess.initConditionsSagittal);
    idx3 = idx2 + length(InitialGuess.GainsCoronal);
    idx4 = idx3 + length(InitialGuess.initConditionsCoronal);
    
    
    
    InitialGuessCMG = load([innerOptSettings.optimizationDir filesep 'initial_gainsCMG.mat']);
    
    if idx4 == length(bestever.x)
        GainsSagittal           = InitialGuess.GainsSagittal.*exp(bestever.x(1:idx1));
        initConditionsSagittal  = InitialGuess.initConditionsSagittal.*exp(bestever.x(idx1+1:idx2));
        GainsCoronal            = InitialGuess.GainsCoronal.*exp(bestever.x(idx2+1:idx3));
        initConditionsCoronal   = InitialGuess.initConditionsCoronal.*exp(bestever.x((idx3+1):idx4));
        CMGGains                = InitialGuessCMG.CMGGains;
    else
        GainsSagittal           = InitialGuess.GainsSagittal;
        initConditionsSagittal  = InitialGuess.initConditionsSagittal;
        GainsCoronal            = InitialGuess.GainsCoronal;
        initConditionsCoronal   = InitialGuess.initConditionsCoronal;
        CMGGains = InitialGuessCMG.CMGGains.*exp(bestever.x);
    end
    
    run([innerOptSettings.optimizationDir, filesep, 'BodyMechParamsCapture']);
    run([innerOptSettings.optimizationDir, filesep, 'ControlParamsCapture']);
    run([innerOptSettings.optimizationDir, filesep, 'Prosthesis3R60ParamsCapture']);
    run([innerOptSettings.optimizationDir, filesep, 'CMGParamsCapture']);
    run([innerOptSettings.optimizationDir, filesep, 'OptimParamsCapture']);
else
    BodyMechParams;
    ControlParams;
    Prosthesis3R60Params;
    OptimParams;
    CMGParams;
    setInitVar;
    innerOptSettings = setInnerOptSettings('eval');
    
    load(['Results'  filesep 'v1.2ms_wCMG.mat'])
    load(['Results' filesep 'CMGGains_tripprevent.mat']);
end

%%
model = 'NeuromuscularModel_3R60CMG_3D';
load_system(model);

%%
[groundX, groundZ, groundTheta] = generateGround('flat');

dt_visual = 1/1000;
animFrameRate = 30;

assignCMGGains;
assignGainsSagittal;
assignGainsCoronal;
assignInit;

%%
if contains(get_param(model,'SimulationMode'),'rapid')
    warning('off')
    rtp = Simulink.BlockDiagram.buildRapidAcceleratorTarget(model);
    warning('on');
    
    paramStruct = {};
    in = Simulink.SimulationInput(model);
    in = in.setModelParameter('TimeOut', innerOptSettings.timeOut);
    in = in.setModelParameter('SimulationMode', 'rapid', ...
        'RapidAcceleratorUpToDateCheck', 'off');
    in = in.setModelParameter('RapidAcceleratorParameterSets', paramSets{1});
    
end

%%
simout = parsim(in, 'ShowProgress', true);

%%
cost = nan(size(simout));
for idx = 1:length(simout)
    mData=simout(idx).getSimulationMetadata();
    
    if strcmp(mData.ExecutionInfo.StopEvent,'DiagnosticError')
        disp('Sim was stopped due to error');
        fprintf('Simulation %d was stopped due to error: \n',idx);
        disp(simout(idx).ErrorMessage);
        cost(idx) = nan;
    elseif strcmp(mData.ExecutionInfo.StopEvent,'Timeout')
        fprintf('Simulation %d was stopped due to Timeout: \n',idx);
        cost(idx) = nan;
    else
        [cost(idx), dataStructLocal] = getCost(model,[],simout(idx).time,simout(idx).metabolicEnergy,simout(idx).sumOfStopTorques,...
                                                simout(idx).HATPosVel,simout(idx).stepVelocities,simout(idx).stepTimes,...
                                                simout(idx).stepLengths,simout(idx).stepNumbers,simout(idx).CMGData,...
                                                simout(idx).selfCollision,innerOptSettings,0);
        printOptInfo(dataStructLocal,true);
        
        kinematics.angularData = simout(idx).angularData;
        kinematics.GaitPhaseData = simout(idx).GaitPhaseData;
        kinematics.time = simout(idx).time;
        kinematics.stepTimes = simout(idx).stepTimes;
        kinematics.musculoData = simout(idx).musculoData;
        kinematics.GRFData = simout(idx).GRFData;
        kinematics.CMGData = simout(idx).CMGData;
        kinematics.jointTorquesData = simout(idx).jointTorquesData;
        
        dataStructLocal.kinematics = kinematics;
        dataStructLocal.animData3D = simout((idx)).animData3D;
        dataStructLocal.optimCost = cost(idx);
        
        try
            dataStruct(idx) = dataStructLocal;
        catch
        end
    end
end

%% Animate and plot data
animPost3D(simout(1).animData3D,'intact',false,'speed',1,'obstacle',true,'view','perspective','CMG',true,...
            'createVideo',false,'info',[num2str(innerOptSettings.target_velocity) 'ms'],...
            'saveLocation',innerOptSettings.optimizationDir);

plotData(   simout(1).angularData,simout(1).musculoData,simout(1).GRFData,simout(1).jointTorquesData,...
            simout(1).GaitPhaseData,simout(1).stepTimes,simout(1).CMGData,'Trip prevent',[7 8],0,1,1,0);
