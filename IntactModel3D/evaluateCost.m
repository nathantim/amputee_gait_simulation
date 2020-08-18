% clc;
%%
tempstring = strsplit(opts.UserData,' ');
dataFile = tempstring{end};
InitialGuessFile = load(dataFile); 
% 
Gains = InitialGuessFile.Gains.*exp(bestever.x);
% load('Results/Flat/GeyerHerrInit.mat');
% load('Results/Flat/optandGeyerHerrInit.mat');
% load('Results/Flat/SCONE.mat');
% load('Results/Flat/v_0.5m_s.mat');
% load('Results/Flat/v_0.8m_s.mat');
% load('Results/Flat/v_1.1m_s.mat');
% load('Results/Flat/v_1.4m_s.mat');
% load('Results/Flat/optUmb10stanceswing1_3ms_prestim.mat');

% compareenergies = load('compareEnergyCostTotal.mat');

% 
% idx_minCost = find(compareenergies.cost==min(compareenergies.cost),1,'first');
% Gains2 = compareenergies.Gains(idx_minCost,:)';
% 

%%
% load('Results/RoughDist/SongGains_wC.mat');
% load('Results/RoughDist/SongGains_wC_IC.mat');
load('Results/Flat/Umb10_SONG3D_kneelim1_2.mat')
% load('Results/Flat/SongGains_02_wC.mat');
load('Results/Flat/SongGains_02_wC_IC.mat');


assignGains;
dt_visual = 1/50;
setInit;

%%
model = 'NeuromuscularModel3D';
load_system(model);

modelwspace = get_param(model,'ModelWorkspace');
modelwspace.DataSource = 'MATLAB File';
modelwspace.Filename = [pwd,'/setVars.m'];
modelwspace.saveToSource;

%%
inner_opt_settings = setInnerOptSettings();
set_param(model,'SimulationMode','accelerator');
set_param(model,'StopTime','30');

%%
save_system(model);
% warning('off');
tic;
sim(model)
toc;
% warning('on');

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