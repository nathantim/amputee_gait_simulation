function [inner_opt_settings, opts] = setInnerOptSettings(b_resume,initial_gains_filename,optimizationInfo)
if nargin < 2
    initial_gains_filename = '';
end
if nargin < 3
    optimizationInfo = '';
end
OptimParams;
opts = [];


% Umberger (2003), Umberger (2003) TG, Umberger (2010), Wang (2012)
inner_opt_settings.expenditure_model = 'Umberger (2010)';
inner_opt_settings.timeFactor = 100000;
inner_opt_settings.velocityFactor = 100;
inner_opt_settings.CoTFactor = 1; % cost of transport
inner_opt_settings.sumStopTorqueFactor = 1E-2;
inner_opt_settings.CMGTorqueFactor = 0;
inner_opt_settings.CMGdeltaHFactor = 15;
inner_opt_settings.ControlRMSEFactor = 0;
inner_opt_settings.selfCollisionFactor = 1000;

inner_opt_settings.numTerrains = 4;
inner_opt_settings.terrain_height = 0.010; % in m
if usejava('desktop')
    inner_opt_settings.numParWorkers = 4;
    inner_opt_settings.visual = true;
else
    inner_opt_settings.numParWorkers = 4;
    inner_opt_settings.visual = false;
end
inner_opt_settings.initiation_steps = initiation_steps;
inner_opt_settings.target_velocity = target_velocity;
inner_opt_settings.min_velocity = min_velocity;
inner_opt_settings.max_velocity = max_velocity;
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
    opts.UserData = char(strcat("Gains filename: ", initial_gains_filename));
    opts.UserDat2 = '';
    fields_opts = fields(inner_opt_settings);
    for i = 1:length(fields(inner_opt_settings))
        opts.UserDat2 = strcat(opts.UserDat2,"; ", fields_opts{i}, ": ", string(inner_opt_settings.(fields_opts{i})));
    end
    
    [inner_opt_settings, opts] = createOptDirectory(pwd,inner_opt_settings,opts,optimizationInfo);
    
end