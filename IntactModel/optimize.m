try 
    save_system;
    disp('Saved loaded system');
catch
    disp('No system loaded to be saved.');
end
bdclose('all');
clear all; close all; clc;

%%
% initial_gains_filename = 'Results/Flat/song3Dopt.mat';
% initial_gains_filename = 'Results/Flat/SongGains_02.mat';
initial_gains_filename = 'Results/Rough/Umb10_1.5cm_1.2ms_kneelim1_mstoptorque2.mat';
% initial_gains_filename = 'Results/Rough/Umb03_1.5cm_1.2ms_kneelim1_mstoptorque3_2.mat';
% initial_gains_filename = 'Results/Rough/Umb10_1.5cm_1.2ms_Umb10_kneelim1_mstoptorque3_2.mat';

initial_gains_file = load(initial_gains_filename);

load('Results/Flat/SongGains_02_wC_IC.mat');

%%
global model rtp InitialGuess inner_opt_settings

%% specifiy model and intial parameters
model = 'NeuromuscularModel2D';
optfunc = 'cmaesParallelSplitRough';

load_system(model);

set_param(strcat(model,'/Body Mechanics Layer/Obstacle'),'Commented','on');
set_param(model,'SimulationMode','rapid');
set_param(model,'StopTime','30');

InitialGuess = initial_gains_file.GainsSagittal;

%% initialize parameters
[inner_opt_settings,opts] = setInnerOptSettings(initial_gains_filename);

BodyMechParams;
ControlParams;
OptimParams;
setInitAmputee;
dt_visual = 1/30;
[groundX, groundZ, groundTheta] = generateGround('flat');
% [groundX, groundZ, groundTheta] = generateGround('const', inner_opt_settings.terrain_height,1,true);
save_system(model)

%% Build the Rapid Accelerator target once
rtp = Simulink.BlockDiagram.buildRapidAcceleratorTarget(model);

%% setup cmaes
numvars = length(InitialGuess);
x0 = zeros(numvars,1);
sigma0 = 1/8;
% sigma0 = 1/3;

opts.SaveFilename = 'vcmaes_1.5cm_0.9ms_Umb10_kneelim1_mstoptorque2_ampinit.mat';

%% Show settings
clc;
disp(opts);
disp(inner_opt_settings);
fprintf('Target velocity: %1.1f m/s \n',target_velocity);

%% run cmaes
[xmin, fmin, counteval, stopflag, out, bestever] = cmaes(optfunc, x0, sigma0, opts)
