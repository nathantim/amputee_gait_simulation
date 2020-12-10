if  (input("Do you want to clear the data? (1/0)   "))
    clearvars;  clc;
end

%% Load settings
model = 'NeuromuscularModel_3R60CMG_3D';

if input("Load from optimization folder? (1/0)   " )
    innerOptSettings = setInnerOptSettings(model,'resume','yes');
    disp(innerOptSettings.optimizationDir);
    
    load([innerOptSettings.optimizationDir filesep 'variablescmaes.mat'],'bestever');
    InitialGuess = load([innerOptSettings.optimizationDir filesep 'initialGains.mat']);
    idx1 = length(InitialGuess.GainsSagittal);
    idx2 = idx1 + length(InitialGuess.initConditionsSagittal);
    idx3 = idx2 + length(InitialGuess.GainsCoronal);
    idx4 = idx3 + length(InitialGuess.initConditionsCoronal);
    
    
    InitialGuessCMG = load([innerOptSettings.optimizationDir filesep 'initialGainsCMG.mat']);
    
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
else
    innerOptSettings = setInnerOptSettings(model,'resume','eval', 'targetVelocity',1.2, 'timeOut',35*60);
    BodyMechParams;
    ControlParams;
    Prosthesis3R60Params;
    CMGParams;
    setInitVar;
    
    load(['Results'  filesep 'v1.2ms_wCMG.mat'])
    load(['Results' filesep 'CMGGains_tripprevent.mat']);
end

%% Load model, create ground, set gains
load_system(model);
set_param(strcat(model,'/Body Mechanics Layer/Obstacle'),'Commented','off');

[groundX, groundZ, groundTheta] = generateGround('flat');

dt_visual = 1/1000;
animFrameRate = 30;

assignCMGGains;
assignGainsSagittal;
assignGainsCoronal;
assignInit;

%% Building rapid accelerator target
save_system(model);
warning('off')
rtp = Simulink.BlockDiagram.buildRapidAcceleratorTarget(model);
warning('on');

%% Construct input
paramSets = {};
in = Simulink.SimulationInput(model);
in = in.setModelParameter('TimeOut', innerOptSettings.timeOut);
in = in.setModelParameter('SimulationMode', 'rapid', ...
    'RapidAcceleratorUpToDateCheck', 'off');
in = in.setModelParameter('StopTime', '20');
in = in.setModelParameter('RapidAcceleratorParameterSets', paramSets);

%% Simulate model
simout = parsim(in, 'ShowProgress', true);

%% Obtain cost function values
dataStruct(1:length(simout)) = struct('modelType',[],'timeCost',struct('data',[],'minimize',1,'info',''),'cost',struct('data',nan,'minimize',1,'info',''),'CoT',struct('data',[],'minimize',1,'info',[]),...
        'E',struct('data',[],'minimize',1,'info',[]),'sumTstop',struct('data',[],'minimize',1,'info',''),...
        'HATPos',struct('data',[],'minimize',0,'info',''),'vMean',struct('data',[],'minimize',0,'info',''),...
        'stepLengthASIstruct',struct('data',[],'minimize',2,'info',''),...
        'stepTimeASIstruct',struct('data',[],'minimize',2,'info',''),'velCost',struct('data',[],'minimize',1,'info',''),'timeVector',struct('data',[],'minimize',1,'info',''),...
        'maxCMGTorque',struct('data',[],'minimize',1,'info',''),'maxCMGdeltaH',struct('data',[],'minimize',1,'info',''),'controlRMSE',struct('data',[],'minimize',1,'info',''),...
        'tripWasActive',struct('data',[],'minimize',1,'info',''),...
        'innerOptSettings',innerOptSettings,'Gains',[],'kinematics',[],'animData3D',[]);
cost = nan(length(simout),1);

for idxSim = 1:length(simout)
    mData=simout(idxSim).getSimulationMetadata();
    
    if strcmp(mData.ExecutionInfo.StopEvent,'DiagnosticError')
        disp('Sim was stopped due to error');
        fprintf('Simulation %d was stopped due to error: \n',idxSim);
        disp(simout(idxSim).ErrorMessage);
        cost(idxSim) = nan;
    elseif strcmp(mData.ExecutionInfo.StopEvent,'Timeout')
        fprintf('Simulation %d was stopped due to Timeout: \n',idxSim);
        cost(idxSim) = nan;
    else
        [cost(idxSim), dataStructLocal] = getCost(model,[],simout(idxSim).time,simout(idxSim).metabolicEnergy,simout(idxSim).sumOfStopTorques,simout(idxSim).HATPosVel,...
            simout(idxSim).stepTimes,simout(idxSim).stepLengths,simout(idxSim).stepNumbers,simout(idxSim).CMGData,mData.ExecutionInfo.StopEvent,...
            innerOptSettings,0);
        printOptInfo(dataStructLocal,true);
        
        kinematics.angularData      = simout(idxSim).angularData;
        kinematics.GaitPhaseData    = simout(idxSim).GaitPhaseData;
        kinematics.time             = simout(idxSim).time;
        kinematics.stepTimes        = simout(idxSim).stepTimes;
        kinematics.musculoData      = simout(idxSim).musculoData;
        kinematics.GRFData          = simout(idxSim).GRFData;
        kinematics.CMGData          = simout(idxSim).CMGData;
        kinematics.jointTorquesData = simout(idxSim).jointTorquesData;
        
        dataStructLocal.kinematics  = kinematics;
        dataStructLocal.animData3D  = simout((idxSim)).animData3D;
        dataStructLocal.optimCost   = cost(idxSim);
        
        try
            dataStruct(idxSim) = dataStructLocal;
        catch
        end
    end
end

%% Animate and plot data
animPost(simout(1).animData3D,'intact',false,'speed',1,'obstacle',true,'view','perspective','CMG',true,...
    'createVideo',false,'info',[num2str(innerOptSettings.targetVelocity) 'ms'],...
    'saveLocation',innerOptSettings.optimizationDir);

plotData(simout(1).GaitPhaseData, simout(1).stepTimes,...
    'angularData',simout(1).angularData, 'musculoData',simout(1).musculoData, ...
    'GRFData',simout(1).GRFData, 'jointTorquesData',simout(1).jointTorquesData,...
    'CMGData',simout(1).CMGData, 'info','Trip prevent', 'saveFigure', false,...
    'showAverageStride', false, 'timeInterval',[7 8]);
