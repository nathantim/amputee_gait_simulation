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

%%
% initial_gains_filename = ['Results' filesep 'Flat' filesep 'SongGains_02amp_wC.mat'];
% initial_gains_filename = ['Results' filesep 'Flat' filesep 'Umb10nodimmuscleforce3D.mat'];
% initial_gains_filename = ['Results' filesep 'Rough' filesep '2Dopt_1.2_ms_part3D.mat'];
% initial_gains_filename = ['Results' filesep 'Rough' filesep 'Umb10_1.5cm_0.9ms_kneelim1_mstoptorque2_2Dopt.mat'];
% initial_gains_filename = ['Results' filesep 'Rough' filesep 'Umb10_1.5cm_0.9ms_kneelim1_mstoptorque2.mat'];
initial_gains_filename = ['Results' filesep 'Rough' filesep '1.3msinter.mat'];
load(initial_gains_filename);

initial_gains_file = load(initial_gains_filename);

% GainsSagittal = initial_gains_file.GainsSagittal;
% initConditionsSagittal = initial_gains_file.initConditionsSagittal;
% GainsCoronal = initial_gains_file.GainsCoronal; 
% initConditionsCoronal = initial_gains_file.initConditionsCoronal;

         
%%
optimizationInfo = 'equal_shank';

%%
global model rtp InitialGuess inner_opt_settings

%% specifiy model and intial parameters
model = 'NeuromuscularModel3D';
optfunc = 'cmaesParallelSplitRough';
load_system(model);
% % set_param(strcat(model,'/Body Mechanics Layer/Right Ankle Joint'),'SpringStiffness','20','DampingCoefficient','4');
set_param(model,'SimulationMode','rapid');
set_param(model,'StopTime','30');
try
    set_param(strcat(model,'/Body Mechanics Layer/Obstacle'),'Commented','on');
catch ME
    warning(ME.message);
end

% InitialGuess = initial_gains_file.Gains;
InitialGuess = [initial_gains_file.GainsSagittal;initial_gains_file.initConditionsSagittal;...
				initial_gains_file.GainsCoronal; initial_gains_file.initConditionsCoronal];

%% initialze parameters
[inner_opt_settings,opts] = setInnerOptSettings(b_resumeOptimization,initial_gains_filename,optimizationInfo);

run([inner_opt_settings.optimizationDir, filesep, 'BodyMechParamsCapture']);
run([inner_opt_settings.optimizationDir, filesep, 'ControlParamsCapture']);
run([inner_opt_settings.optimizationDir, filesep, 'OptimParamsCapture']);

% initSignals;
setInitAmputee;
 
dt_visual = 1/30;
[groundX, groundZ, groundTheta] = generateGround('flat');
set_param(model, 'AccelVerboseBuild', 'off');
save_system(model)

%% Build the Rapid Accelerator target once
rtp = Simulink.BlockDiagram.buildRapidAcceleratorTarget(model);

%% setup cmaes
numvars = length(InitialGuess);
x0 = zeros(numvars,1);
sigma0 = 1/8;
% sigma0 = 1/3;

opts.DiagonalOnly = 50;

opts.UserDat2 = strcat(opts.UserDat2,"; ", "sigma0: ", string(sigma0) );

%% Show settings
clc;
disp(opts);
disp(inner_opt_settings);
disp(initial_gains_filename);
fprintf('Target velocity: %1.1f m/s \n',inner_opt_settings.target_velocity);

parpool(inner_opt_settings.numParWorkers);

%% run cmaes
[xmin, fmin, counteval, stopflag, out, bestever] = cmaes(optfunc, x0, sigma0, opts)
