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

%% Specifiy model and initial gain files
global model rtp InitialGuess innerOptSettings

model = 'NeuromuscularModel_3R60CMG_3D';
optfunc = 'cmaesParallelSplitCMG';

initialGainsFilename = ['Results' filesep 'v1.2ms.mat'];
initialCMGGainsFilename = ['Results' filesep 'CMGGains_tripprevent.mat'];

b_resumeOptimization = char(input("Do you want to resume a previous optimization? (yes/no)   ",'s'));
optimizationInfo = '';

load_system(model);
try
    set_param(strcat(model,'/Body Mechanics Layer/Obstacle'),'Commented','off');
catch ME
    warning(ME.message);
end

%% Initialize parameters
[innerOptSettings,opts] = setInnerOptSettings(model,'initialGainsFilename',initialGainsFilename,'initialCMGGainsFilename',initialCMGGainsFilename,...
                                                    'resume',b_resumeOptimization ,'optimizationInfo',optimizationInfo ,'numTerrains',1, ...
                                                    'targetVelocity', 1.2,'timeOut', 25*60 );

load([innerOptSettings.optimizationDir filesep 'initialGains.mat']);
InitialGuessFile = load([innerOptSettings.optimizationDir filesep 'initialGainsCMG.mat']);

InitialGuess = InitialGuessFile.CMGGains;

run([innerOptSettings.optimizationDir, filesep, 'BodyMechParamsCapture']);
run([innerOptSettings.optimizationDir, filesep, 'ControlParamsCapture']);
run([innerOptSettings.optimizationDir, filesep, 'Prosthesis3R60ParamsCapture']);
run([innerOptSettings.optimizationDir, filesep, 'CMGParamsCapture']);

assignGainsSagittal;
assignGainsCoronal;
assignInit;

dt_visual = 1/1000;
animFrameRate = 30;
[groundX, groundZ, groundTheta] = generateGround('flat');

numvars = length(InitialGuess);
x0 = zeros(numvars,1);
sigma0 = 1/8;

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
