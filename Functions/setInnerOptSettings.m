function [innerOptSettings, opts] = setInnerOptSettings(b_resume,initial_gains_filename,optimizationInfo,initial_gains_filenameCMG)
if nargin < 2
    initial_gains_filename = '';
end
if nargin < 3
    optimizationInfo = '';
end
if nargin < 4
    initial_gains_filenameCMG = [];
end
OptimParams;
opts = [];


% Umberger (2003), Umberger (2003) TG, Umberger (2010), Wang (2012)
innerOptSettings.expenditure_model = 'Umberger (2010)';
innerOptSettings.timeFactor = 100000;
innerOptSettings.velocityFactor = 100;
innerOptSettings.CoTFactor = 1; % cost of transport
innerOptSettings.sumStopTorqueFactor = 1E-2;
innerOptSettings.CMGTorqueFactor = 0;
innerOptSettings.CMGdeltaHFactor = 15;
innerOptSettings.ControlRMSEFactor = 0;
innerOptSettings.selfCollisionFactor = 1000;


% innerOptSettings.numTerrains = 4;
innerOptSettings.numTerrains = 1;
innerOptSettings.terrain_height = 0.010; % in m
% innerOptSettings.terrain_height = 0.010E-8; % in m

if usejava('desktop')
    innerOptSettings.numParWorkers = 4;
    innerOptSettings.visual = true;
else
    innerOptSettings.numParWorkers = 4;
    innerOptSettings.visual = false;
end
innerOptSettings.initiation_steps = initiation_steps;
innerOptSettings.target_velocity = target_velocity;
innerOptSettings.min_velocity = min_velocity;
innerOptSettings.max_velocity = max_velocity;

innerOptSettings.timeOut = 25*60; % Time out for simulation
innerOptSettings.createVideo = true; % Create video during optimization
if nargin > 0
    opts = cmaes;
    %opts.PopSize = numvars;
    if contains(num2str(b_resume),'yes') || min(opts.Resume) == 1 
        opts.Resume = 'yes';
    elseif contains(num2str(b_resume),'no') || min(opts.Resume) == 0 
        opts.Resume = 'no';
    elseif contains(num2str(b_resume),'eval') || min(opts.Resume) == -1 
        opts.Resume = 'eval';
    end
    opts.MaxIter = 300;
    % opts.StopFitness = -inf;
    opts.StopFitness = 0;
    opts.DispModulo = 1;
    opts.TolX = 1e-2;
    opts.TolFun = 1e-2;
    opts.EvalParallel = 'yes';
    opts.LogPlot = 'off';
    if (min_velocity == target_velocity && max_velocity == target_velocity)
        opts.TargetVel = target_velocity;
    end
    opts.UserData = char(strcat("Gains filename: ", initial_gains_filename, "  ; CMGGains: ", initial_gains_filenameCMG));
    opts.UserDat2 = '';
    fields_opts = fields(innerOptSettings);
    for ii = 1:length(fields(innerOptSettings))
        opts.UserDat2 = strcat(opts.UserDat2,"; ", fields_opts{ii}, ": ", string(innerOptSettings.(fields_opts{ii})));
    end
    
    [innerOptSettings, opts] = createOptDirectory(pwd,innerOptSettings,opts,optimizationInfo);
    
end