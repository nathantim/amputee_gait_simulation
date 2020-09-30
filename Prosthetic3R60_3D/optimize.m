try 
    save_system;
    disp('Saved loaded system');
catch
    disp('No system loaded to be saved.');
end
bdclose('all');
clear all; close all; clc;

%%
% initial_gains_filename = 'Results/Flat/SongGains_02amp_wC.mat';
% initial_gains_filename = 'Results/Flat/Umb10nodimmuscleforce3D.mat';
% initial_gains_filename = 'Results/Flat/Umb10nodimmuscleforce2D_C3D.mat';
% initial_gains_filename = 'Results/Rough/Umb10_1.5cm_1.2ms_kneelim1_mstoptorque2.mat';
% initial_gains_filename = 'Results/Rough/Umb10_1.5cm_0.9ms_opt_1.2mscoronal.mat';
initial_gains_filename = 'Results/Rough/Umb10_1.5cm_0.9ms_ConlyOpt.mat';

initial_gains_file = load(initial_gains_filename);
load('Results/Flat/SongGains_02_wC_IC.mat');

%%
global model rtp InitialGuess inner_opt_settings

%% specifiy model and intial parameters
model = 'NeuromuscularModel_3R60_3D';
optfunc = 'cmaesParallelSplitRough';
load_system(model);
set_param(strcat(model,'/Body Mechanics Layer/Right Ankle Joint'),'SpringStiffness','3000','DampingCoefficient','1000');
% % set_param(strcat(model,'/Body Mechanics Layer/Right Ankle Joint'),'SpringStiffness','20','DampingCoefficient','4');
set_param(model,'SimulationMode','rapid');
set_param(model,'StopTime','30');
try
    set_param(strcat(model,'/Body Mechanics Layer/Obstacle'),'Commented','on');
catch ME
    warning(ME.message);
end

InitialGuess = [initial_gains_file.GainsSagittal;initial_gains_file.initConditionsSagittal;...
				initial_gains_file.GainsCoronal; initial_gains_file.initConditionsCoronal];

%% initialze parameters
[inner_opt_settings,opts] = setInnerOptSettings(initial_gains_filename);

BodyMechParams;
ControlParams;
OptimParams;
Prosthesis3R60Params;
% initSignals;
setInitAmputee;

dt_visual = 1/30;
[groundX, groundZ, groundTheta] = generateGround('flat');
save_system(model)

%% Build the Rapid Accelerator target once
rtp = Simulink.BlockDiagram.buildRapidAcceleratorTarget(model);

%% setup cmaes
numvars = length(InitialGuess);
x0 = zeros(numvars,1);
sigma0 = 1/8;
% sigma0 = 1/3;

opts.DiagonalOnly = 20;
opts.SaveFilename = 'vcmaes_1.5cm_0.9ms_Umb10_kneelim1_mstoptorque2_wInit_2.mat';
opts.UserDat2 = strcat(opts.UserDat2,"; ", "sigma0: ", string(sigma0), "; ampHipFlexFactor: ", string(ampHipFlexFactor) , "; ampHipExtFactor: ", string(ampHipExtFactor), "; ampHipAbdFactor: ", string(ampHipAbdFactor), "; ampHipAddFactor: ", string(ampHipAddFactor) );

%% Show settings
clc;
disp(opts);
disp(inner_opt_settings);
disp(initial_gains_filename);
fprintf('Target velocity: %1.1f m/s \n',target_velocity);
fprintf('Amputated hip flexor diminish factor:   %1.2f \n',ampHipFlexFactor);
fprintf('Amputated hip extensor diminish factor: %1.2f \n',ampHipExtFactor);
fprintf('Amputated hip abductor diminish factor: %1.2f \n',ampHipAbdFactor);
fprintf('Amputated hip adductor diminish factor: %1.2f \n',ampHipAddFactor);

parpool(inner_opt_settings.numParWorkers);

%% run cmaes
[xmin, fmin, counteval, stopflag, out, bestever] = cmaes(optfunc, x0, sigma0, opts)
