% clc;
%
tempstring = strsplit(opts.UserData,' ');
dataFile = tempstring{end};
InitialGuessFile = load(dataFile); 

GainsSagittal = InitialGuessFile.Gains.*exp(bestever.x);

%%
% load('Results/RoughDist/SongGainsamp.mat');
% load('Results/Flat/SongGains_02amp.mat');

% load('Results/RoughDist/SongGains_wC_IC.mat');
load('Results/Rough/Umb10_1.5cm_0.9ms_kneelim1_mstoptorque2.mat');
% load('Results/Rough/Umb10_1.5cm_1.2ms_kneelim1_mstoptorque2.mat');
load('Results/Flat/SongGains_02_wC_IC.mat');

assignGainsSagittal;
dt_visual = 1/50;

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
setInitAmputee;

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