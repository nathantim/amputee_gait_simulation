if  (input("Do you want to clear the data? (1/0)   "))
%     close all;  
    clearvars;  clc;
end

%%
if input("Load from optimization folder? (1/0)   " )
    innerOptSettings = setInnerOptSettings('yes');
    disp(innerOptSettings.optimizationDir);
    
    load([innerOptSettings.optimizationDir filesep 'variablescmaes.mat']);
    InitialGuess = load([innerOptSettings.optimizationDir filesep 'initial_gains.mat']);
    
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
    run([innerOptSettings.optimizationDir, filesep, 'Prosthesis3R60ParamsCapture']);
    run([inner_opt_settings.optimizationDir, filesep, 'CMGParamsCapture']);
    run([innerOptSettings.optimizationDir, filesep, 'OptimParamsCapture']);
    
else
    BodyMechParams;
    ControlParams;
    Prosthesis3R60Params;
    OptimParams;
    CMGParams;
    setInitVar;
    innerOptSettings = setInnerOptSettings('eval');
    
%     load(['Results' filesep 'Rough' filesep 'Umb10_0.9ms_num_inter.mat'])
    load(['Results' filesep 'Rough' filesep 'Umb10_1.2ms_wheading.mat'])
    
end

terrains2Test = input("Number of terrains to test:   ");

%%
model = 'NeuromuscularModel_3R60_3D';

load_system(model);
% set_param(model, 'OptimizationLevel','level2');
% set_param(strcat(model,'/Body Mechanics Layer/Right Ankle Joint'),'SpringStiffness','3000','DampingCoefficient','1000');

%%
[groundX, groundZ, groundTheta] = generateGround('flat');

dt_visual = 1/30;
animFrameRate = 30;

assignGainsSagittal;
assignGainsCoronal;
assignInit;

% set_param(model, 'AccelVerboseBuild', 'off');
% save_system(model);

%%
if contains(get_param(model,'SimulationMode'),'rapid')
    warning('off')
    rtp = Simulink.BlockDiagram.buildRapidAcceleratorTarget(model);
    warning('on');
    
    for jj = 1:(terrains2Test)
            if jj == 1
                [groundX(jj,:), groundZ(jj,:), groundTheta(jj,:)] = generateGround('flat',[],4*(jj-1),false);
            else
                [groundX(jj,:), groundZ(jj,:), groundTheta(jj,:)] = generateGround('const', innerOptSettings.terrain_height, 4*(jj-1),false);
            end
            paramSets{jj} = ...
                Simulink.BlockDiagram.modifyTunableParameters(rtp, ...
                'groundZ',     groundZ(jj,:), ...
                'groundTheta', groundTheta(jj,:));
            in(jj) = Simulink.SimulationInput(model);
            in(jj) = in(jj).setModelParameter('TimeOut', 10*60);
            in(jj) = in(jj).setModelParameter('SimulationMode', 'rapid', ...
                'RapidAcceleratorUpToDateCheck', 'off');
            in(jj) = in(jj).setModelParameter('RapidAcceleratorParameterSets', paramSets{jj});
    end   
else
    paramStruct = [];
end

%%
% parfor ii = 1:length(paramSets)
%     tic;
%     simout(ii) = sim(model,...
%         'RapidAcceleratorParameterSets',paramSets{ii},...
%         'RapidAcceleratorUpToDateCheck','off',...
%         'TimeOut',10*60,...
%         'SaveOutput','on');
%     toc;
% end
simout = parsim(in, 'ShowProgress', true);

%%
for idx = 1:length(simout)
    mData=simout(idx).getSimulationMetadata();
    
    if strcmp(mData.ExecutionInfo.StopEvent,'DiagnosticError') || strcmp(mData.ExecutionInfo.StopEvent,'TimeOut')
        disp('Sim was stopped due to error');
        fprintf('Simulation %d was stopped due to error: \n',idx);
        disp(simout(idx).ErrorMessage);
        cost(idx) = nan;
    else
        [cost(idx), dataStructLocal] = getCost(model,[],simout(idx).time,simout(idx).metabolicEnergy,simout(idx).sumOfStopTorques,simout(idx).HATPosVel,simout(idx).stepVelocities,simout(idx).stepTimes,simout(idx).stepLengths,simout(idx).stepNumbers,[],simout(idx).selfCollision,innerOptSettings,0);
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

%%
%  animPost3D(simout(1).animData3D,'intact',false,'speed',1,'obstacle',false,'view','perspective','CMG',false,...
%                 'showFigure',true,'createVideo',true,'info',[num2str(innerOptSettings.target_velocity) 'ms_y_dt1000'],'saveLocation',innerOptSettings.optimizationDir);
            
plotData(simout(1).angularData,simout(1).musculoData,simout(1).GRFData,simout(1).jointTorquesData,simout(1).GaitPhaseData,simout(1).stepTimes,[],'prosthetic3D_1.2ms_yaw',[],0,1,1)
%%
set(0, 'DefaultFigureHitTest','on');
set(0, 'DefaultAxesHitTest','on','DefaultAxesPickableParts','all');
set(0, 'DefaultLineHitTest','on','DefaultLinePickableParts','all');
set(0, 'DefaultPatchHitTest','on','DefaultPatchPickableParts','all');
set(0, 'DefaultStairHitTest','on','DefaultStairPickableParts','all');
set(0, 'DefaultLegendHitTest','on','DefaultLegendPickableParts','all');