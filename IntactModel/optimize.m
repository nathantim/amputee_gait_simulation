% try 
%     save_system;
%     disp('Saved loaded system');
% catch
%     disp('No system loaded to be saved.');
% end
% bdclose('all');
% clear all; close all; clc;

%%
% initial_gains_filename = 'Results/Flat/song3Dopt.mat';
% initial_gains_filename = 'Results/Flat/SongGains_02.mat';
% initial_gains_filename = 'Results/Rough/Umb10_1.5cm_1.2ms_kneelim1_mstoptorque2.mat';
initial_gains_filename = 'Results/Rough/Umb03_1.5cm_1.2ms_kneelim1_mstoptorque3_2.mat';

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

InitialGuess = initial_gains_file.Gains;

%% initialze parameters
inner_opt_settings.numTerrains = 6;
inner_opt_settings.terrain_height = 0.015; % in m
if usejava('desktop')
    inner_opt_settings.numParWorkers = 4;
    inner_opt_settings.visual = true;
else
    inner_opt_settings.numParWorkers = 12;
    inner_opt_settings.visual = false;
end

BodyMechParams;
ControlParams;
OptimParams;
setInit;
dt_visual = 1/30;
% [groundX, groundZ, groundTheta] = generateGround('flat');
[groundX, groundZ, groundTheta] = generateGround('const', inner_opt_settings.terrain_height,1,true);
load_system(model)

%% Build the Rapid Accelerator target once
rtp = Simulink.BlockDiagram.buildRapidAcceleratorTarget(model);

%% setup cmaes
numvars = length(InitialGuess);
x0 = zeros(numvars,1);
sigma0 = 1/8;
% sigma0 = 1/3;

opts = cmaes;
%opts.PopSize = numvars;
opts.Resume = 'yes';
opts.MaxIter = 2000;
% opts.StopFitness = -inf;
opts.StopFitness = 0;
opts.DispModulo = 1;
opts.TolX = 1e-2;
% opts.TolX = 1e-3;
opts.TolFun = 1e-2;
opts.EvalParallel = 'yes';
opts.LogPlot = 'off';
if (min_velocity == target_velocity && max_velocity == target_velocity)
    opts.TargetVel = target_velocity;
    fprintf('Using target velocity of %1.1f m/s.\n',target_velocity);
end
opts.UserData = char(strcat("Gains filename: ", initial_gains_filename));
opts.SaveVariables=1;
opts.SaveFilename = 'vcmaes_1.5cm_1.2ms_Umb10_kneelim1_mstoptorque3_2.mat';

%% run cmaes
[xmin, fmin, counteval, stopflag, out, bestever] = cmaes(optfunc, x0, sigma0, opts)
