function [inner_opt_settings, opts] = createOptDirectory(modelDir,inner_opt_settings,opts,optimizationInfo)
% Function creates a directory in the Results folder located in the directory
% of the NeuroMuscular model file. This directory contains the vcmaes file
% which contains saved intermediate steps of the optimization, and it
% contains successfull runs (meaning full simulation time was reached)
% If resume is true, than it selects the latests directory containing the
% same optimization info and target velocity
baseDirParts = strsplit(modelDir,filesep);
baseDir = baseDirParts{1};
for idx = 2:length(baseDirParts)-1
    baseDir = [baseDir filesep baseDirParts{idx}];
end

if contains(num2str(opts.Resume),'no') || min(opts.Resume) == 0
    dateNow = strcat(char(datestr(now,'yyyy-mm-dd_HH-MM')),'_');
    
    folderName = [dateNow, num2str(inner_opt_settings.target_velocity) 'ms_' optimizationInfo];
    optDirectory = [modelDir, filesep, 'Results', filesep, folderName];
    mkdir(optDirectory);
    inner_opt_settings.optimizationDir = optDirectory;
    
    init_gains = strsplit(string(opts.UserData),' ');
    init_gains = init_gains{end};
    init_gains_name = strsplit(string(opts.UserData),filesep);
    init_gains_name = init_gains_name{end};
    opts.UserData = ['Gains filename: ' optDirectory, filesep init_gains_name];
    moveAndRenameFile([modelDir filesep init_gains], [optDirectory, filesep 'initial_gains.mat']);
    moveAndRenameFile([baseDir filesep 'BodyMechParams.m'], [optDirectory, filesep,'BodyMechParamsCapture.m']);
    moveAndRenameFile([modelDir filesep 'ControlParams.m'], [optDirectory, filesep,'ControlParamsCapture.m']);
    moveAndRenameFile([baseDir filesep 'Prosthesis3R60Params.m'], [optDirectory, filesep,'Prosthesis3R60ParamsCapture.m']);
    moveAndRenameFile([baseDir filesep 'OptimParams.m'], [optDirectory, filesep,'OptimParamsCapture.m']);
    
%     opts.SaveFilename = [optDirectory filesep 'vcmaes.mat'];
    opts.BaseDirectory = optDirectory;
    save([optDirectory filesep 'settings.mat'],'inner_opt_settings','opts');  
    
    
elseif contains(num2str(opts.Resume),'yes') || min(opts.Resume) == 1
%     folderNameContains = [num2str(inner_opt_settings.target_velocity) 'ms_' optimizationInfo];
%     
%     existFolders = dir([modelDir, filesep, 'Results']);
%     existFoldersNames = {existFolders.name};
%     
%     folderName = existFoldersNames{ find((contains(existFoldersNames,folderNameContains)) == 1,1,'last') };
    optDirectory = uigetdir; %[modelDir, filesep, 'Results', filesep, folderName];
    
    prevSettings = load([optDirectory filesep 'settings.mat']);
    opts = prevSettings.opts;
    inner_opt_settings = prevSettings.inner_opt_settings;
    
else
    error('Unknown resume value');
end

