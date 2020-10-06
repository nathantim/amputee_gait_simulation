try 
    save_system;
    disp('Saved loaded system');
catch
    disp('No system loaded to be saved.');
end
bdclose('all');
clear all; close all; clc;

%%
% initial_gains_filename = 'Results/Flat/SongGains_02amp.mat';
% initial_gains_filename = 'Results/Flat/Umb10dimmuscleforce.mat';
load('Results/Rough/Umb10_1.5cm_1.2ms_kneelim1_mstoptorque2_CMGflat_4.mat');
% load('Results/Rough/Umb10_1.5cm_0.9ms_kneelim1_mstoptorque2.mat');

% initial_gains_filename = 'Results/littleoptCMGgains_1_2ms.mat';
% initial_gains_filename =  'Results/optCMGgains_1_2ms_lowerDH.mat';
initial_gains_filename =  'Results/optCMGgains_1_2ms_lowerDH_noKpKi_wLegClr_opt1.mat';


initial_gains_file = load(initial_gains_filename);
load('Results/Flat/SongGains_02_wC_IC.mat');

%%
global model rtp InitialGuess inner_opt_settings

%% specifiy model and intial parameters
model = 'NeuromuscularModel_3R60_3D';
optfunc = 'cmaesParallelSplitRoughCMG';
load_system(model);
% set_param(model, 'AccelVerboseBuild', 'on')
set_param(strcat(model,'/Body Mechanics Layer/Obstacle'),'Commented','off');
set_param(strcat(model,'/Body Mechanics Layer/Right Ankle Joint'),'SpringStiffness','3000','DampingCoefficient','1000');
% % set_param(strcat(model,'/Body Mechanics Layer/Right Ankle Joint'),'SpringStiffness','20','DampingCoefficient','4');
set_param(model,'SimulationMode','rapid');
% set_param(model,'StopTime','30');
set_param(model,'StopTime','20');

InitialGuess = initial_gains_file.CMGGains;


BodyMechParams;
ControlParams;
OptimParams;
Prosthesis3R60Params;
assignGainsSagittal;
assignGainsCoronal;
setInitAmputee;

CMGParams;


 
dt_visual = 1/50;

[groundX, groundZ, groundTheta] = generateGround('flat');
% [groundX, groundZ, groundTheta] = generateGround('const', inner_opt_settings.terrain_height,1,true);
save_system(model)

%% initialze parameters
[inner_opt_settings,opts] = setInnerOptSettings(initial_gains_filename);

inner_opt_settings.numTerrains = 1;
inner_opt_settings.terrain_height = 0.0000015; % in m

%% Build the Rapid Accelerator target once
rtp = Simulink.BlockDiagram.buildRapidAcceleratorTarget(model);

%% setup rest of cmaes
numvars = length(InitialGuess);
x0 = zeros(numvars,1);
sigma0 = 1/8;
% sigma0 = 1/3;

opts.SaveFilename = 'vcmaes_CMG_1.5cm_1.2ms_Umb10_diffobstacle_wselfcoll_x8.78m.mat';

%% Show settings
clc;
disp(opts);
disp(inner_opt_settings);
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
