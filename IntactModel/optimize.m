global model rtp InitialGuess

%specifiy model and intial parameters
model = 'NeuromuscularModel';
optfunc = 'cmaesParallelSplitRough';
InitialGuess = load('InitialGuess.mat');
InitialGuess = InitialGuess.InitialGuess;

%initialze parameters
BodyMechParams
ControlParams
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
opts.Resume = 'yes';
opts.MaxIter = 300;
opts.StopFitness = -inf;
%opts.StopFitness = -20;
opts.DispModulo = 1;
opts.TolX = 1e-2;
opts.TolFun = 1e-2;
opts.EvalParallel = 'yes';
opts.LogPlot = 'on';

%run cmaes
[xmin, fmin, counteval, stopflag, out, bestever] = cmaes(optfunc, x0, sigma0, opts)
