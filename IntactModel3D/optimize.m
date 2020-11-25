try
    if input('Do you want to save loaded model? (1/0)  ')
        save_system;
        disp('Saved loaded system');
    end
catch
    disp('No system loaded to be saved.');
end
bdclose('all');
clear all; close all; clc;

%% Specifiy model and initial gain file
global model rtp InitialGuess innerOptSettings

model = 'NeuromuscularModel3D';
optfunc = 'cmaesParallelSplit';

initialGainsFilename = ['Results' filesep 'v0.9ms.mat'];
b_resumeOptimization = char(input("Do you want to resume a previous optimization? (yes/no)   ",'s'));

load_system(model);

%% Initialize parameters
[innerOptSettings,opts] = setInnerOptSettings(model,'initialGainsFilename',initialGainsFilename,'resume',b_resumeOptimization,...
    'optimizationInfo','Test', 'targetVelocity', 0.9);

InitialGuessFile = load([innerOptSettings.optimizationDir filesep 'initialGains.mat']);
InitialGuess = [InitialGuessFile.GainsSagittal;InitialGuessFile.initConditionsSagittal;...
    InitialGuessFile.GainsCoronal; InitialGuessFile.initConditionsCoronal];

run([innerOptSettings.optimizationDir, filesep, 'BodyMechParamsCapture']);
run([innerOptSettings.optimizationDir, filesep, 'ControlParamsCapture']);

setInitVar;
dt_visual = 1/30;
animFrameRate = 30;
[groundX, groundZ, groundTheta] = generateGround('flat');

numvars = length(InitialGuess);
x0 = zeros(numvars,1);
sigma0 = 1/8;

opts.DiagonalOnly = 30;
opts.UserDat2 = strcat(opts.UserDat2,"; ", "sigma0: ", string(sigma0) );

%% Build the Rapid Accelerator target once
rtp = Simulink.BlockDiagram.buildRapidAcceleratorTarget(model);

%% Show settings
clc;
disp(opts);
disp(innerOptSettings);
disp(initialGainsFilename);
fprintf('Target velocity: %1.1f m/s \n',innerOptSettings.targetVelocity);

delete(gcp('nocreate'));
parpool('local',innerOptSettings.numParWorkers);

%% run cmaes
[xmin, fmin, counteval, stopflag, out, bestever] = cmaes(optfunc, x0, sigma0, opts)
