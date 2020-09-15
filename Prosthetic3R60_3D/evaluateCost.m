% clc;
%%
% load('Results/Rough/Prosthetic2D_C3D.mat');
% assignGains;

tempstring = strsplit(opts.UserData,' ');
dataFile = tempstring{end};
InitialGuessFile = load(dataFile); 

GainsSagittal = InitialGuessFile.GainsSagittal;
GainsCoronal = InitialGuessFile.GainsCoronal;%.*exp(bestever.x);


% compareenergies = load('compareEnergyCostTotal_Umb10_prost.mat');
% 
% % 
% idx_minCost = find(round(compareenergies.cost,2)==93,1,'first');
% Gains = compareenergies.Gains(idx_minCost,:)';
% 

%%
% load('Results/Rough/Prosthetic2D_C3D.mat');
% load('Results/Rough/Umb10_0.9_ms_3D_partlyopt.mat');

% load('Results/Rough/Umb10_1.5cm_1.2ms_kneelim1_mstoptorque2.mat');
% load('Results/Rough/Umb10_1.5cm_0.9ms_kneelim1_mstoptorque2_2Dopt.mat');


load('Results/Flat/SongGains_02_wC_IC.mat');


%%
model = 'NeuromuscularModel_3R60_3D';

load_system(model);
BodyMechParams;
ControlParams;
OptimParams;
Prosthesis3R60Params;
assignGainsSagittal;
assignGainsCoronal;
dt_visual = 1/30;
set_param(strcat(model,'/Body Mechanics Layer/Right Ankle Joint'),'SpringStiffness','3000','DampingCoefficient','1000');

load('Results/optCMGgains_1_2ms_lowerDH_noKpKi.mat');
assignCMGGains;
% CMGParams;

%%
inner_opt_settings = setInnerOptSettings();
setInitAmputee;
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
[cost, dataStruct] = getCost(model,[],time,metabolicEnergy,sumOfStopTorques,HATPosVel,stepVelocities,stepTimes,stepLengths,stepNumbers,CMGData,inner_opt_settings,0);
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