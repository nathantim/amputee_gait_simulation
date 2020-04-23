try 
    save_system;
catch
    disp('No system loaded to be saved.');
end
bdclose('all');
clear all; clc;

%%
initial_gains_filename = ('Results/RoughDist/optimizedGains.mat');
% initial_gains_filename = ('Results/Flat/v_0.5m_s.mat');
% initial_gains_filename = ('Results/Flat/v_0.8m_s.mat');
% initial_gains_filename = ('Results/Flat/v_1.1m_s.mat');
% initial_gains_filename = ('Results/Flat/v_1.4m_s.mat');
% InitialGuess = load('InitialGuess.mat');
% InitialGuess = InitialGuess.InitialGuess;

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
opts.MaxIter = 1000;
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
% opts.SaveFilename = 'variablescmaes_healthy_energy_cost_compare.mat';
% opts.SaveFilename = 'variablescmaes_healthy_energy_Wang2012.mat';
opts.SaveFilename = 'variablescmaes_healthy_energy_Umberger2010.mat';

%% Data plotting during optimization
global dataQueueD updateFigure
updateFigure = figure();
subplot(2,4,1,'Tag','cost');
subplot(2,4,2,'Tag','time');
subplot(2,4,3,'Tag','metabolicEnergy');
subplot(2,4,4,'Tag','meanStepTime');
subplot(2,4,5,'Tag','meanStepLength');
subplot(2,4,6,'Tag','meanVel');
subplot(2,4,7,'Tag','ASIStepLength');
subplot(2,4,8,'Tag','ASIStepTime');
dataQueueD = parallel.pool.DataQueue;
listener = dataQueueD.afterEach(@plotProgressOptimization);

%% run cmaes

% afterEach(queue, @tryout);
[xmin, fmin, counteval, stopflag, out, bestever] = cmaes(optfunc, x0, sigma0, opts)
%%
% tryout = @(data)( ax = gca; previousData = ax.Children.Data; plotData = [previousData,data]; disp('hi'); histogram(gca,plotData));

for i = 1:1000
    send(dataQueueD,struct('cost',rand*rand*rand*1000));
    pause(0.01);
end