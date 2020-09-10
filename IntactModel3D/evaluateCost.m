% clc;
%%
% tempstring = strsplit(opts.UserData,' ');
% dataFile = tempstring{end};
% InitialGuessFile = load(dataFile); 
% % 
% Gains = InitialGuessFile.Gains.*exp(bestever.x);
% load('Results/Flat/GeyerHerrInit.mat');

% compareenergies = load('compareEnergyCostTotal.mat');

% 
% idx_minCost = find(compareenergies.cost==min(compareenergies.cost),1,'first');
% Gains2 = compareenergies.Gains(idx_minCost,:)';
% 

%%
% load('Results/RoughDist/SongGains_wC.mat');
% load('Results/RoughDist/SongGains_wC_IC.mat');
load('Results/Flat/song3Dopt.mat' );
% load('Results/Rough/Umb10_1.5cm_0.9ms_kneelim1_mstoptorque2.mat');


load('Results/Flat/SongGains_02_wC_IC.mat');


assignGains;
dt_visual = 1/50;
setInit;

%%
model = 'NeuromuscularModel3D';

%%
inner_opt_settings = setInnerOptSettings();
[groundX, groundZ, groundTheta] = generateGround('flat');

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