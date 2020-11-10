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
%     clearvars -except CMGGains GainsSagittal initConditionsSagittal GainsCoronal initConditionsCoronal innerOptSettings
    
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
    
    %     load(['Results' filesep 'Rough' filesep 'Umb10_0.9ms_num_inter.mat'])
    %     load(['Results' filesep 'Rough' filesep 'Umb10_1.2ms_wheading_numsolve.mat'])
    load(['Results' filesep 'Rough' filesep 'v1.2ms_wCMG.mat'])
    load(['Results' filesep 'CMGGains_init.mat']);
end

terrains2Test = 1;%input("Number of terrains to test:   ");

%%
model = 'NeuromuscularModel_3R60CMG_3D';

load_system(model);
% set_param(model, 'OptimizationLevel','level2');
% set_param(strcat(model,'/Body Mechanics Layer/Right Ankle Joint'),'SpringStiffness','3000','DampingCoefficient','1000');

%%
[groundX, groundZ, groundTheta] = generateGround('flat');

dt_visual = 1/1000;
animFrameRate = 30;

assignCMGGains;
assignGainsSagittal;
assignGainsCoronal;
assignInit;

% try
%     set_param(strcat(model,'/Body Mechanics Layer/Obstacle'),'Commented','off');
% catch ME
%     warning(ME.message);
% end
% set_param(model, 'AccelVerboseBuild', 'off');
% set_param(model,'StopTime','20');
% save_system(model);

%%
if contains(get_param(model,'SimulationMode'),'rapid')
    warning('off')
    rtp = Simulink.BlockDiagram.buildRapidAcceleratorTarget(model);
    warning('on');
    
    %     obstacleX = 12.71:0.02:13.01;
    obstacleX = [];%[9.079:0.001:9.095];%[7.80:0.005:7.87,9.065:0.001:9.085];%13.04;%[13.04:0.005:13.06]; %13.04;
    if ~isempty(obstacleX)
        for jj = 1:length(obstacleX)
            %             if jj == 1
            %                 [groundX(jj,:), groundZ(jj,:), groundTheta(jj,:)] = generateGround('flat',[],4*(jj-1),false);
            %             else
            %                 [groundX(jj,:), groundZ(jj,:), groundTheta(jj,:)] = generateGround('const', innerOptSettings.terrain_height, 4*(jj-1),false);
            %             end
            %             paramSets{jj} = ...
            %                 Simulink.BlockDiagram.modifyTunableParameters(rtp, ...
            %                 'groundZ',     groundZ(jj,:), ...
            %                 'groundTheta', groundTheta(jj,:));
            paramSets{jj} = ...
                Simulink.BlockDiagram.modifyTunableParameters(rtp, ...
                'obstacle_x',     obstacleX(jj),...
                'tripDetectThreshold',     2000, ...
                 'RkneeFlexPosGain',     0, ...
                 'RkneeFlexSpeedGain',   0, ...
                 'TargetLegAngleTripFlex', 2/3*pi,...
                 'RkneeStopGain',        0, ...
                 'RkneeExtendGain',0);
            in(jj) = Simulink.SimulationInput(model);
            in(jj) = in(jj).setModelParameter('TimeOut', innerOptSettings.timeOut);
            in(jj) = in(jj).setModelParameter('SimulationMode', 'rapid', ...
                'RapidAcceleratorUpToDateCheck', 'off');
            in(jj) = in(jj).setModelParameter('RapidAcceleratorParameterSets', paramSets{jj});
        end
    else
        paramStruct = {};
        in = Simulink.SimulationInput(model);
        in = in.setModelParameter('TimeOut', innerOptSettings.timeOut);
%                 paramSets = ...
%                         Simulink.BlockDiagram.modifyTunableParameters(rtp, ...
%                         'tripDetectThreshold', 2000, ...
%                         'RkneeFlexPosGain',     0, ...
%                         'RkneeFlexSpeedGain',   0, ...
%                         'TargetLegAngleTripFlex', 2/3*pi,...
%                         'RkneeStopGain',        0, ...
%                         'RkneeExtendGain', 0);
        in = in.setModelParameter('SimulationMode', 'rapid', ...
            'RapidAcceleratorUpToDateCheck', 'off');
%                 in = in.setModelParameter('RapidAcceleratorParameterSets', paramSets);
        
    end
else
    paramStruct = {};
    in = Simulink.SimulationInput(model);
    in = in.setModelParameter('TimeOut', innerOptSettings.timeOut);
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
%     mData=simout(idx).getSimulationMetadata();
    
    if false%strcmp(mData.ExecutionInfo.StopEvent,'DiagnosticError')
        disp('Sim was stopped due to error');
        fprintf('Simulation %d was stopped due to error: \n',idx);
        disp(simout(idx).ErrorMessage);
        cost(idx) = nan;
    elseif false %strcmp(mData.ExecutionInfo.StopEvent,'Timeout')
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
        
        %         animPost3D(simout(idx).animData3D,'intact',false,'speed',1,'obstacle',true,'view','perspective','CMG',true,...
        %     'showFigure',true,'createVideo',true,'info',[num2str(innerOptSettings.target_velocity) 'ms_y_dt1000_' num2str(idx)],'saveLocation',innerOptSettings.optimizationDir);
        
        try
            dataStruct(idx) = dataStructLocal;
        catch
        end
    end
end

%%
animPost3D(simout(1).animData3D,'intact',false,'speed',1,'obstacle',true,'view','perspective','CMG',true,...
    'showFigure',true,'createVideo',false,'info',[num2str(innerOptSettings.target_velocity) 'ms_y_dt1000'],'saveLocation',innerOptSettings.optimizationDir);
% % %
% plotData(simout(1).angularData,simout(1).musculoData,simout(1).GRFData,simout(1).jointTorquesData,simout(1).GaitPhaseData,simout(1).stepTimes,simout(1).CMGData,'prosthetic3D_1.2ms_yaw',[],0,1,1)

%%
set(0, 'DefaultFigureHitTest','on');
set(0, 'DefaultAxesHitTest','on','DefaultAxesPickableParts','all');
set(0, 'DefaultLineHitTest','on','DefaultLinePickableParts','all');
set(0, 'DefaultPatchHitTest','on','DefaultPatchPickableParts','all');
set(0, 'DefaultStairHitTest','on','DefaultStairPickableParts','all');
set(0, 'DefaultLegendHitTest','on','DefaultLegendPickableParts','all');