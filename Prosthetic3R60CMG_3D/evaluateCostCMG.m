% clc;
%%
tempstring = strsplit(opts.UserData,' ');
dataFile = tempstring{end};
InitialGuessFile = load(dataFile); 
% 
% % Gains = InitialGuessFile.Gains.*exp(bestever.x);
CMGGains = InitialGuessFile.CMGGains.*exp(bestever.x);

% compareenergies = load('compareEnergyCostTotal_Umb10_CMG.mat');

% idx_minCost = find(round(compareenergies.cost)==min(compareenergies.cost),1,'first');
% 
% idx_minCost = find(round(compareenergies.cost)==48),1,'first');
% CMGGains = compareenergies.Gains(idx_minCost,:)';
% CMGGains = GainsSave(1,:)';
%%
% load('Results/RoughDist/SongGainsamp.mat');
% load('Results/Flat/SongGains_02amp.mat');
% load('Results/RoughDist/SongGains_wC_IC.mat');
% load('Results/Rough/Umb10_1.5cm_1.2ms_Umb10_kneelim1_mstoptorque3.mat');

% load('Results/Rough/Umb10_1.5cm_1.2ms_kneelim1_mstoptorque2_wCMG.mat');
load('Results/Rough/Umb10_1.5cm_1.2ms_kneelim1_mstoptorque2.mat');

% load('Results/Rough/Umb10_1.5cm_0.9ms_kneelim1_mstoptorque2.mat');
load('Results/Flat/SongGains_02_wC_IC.mat');

% load('Results/optCMGGains_1_2ms_wmass.mat');
% load('Results/optCMGgains_1_2ms_lowerDH.mat');

assignCMGGains;
assignGains;


dt_visual = 1/50;
setInit;

[groundX, groundZ, groundTheta] = generateGround('flat');
% [groundX, groundZ, groundTheta] = generateGround('const', .05,1);
%[groundX, groundZ, groundTheta] = generateGround('ramp');

% LlegLengthClr = 0.95*LlegLengthClr;
% RGainLRFHFLsw = 5*RGainLRFHFLsw;
% RGainVRFHFLsw = 5*RGainVRFHFLsw;
% RlegLengthClr = 0.9*RlegLengthClr;
% RGainLGLUsw = 3*RGainLGLUsw;
%%
model = 'NeuromuscularModel_3R60_2D';

%%
[inner_opt_settings,~] = setInnerOptSettings();
% myModelBuildInfo = RTW.BuildInfo;
% addCompileFlags(myModelBuildInfo,{'/fp:precise'},'OPTS');
% getCompileFlags(myModelBuildInfo)
% % RTW.BuildInfo = myModelBuildInfo;
% getCompileFlags(RTW.BuildInfo)
%%
%open('NeuromuscularModel');
% set_param(model,'SimulationMode','normal');
% set_param(model,'StopTime','30');
% -ffloat-store
% AccelMakeCommand
% RTWMakeCommand
% RTWBuildArgs

% set_param(model,'RTWMakeCommand','make_rtw OPT_OPTS="-ffloat-store"');
warning('off');
tic;
sim(model)
toc;
warning('on');

%%
[cost, dataStruct] = getCost(model,Gains,time,metabolicEnergy,sumOfStopTorques,HATPos,stepVelocities,stepTimes,stepLengths,CMGData,inner_opt_settings,0);
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