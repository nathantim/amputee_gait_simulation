% clc;
%%
% load('Results/Rough/Prosthetic2D_C3D.mat');
% assignGains;

% tempstring = strsplit(opts.UserData,' ');
% dataFile = tempstring{end};
% InitialGuessFile = load(dataFile); 
% InitialGuess = InitialGuessFile.Gains([39:47,53:55,58,59,69,70,80,81,101:109,115:117,120:121,126,127,132,133]);
% GainsSagittal = InitialGuessFile.Gains([1:38,48:52,56:57,60:68,71:79,82:100,110:114,118:119,122:125,128:131]);
% 
% GainsCoronal = InitialGuess.*exp(bestever.x);

% load('Results/Flat/GeyerHerrInit.mat');
% load('Results/Flat/optandGeyerHerrInit.mat');
% load('Results/Flat/SCONE.mat');
% load('Results/Flat/v_0.5m_s.mat');
% load('Results/Flat/v_0.8m_s.mat');
% load('Results/Flat/v_1.1m_s.mat');
% load('Results/Flat/v_1.4m_s.mat');
% load('Results/Flat/optUmb10stanceswing1_3ms_prestim.mat');

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
load('Results/Rough/Umb10_1.5cm_0.9ms_kneelim1_mstoptorque2_2Dopt.mat');
assignGainsSagittal;
assignGainsCoronal;
% load('Results/RoughDist/SongGains_wC_IC.mat');
load('Results/Flat/SongGains_02_wC_IC.mat');
% Gains(94) = 2*Gains(94);
% Gains(101) = 1*Gains(101);
% Gains(108) = 1*Gains(108);
% Gains(109) = 0.01*Gains(109);
% assignGains;
dt_visual = 1/30;
setInit;


%%
model = 'NeuromuscularModel_3R60_3D';

load_system(model);
set_param(strcat(model,'/Body Mechanics Layer/Right Ankle Joint'),'SpringStiffness','3000','DampingCoefficient','1000');

%%
inner_opt_settings = setInnerOptSettings();
[groundX, groundZ, groundTheta] = generateGround('flat');
% [groundX, groundZ, groundTheta] = generateGround('const', .05,1);
% [groundX, groundZ, groundTheta] = generateGround('const', inner_opt_settings.terrain_height, 1,true);
%[groundX, groundZ, groundTheta] = generateGround('ramp');

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
[cost, dataStruct] = getCost(model,Gains,time,metabolicEnergy,sumOfStopTorques,HATPos,stepVelocities,stepTimes,stepLengths,inner_opt_settings,0);
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