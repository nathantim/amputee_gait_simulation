try 
    save_system;
    disp('Saved loaded system');
catch
    disp('No system loaded to be saved.');
end
bdclose('all');
clear all; close all; clc;

%%
% initial_gains_filename = ('Results/Flat/optandGH_diffswing.mat');
% initial_gains_filename = ('Results/Flat/optdiffswing.mat');
% initial_gains_filename = ('Results/Flat/optandGeyerHerrInit.mat');
% initial_gains_filename = 'Results/Flat/optUmb10stanceswing1_3ms_prestim.mat';
% initial_gains_filename = 'Results/Flat/optUmb10stanceswing1_3ms_prestim_lesshyper_dSopt.mat';
% initial_gains_filename = 'Results/Flat/optUmb10kneelim3.mat';
% initial_gains_filename = 'Results/Flat/optwoptUmb10_1_3ms.mat';
initial_gains_filename = 'Results/Flat/song3Dopt.mat';
% initial_gains_filename = 'Results/Flat/SongGains_02_wC.mat';
initial_gains_file = load(initial_gains_filename);
load('Results/Flat/SongGains_02_wC_IC.mat');

%%
global model rtp InitialGuess inner_opt_settings

%% specifiy model and intial parameters
model = 'NeuromuscularModel3D';
optfunc = 'cmaesParallelSplitRough';

load_system(model);
set_param(model,'SimulationMode','rapid');
set_param(model,'StopTime','30');
try
    set_param(strcat(model,'/Body Mechanics Layer/Obstacle'),'Commented','on');
catch ME
    warning(ME.message);
end

InitialGuess = initial_gains_file.Gains;

%% initialze parameters
[inner_opt_settings,opts] = setInnerOptSettings(initial_gains_filename);

BodyMechParams;
ControlParams;
OptimParams;
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

opts.SaveFilename = 'vcmaes_Umb10_SONG3D_kneelim1_2.mat';

%% run cmaes
[xmin, fmin, counteval, stopflag, out, bestever] = cmaes(optfunc, x0, sigma0, opts)
