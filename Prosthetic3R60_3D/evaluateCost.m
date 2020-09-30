clc;
%%
% load('Results/Rough/Prosthetic2D_C3D.mat');
% assignGains;

% tempstring = strsplit(opts.UserData,' ');
% dataFile = tempstring{end};
% 
% idx1 = length(InitialGuess.GainsCoronal);
% idx2 = idx1 + length(InitialGuess.initConditionsCoronal);
% GainsCoronal = InitialGuess.GainsCoronal.*exp(bestever.x(1:idx1));
% initConditionsCoronal = InitialGuess.initConditionsCoronal.*exp(bestever.x((idx1+1):idx2));
% 
% initConditionsSagittal = InitialGuess.initConditionsSagittal.*exp(bestever.x((idx2+1):end));
% GainsSagittal = InitialGuess.GainsSagittal;


%%
load('Results/Rough/Umb10_1.5cm_1.2ms_kneelim1_mstoptorque2.mat');
% load('Results/Rough/Umb10_1.5cm_0.9ms_ConlyOpt.mat');


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
set_param(model,'SimulationMode','rapid');
set_param(model,'StopTime','30');

%%
warning('off');
tic;
sim(model)
toc;
warning('on');

%%
[~,dataStruct] = getCost(model,[],time,metabolicEnergy,sumOfStopTorques,HATPosVel,stepVelocities,stepTimes,stepLengths,stepNumbers,[],inner_opt_settings, 0);
printOptInfo(dataStruct,true);

%%

% %%
set(0, 'DefaultFigureHitTest','on');
set(0, 'DefaultAxesHitTest','on','DefaultAxesPickableParts','all');
set(0, 'DefaultLineHitTest','on','DefaultLinePickableParts','all');
set(0, 'DefaultPatchHitTest','on','DefaultPatchPickableParts','all');
set(0, 'DefaultStairHitTest','on','DefaultStairPickableParts','all');
set(0, 'DefaultLegendHitTest','on','DefaultLegendPickableParts','all');