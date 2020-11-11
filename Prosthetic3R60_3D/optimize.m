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
global model rtp InitialGuess innerOptSettings
initial_gains_filename = ['Results'  filesep 'v1.2ms.mat'];

%% specifiy model and intial parameters
model = 'NeuromuscularModel_3R60_3D';
optfunc = 'cmaesParallelSplit';

load_system(model);

%% initialze parameters
[innerOptSettings,opts] = setInnerOptSettings(b_resumeOptimization,initial_gains_filename,optimizationInfo);

InitialGuessFile = load([innerOptSettings.optimizationDir filesep 'initial_gains.mat']);
InitialGuess = [InitialGuessFile.GainsSagittal;InitialGuessFile.initConditionsSagittal;...
				InitialGuessFile.GainsCoronal; InitialGuessFile.initConditionsCoronal];
            
run([innerOptSettings.optimizationDir, filesep, 'BodyMechParamsCapture']);
run([innerOptSettings.optimizationDir, filesep, 'ControlParamsCapture']);
run([innerOptSettings.optimizationDir, filesep, 'Prosthesis3R60ParamsCapture']);
run([innerOptSettings.optimizationDir, filesep, 'OptimParamsCapture']);

setInitVar;
dt_visual = 1/30;
animFrameRate = 30;
[groundX, groundZ, groundTheta] = generateGround('flat');

%% Build the Rapid Accelerator target once
rtp = Simulink.BlockDiagram.buildRapidAcceleratorTarget(model);


%% setup cmaes
numvars = length(InitialGuess);
x0 = zeros(numvars,1);
sigma0 = 1/8;


opts.DiagonalOnly = 10;
opts.UserDat2 = strcat( opts.UserDat2,"; ", "sigma0: ", string(sigma0), "; ampHipFlexFactor: ", ...
                        string(ampHipFlexFactor) , "; ampHipExtFactor: ", string(ampHipExtFactor), ...
                        "; ampHipAbdFactor: ", string(ampHipAbdFactor), "; ampHipAddFactor: ", string(ampHipAddFactor) );

%% Show settings
clc;
disp(opts);
disp(innerOptSettings);
disp(initial_gains_filename);
fprintf('Target velocity: %1.1f m/s \n',innerOptSettings.target_velocity);
fprintf('Amputated hip flexor diminish factor:   %1.2f \n',ampHipFlexFactor);
fprintf('Amputated hip extensor diminish factor: %1.2f \n',ampHipExtFactor);
fprintf('Amputated hip abductor diminish factor: %1.2f \n',ampHipAbdFactor);
fprintf('Amputated hip adductor diminish factor: %1.2f \n',ampHipAddFactor);


%% run cmaes
[xmin, fmin, counteval, stopflag, out, bestever] = cmaes(optfunc, x0, sigma0, opts)
