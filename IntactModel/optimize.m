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
initial_gains_filename = 'Results/Flat/optUmb10stanceswing1_3ms_prestim_lesshyper.mat';
initial_gains_file = load(initial_gains_filename);

%%
global model rtp InitialGuess

%% specifiy model and intial parameters
model = 'NeuromuscularModel';
optfunc = 'cmaesParallelSplit';

InitialGuess = initial_gains_file.Gains;

%% initialze parameters
BodyMechParams;
ControlParams;
OptimParams;
dt_visual = 1/30;
[groundX, groundZ, groundTheta] = generateGround('flat');
load_system(model)

%% Build the Rapid Accelerator target once
rtp = Simulink.BlockDiagram.buildRapidAcceleratorTarget(model);

%% setup cmaes
numvars = length(InitialGuess);
x0 = zeros(numvars,1);
sigma0 = 1/8;

opts = cmaes;
%opts.PopSize = numvars;
opts.Resume = 'no';
opts.MaxIter = 2000;
% opts.StopFitness = -inf;
opts.StopFitness = 0;
opts.DispModulo = 1;
opts.TolX = 1e-2;
opts.TolFun = 1e-2;
opts.EvalParallel = 'yes';
opts.LogPlot = 'off';
if (min_velocity == target_velocity && max_velocity == target_velocity)
    opts.TargetVel = target_velocity;
end
opts.UserData = char(strcat("Gains filename: ", initial_gains_filename));
opts.SaveFilename = 'vcmaes_energy_ha_swing_Umb10_notargetangle_1_3ms_prestim_diffcostf_morenhyper_dS.mat';

%% run cmaes
[xmin, fmin, counteval, stopflag, out, bestever] = cmaes(optfunc, x0, sigma0, opts)
