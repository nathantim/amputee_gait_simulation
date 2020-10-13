% clc;
%%


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



% compareenergies = load('compareEnergyCostTotal_Umb10_prost.mat');
% 
% % 
% idx_minCost = find(round(compareenergies.cost,2)==93,1,'first');
% Gains = compareenergies.Gains(idx_minCost,:)';
% 

%%
% load('Results/RoughDist/SongGains_wC.mat');
% load('Results/Flat/SongGains_02amp_wC.mat');
% load('Results/Flat/Umb10nodimmuscleforce2D_C3D.mat');
% load('Results/Rough/Prosthetic2D_C3D.mat');
% load('Results/Rough/Umb10_0.9_ms_3D_partlyopt.mat');

% load('Results/Rough/Umb10_1.5cm_1.2ms_kneelim1_mstoptorque2.mat');
% load('Results/Rough/Umb10_1.5cm_0.9ms_kneelim1_mstoptorque2_2Dopt.mat');

% load('Results/Rough/Umb10_1.2ms_difffoot_higherabd.mat');


%%
model = 'NeuromuscularModel_3R60_3D';

load_system(model);
set_param(strcat(model,'/Body Mechanics Layer/Right Ankle Joint'),'SpringStiffness','3000','DampingCoefficient','1000');

%%
inner_opt_settings = setInnerOptSettings();
assignGainsSagittal;
assignGainsCoronal;


dt_visual = 1/30;

assignInit;
[groundX, groundZ, groundTheta] = generateGround('flat');
% [groundX, groundZ, groundTheta] = generateGround('const', .05,1);
% [groundX, groundZ, groundTheta] = generateGround('const', inner_opt_settings.terrain_height, 1,true);
%[groundX, groundZ, groundTheta] = generateGround('ramp');

%open('NeuromuscularModel');
% set_param(model,'SimulationMode','normal');
% set_param(model,'StopTime','30');

set_param(model, 'AccelVerboseBuild', 'off');
save_system(model);


%%
warning('off');
tic;
sim(model)
toc;
warning('on');

%%
% [cost, dataStruct] = getCost(model,[],time,metabolicEnergy,sumOfStopTorques,HATPosVel,stepVelocities,stepTimes,stepLengths,stepNumbers,[],inner_opt_settings,0);
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