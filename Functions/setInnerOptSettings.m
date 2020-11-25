function [innerOptSettings, opts] = setInnerOptSettings(model,varargin)
% SETINNEROPTSETTINGS               Function that plots the data simulation
%
% INPUTS:
%   - model                         Name of model that is being evaluated or optimized.
%   - varargin                      Variable inputs can be given, which will result in affecting the plot, or adding plots etc
%                                   Use: 
%                                   setInnerOptSettings(model,'nameVarArgin1',<value/data varargin1> ,'nameVarArgin2',<value/data varargin2>)
%                                   Optional varargin:
%                                   - 'initialGainsFilename': .mat file with the initial neurological controller gains  
%                                   - 'initialCMGGainsFilename': s.mat file with the initial CMG controller gains  
%                                   - 'expenditureModel': Expenditure model which should be used in the cost function.                      Default: 'Umberger (2010)'. 
%                                   - 'resume': Select whether to resume a previous optimization, or just do evaluation (yes/no/eval).      Default: 'no'.
%                                   - 'optimizationInfo': Information which is to be added in the optimization directory name.
%                                   - 'timeFactor': Factor with which to multiply the time cost.                                            Default: 100000. 
%                                   - 'velocityFactor': Factor with which to multiply the velocity cost.                                    Default: 100.
%                                   - 'CoTFactor': Factor with which to multiply the cost of transport cost.                                Default: 1.
%                                   - 'sumStopTorqueFactor': Factor with which to multiply the sum of stop torque cost.                     Default: 1E-1.
%                                   - 'CMGdeltaHFactor': Factor with which to multiply the exchanged angular momentum cost.                 Default: 15.
%                                   - 'terrainHeight': Terrain height used during optimization.                                             Default: 0.01 m .
%                                   - 'numTerrains': Number of terrains to evaluate during optimization (of which 1 is flat).               Default: 4.
%                                   - 'targetVelocity': Velocity with which the model has to walk.                                          Default: 0.9 m/s.
%                                   - 'minVelocity': Minimal velocity with which the model has to walk.                                     Default: 0.5 m/s.
%                                   - 'maxVelocity': Maximal velocity with which the model is allowed to walk.                              Default: speed of light 
%                                   - 'minLimbDistance': Minimal distance between center line of limbs that has to be satisfied.            Default: 0.02 m.
%                                   - 'initiationSteps': Number of initial steps which are not included in the cost function evaluation.    Default: 5.
%                                   - 'numParWorkers': Number of parallel workers during optimization.                                      Default: Number of cores available.
%                                   - 'timeOut': Maxmimum computation time simulation of the model can take.                                Default: 10 minutes.
%                                   - 'maxIter': Maximum number of iterations of the CMAES algorithm.                                       Default: 300.
%                                   - 'createVideo': Create a video of the simulation if a new best evaluation is found.                    Default: true.
%
% OUTPUTS:
%   - innerOptSettings              - All the inner optimization settings
%   used in GETCOST, or PLOTPROGRESSOPTIMIZATION
%   - opts
%%
opts = [];
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
        
    validFileFcn = @(ii) isempty(ii) || exist(ii,'file') ==2;
    addParameter(p,'initialGainsFilename','',validFileFcn);
    addParameter(p,'initialCMGGainsFilename','',validFileFcn);
    
    % Umberger (2003), Umberger (2003) TG, Umberger (2010), Wang (2012) are valid
    validExpModelFcn = @(ii) sum(contains(getExpenditureModels(model),ii))>0;
    addParameter(p,'expenditureModel','Umberger (2010)',validExpModelFcn);
    
    validResumeFcn = @(ii) contains(ii,'yes') || contains(ii,'no') || contains(ii,'eval');
    addParameter(p,'resume','no',validResumeFcn);
    
    validCharFcn = @(ii) ischar(ii);
    addParameter(p,'optimizationInfo','',validCharFcn);
    
    validValueFcn = @(ii) isreal(ii);
    % Cost function factors
    addParameter(p,'timeFactor',            100000,             validValueFcn);
    addParameter(p,'velocityFactor',        100,                validValueFcn);
    addParameter(p,'CoTFactor',             1,                  validValueFcn);
    addParameter(p,'sumStopTorqueFactor',   1E-2,               validValueFcn);
    addParameter(p,'CMGdeltaHFactor',       15,                 validValueFcn); 
    
    addParameter(p,'terrainHeight',         0.010,              validValueFcn); % m
    addParameter(p,'targetVelocity',        0.9,                validValueFcn); % m/s
    addParameter(p,'minVelocity',           0.5,                validValueFcn); % m/s
    addParameter(p,'maxVelocity',           299792458,          validValueFcn); % m/s, speed of light
    
    addParameter(p,'minLimbDistance',       0.02,               validValueFcn); % m, minimal distance betweeen limbs
    
    validIntegerFcn = @(ii) mod(ii,1)==0;
    addParameter(p,'numTerrains',       4,                  validIntegerFcn);
    addParameter(p,'initiationSteps',   4,                  validIntegerFcn);
    addParameter(p,'numParWorkers',     maxNumCompThreads,  validIntegerFcn);
    addParameter(p,'timeOut',           10*60,              validIntegerFcn); % Time out for simulation
    addParameter(p,'maxIter',           300,              validIntegerFcn);
    
    validBoolFcn = @(ii) isscalar(ii) && islogical(ii);
    addParameter(p,'createVideo',     true,  validBoolFcn);  % Create video during optimization
    
end

parse(p,varargin{:});

%%
innerOptSettings.optimizationDir            = ' ';
optimizationInfo                            = p.Results.optimizationInfo;
innerOptSettings.modelStopTime              = str2double(get_param(model,'StopTime'));

innerOptSettings.initialGainsFilename       = p.Results.initialGainsFilename;
innerOptSettings.initialCMGGainsFilename    = p.Results.initialCMGGainsFilename;

innerOptSettings.expenditure_model      = p.Results.expenditureModel;   %'Umberger (2010)';
innerOptSettings.numTerrains            = p.Results.numTerrains;
innerOptSettings.terrainHeight          = p.Results.terrainHeight; % in m

% Cost function factors
innerOptSettings.timeFactor             = p.Results.timeFactor;
innerOptSettings.velocityFactor         = p.Results.velocityFactor;
innerOptSettings.CoTFactor              = p.Results.CoTFactor;      % cost of transport
innerOptSettings.sumStopTorqueFactor    = p.Results.sumStopTorqueFactor;
innerOptSettings.CMGdeltaHFactor        = p.Results.CMGdeltaHFactor;

if ~usejava('desktop') || batchStartupOptionUsed
    innerOptSettings.visual             = false;
else
    innerOptSettings.visual             = true;
end

innerOptSettings.numParWorkers          = p.Results.numParWorkers;

innerOptSettings.targetVelocity         = p.Results.targetVelocity; % m/s
if ~isempty(innerOptSettings.targetVelocity)
    innerOptSettings.minVelocity        = innerOptSettings.targetVelocity;
    innerOptSettings.maxVelocity        = innerOptSettings.targetVelocity;
else
    innerOptSettings.minVelocity        = p.Results.minVelocity;
    innerOptSettings.maxVelocity        = p.Results.maxVelocity; 
end

innerOptSettings.initiationSteps        = p.Results.initiationSteps;
innerOptSettings.minLimbDistance        = p.Results.minLimbDistance;

innerOptSettings.timeOut                = p.Results.timeOut; 
innerOptSettings.createVideo            = p.Results.createVideo;

if ~isempty(innerOptSettings.initialGainsFilename)
    opts                                = cmaes; 
    opts.Resume                         = lower(p.Results.resume);
    opts.MaxIter                        = p.Results.maxIter;
    opts.StopFitness                    = 0;
    opts.DispModulo                     = 1;
    opts.TolX                           = 1e-2;
    opts.TolFun                         = 1e-2;
    opts.EvalParallel                   = 'yes';
    opts.LogPlot                        = 'off';
   
    [innerOptSettings, opts] = createOptDirectory(pwd,innerOptSettings,opts,optimizationInfo);
    
end