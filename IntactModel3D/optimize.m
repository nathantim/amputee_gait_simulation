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
initial_gains_filename = 'Results/Flat/Umb10_SONG3D_kneelim1_2.mat';
% initial_gains_filename = 'Results/Flat/SongGains_02_wC.mat';
initial_gains_file = load(initial_gains_filename);
load('Results/Flat/SongGains_02_wC_IC.mat');

%%
global model InitialGuess inner_opt_settings %rtp

%% specifiy model and intial parameters
model = 'NeuromuscularModel3D';
optfunc = 'cmaesParallelSplitRoughSimInput';
load_system(model);

modelwspace = get_param(model,'ModelWorkspace');
modelwspace.DataSource = 'MATLAB File';
modelwspace.Filename = [pwd,filesep,'setVars.m'];
modelwspace.saveToSource;

set_param(model, 'AccelVerboseBuild', 'on');
set_param(model,'FastRestart','on');
try
    set_param(strcat(model,'/Body Mechanics Layer/Obstacle'),'Commented','on');
catch ME
    warning(ME.message);
end

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
set_param( [prepend,'MDelay12'] ,'InitialOutput', '0'); %RPreStimVASst
set_param( [prepend,'MDelay11'],'InitialOutput', '0'); %RPreStimBFSHst
set_param( [prepend,'LDelay7'],'InitialOutput', '0'); %RPreStimGASst
set_param( [prepend,'LDelay8'] ,'InitialOutput', '0'); %RPreStimSOLst
set_param( [prepend,'LDelay6'],'InitialOutput', '0'); %RPreStimTAst

InitialGuess = initial_gains_file.Gains;

%% initialze parameters
[inner_opt_settings,opts] = setInnerOptSettings('init_gains_file',initial_gains_filename);

OptimParams;
setInit;
dt_visual = 1/30;
[groundX, groundZ, groundTheta] = generateGround('flat');
% load_system(model)

%% Build the Rapid Accelerator target once
% rtp = Simulink.BlockDiagram.buildRapidAcceleratorTarget(model);

%% setup cmaes
numvars = length(InitialGuess);
x0 = zeros(numvars,1);
sigma0 = 1/8;
% sigma0 = 1/3;

% opts.SaveFilename = 'vcmaes_Umb10_SONG3D_kneelim1_2.mat';
opts.SaveFilename = 'vcmaes_simInputTry.mat';
opts.UserDat2 = strcat(opts.UserDat2,"; ", "sigma0: ", string(sigma0));

save_system(model);

%% Show settings
clc;
disp(inner_opt_settings);
disp(initial_gains_filename);
fprintf('Target velocity: %1.1f m/s \n',target_velocity);
fprintf('Amputated hip flexor diminish factor:   %1.2f \n',ampHipFlexFactor);
fprintf('Amputated hip extensor diminish factor: %1.2f \n',ampHipExtFactor);
parpool('local',inner_opt_settings.numParWorkers);

%% run cmaes
[xmin, fmin, counteval, stopflag, out, bestever] = cmaes(optfunc, x0, sigma0, opts)
