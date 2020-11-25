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
model = 'NeuromuscularModel_3R60CMG_3D';
optfunc = 'cmaesParallelSplit';

initialGainsFilename = ['Results' filesep 'v1.2ms_wCMG.mat'];
b_resumeOptimization = char(input("Do you want to resume a previous optimization? (yes/no)   ",'s'));

load_system(model);
try
    set_param(strcat(model,'/Body Mechanics Layer/Obstacle'),'Commented','on');
    set_param(model,'StopTime','30');
catch ME
    warning(ME.message);
end

%% Initialize parameters
[innerOptSettings,opts] = setInnerOptSettings(model,'initialGainsFilename',initialGainsFilename,'resume',b_resumeOptimization,...
                                                    'optimizationInfo','Test' , 'targetVelocity', 1.2,'timeOut', 30*60,...
                                                    'CMGdeltaHFactor', 0);

InitialGuessFile = load([innerOptSettings.optimizationDir filesep 'initialGains.mat']);
InitialGuess = [InitialGuessFile.GainsSagittal;InitialGuessFile.initConditionsSagittal;...
				InitialGuessFile.GainsCoronal; InitialGuessFile.initConditionsCoronal];
            
run([innerOptSettings.optimizationDir, filesep, 'BodyMechParamsCapture']);
run([innerOptSettings.optimizationDir, filesep, 'ControlParamsCapture']);
run([innerOptSettings.optimizationDir, filesep, 'Prosthesis3R60ParamsCapture']);
run([innerOptSettings.optimizationDir, filesep, 'CMGParamsCapture']);

% For no trip prevention,
tripDetectThreshold = tripDetectThreshold*1E9;
% % For inactive CMG
KpGamma = 0;
KiGamma = 0;
KpGammaReset = 0;
KdGammaReset = 0;
omegaRef = 0;
                    
setInitVar;
dt_visual = 1/30;
animFrameRate = 30;
[groundX, groundZ, groundTheta] = generateGround('flat');

numvars = length(InitialGuess);
x0 = zeros(numvars,1);
sigma0 = 1/8;

opts.DiagonalOnly = 20;
opts.UserDat2 = strcat(opts.UserDat2,"; ", "sigma0: ", string(sigma0), "; ampHipFlexFactor: ", string(ampHipFlexFactor) , "; ampHipExtFactor: ", string(ampHipExtFactor), "; ampHipAbdFactor: ", string(ampHipAbdFactor), "; ampHipAddFactor: ", string(ampHipAddFactor) );

save_system(model)

%% Build the Rapid Accelerator target once
rtp = Simulink.BlockDiagram.buildRapidAcceleratorTarget(model);

%% Show settings
clc;
disp(opts);
disp(innerOptSettings);
disp(initialGainsFilename);
fprintf('Target velocity: %1.1f m/s \n',innerOptSettings.targetVelocity);
fprintf('Amputated hip flexor diminish factor:   %1.2f \n',ampHipFlexFactor);
fprintf('Amputated hip extensor diminish factor: %1.2f \n',ampHipExtFactor);
fprintf('Amputated hip abductor diminish factor: %1.2f \n',ampHipAbdFactor);
fprintf('Amputated hip adductor diminish factor: %1.2f \n',ampHipAddFactor);

delete(gcp('nocreate'));
parpool('local',innerOptSettings.numParWorkers);

%% run cmaes
[xmin, fmin, counteval, stopflag, out, bestever] = cmaes(optfunc, x0, sigma0, opts)
