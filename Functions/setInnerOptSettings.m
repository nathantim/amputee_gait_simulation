function [inner_opt_settings, opts] = setInnerOptSettings(varargin)
opts = [];
%%%%%%%%%%%%%%%%%%%%
% Parse Argmuments %
%%%%%%%%%%%%%%%%%%%%


persistent p
if isempty(p)
    p = inputParser;
    p.FunctionName = 'setInnerOptSettings';
  
    validModelFcn = @(i) exist(i,'file') ==4;
    addParameter(p,'model','',validModelFcn);
    
    validInitGainsFileFcn = @(i) exist(i,'file') ==2;
    addParameter(p,'init_gains_file','Results/Rough/SongGains_wC.mat',validInitGainsFileFcn);
    
    
    validExpModelFcn = @(i) sum(contains(getExpenditureModels(model),i))>0;
    addParameter(p,'expenditure_model','Umberger (2010)',validExpModelFcn);
    
    validPosValFcn = @(i) isempty(i) || i>0;
    addParameter(p,'target_velocity',0.9,validPosValFcn)
    
%     validSpeedFcn = @(i) isnumeric(i) && isscalar(i) && (i > 0);
%     addParameter(p,'speed',1,validSpeedFcn);
% 
%     validBoolFcn = @(i) islogical(i) && isscalar(i);
%     addParameter(p,'intact',false,validBoolFcn);
%     addParameter(p,'saveAllFrames',false,validBoolFcn);
%     addParameter(p,'showFrameNum',false,validBoolFcn);
%     addParameter(p,'showTime',false,validBoolFcn);
 

end
parse(p,varargin{:});
if ~isempty(p.Results.model)
    load_system(p.Results.model);
end
init_gains_filename = p.Results.init_gains_file;

% Umberger (2003), Umberger (2003) TG, Umberger (2010), Wang (2012)
inner_opt_settings.expenditure_model = p.Results.expenditure_model;%'Umberger (2010)';
inner_opt_settings.timeFactor = 100000;
inner_opt_settings.velocityFactor = 100;
inner_opt_settings.CoTFactor = 10; % cost of transport
inner_opt_settings.sumStopTorqueFactor = 1E-2;

inner_opt_settings.numTerrains = 6;
inner_opt_settings.terrain_height = 0.015; % in m

% literature velocity: [0.5,0.9,1.2]
inner_opt_settings.target_velocity = p.Results.target_velocity; %0.9;

if ~isempty(inner_opt_settings.target_velocity)
    inner_opt_settings.min_velocity = inner_opt_settings.target_velocity;
    inner_opt_settings.max_velocity = inner_opt_settings.target_velocity;
    opts.TargetVel = inner_opt_settings.target_velocity;
else
    inner_opt_settings.min_velocity = 0.5;
    inner_opt_settings.max_velocity = 299792458.0; % speed of light
end
inner_opt_settings.initiation_steps = 5;


% feature('NumCores')
inner_opt_settings.numParWorkers = feature('NumCores');

if usejava('desktop')
    %inner_opt_settings.numParWorkers = 4;
    inner_opt_settings.visual = true;
else
%     inner_opt_settings.numParWorkers = 12;
    inner_opt_settings.visual = false;
end

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
% if ~isempty(target_velocity) %(inner_opt_settings.min_velocity == inner_opt_settings.target_velocity && inner_opt_settings.max_velocity == inner_opt_settings.target_velocity)
%     
% end
opts.UserData = char(strcat("Gains filename: ", init_gains_filename));
opts.UserDat2 = '';
fields_opts = fields(inner_opt_settings);
for i = 1:length(fields(inner_opt_settings))
    opts.UserDat2 = strcat(opts.UserDat2,"; ", fields_opts{i}, ": ", string(inner_opt_settings.(fields_opts{i})));
end
