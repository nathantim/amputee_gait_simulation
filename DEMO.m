bdclose('all'); clearvars; close all; clc
%%
setup_paths;
if input(['\nDo you want to \n' '(1) simulate, or \n' '(0) load datafiles? \n' '(Note: simulation can takes some time, (30-60 min)   '])
    %% Simulating the models
    modelsSelected = [str2num(input(['\nWhich simulations do you want to run? \n '...
        '   (1) Healthy model gait \n '...
        '   (2) Amputee model gait \n '...,
        '   (3) Amputee model with CMG gait, and trip prevention \n '...
        ' (Note: amputee models are numerical sensitve, especially the trip prevention simulation. \n ' ...
        ' Running the simulation on your computer might yield different results than presented in the paper.\n '...
        ' You can optimize your gains to get a successful result) \n ',...
        ' You can select multiple models            '],'s'))];
    pathnames = {'IntactModel3D','Prosthetic3R60_3D','Prosthetic3R60CMG_3D'};
    
    hwb = waitbar(0,'Please wait...');
    allChild =  findall(hwb);
    set(hwb, 'Units', 'Normalized');
    for childIdx = 1:length(allChild)
        try
            set(allChild(childIdx), 'Units', 'Normalized')
        catch
        end
    end
    
    currPos = get(hwb,'Position');
    set(hwb,'Position',[currPos(1:2) 0.4 0.08])
    
    executMess = '';
    tic;
    for idxModels = 1:length(modelsSelected)
        
        cd(pathnames{modelsSelected(idxModels)})
        % Run subfolder demorun script
        try
            outPut = evalc('demorun');
        catch ME
            cd ..
            error(ME.message);
        end
        
        % Save output from the script
        commOutput{idxModels} = outPut;
        for jjModels = 1:length(simout)
            simouts(jjModels,idxModels) = simout(jjModels);
        end
        cd ..
        clearvars -except idxModels simouts commOutput pathnames hwb executMess modelsSelected
        
        % update waitbar
        executMess = [executMess pathnames{modelsSelected(idxModels)} ', '];
        executMess = strrep(executMess,'_3D','{\_}3D');
        waitbar(idxModels/length(modelsSelected),hwb,['Please wait... ' executMess 'executed.']);
    end
    toc;
    close(hwb);
    
    %% Setting the results
    realHealthy3D                       = load('Plot_figures/Data/FukuchiData.mat','gaitData');
    realHealthy3D09                     = realHealthy3D.gaitData.v0_9;
    realHealthy3D12                     = realHealthy3D.gaitData.v1_2;
    healthy3D09.simout                  = simouts(1,1);
    healthy3D12.simout                  = simouts(2,1);
    prosthetic3D09.simout               = simouts(1,2);
    prosthetic3D12.simout               = simouts(2,2);
    prosthetic3DCMGTripPrevent.simout   = simouts(1,3);
    prosthetic3DCMGActive.simout        = simouts(2,3);
    prosthetic3DCMGTripFall.simout      = simouts(3,3);
    prosthetic3DCMGNOTActive.simout     = simouts(4,3);
    
    
else
    %% Get the saved results
    healthy3D09                 = load('IntactModel3D/Results/resultData_healthy_0.9ms.mat');
    healthy3D12                 = load('IntactModel3D/Results/resultData_healthy_1.2ms.mat');
    realHealthy3D               = load('Plot_figures/Data/FukuchiData.mat','gaitData');
    realHealthy3D09             = realHealthy3D.gaitData.v0_9;
    realHealthy3D12             = realHealthy3D.gaitData.v1_2;
    prosthetic3D09              = load('Prosthetic3R60_3D/Results/resultData_prosthetic_0.9ms.mat');
    prosthetic3D12              = load('Prosthetic3R60_3D/Results/resultData_prosthetic_1.2ms.mat');
    prosthetic3DCMGNOTActive    = load('Prosthetic3R60CMG_3D/Results/resultData_prostheticNOTActiveCMG_1.2ms.mat');
    prosthetic3DCMGActive       = load('Prosthetic3R60CMG_3D/Results/resultData_prostheticActiveCMG_1.2ms.mat');
    prosthetic3DCMGTripFall     = load('Prosthetic3R60CMG_3D/Results/resultData_prostheticTripFall.mat');
    prosthetic3DCMGTripPrevent  = load('Prosthetic3R60CMG_3D/Results/resultData_prostheticTripPrevent.mat');
    
end

%% Plotting and animating the results
plotSelected = [str2num(input(['\nWhich results do you want to plot? \n '...
    '  (1) Gait at 0.9 m/s \n '...
    '  (2) Gait at 1.2 m/s \n '...
    '  (3) CMG data during walking and trip prevention \n '...
    ' You can select multiple animations or leave it empty           '],'s'))];

plotCommands = { ...
    'plotHealthyProstheticData(realHealthy3D09,healthy3D09.simout,prosthetic3D09.simout,[],[],''0.9m/s'',false)';...
    'plotHealthyProstheticData(realHealthy3D12,healthy3D12.simout,prosthetic3D12.simout,prosthetic3DCMGNOTActive.simout,prosthetic3DCMGActive.simout,''1.2m/s'',false);';...
    'plotCombinedCMGData(prosthetic3DCMGActive.simout,prosthetic3DCMGTripPrevent.simout);'};

animationCommands = {'animPost3D(healthy3D09.simout.animData3D,''intact'',true,''obstacle'',false,''view'',''perspective'',''CMG'',false,''info'',''Healthy 0.9m/s'');';...
    'animPost3D(healthy3D12.simout.animData3D,''intact'',true,''obstacle'',false,''view'',''perspective'',''CMG'',false,''info'',''Healthy 1.2m/s'');';...
    'animPost3D(prosthetic3D09.simout.animData3D,''intact'',false,''obstacle'',false,''view'',''perspective'',''CMG'',false,''info'',''Amputee 0.9m/s'');';...
    'animPost3D(prosthetic3D12.simout.animData3D,''intact'',false,''obstacle'',false,''view'',''perspective'',''CMG'',false,''info'',''Amputee 1.2m/s'');';...
    'animPost3D(prosthetic3DCMGNOTActive.simout.animData3D,''intact'',false,''obstacle'',false,''view'',''perspective'',''CMG'',true,''info'',''Amputee with inactive CMG'')';...
    'animPost3D(prosthetic3DCMGActive.simout.animData3D,''intact'',false,''obstacle'',false,''view'',''perspective'',''CMG'',true,''info'',''Amputee with active CMG'')';...
    'animPost3D(prosthetic3DCMGTripFall.simout.animData3D,''intact'',false,''obstacle'',true,''view'',''perspective'',''CMG'',true,''info'',''Amputee trip fall'')';...
    'animPost3D(prosthetic3DCMGTripPrevent.simout.animData3D,''intact'',false,''obstacle'',true,''view'',''perspective'',''CMG'',true,''info'',''Amputee trip prevention'')';};

animSelected = [str2num(input(['\nWhich gaits do you want to animate? \n '...
    '  (1) Healthy model gait at 0.9 m/s \n '...
    '  (2) Healthy model gait at 1.2 m/s \n '...
    '  (3) Amputee model gait at 0.9 m/s \n '...
    '  (4) Amputee model gait at 1.2 m/s \n '...
    '  (5) Amputee model with inactive CMG gait \n '...
    '  (6) Amputee model with active CMG gait \n '...
    '  (7) Amputee model tripping and falling over obstacle \n '...
    '  (8) Amputee model trip prevented \n '...
    ' You can select multiple animations or leave it empty           '],'s'))];

for plotIdx = 1:length(plotSelected)
    evalc(plotCommands{plotSelected(plotIdx)});
end

for animIdx = 1:length(animSelected)
    evalc(animationCommands{animSelected(animIdx)});
end