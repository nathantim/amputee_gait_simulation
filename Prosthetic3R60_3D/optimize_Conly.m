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
initial_gains_filename = 'Results/Rough/Umb10_1.5cm_0.9ms_kneelim1_mstoptorque2_2Dopt.mat';
% initial_gains_filename = 'Results/Rough/Umb10_0.9_ms_3D_partlyopt.mat';
load(initial_gains_filename);

initial_gains_file = load(initial_gains_filename);
load('Results/Flat/SongGains_02_wC_IC.mat');

%%
global model rtp InitialGuess inner_opt_settings

%% specifiy model and intial parameters
model = 'NeuromuscularModel_3R60_3D';
optfunc = 'cmaesParallelSplitRough_Conly';
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

% InitialGuess = initial_gains_file.Gains;
InitialGuess = initial_gains_file.GainsCoronal;

%% initialze parameters
[inner_opt_settings,opts] = setInnerOptSettings(initial_gains_filename);

BodyMechParams;
ControlParams;
OptimParams;
Prosthesis3R60Params;
assignGainsSagittal;
setInit;

 
dt_visual = 1/30;
[groundX, groundZ, groundTheta] = generateGround('flat');
load_system(model)

%% Build the Rapid Accelerator target once
rtp = Simulink.BlockDiagram.buildRapidAcceleratorTarget(model);

%% setup cmaes
numvars = length(InitialGuess);
x0 = zeros(numvars,1);
sigma0 = 1/8;
% sigma0 = 1/3;

% opts.DiagonalOnly = 150;
opts.SaveFilename = 'vcmaes_1.5cm_0.9ms_Umb10_kneelim1_mstoptorque2_Conly.mat';
opts.UserDat2 = strcat(opts.UserDat2,"; ", "sigma0: ", string(sigma0), "; ampHipFlexFactor: ", string(ampHipFlexFactor) , "; ampHipExtFactor: ", string(ampHipExtFactor) );

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

% parpool(inner_opt_settings.numParWorkers);

%% run cmaes
[xmin, fmin, counteval, stopflag, out, bestever] = cmaes(optfunc, x0, sigma0, opts)
