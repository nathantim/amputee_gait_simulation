% clc;
%%
% tempstring = strsplit(opts.UserData,' ');
% dataFile = tempstring{end};
% InitialGuessFile = load(dataFile);
% 
% Gains = InitialGuessFile.Gains.*exp(bestever.x);


%%
% load('Results/RoughDist/SongGains_wC.mat');
% load('Results/RoughDist/SongGains_wC_IC.mat');
% load('Results/Flat/SongGains_02.mat');
% load('Results/Rough/Umb03_1.5cm_1.2ms_kneelim1_mstoptorque3_2.mat');
load('Results/Rough/Umb10_1.5cm_1.2ms_kneelim1_mstoptorque2.mat');
load('Results/Flat/SongGains_02_wC_IC.mat');

[groundX, groundZ, groundTheta] = generateGround('flat');
% [groundX, groundZ, groundTheta] = generateGround('const', .015,1,true);
%[groundX, groundZ, groundTheta] = generateGround('ramp');

assignGainsSagittal;
dt_visual = 1/50;


%%
model = 'NeuromuscularModel2D';
%open('NeuromuscularModel');
% set_param(model,'SimulationMode','normal');
% set_param(model,'StopTime','30');

%%
inner_opt_settings = setInnerOptSettings();
setInitHealthy;

%%
warning('off');
tic;
sim(model)
toc;
warning('on');

%%
[cost, dataStruct] = getCost(model,Gains,time,metabolicEnergy,sumOfStopTorques,HATPos,stepVelocities,stepTimes,stepLengths,inner_opt_settings,0);
printOptInfo(dataStruct,true);
% animPost(animData2D,'intact',true,'speed',1);
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
if inner_opt_settings.visual
    set(0, 'DefaultFigureHitTest','on');
    set(0, 'DefaultAxesHitTest','on','DefaultAxesPickableParts','all');
    set(0, 'DefaultLineHitTest','on','DefaultLinePickableParts','all');
    set(0, 'DefaultPatchHitTest','on','DefaultPatchPickableParts','all');
    set(0, 'DefaultStairHitTest','on','DefaultStairPickableParts','all');
    set(0, 'DefaultLegendHitTest','on','DefaultLegendPickableParts','all');
end