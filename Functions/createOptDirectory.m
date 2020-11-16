function [setInnerOptSettings, opts] = createOptDirectory(modelDir,setInnerOptSettings,opts,optimizationInfo)
%CREATEOPTDIRECTORY             Function creates a directory in the Results folder located in the directory
%                               of the NeuroMuscular model file. This directory contains the vcmaes file
%                               which contains saved intermediate steps of the optimization, and it
%                               contains successfull runs (meaning full simulation time was reached)
%                               If resume is true, than it selects the latests directory containing the
%                               same optimization info and target velocity
% INPUTS:
%   - modelDir                  Directory of the model that is being optimized
%   - setInnerOptSettings       Already created settings, to which the optimization directory is added
%   - opts                      Already created options, to which the optimization directory is set as base directory
%   - optimizationInfo          Extra info added to the optimization directory name
%%
baseDirParts = strsplit(modelDir,filesep);
baseDir = baseDirParts{1};
for idx = 2:length(baseDirParts)-1
    baseDir = [baseDir filesep baseDirParts{idx}];
end

if contains(num2str(opts.Resume),'no') || min(opts.Resume) == 0
    dateNow = strcat(char(datestr(now,'yyyy-mm-dd_HH-MM')),'_');
    
    folderName = [dateNow, num2str(setInnerOptSettings.target_velocity) 'ms_' optimizationInfo];
    optDirectory = [modelDir, filesep, 'Results', filesep, folderName];
    mkdir(optDirectory);
    setInnerOptSettings.optimizationDir = optDirectory;
    
    moveAndRenameFile([modelDir filesep innerOptSettings.initialGainsFilename], [optDirectory, filesep 'initialGains.mat']);
    if ~isempty(init_gainsCMG)
        moveAndRenameFile([modelDir filesep innerOptSettings.initialCMGGainsFilename], [optDirectory, filesep 'initialGainsCMG.mat']);
        moveAndRenameFile([baseDir filesep 'CMGParams.m'], [optDirectory, filesep,'CMGParamsCapture.m']);
    end
    
    moveAndRenameFile([baseDir filesep 'BodyMechParams.m'], [optDirectory, filesep,'BodyMechParamsCapture.m']);
    moveAndRenameFile([modelDir filesep 'ControlParams.m'], [optDirectory, filesep,'ControlParamsCapture.m']);
    moveAndRenameFile([baseDir filesep 'Prosthesis3R60Params.m'], [optDirectory, filesep,'Prosthesis3R60ParamsCapture.m']);
    
    opts.BaseDirectory = optDirectory;
    save([optDirectory filesep 'settings.mat'],'setInnerOptSettings','opts');  
    
    
elseif contains(num2str(opts.Resume),'yes') || min(opts.Resume) == 1
    optDirectory = uigetdir([modelDir, filesep, 'Results']);
    
    prevSettings = load([optDirectory filesep 'settings.mat']);
    opts = prevSettings.opts;
    opts.Resume = 'yes';
    setInnerOptSettings = prevSettings.setInnerOptSettings;
    
elseif contains(num2str(opts.Resume),'eval')
    setInnerOptSettings.optimizationDir = ' ';
else
    error('Unknown resume value');
end

