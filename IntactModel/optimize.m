bdclose('all');
clear all; clc;
%%
global model rtp InitialGuess

%specifiy model and intial parameters
model = 'NeuromuscularModel';
optfunc = 'cmaesParallelSplit';
InitialGuess = load('InitialGuess.mat');
InitialGuess = InitialGuess.InitialGuess;

%initialze parameters
BodyMechParams;
ControlParams;
OptimParams;
[groundX, groundZ, groundTheta] = generateGround('flat');
load_system(model)

% Build the Rapid Accelerator target once
rtp = Simulink.BlockDiagram.buildRapidAcceleratorTarget(model);

%setup cmaes
numvars = length(InitialGuess);
x0 = zeros(numvars,1);
sigma0 = 1/8;

opts = cmaes;
%opts.PopSize = numvars;
opts.Resume = 'no';
opts.MaxIter = 100;
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
% opts.ExtraInfo = 'Does this work?';
opts.SaveFilename = 'variablescmaes_healthy_energy_Wang2012.mat';

%run cmaes
[xmin, fmin, counteval, stopflag, out, bestever] = cmaes(optfunc, x0, sigma0, opts)
