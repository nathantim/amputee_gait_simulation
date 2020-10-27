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
optimizationInfo = 'heading_noInt';

%%
% initial_gains_filename = ['Results' filesep 'Rough' filesep 'Umb10_1.5cm_1.2ms_kneelim1_mstoptorque2.mat'];
% initial_gains_filename = ['Results' filesep 'Rough' filesep 'Umb10_1.5cm_0.9ms_opt_1.2mscoronal.mat'];
% initial_gains_filename = ['Results' filesep 'Rough' filesep 'Umb10_1.2ms_difffoot_higherabd.mat'];
% initial_gains_filename = ['Results' filesep 'Rough' filesep 'Umb10_0.9ms.mat'];
initial_gains_filename = ['Results' filesep 'Rough' filesep 'Umb10_0.9ms_wheading_noInt.mat'];


%%
global model rtp InitialGuess inner_opt_settings

%% specifiy model and intial parameters
model = 'NeuromuscularModel_3R60_3D';
optfunc = 'cmaesParallelSplitRough';
load_system(model);
% set_param(strcat(model,'/Body Mechanics Layer/Right Ankle Joint'),'SpringStiffness','3000','DampingCoefficient','1000');
% set_param(model,'SimulationMode','rapid');
% set_param(model,'StopTime','30');
try
    set_param(strcat(model,'/Body Mechanics Layer/Obstacle'),'Commented','on');
catch ME
    warning(ME.message);
end

%% initialze parameters1
[inner_opt_settings,opts] = setInnerOptSettings(b_resumeOptimization,initial_gains_filename,optimizationInfo);

InitialGuessFile = load([inner_opt_settings.optimizationDir filesep 'initial_gains.mat']);
InitialGuess = [InitialGuessFile.GainsSagittal;InitialGuessFile.initConditionsSagittal;...
				InitialGuessFile.GainsCoronal; InitialGuessFile.initConditionsCoronal];
            
run([inner_opt_settings.optimizationDir, filesep, 'BodyMechParamsCapture']);
run([inner_opt_settings.optimizationDir, filesep, 'ControlParamsCapture']);
run([inner_opt_settings.optimizationDir, filesep, 'Prosthesis3R60ParamsCapture']);
run([inner_opt_settings.optimizationDir, filesep, 'OptimParamsCapture']);

setInitVar;

dt_visual = 1/1000;
animFrameRate = 30;

[groundX, groundZ, groundTheta] = generateGround('flat');

% set_param(model, 'AccelVerboseBuild', 'off');
% save_system(model)

%% Build the Rapid Accelerator target once
rtp = Simulink.BlockDiagram.buildRapidAcceleratorTarget(model);

%% setup cmaes
numvars = length(InitialGuess);
x0 = zeros(numvars,1);
sigma0 = 1/8;
% sigma0 = 1/3;

opts.DiagonalOnly = 10;
opts.UserDat2 = strcat(opts.UserDat2,"; ", "sigma0: ", string(sigma0), "; ampHipFlexFactor: ", string(ampHipFlexFactor) , "; ampHipExtFactor: ", string(ampHipExtFactor), "; ampHipAbdFactor: ", string(ampHipAbdFactor), "; ampHipAddFactor: ", string(ampHipAddFactor) );

%% Show settings
clc;
disp(opts);
disp(inner_opt_settings);
disp(initial_gains_filename);
fprintf('Target velocity: %1.1f m/s \n',inner_opt_settings.target_velocity);
fprintf('Amputated hip flexor diminish factor:   %1.2f \n',ampHipFlexFactor);
fprintf('Amputated hip extensor diminish factor: %1.2f \n',ampHipExtFactor);
fprintf('Amputated hip abductor diminish factor: %1.2f \n',ampHipAbdFactor);
fprintf('Amputated hip adductor diminish factor: %1.2f \n',ampHipAddFactor);

% parpool(inner_opt_settings.numParWorkers);

%% run cmaes
[xmin, fmin, counteval, stopflag, out, bestever] = cmaes(optfunc, x0, sigma0, opts)
