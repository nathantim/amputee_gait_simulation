function simout = demorun()
simout = nan;
% model = 'NeuromuscularModel3D';
% gainfiles = {'v0.9ms.mat', 'v1.2ms.mat'};
% 
% [groundX, groundZ, groundTheta] = generateGround('flat');
% dt_visual = 1/1000;
% animFrameRate = 30;
% BodyMechParams;
% ControlParams;
% OptimParams;
% innerOptSettings = setInnerOptSettings('eval');
% 
% for idx = 1:length(gainfiles)
%     
% 
% load(['Results' filesep gainfiles{idx}])
% load_system(model);
% 
% %%
% assignGainsSagittal;
% assignGainsCoronal;
% assignInit;
% 
% tic;
% simout(idx) = sim(model,'TimeOut',10*60, 'SaveOutput','on');
% toc;
% 
% end
% 
% for idx = 1:length(simout)
%     mData=simout(idx).getSimulationMetadata();
%     
%     if strcmp(mData.ExecutionInfo.StopEvent,'DiagnosticError')
%         disp('Sim was stopped due to error');
%         fprintf('Simulation %d was stopped due to error: \n',idx);
%         disp(simout(idx).ErrorMessage);
%     elseif strcmp(mData.ExecutionInfo.StopEvent,'Timeout')
%         fprintf('Simulation %d was stopped due to Timeout: \n',idx);
%     else
%         [~, dataStructLocal] = getCost(model,[],simout(idx).time,simout(idx).metabolicEnergy,simout(idx).sumOfStopTorques,simout(idx).HATPosVel,simout(idx).stepVelocities,simout(idx).stepTimes,simout(idx).stepLengths,simout(idx).stepNumbers,[],simout(idx).selfCollision,innerOptSettings,0);
%         printOptInfo(dataStructLocal,true);
%     end
% end