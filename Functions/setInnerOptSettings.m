function [inner_opt_settings, opts] = setInnerOptSettings(initial_gains_filename)
OptimParams;
opts = [];
% Umberger (2003), Umberger (2003) TG, Umberger (2010), Wang (2012)
inner_opt_settings.expenditure_model = 'Umberger (2010)';
inner_opt_settings.timeFactor = 100000;
inner_opt_settings.velocityFactor = 100;
inner_opt_settings.CoTFactor = 10; % cost of transport
inner_opt_settings.sumStopTorqueFactor = 1E-2;
inner_opt_settings.CMGTorqueFactor = 5;

inner_opt_settings.numTerrains = 6;
inner_opt_settings.terrain_height = 0.015; % in m
if usejava('desktop')
    inner_opt_settings.numParWorkers = 4;
    inner_opt_settings.visual = true;
else
    inner_opt_settings.numParWorkers = 4;
    inner_opt_settings.visual = false;
end
if nargin > 0
    opts = cmaes;
    %opts.PopSize = numvars;
    opts.Resume = 'yes';
    opts.MaxIter = 2000;
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
end