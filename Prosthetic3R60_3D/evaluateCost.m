% clc;
%%
% tempstring = strsplit(opts.UserData,' ');
% dataFile = tempstring{end};
% InitialGuessFile = load(dataFile); 
% 
% Gains = InitialGuessFile.Gains.*exp(bestever.x);
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
% load('Results/Flat/SongGains_02amp_wC.mat');

% load('Results/RoughDist/SongGains_wC_IC.mat');
load('Results/Rough/Umb10_1.5cm_0.9ms_kneelim1_mstoptorque2.mat');
load('Results/Flat/SongGains_02_wC_IC.mat');
% Gains(94) = 2*Gains(94);
% Gains(101) = 1*Gains(101);
% Gains(108) = 1*Gains(108);
% Gains(109) = 0.01*Gains(109);
assignGains;
dt_visual = 1/50;
setInit;

[groundX, groundZ, groundTheta] = generateGround('flat');
% [groundX, groundZ, groundTheta] = generateGround('const', .05,1);

%%
model = 'NeuromuscularModel_3R60_3D';
load_system(model);

modelwspace = get_param(model,'ModelWorkspace');
modelwspace.DataSource = 'MATLAB File';
modelwspace.Filename = [pwd,'\setVars.m'];
modelwspace.saveToSource;

prepend = [model,'/Neural Control Layer/'];
set_param( [prepend,'SDelay46'],'InitialOutput', '0'); %LStimHAB
set_param( [prepend,'SDelay40'],'InitialOutput', '0'); %LStimHAD
set_param( [prepend,'SDelay35'],'InitialOutput', '0'); %RStimHAB
set_param( [prepend,'SDelay37'],'InitialOutput', '0'); %RStimHAD

set_param( [prepend,'SDelay20'],'InitialOutput', '0'); %LPreStimHFLst
set_param( [prepend,'SDelay21'],'InitialOutput', '0'); %LPreStimGLUst
set_param( [prepend,'SDelay22'],'InitialOutput', '0'); %LPreStimHAMst
set_param( [prepend,'SDelay23'],'InitialOutput', '0'); %LPreStimRFst
set_param( [prepend,'MDelay9'] ,'InitialOutput', '0'); %LPreStimVASst
set_param( [prepend,'MDelay10'],'InitialOutput', '0'); %LPreStimBFSHst
set_param( [prepend,'LDelay11'],'InitialOutput', '0'); %LPreStimGASst
set_param( [prepend,'LDelay9'] ,'InitialOutput', '0'); %LPreStimSOLst
set_param( [prepend,'LDelay10'],'InitialOutput', '0'); %LPreStimTAst
set_param( [prepend,'SDelay24'],'InitialOutput', '0'); %RPreStimHFLsw
set_param( [prepend,'SDelay25'],'InitialOutput', '0'); %RPreStimGLUsw
set_param( [prepend,'SDelay26'],'InitialOutput', '0'); %RPreStimHAMsw
set_param( [prepend,'SDelay27'],'InitialOutput', '0'); %RPreStimRFsw

% modelwspace = get_param(model,'ModelWorkspace');
% modelwspace.DataSource = 'MATLAB File';
% modelwspace.Filename = [pwd,'/setVars.m'];
% modelwspace.saveToSource;
%%
inner_opt_settings = setInnerOptSettings();
set_param(model,'SimulationMode','accelerator');
set_param(model,'StopTime','30');


%%
save_system(model);
% warning('off');
tic;
out = sim(model);
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