% clc;
%% Check results from vcmaes file
if true
    inner_opt_settings = setInnerOptSettings('yes');
    disp(inner_opt_settings.optimizationDir);
    
    load([inner_opt_settings.optimizationDir filesep 'vcmaes.mat']);
    
    tempstring = strsplit(opts.UserData,' ');
    dataFile = tempstring{end};
    % dataFile =  'Results/Rough/Umb10_1.5cm_0.9ms_difffoot_higherabd_inter.mat';
    InitialGuess = load(dataFile);
    % % InitialGuess = InitialGuessFile.Gains([39:47,53:55,58,59,69,70,80,81,101:109,115:117,120:121,126,127,132,133]);
    %
    % %
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
    run([inner_opt_settings.optimizationDir, filesep, 'OptimParamsCapture']);
    
else
    BodyMechParams;
    ControlParams;
    OptimParams;
    %%
    % load('Results/Rough/SongGains_wC.mat');
    % load('Results/Rough/SongGains_wC_IC.mat');
    % load('Results/Flat/song3Dopt.mat' );
    % load('Results/Rough/Umb10_1.5cm_0.9ms_kneelim1_mstoptorque2.mat');
    
    % load('Results/Flat/SongGains_02_wC_IC.mat');
    % load('Results/Rough/1.3msinter.mat');
end

%%
model = 'NeuromuscularModel3D';

%%
% inner_opt_settings = setInnerOptSettings();
[groundX, groundZ, groundTheta] = generateGround('flat');

dt_visual = 1/30;

assignGainsSagittal;
assignGainsCoronal;
assignInit;
%open('NeuromuscularModel');
% set_param(model,'SimulationMode','normal');
% set_param(model,'StopTime','30');


%%

warning('off');
tic;
sim(model)
toc;
warning('on');

%%
[cost, dataStruct] = getCost(model,[],time,metabolicEnergy,sumOfStopTorques,HATPosVel,stepVelocities,stepTimes,stepLengths,stepNumbers,[],selfCollision,inner_opt_settings,0);
printOptInfo(dataStruct,true);

%%
% kinematics.angularData = angularData;
% kinematics.GaitPhaseData = GaitPhaseData;
% kinematics.time = time;
% kinematics.stepTimes = stepTimes;
% kinematics.musculoData = musculoData;
% kinematics.GRFData = GRFData;
% dataStruct.kinematics = kinematics;
% save('dataStruct.mat','dataStruct')
% 
% %%
set(0, 'DefaultFigureHitTest','on');
set(0, 'DefaultAxesHitTest','on','DefaultAxesPickableParts','all');
set(0, 'DefaultLineHitTest','on','DefaultLinePickableParts','all');
set(0, 'DefaultPatchHitTest','on','DefaultPatchPickableParts','all');
set(0, 'DefaultStairHitTest','on','DefaultStairPickableParts','all');
set(0, 'DefaultLegendHitTest','on','DefaultLegendPickableParts','all');