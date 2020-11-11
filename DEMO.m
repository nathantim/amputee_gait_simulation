bdclose('all'); clearvars; close all; clc
%%
setup_paths;
if input(['Do you want to \n' '(1) simulate all models, or \n' '(0) use datafiles for visualization ? \n' '(Note: simulation can takes some time, around 30 min)\n   '])
    %%
    pathnames = {'IntactModel3D','Prosthetic3R60_3D','Prosthetic3R60CMG_3D'};
    
    hwb = waitbar(0,'Please wait...');
    executMess = '';
    tic;
    for idxModels = 1:length(pathnames)
        
        cd(pathnames{idxModels})
        outPut = evalc('demorun');
        commOutput{idxModels} = outPut;
        for jjModels = 1:length(simout)
            simouts(jjModels,idxModels) = simout(jjModels);
        end
        cd ..
        clearvars -except idxModels simouts commOutput pathnames hwb executMess
        executMess = [executMess pathnames{idxModels} ', '];
        waitbar(idxModels/length(pathnames),hwb,['Please wait... ' executMess 'just executed....']);
    end
    toc;
    close(hwb);
    intactArray = logical([1,0,0]);
    cmgArray = logical([0,0,1]);
    
    %%
    realHealthy3D = load('Plot_figures/Data/FukuchiData.mat','gaitData');
    realHealthy3D09 = realHealthy3D.gaitData.v0_9;
    realHealthy3D12 = realHealthy3D.gaitData.v1_2;
    prosthetic3DCMGNOTActive = load('Prosthetic3R60CMG_3D/Results/resultData_prostheticNOTActiveCMG_1.2ms.mat');
    prosthetic3DCMGActive = simouts(3,3);
    CMGtripPrevent = simouts(1,3);
    prosthetic3D09 = simouts(1,2);
    prosthetic3D12 = simouts(2,2);
    healthy3D09 = simouts(1,1);
    healthy3D12 = simouts(2,1);
    
    plotHealthyProstheticData(realHealthy3D09,healthy3D09,prosthetic3D09,[],[],'3D_0_9ms',false)
    plotHealthyProstheticData(realHealthy3D12,healthy3D12,prosthetic3D12,prosthetic3DCMGNOTActive.simout,prosthetic3DCMGActive,'3D_1_2ms',false);
    plotCombinedCMGData(prosthetic3DCMGActive,CMGtripPrevent);
    
else
    
    healthy3D09 = load('IntactModel3D/Results/resultData_healthy_0.9ms.mat');
    healthy3D12 = load('IntactModel3D/Results/resultData_healthy_1.2ms.mat');
    realHealthy3D = load('Plot_figures/Data/FukuchiData.mat','gaitData');
    realHealthy3D09 = realHealthy3D.gaitData.v0_9;
    realHealthy3D12 = realHealthy3D.gaitData.v1_2;
    prosthetic3D09 = load('Prosthetic3R60_3D/Results/resultData_prosthetic_0.9ms.mat');
    prosthetic3D12 = load('Prosthetic3R60_3D/Results/resultData_prosthetic_1.2ms.mat');
    prosthetic3DCMGActive = load('Prosthetic3R60CMG_3D/Results/resultData_prostheticActiveCMG_1.2ms.mat');
    prosthetic3DCMGTripFall = load('Prosthetic3R60CMG_3D/Results/resultData_prostheticTripNOTPrevent.mat');
    prosthetic3DCMGTripPrevent = load('Prosthetic3R60CMG_3D/Results/resultData_prostheticTripPrevent.mat');
    
    plotHealthyProstheticData(realHealthy3D09,healthy3D09.simout,prosthetic3D09.simout,[],[],'3D_0_9ms',false)
    plotHealthyProstheticData(realHealthy3D12,healthy3D12.simout,prosthetic3D12.simout,prosthetic3DCMGNOTActive.simout,prosthetic3DCMGActive.simout,'3D_1_2ms',false);
    plotCombinedCMGData(prosthetic3DCMGActive.simout,prosthetic3DCMGTripPrevent.simout);
    
    animPost3D(healthy3D09.simout.animData3D,'intact',true,'obstacle',false,'view','perspective','CMG',false);
    animPost3D(healthy3D12.simout.animData3D,'intact',true,'obstacle',false,'view','perspective','CMG',false);
    animPost3D(prosthetic3D09.simout.animData3D,'intact',false,'obstacle',false,'view','perspective','CMG',false);
    animPost3D(prosthetic3D12.simout.animData3D,'intact',false,'obstacle',false,'view','perspective','CMG',false);
    animPost3D(prosthetic3DCMGActive.simout.animData3D,'intact',false,'obstacle',false,'view','perspective','CMG',true);
    animPost3D(prosthetic3DCMGTripFall.simout.animData3D,'intact',false,'obstacle',true,'view','perspective','CMG',true);
    animPost3D(prosthetic3DCMGTripPrevent.simout.animData3D,'intact',false,'obstacle',true,'view','perspective','CMG',true);

            
end