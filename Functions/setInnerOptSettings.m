function [innerOptSettings, opts] = setInnerOptSettings(model,varargin)
% PLOTDATA                          Function that plots the data simulation
%
% INPUTS:
%   - varargin                      Variable inputs can be given, which will result in affecting the plot, or adding plots etc
%                                   Use: 
%                                   plotData(GaitPhaseData,stepTimes,'nameVarArgin1',<value/data varargin1> ,'nameVarArgin2',<value/data varargin2>)
%                                   Required varargin:
%                                   - 'GaitPhaseData': structure with the gait phase data from the simulation 
%                                   - 'stepTimes': structure with the step time data from simulation.
%                                   Optional varargin:
%                                   - 'angularData': structure with time with angular data from simulation  
%                                   - 'musculoData': structure with time with muscular data from simulation 
%                                   - 'GRFData': structure with time with GRF data from simulation 
%                                   - 'jointTorquesData': structure with time with joint torque data from simulation 
%                                   - 'CMGData': structure with time with CMG data from simulation 
%                                   - 'saveFigure': bool for saving figure, default: false
%                                   - 'showAverageStride': bool for showing data averaged per stride, default: true
%                                   - 'showSD': bool for showing std data per stride, default: true
%                                   - 'showFukuchi': bool for showing Fukuchi data, default: false
%                                   - 'info': char with information that can be added to figure saved file name
%                                   - 'timeInterval': time interval over which to show the data
% 
%   - amputeeCMGNotActiveData       Optional, structure with the data from amputee gait with inactive CMG simulation.
%   - amputeeCMGActiveData          Optional, Structure with the data from amputee gait with active CMG simulation.
%   - info                          Optional, info which can be added to the saved file name of the figure
%   - b_saveTotalFig                Optional, select whether to save the figure or not, default is false
%
% OUTPUTS:
%   -
%%
if ~isempty(model)
    load_system(model);
end
%%%%%%%%%%%%%%%%%%%%
% Parse Argmuments %
%%%%%%%%%%%%%%%%%%%%

persistent p
if isempty(p)
    p = inputParser;
    p.FunctionName = 'setInnerOptSettings';
    

        
    validFileFcn = @(ii) exist(ii,'file') ==2;
    addParameter(p,'initialGainsFilename','',validFileFcn);
    
    % Umberger (2003), Umberger (2003) TG, Umberger (2010), Wang (2012) are valid
    validExpModelFcn = @(ii) sum(contains(getExpenditureModels(model),ii))>0;
    addParameter(p,'expenditureModel','Umberger (2010)',validExpModelFcn);
    
    validResumeFcn = @(ii) contains(ii,'yes') || contains(ii,'no') || contains(ii,'eval');
    addParameter(p,'resume','eval',validResumeFcn);
    
    validCharFcn = @(ii) ischar(ii);
    addParameter(p,'optimizationInfo','',validCharFcn);
    
    validValueFcn = @(ii) isreal(ii);
    addParameter(p,'timeFactor',            100000,             validValueFcn);
    addParameter(p,'velocityFactor',        100,                validValueFcn);
    addParameter(p,'CoTFactor',             1,                  validValueFcn);
    addParameter(p,'sumStopTorqueFactor',   1E-2,               validValueFcn);
    addParameter(p,'CMGTorqueFactor',       0,                  validValueFcn);
    addParameter(p,'CMGdeltaHFactor',       15,                 validValueFcn);
    addParameter(p,'ControlRMSEFactor',     0,                  validValueFcn);
    addParameter(p,'selfCollisionFactor',   1000,               validValueFcn);
    addParameter(p,'terrain_height',        0.010,              validValueFcn);
    
    validIntegerFcn = @(ii) isinteger(ii);
    addParameter(p,'numTerrains',       4,  validIntegerFcn);
    addParameter(p,'initiationSteps',   5,  validIntegerFcn);
    
end

parse(p,varargin{:});
opts.Resume             = p.Results.resume;
initialGainsFilename    = p.Results.initialGainsFilename;

%%

%%
OptimParams;
opts = [];


innerOptSettings.expenditure_model      = p.Results.expenditureModel;%'Umberger (2010)';
innerOptSettings.timeFactor             = p.Results.timeFactor;
innerOptSettings.velocityFactor         = p.Results.velocityFactor;
innerOptSettings.CoTFactor              = p.Results.CoTFactor; % cost of transport
innerOptSettings.sumStopTorqueFactor    = p.Results.sumStopTorqueFactor;
innerOptSettings.CMGTorqueFactor        = p.Results.CMGTorqueFactor;
innerOptSettings.CMGdeltaHFactor        = p.Results.CMGdeltaHFactor;
innerOptSettings.ControlRMSEFactor      = p.Results.ControlRMSEFactor;
innerOptSettings.selfCollisionFactor    = p.Results.selfCollisionFactor;

innerOptSettings.numTerrains = 4;
innerOptSettings.terrain_height = 0.010; % in m
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

innerOptSettings.timeOut = 10*60; % Time out for simulation
innerOptSettings.createVideo = true; % Create video during optimization
if nargin > 0
    opts = cmaes;
    %opts.PopSize = numvars;
    
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
    opts.UserData = char(strcat("Gains filename: ", initialGainsFilename));
    opts.UserDat2 = '';
    fields_opts = fields(innerOptSettings);
    for ii = 1:length(fields(innerOptSettings))
        opts.UserDat2 = strcat(opts.UserDat2,"; ", fields_opts{ii}, ": ", string(innerOptSettings.(fields_opts{ii})));
    end
    
    [innerOptSettings, opts] = createOptDirectory(pwd,innerOptSettings,opts,optimizationInfo);
    
end