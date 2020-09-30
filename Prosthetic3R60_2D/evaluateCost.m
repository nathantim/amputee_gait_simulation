% clc;
% % %
% tempstring = strsplit(opts.UserData,' ');
% dataFile = tempstring{end};
% InitialGuessFile = load(dataFile); 
% 
% GainsSagittal = InitialGuessFile.GainsSagittal.*exp(bestever.x(1:length(InitialGuessFile.GainsSagittal)));
% initConditionsSagittal = InitialGuessFile.initConditionsSagittal.*exp(bestever.x(length(InitialGuessFile.GainsSagittal)+1:end));


%%
% load('Results/RoughDist/SongGainsamp.mat');
% load('Results/Flat/SongGains_02amp.mat');

% load('Results/RoughDist/SongGains_wC_IC.mat');
% load('Results/Rough/Umb10_1.5cm_0.9ms_intermediate.mat');
% load('Results/Rough/Umb10_1.5cm_1.2ms_kneelim1_mstoptorque2.mat');


%%
model = 'NeuromuscularModel_3R60_2D';
load_system(model);
set_param(strcat(model,'/Body Mechanics Layer/Right Ankle Joint'),'SpringStiffness','3000','DampingCoefficient','1000');
set_param(strcat(model,'/Body Mechanics Layer/Obstacle'),'Commented','on');

%%
[inner_opt_settings,~] = setInnerOptSettings();

BodyMechParams;
ControlParams;
OptimParams;
Prosthesis3R60Params;
% initSignals;
setInitAmputee;

% assignInit;
assignGainsSagittal;

dt_visual = 1/30;

[groundX, groundZ, groundTheta] = generateGround('flat');
% [groundX, groundZ, groundTheta] = generateGround('const', .05,1);
%[groundX, groundZ, groundTheta] = generateGround('ramp');


%%
%open('NeuromuscularModel');
% set_param(model,'SimulationMode','normal');
% set_param(model,'StopTime','30');

warning('off');
tic;
sim(model)
toc;
warning('on');

%%
[~,dataStruct] = getCost(model,[],time,metabolicEnergy,sumOfStopTorques,HATPosVel,stepVelocities,stepTimes,stepLengths,stepNumbers,[],inner_opt_settings, 0);
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