try 
    save_system;
    disp('Saved loaded system');
catch
    disp('No system loaded to be saved.');
end
bdclose('all');
clear all; close all; clc;

%%
b_resumeOptimization = char(input("Do you want to resume a previous optimization? (yes/no)   ",'s'));
optimizationInfo = '';

%%
initial_gains_filename = ['Results' filesep 'v0.9ms.mat'];



%%
global model rtp InitialGuess inner_opt_settings

%% specifiy model and intial parameters
model = 'NeuromuscularModel3D';
optfunc = 'cmaesParallelSplit';

load_system(model);


%% initialze parameters
[inner_opt_settings,opts] = setInnerOptSettings(b_resumeOptimization,initial_gains_filename,optimizationInfo);
    
InitialGuessFile = load([inner_opt_settings.optimizationDir filesep 'initial_gains.mat']);
InitialGuess = [InitialGuessFile.GainsSagittal;InitialGuessFile.initConditionsSagittal;...
				InitialGuessFile.GainsCoronal; InitialGuessFile.initConditionsCoronal];
    
run([inner_opt_settings.optimizationDir, filesep, 'BodyMechParamsCapture']);
run([inner_opt_settings.optimizationDir, filesep, 'ControlParamsCapture']);
run([inner_opt_settings.optimizationDir, filesep, 'OptimParamsCapture']);

setInitVar;
 
dt_visual = 1/30;
animFrameRate = 30;

[groundX, groundZ, groundTheta] = generateGround('flat');


%% Build the Rapid Accelerator target once
rtp = Simulink.BlockDiagram.buildRapidAcceleratorTarget(model);

%% setup cmaes
numvars = length(InitialGuess);
x0 = zeros(numvars,1);
sigma0 = 1/8;

opts.DiagonalOnly = 30;
opts.UserDat2 = strcat(opts.UserDat2,"; ", "sigma0: ", string(sigma0) );

%% Show settings
clc;
disp(opts);
disp(inner_opt_settings);
disp(initial_gains_filename);
fprintf('Target velocity: %1.1f m/s \n',inner_opt_settings.target_velocity);

%% run cmaes
[xmin, fmin, counteval, stopflag, out, bestever] = cmaes(optfunc, x0, sigma0, opts)
