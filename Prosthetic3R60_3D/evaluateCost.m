if  (input("Do you want to clear the data? (1/0)   "))
%     close all;  
    clearvars;  clc;
end

%%
if input("Load from optimization folder? (1/0)   " )
    inner_opt_settings = setInnerOptSettings('yes');
    disp(inner_opt_settings.optimizationDir);
    
    load([inner_opt_settings.optimizationDir filesep 'variablescmaes.mat']);
    InitialGuess = load([inner_opt_settings.optimizationDir filesep 'initial_gains.mat']);
    
    idx1 = length(InitialGuess.GainsSagittal);
    idx2 = idx1 + length(InitialGuess.initConditionsSagittal);
    idx3 = idx2 + length(InitialGuess.GainsCoronal);
    idx4 = idx3 + length(InitialGuess.initConditionsCoronal);
    
    GainsSagittal = InitialGuess.GainsSagittal.*exp(bestever.x(1:idx1));
    initConditionsSagittal = InitialGuess.initConditionsSagittal.*exp(bestever.x(idx1+1:idx2));
    
    GainsCoronal = InitialGuess.GainsCoronal.*exp(bestever.x(idx2+1:idx3));
    initConditionsCoronal = InitialGuess.initConditionsCoronal.*exp(bestever.x((idx3+1):idx4));
    
    run([inner_opt_settings.optimizationDir, filesep, 'BodyMechParamsCapture']);
    run([inner_opt_settings.optimizationDir, filesep, 'ControlParamsCapture']);
    run([inner_opt_settings.optimizationDir, filesep, 'Prosthesis3R60ParamsCapture']);
    run([inner_opt_settings.optimizationDir, filesep, 'OptimParamsCapture']);
    
else
    BodyMechParams;
    ControlParams;
    Prosthesis3R60Params;
    OptimParams;
    inner_opt_settings = setInnerOptSettings('eval');
    
    load(['Results' filesep 'Rough' filesep 'Umb10_0.9ms_wheading.mat'])
%     load(['Results' filesep 'Rough' filesep 'Umb10_1.2ms_wheading.mat'])
    
end

terrains2Test = input("Number of terrains to test:   ");

%%
model = 'NeuromuscularModel_3R60_3D';

load_system(model);
% set_param(model, 'OptimizationLevel','level2');
% set_param(strcat(model,'/Body Mechanics Layer/Right Ankle Joint'),'SpringStiffness','3000','DampingCoefficient','1000');

%%
[groundX, groundZ, groundTheta] = generateGround('flat');

dt_visual = 1/1000;
animFrameRate = 30;

assignGainsSagittal;
assignGainsCoronal;
assignInit;


% set_param(model, 'AccelVerboseBuild', 'off');
% save_system(model);

%%
if contains(get_param(model,'SimulationMode'),'rapid')
    rtp = Simulink.BlockDiagram.buildRapidAcceleratorTarget(model);
    
    for jj = 0:(terrains2Test-1)
            if jj == 0
                [~, groundZ, groundTheta] = generateGround('flat',[],4*jj,false);
            else
                [~, groundZ, groundTheta] = generateGround('const', inner_opt_settings.terrain_height, 4*jj,false);
            end
            paramSets{jj+1} = ...
                Simulink.BlockDiagram.modifyTunableParameters(rtp, ...
                'groundZ',     groundZ, ...
                'groundTheta', groundTheta);
    end   
else
    paramStruct = [];
end

%%
parfor ii = 1:length(paramSets)
    tic;
    simout(ii) = sim(model,...
        'RapidAcceleratorParameterSets',paramSets{ii},...
        'RapidAcceleratorUpToDateCheck','off',...
        'TimeOut',20*60,...
        'SaveOutput','on');
    toc; 
end

%%
for idx = 1:length(simout)
   [cost(idx), dataStruct(idx)] = getCost(model,[],simout(idx).time,simout(idx).metabolicEnergy,simout(idx).sumOfStopTorques,simout(idx).HATPosVel,simout(idx).stepVelocities,simout(idx).stepTimes,simout(idx).stepLengths,simout(idx).stepNumbers,[],simout(idx).selfCollision,inner_opt_settings,0);
    printOptInfo(dataStruct(idx),true); 
end

%  animPost3D(simout(4).animData3D,'intact',false,'speed',1,'obstacle',false,'view','perspective','CMG',false,...
%                 'showFigure',true,'createVideo',false,'info','prosthetic1.2ms_y','saveLocation',inner_opt_settings.optimizationDir);
            
% plotData(simout(1).angularData,simout(1).musculoData,simout(1).GRFData,simout(1).jointTorquesData,simout(1).GaitPhaseData,simout(1).stepTimes,[],'prosthetic3D_1.2ms_yaw',[],0,1,1)
%%
set(0, 'DefaultFigureHitTest','on');
set(0, 'DefaultAxesHitTest','on','DefaultAxesPickableParts','all');
set(0, 'DefaultLineHitTest','on','DefaultLinePickableParts','all');
set(0, 'DefaultPatchHitTest','on','DefaultPatchPickableParts','all');
set(0, 'DefaultStairHitTest','on','DefaultStairPickableParts','all');
set(0, 'DefaultLegendHitTest','on','DefaultLegendPickableParts','all');