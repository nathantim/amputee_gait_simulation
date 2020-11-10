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
optimizationInfo = 'CMG_trip_prevent';

%%
% initial_gains_filename = ['Results' filesep 'Rough' filesep 'Umb10_1.5cm_1.2ms_kneelim1_mstoptorque2.mat'];
% initial_gains_filename = ['Results' filesep 'Rough' filesep 'Umb10_1.5cm_0.9ms_opt_1.2mscoronal.mat'];
% initial_gains_filename = ['Results' filesep 'Rough' filesep 'Umb10_1.2ms_difffoot_higherabd.mat'];
% initial_gains_filename = ['Results' filesep 'Rough' filesep 'Umb10_0.9ms.mat'];
initial_gains_filename = ['Results' filesep 'Rough' filesep 'v1.2ms_wCMG.mat'];
initial_gains_filenameCMG = ['Results' filesep 'CMGGains_inter2.mat'];


%%
global model rtp InitialGuess innerOptSettings

%% specifiy model and intial parameters
model = 'NeuromuscularModel_3R60_3D';
optfunc = 'cmaesParallelSplitRoughCMG';
load_system(model);
% set_param(strcat(model,'/Body Mechanics Layer/Obstacle'),'Commented','off');
% set_param(model,'SimulationMode','rapid');
% set_param(model,'StopTime','30');
% set_param(model,'StopTime','20');

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

% setInitVar;
assignGainsSagittal;
assignGainsCoronal;
assignInit;

dt_visual = 1/1000;
animFrameRate = 30;

[groundX, groundZ, groundTheta] = generateGround('flat');

% save_system(model)

%% Build the Rapid Accelerator target once
warning('off')
rtp = Simulink.BlockDiagram.buildRapidAcceleratorTarget(model);
warning('on')

%% setup rest of cmaes
numvars = length(InitialGuess);
x0 = zeros(numvars,1);
sigma0 = 1/8;
% sigma0 = 1/3;


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
% parpool(inner_opt_settings.numParWorkers);

%% run cmaes
[xmin, fmin, counteval, stopflag, out, bestever] = cmaes(optfunc, x0, sigma0, opts)
