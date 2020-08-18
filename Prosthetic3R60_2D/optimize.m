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
initial_gains_filename = 'Results/Rough/Umb10_1.5cm_1.2ms_kneelim1_mstoptorque2.mat';
initial_gains_file = load(initial_gains_filename);
load('Results/Flat/SongGains_02_wC_IC.mat');

%%
global model InitialGuess inner_opt_settings %rtp

%% specifiy model and intial parameters
model = 'NeuromuscularModel_3R60_2D';
optfunc = 'cmaesParallelSplitRoughSimInput';
load_system(model);

modelwspace = get_param(model,'ModelWorkspace');
modelwspace.DataSource = 'MATLAB File';
modelwspace.Filename = [pwd,filesep,'setVars.m'];
modelwspace.saveToSource;

set_param(model, 'AccelVerboseBuild', 'on');
set_param(model,'FastRestart','on');

set_param(strcat(model,'/Body Mechanics Layer/Obstacle'),'Commented','on');
set_param(strcat(model,'/Body Mechanics Layer/Right Ankle Joint'),'SpringStiffness','300','DampingCoefficient','100');
% % set_param(strcat(model,'/Body Mechanics Layer/Right Ankle Joint'),'SpringStiffness','20','DampingCoefficient','4');
set_param(model,'SimulationMode','accelerator');
set_param(model,'StopTime','30');

BodyMechParams;
ControlParams;

prepend = [model,'/Neural Control Layer/'];
set_param( [prepend,'SDelay46'],'InitialOutput', '0'); %LStimHAB
set_param( [prepend,'SDelay40'],'InitialOutput', '0'); %LStimHAD
set_param( [prepend,'SDelay35'],'InitialOutput', '0'); %RStimHAB
set_param( [prepend,'SDelay37'],'InitialOutput', '0'); %RStimHAD

set_param( [prepend,'SDelay20'],'InitialOutput', '0'); %LPreStimHFLst
set_param( [prepend,'SDelay21'],'InitialOutput', '0'); %LPreStimGLUst
set_param( [prepend,'SDelay22'],'InitialOutput', '0'); %LPreStimHAMst
set_param( [prepend,'SDelay23'],'InitialOutput', '0'); %LPreStimRFst
set_param( [prepend,'MDelay9'] ,'InitialOutput', '0'); %LPreStimVASst
set_param( [prepend,'MDelay10'],'InitialOutput', '0'); %LPreStimBFSHst
set_param( [prepend,'LDelay11'],'InitialOutput', '0'); %LPreStimGASst
set_param( [prepend,'LDelay9'] ,'InitialOutput', '0'); %LPreStimSOLst
set_param( [prepend,'LDelay10'],'InitialOutput', '0'); %LPreStimTAst
set_param( [prepend,'SDelay24'],'InitialOutput', '0'); %RPreStimHFLsw
set_param( [prepend,'SDelay25'],'InitialOutput', '0'); %RPreStimGLUsw
set_param( [prepend,'SDelay26'],'InitialOutput', '0'); %RPreStimHAMsw
set_param( [prepend,'SDelay27'],'InitialOutput', '0'); %RPreStimRFsw

InitialGuess = initial_gains_file.Gains;

%% initialze parameters
[inner_opt_settings,opts] = setInnerOptSettings('init_gains_file',initial_gains_filename);

OptimParams;
Prosthesis3R60Params;
setInit;
 
dt_visual = 1/30;
[groundX, groundZ, groundTheta] = generateGround('const', inner_opt_settings.terrain_height,1,true);
%load_system(model)

%% Build the Rapid Accelerator target once
%rtp = Simulink.BlockDiagram.buildRapidAcceleratorTarget(model);

%% setup rest of cmaes
numvars = length(InitialGuess);
x0 = zeros(numvars,1);
sigma0 = 1/8;
% sigma0 = 1/3;

%opts.SaveFilename = 'vcmaes_1.5cm_0.9ms_Umb10_kneelim1_mstoptorque2.mat';
opts.SaveFilename = 'vcmaes_simInputTry.mat';
opts.UserDat2 = strcat(opts.UserDat2,"; ", "sigma0: ", string(sigma0), "; ampHipFlexFactor: ", string(ampHipFlexFactor) , "; ampHipExtFactor: ", string(ampHipExtFactor) );

save_system(model);

%% Show settings
clc;
disp(inner_opt_settings);
fprintf('Target velocity: %1.1f m/s \n',target_velocity);
fprintf('Amputated hip flexor diminish factor:   %1.2f \n',ampHipFlexFactor);
fprintf('Amputated hip extensor diminish factor: %1.2f \n',ampHipExtFactor);
parpool('local',inner_opt_settings.numParWorkers);

%% run cmaes
[xmin, fmin, counteval, stopflag, out, bestever] = cmaes(optfunc, x0, sigma0, opts)
