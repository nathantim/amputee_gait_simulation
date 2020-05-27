try 
    save_system;
catch
    disp('No system loaded to be saved.');
end
bdclose('all');
clear all; clc;

%%
initial_gains_filename = ('Results/RoughDist/optimizedGains1.mat');

initial_gains_file = load(initial_gains_filename);

%%
global model rtp InitialGuess

%% specifiy model and intial parameters
model = 'NeuromuscularModelwReflex2';
% optfunc = 'cmaesParallelSplit_novirtmuscle';
optfunc = 'cmaesParallelSplit';

InitialGuess = initial_gains_file.Gains(1:45);

%% initialze parameters
BodyMechParams;
ControlParams;
OptimParams;
Prosthesis3R60Params;
dt_visual = 1/30;
[groundX, groundZ, groundTheta] = generateGround('flat');

%% Build the Rapid Accelerator target once
load_system(model)
set_param(model,'SimulationMode','rapid');
set_param(model,'StopTime','30');
rtp = Simulink.BlockDiagram.buildRapidAcceleratorTarget(model);

%% setup cmaes
numvars = length(InitialGuess);
x0 = zeros(numvars,1);
sigma0 = 1/8;

opts = cmaes;
%opts.PopSize = numvars;
opts.Resume = 'yes';
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
opts.SaveFilename = 'variablescmaes_healthy_energy_Umb10_no_stiff_ankle.mat';

%% run cmaes
[xmin, fmin, counteval, stopflag, out, bestever] = cmaes(optfunc, x0, sigma0, opts)
