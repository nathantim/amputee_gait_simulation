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

%%
b_resumeOptimization = char(input("Do you want to resume a previous optimization? (yes/no)   ",'s'));
optimizationInfo = '';

%%

initial_gains_filename = ['Results' filesep 'v1.2ms_wCMG.mat'];
initial_gains_filenameCMG = ['Results' filesep 'CMGGains_tripprevent.mat'];


%%
global model rtp InitialGuess innerOptSettings

%% specifiy model and intial parameters
model = 'NeuromuscularModel_3R60CMG_3D';
optfunc = 'cmaesParallelSplitCMG';

load_system(model);
try
    set_param(strcat(model,'/Body Mechanics Layer/Obstacle'),'Commented','off');
catch ME
    warning(ME.message);
end


%% initialze parameters
[innerOptSettings,opts] = setInnerOptSettings(b_resumeOptimization,initial_gains_filename,optimizationInfo,initial_gains_filenameCMG);

load([innerOptSettings.optimizationDir filesep 'initial_gains.mat']);
InitialGuessFile = load([innerOptSettings.optimizationDir filesep 'initial_gainsCMG.mat']);

InitialGuess = InitialGuessFile.CMGGains;

run([innerOptSettings.optimizationDir, filesep, 'BodyMechParamsCapture']);
run([innerOptSettings.optimizationDir, filesep, 'ControlParamsCapture']);
run([innerOptSettings.optimizationDir, filesep, 'Prosthesis3R60ParamsCapture']);
run([innerOptSettings.optimizationDir, filesep, 'CMGParamsCapture']);
run([innerOptSettings.optimizationDir, filesep, 'OptimParamsCapture']);

assignGainsSagittal;
assignGainsCoronal;
assignInit;

dt_visual = 1/1000;
animFrameRate = 30;

[groundX, groundZ, groundTheta] = generateGround('flat');

save_system(model)

%% Build the Rapid Accelerator target once
warning('off')
rtp = Simulink.BlockDiagram.buildRapidAcceleratorTarget(model);
warning('on')

%% setup rest of cmaes
numvars = length(InitialGuess);
x0 = zeros(numvars,1);
sigma0 = 1/8;

%% Show settings
clc;
disp(opts);
disp(innerOptSettings);
disp(initial_gains_filename);
disp(obstacle_x);
fprintf('Target velocity: %1.1f m/s \n',target_velocity);
fprintf('Amputated hip flexor diminish factor:   %1.2f \n',ampHipFlexFactor);
fprintf('Amputated hip extensor diminish factor: %1.2f \n',ampHipExtFactor);
fprintf('Amputated hip abductor diminish factor: %1.2f \n',ampHipAbdFactor);
fprintf('Amputated hip adductor diminish factor: %1.2f \n',ampHipAddFactor);

%% run cmaes
[xmin, fmin, counteval, stopflag, out, bestever] = cmaes(optfunc, x0, sigma0, opts)
