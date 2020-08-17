try 
    save_system;
    disp('Saved loaded system');
catch
    disp('No system loaded to be saved.');
end
bdclose('all');
clear all; close all; clc;

%%
% initial_gains_filename = 'Results/Flat/song3Dopt.mat';
% initial_gains_filename = 'Results/Flat/SongGains_02.mat';
% initial_gains_filename = 'Results/Rough/Umb10_1.5cm_1.2ms_kneelim1_mstoptorque2.mat';
initial_gains_filename = 'Results/Rough/Umb03_1.5cm_1.2ms_kneelim1_mstoptorque3_2.mat';
% initial_gains_filename = 'Results/Rough/Umb10_1.5cm_1.2ms_Umb10_kneelim1_mstoptorque3_2.mat';

initial_gains_file = load(initial_gains_filename);

load('Results/Flat/SongGains_02_wC_IC.mat');

%%
global model rtp InitialGuess inner_opt_settings

%% specifiy model and intial parameters
model = 'NeuromuscularModel2D';
% model = 'NeuromuscularModel3D';
% model = 'NeuromuscularModel_3R60_2D';
% model = 'NeuromuscularModel_3R60_3D';
optfunc = 'cmaesParallelSplitRough';

load_system(model);
% set_param(model,'MakeCommand','make_rtw  CPP_OPTS="-D_GLIBCXX_USE_CXX11_ABI=0"')
% set_param(model,'AccelMakeCommand','make_rtw  CPP_OPTS="-D_GLIBCXX_USE_CXX11_ABI=0"')
% set_param(model, 'AccelVerboseBuild', 'on')
set_param(strcat(model,'/Body Mechanics Layer/Obstacle'),'Commented','on');
set_param(model,'SimulationMode','rapid');
set_param(model,'StopTime','30');
% disp(get_param(model,'MakeCommand'));
% disp(get_param(model,'AccelMakeCommand'));
InitialGuess = initial_gains_file.Gains;

%% initialize parameters
[inner_opt_settings,opts] = setInnerOptSettings(initial_gains_filename);

BodyMechParams;
ControlParams;
OptimParams;
setInit;
dt_visual = 1/30;
% [groundX, groundZ, groundTheta] = generateGround('flat');
[groundX, groundZ, groundTheta] = generateGround('const', inner_opt_settings.terrain_height,1,true);
load_system(model)

%% Build the Rapid Accelerator target once
rtp = Simulink.BlockDiagram.buildRapidAcceleratorTarget(model);

%% setup cmaes
numvars = length(InitialGuess);
x0 = zeros(numvars,1);
sigma0 = 1/8;
% sigma0 = 1/3;

opts.SaveFilename = 'vcmaes_1.5cm_1.2ms_Umb03_kneelim1_mstoptorque2.mat';

%% Show settings
clc;
disp(inner_opt_settings);
fprintf('Target velocity: %1.1f m/s \n',target_velocity);

%% run cmaes
[xmin, fmin, counteval, stopflag, out, bestever] = cmaes(optfunc, x0, sigma0, opts)
