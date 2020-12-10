if  (input("Do you want to clear the data? (1/0)   "))
    clearvars;  clc;
end

%% Load settings
model = 'NeuromuscularModel3D';

if input("Load from optimization folder? (1/0)   " )
    innerOptSettings = setInnerOptSettings(model,'resume','yes');
    disp(innerOptSettings.optimizationDir);
    
    load([innerOptSettings.optimizationDir filesep 'variablescmaes.mat']);
    InitialGuess = load([innerOptSettings.optimizationDir filesep 'initialGains.mat']);
    
    idx1 = length(InitialGuess.GainsSagittal);
    idx2 = idx1 + length(InitialGuess.initConditionsSagittal);
    idx3 = idx2 + length(InitialGuess.GainsCoronal);
    idx4 = idx3 + length(InitialGuess.initConditionsCoronal);
    
    GainsSagittal = InitialGuess.GainsSagittal.*exp(bestever.x(1:idx1));
    initConditionsSagittal = InitialGuess.initConditionsSagittal.*exp(bestever.x(idx1+1:idx2));
    
    GainsCoronal = InitialGuess.GainsCoronal.*exp(bestever.x(idx2+1:idx3));
    initConditionsCoronal = InitialGuess.initConditionsCoronal.*exp(bestever.x((idx3+1):idx4));
    
    run([innerOptSettings.optimizationDir, filesep, 'BodyMechParamsCapture']);
    run([innerOptSettings.optimizationDir, filesep, 'ControlParamsCapture']);
    
else
    innerOptSettings = setInnerOptSettings(model,'resume','eval','targetVelocity', 0.9);
    BodyMechParams;
    ControlParams;                                                
    load(['Results' filesep 'v0.9ms.mat']);

end

terrains2Test = input("Number of terrains to test:   ");

%% Load model, create ground, set gains
load_system(model);
[groundX, groundZ, groundTheta] = generateGround('flat');

dt_visual = 1/1000;
animFrameRate = 30;

assignGainsSagittal;
assignGainsCoronal;
assignInit;

%% Building rapid accelerator target
warning('off')
rtp = Simulink.BlockDiagram.buildRapidAcceleratorTarget(model);
warning('on');

for jj = 1:(terrains2Test)
    if jj == 1
        [groundX(jj,:), groundZ(jj,:), groundTheta(jj,:)] = generateGround('flat',[],4*(jj-1),false);
    else
        [groundX(jj,:), groundZ(jj,:), groundTheta(jj,:)] = generateGround('const', innerOptSettings.terrainHeight, 4*(jj-1),false);
    end
    paramSets{jj} = ...
        Simulink.BlockDiagram.modifyTunableParameters(rtp, ...
        'groundZ',     groundZ(jj,:), ...
        'groundTheta', groundTheta(jj,:));
    in(jj) = Simulink.SimulationInput(model);
    in(jj) = in(jj).setModelParameter('TimeOut', 10*60);
    in(jj) = in(jj).setModelParameter('SimulationMode', 'rapid', ...
        'RapidAcceleratorUpToDateCheck', 'off');
    in(jj) = in(jj).setModelParameter('StopTime', '30');
    in(jj) = in(jj).setModelParameter('RapidAcceleratorParameterSets', paramSets{jj});
end


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
    
    if strcmp(mData.ExecutionInfo.StopEvent,'DiagnosticError') || strcmp(mData.ExecutionInfo.StopEvent,'TimeOut')
        disp('Sim was stopped due to error');
        fprintf('Simulation %d was stopped due to error: \n',idxSim);
        disp(simout(idxSim).ErrorMessage);
        cost(idxSim) = nan;
    else
        [cost(idxSim), dataStructLocal] = getCost(model,[],simout(idxSim).time,simout(idxSim).metabolicEnergy,simout(idxSim).sumOfStopTorques,simout(idxSim).HATPosVel,...
                                                simout(idxSim).stepTimes,simout(idxSim).stepLengths,simout(idxSim).stepNumbers,simout(idxSim).CMGData,mData.ExecutionInfo.StopEvent,...
                                                innerOptSettings,0);
        printOptInfo(dataStructLocal,true);
        
        kinematics.angularData = simout(idxSim).angularData;
        kinematics.GaitPhaseData = simout(idxSim).GaitPhaseData;
        kinematics.time = simout(idxSim).time;
        kinematics.stepTimes = simout(idxSim).stepTimes;
        kinematics.musculoData = simout(idxSim).musculoData;
        kinematics.GRFData = simout(idxSim).GRFData;
        kinematics.CMGData = simout(idxSim).CMGData;
        kinematics.jointTorquesData = simout(idxSim).jointTorquesData;
        
        dataStructLocal.kinematics = kinematics;
        dataStructLocal.animData3D = simout((idxSim)).animData3D;
        dataStructLocal.optimCost = cost(idxSim);
        try
            dataStruct(idxSim) = dataStructLocal;
        catch
        end
    end
end

%% Animate and plot data
 animPost(simout(1).animData3D,'intact',true,'speed',1,'view','perspective',...
                'showFigure',true,'createVideo',false,'info',[num2str(innerOptSettings.targetVelocity) 'ms'],'saveLocation',innerOptSettings.optimizationDir);
            
plotData(simout(1).GaitPhaseData, simout(1).stepTimes,...
    'angularData',simout(1).angularData, 'musculoData',simout(1).musculoData, ...
    'GRFData',simout(1).GRFData, 'jointTorquesData',simout(1).jointTorquesData, 'info',' ', 'saveFigure', false);