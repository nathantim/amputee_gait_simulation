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
    for ii = 1:size(simouts,2)
        for jj = 1:size(simouts,1)
        animPost3D(simouts(jj,ii).animData3D,'intact',intactArray(ii),'view','perspective',...
                'CMG',cmgArray(ii),'obstacle',cmgArray(ii),'showFigure',true,'createVideo',false);
            
        plotData(simouts(jj,ii).angularData,simouts(jj,ii).musculoData,simouts(jj,ii).GRFData,...
            simouts(jj,ii).jointTorquesData,simouts(jj,ii).GaitPhaseData,simouts(jj,ii).stepTimes,...
            simouts(jj,ii).CMGData,'',[],0,1,1);
    
        end
    end
    
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
    
    animPost3D(healthy3D09.simout.animData3D,'intact',true,'obstacle',false,'view','perspective','CMG',false);
    animPost3D(healthy3D12.simout.animData3D,'intact',true,'obstacle',false,'view','perspective','CMG',false);
    animPost3D(prosthetic3D09.simout.animData3D,'intact',false,'obstacle',false,'view','perspective','CMG',false);
    animPost3D(prosthetic3D12.simout.animData3D,'intact',false,'obstacle',false,'view','perspective','CMG',false);
    animPost3D(prosthetic3DCMGActive.simout.animData3D,'intact',false,'obstacle',false,'view','perspective','CMG',true);
    animPost3D(prosthetic3DCMGTripFall.simout.animData3D,'intact',false,'obstacle',true,'view','perspective','CMG',true);
    animPost3D(prosthetic3DCMGTripPrevent.simout.animData3D,'intact',false,'obstacle',true,'view','perspective','CMG',true);

            
end