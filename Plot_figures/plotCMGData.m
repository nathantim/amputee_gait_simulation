function plotCMGData(CMGData,plotInfo,GaitInfo,saveInfoInput,CMGDataFigure,b_saveFigure)
if nargin <3
   CMGDataFigure = []; 
end
if nargin < 4
    b_saveFigure = false;
end
if ~isstruct(saveInfoInput)
   saveInfo.info = saveInfoInput;
   saveInfo.b_saveFigure = b_saveFigure;
   saveInfo.type = {'jpeg','eps','emf'};
else
    saveInfo = saveInfoInput;
end
CMGParams;
t = CMGData.time;

% t1 = 1;
% t2 = 20;
% idx = (find(abs(CMGData.time-t1) == min(abs(CMGData.time-t1))):find(abs(CMGData.time-t2) == min(abs(CMGData.time-t2))));


%%
gamma               = CMGData.signals.values(:,1);
gammadot            = CMGData.signals.values(:,2);
gammadotref         = CMGData.signals.values(:,3);
torqueTotal         = CMGData.signals.values(:,6);
torqueReset         = CMGData.signals.values(:,7);
torqueLowLevel      = CMGData.signals.values(:,8);
torqueFeedForward   = CMGData.signals.values(:,9);
Hmag                = CMGData.signals.values(:,10);
deltaH_ML           = CMGData.signals.values(:,11);
deltaH_AP           = CMGData.signals.values(:,12);
deltaHmag           = CMGData.signals.values(:,13);
% gyroscopicTorqueML  = CMGData.signals.values(:,15);
% gyroscopicTorqueAP  = CMGData.signals.values(:,16);
% gyroscopicTorqueL   = CMGData.signals.values(:,17);

%%
[gamma_avg,gamma_sd] = interpData2perc(t,GaitInfo.tp,gamma,GaitInfo.start.leftV,GaitInfo.end.leftV,GaitInfo.b_oneGaitPhase);
[gammadot_avg,gammadot_sd] = interpData2perc(t,GaitInfo.tp,gammadot,GaitInfo.start.leftV,GaitInfo.end.leftV,GaitInfo.b_oneGaitPhase);
[gammadotref_avg,gammadotref_sd] = interpData2perc(t,GaitInfo.tp,gammadotref,GaitInfo.start.leftV,GaitInfo.end.leftV,GaitInfo.b_oneGaitPhase);
[torqueTotal_avg,torqueTotal_sd] = interpData2perc(t,GaitInfo.tp,torqueTotal,GaitInfo.start.leftV,GaitInfo.end.leftV,GaitInfo.b_oneGaitPhase);
[torqueReset_avg,torqueReset_sd] = interpData2perc(t,GaitInfo.tp,torqueReset,GaitInfo.start.leftV,GaitInfo.end.leftV,GaitInfo.b_oneGaitPhase);
[torqueLowLevel_avg,torqueLowLevel_sd] = interpData2perc(t,GaitInfo.tp,torqueLowLevel,GaitInfo.start.leftV,GaitInfo.end.leftV,GaitInfo.b_oneGaitPhase);
[torqueFeedForward_avg,torqueFeedForward_sd] = interpData2perc(t,GaitInfo.tp,torqueFeedForward,GaitInfo.start.leftV,GaitInfo.end.leftV,GaitInfo.b_oneGaitPhase);
[Hmag_avg,Hmag_sd] = interpData2perc(t,GaitInfo.tp,Hmag,GaitInfo.start.leftV,GaitInfo.end.leftV,GaitInfo.b_oneGaitPhase);
[deltaH_ML_avg,deltaH_ML_sd] = interpData2perc(t,GaitInfo.tp,deltaH_ML,GaitInfo.start.leftV,GaitInfo.end.leftV,GaitInfo.b_oneGaitPhase);
[deltaH_AP_avg,deltaH_AP_sd] = interpData2perc(t,GaitInfo.tp,deltaH_AP,GaitInfo.start.leftV,GaitInfo.end.leftV,GaitInfo.b_oneGaitPhase);
[deltaHmag_avg,deltaHmag_sd] = interpData2perc(t,GaitInfo.tp,deltaHmag,GaitInfo.start.leftV,GaitInfo.end.leftV,GaitInfo.b_oneGaitPhase);
% [gyroscopicTorqueML_avg,gyroscopicTorqueML_sd] = interpData2perc(t,GaitInfo.tp,gyroscopicTorqueML,GaitInfo.start.leftV,GaitInfo.end.leftV,GaitInfo.b_oneGaitPhase);
% [gyroscopicTorqueAP_avg,gyroscopicTorqueAP_sd] = interpData2perc(t,GaitInfo.tp,gyroscopicTorqueAP,GaitInfo.start.leftV,GaitInfo.end.leftV,GaitInfo.b_oneGaitPhase);
% [gyroscopicTorqueL_avg,gyroscopicTorqueL_sd] = interpData2perc(t,GaitInfo.tp,gyroscopicTorqueL,GaitInfo.start.leftV,GaitInfo.end.leftV,GaitInfo.b_oneGaitPhase);

if ~plotInfo.showSD
    gamma_sd                = [];
    gammadot_sd             = [];
    gammadotref_sd          = [];
    torqueTotal_sd          = [];
    torqueReset_sd          = [];
    torqueLowLevel_sd       = [];
    torqueFeedForward_sd    = [];
    Hmag_sd                 = [];
    deltaH_ML_sd            = [];
    deltaH_AP_sd            = [];
    deltaHmag_sd            = [];
    gyroscopicTorqueML_sd   = [];
    gyroscopicTorqueAP_sd   = [];
    gyroscopicTorqueL_sd    = [];
end

%%

if isempty(CMGDataFigure)
    CMGDataFig = figure();
    set(CMGDataFig, 'Position',[10,50,650,1200]);
else
    CMGDataFig = CMGDataFigure;
end
subplotStart = [4,1,1];
%%
for i = 1:subplotStart(1)
    axesHandles(i) = axes(CMGDataFig);
%     set(axesHandles(i),'Position', [0.13
end
fontSizeLeg = 18;

%% Angle
axidx = 1;
axesHandles(axidx) = subplot(subplotStart(1),subplotStart(2),subplotStart(3),axesHandles(axidx)); 
subplotStart(3) = subplotStart(3) + 1;
plotHandles1(axidx,1) = plot(axesHandles(axidx), GaitInfo.tp,gamma_avg); 

legend(plotHandles1(axidx,1:end),'$\gamma$(t)','Location','northeastoutside','FontSize',fontSizeLeg);
title(axesHandles(axidx),'GM angle');
ylabel(axesHandles(axidx),'$\gamma$(t) (deg)'); 

%% Angular velocity
axidx = 2;
axesHandles(axidx) = subplot(subplotStart(1),subplotStart(2),subplotStart(3),axesHandles(axidx)); 
subplotStart(3) = subplotStart(3) + 1;
plotHandles2(1) = plot(axesHandles(axidx),GaitInfo.tp,gammadot_avg); 
hold(axesHandles(axidx),'on');
plotHandles2(2) = plot(axesHandles(axidx),GaitInfo.tp,gammadotref_avg,':'); 
legend(plotHandles2(1:end),'$\dot{\gamma}(t)$','$\dot{\gamma}_{\mathrm{ref}}$','Location','northeastoutside','FontSize',fontSizeLeg);
title(axesHandles(axidx),'GM angular velocity ');
minmax = 2;
set(axesHandles(axidx),'YLim',[ [ max(-minmax,(min( [gammadot_avg;gammadotref_avg] )*1.1)), min((max( [gammadot_avg;gammadotref_avg] )*1.1)) ]]);
ylabel(axesHandles(axidx),'$\dot{\gamma}(t)$ (rad/s)'); 

%% torque
taumax = 15;
axidx = 3;
axesHandles(axidx) = subplot(subplotStart(1),subplotStart(2),subplotStart(3),axesHandles(axidx)); 
colorOrder = get(axesHandles(axidx),'colororder');
subplotStart(3) = subplotStart(3) + 1;
plotHandles3(1) =  plot(axesHandles(axidx),GaitInfo.tp,torqueTotal_avg); % total torque
hold(axesHandles(axidx),'on');
plotHandles3(2) =  plot(axesHandles(axidx), GaitInfo.tp([1,end]),taumax*ones(2,1),'--','Color',colorOrder(5,:));  % max torque
plotHandles3(3) =  plot(axesHandles(axidx), GaitInfo.tp([1,end]),-taumax*ones(2,1),'--','Color',colorOrder(5,:));  % min torque

% plotHandles3(4) =  plot(axesHandles(axidx), GaitInfo.tp,torqueReset_avg,'--');  % reset torque
% plotHandles3(5) =  plot(axesHandles(axidx), GaitInfo.tp,torqueLowLevel_avg,'-.');  % low-level torque
% plotHandles3(6) =  plot(axesHandles(axidx), GaitInfo.tp,torqueFeedForward_avg,':');  % feed-forward torque
title(axesHandles(axidx),'GM torque');
set(axesHandles(axidx),'YLim',[[max(-taumax-1,min(min(torqueTotal_avg*1.1))),min(taumax+1,max(max(1.1*torqueTotal_avg)))]]);
legend(plotHandles3([1,3:end]),'$\tau_{\mathrm{GM}}(t)$','$\tau_{\mathrm{max}}$','$\tau_{{\mathrm{r}0}}(t)$','$\tau_{\mathrm{L}}(t)$','$\tau_{\mathrm{ff}}(t)$','Location','northeastoutside','FontSize',fontSizeLeg);

ylabel(axesHandles(axidx),'$\tau(t)$ (Nm)'); 

%% Angular momentum
axidx = 4;
axesHandles(axidx) = subplot(subplotStart(1),subplotStart(2),subplotStart(3),axesHandles(axidx)); 
subplotStart(3) = subplotStart(3) + 1;
colorOrder = get(axesHandles(axidx),'colororder');
plotHandles4(1) = plot(axesHandles(axidx),GaitInfo.tp,deltaH_ML_avg,'-.'); 
hold(axesHandles(axidx),'on');
plotHandles4(2) = plot(axesHandles(axidx),GaitInfo.tp,deltaH_AP_avg); 
plotHandles4(3) = plot(axesHandles(axidx),GaitInfo.tp,deltaHmag_avg,' :','color',colorOrder(4,:)); 
% plotHandles4(4) = plot(axesHandles(axidx),GaitInfo.tp,Hmag_avg,'--','color',colorOrder(3,:)); 

legend(plotHandles4(1:end),'$\Delta H_{\mathrm{ML}}(t)$','$\Delta H_{\mathrm{AP}}(t)$','$||\Delta\mathbf{H}(t)||$','$||\mathbf{H}(t)||$','location','northeastoutside','FontSize',fontSizeLeg);
title(axesHandles(axidx),'Exchanged angular momentum');
ylabel(axesHandles(axidx),'$\Delta H(t)$ (Nms)'); 

if GaitInfo.b_oneGaitPhase
    xlabel(axesHandles(end),'gait cycle ($\%$)');
else
    xlabel(axesHandles(end),'s');
end

for i = 1:length(axesHandles)
    setPos = get(axesHandles(i),'Position');
    set(axesHandles(i),'Position', [setPos(1:2), 0.55,setPos(4)]);
end

% %% Gyroscopic Torque
% % axidx = 5;
% figure();
% axesHandles(axidx) = axes(gcf);
% % axesHandles(axidx) = subplot(subplotStart(1),subplotStart(2),subplotStart(3),axesHandles(axidx)); 
% % colorOrder = get(axesHandles(axidx),'colororder');
% subplotStart(3) = subplotStart(3) + 1;
% 
% plotHandles5(1) =  plot(axesHandles(axidx),GaitInfo.tp,gyroscopicTorqueML_avg); % total torque
% hold(axesHandles(axidx),'on');
% plotHandles5(2) =  plot(axesHandles(axidx), GaitInfo.tp,gyroscopicTorqueAP_avg,'--');  % reset torque
% plotHandles5(3) =  plot(axesHandles(axidx), GaitInfo.tp,gyroscopicTorqueL_avg,'-.');  % low-level torque
% title(axesHandles(axidx),'Gyroscopic torque');
% % set(axesHandles(axidx),'YLim',[[max(-15,min(min(CMGData.signals.values(idx,6:8)*1.1))),min(15,max(max(1.1*CMGData.signals.values(idx,6:8))))]]);
% % yaxis([-taumax-1 taumax+1]);
% legend(plotHandles5([1:end]),'$\tau_{\mathrm{ML}}(t)$','$\tau_{\mathrm{AP}}(t)$','$\tau_{\mathrm{L}}(t)$');
% 
% ylabel(axesHandles(axidx),'$\tau(t)$ (Nm)'); 

%%

if saveInfo.b_saveFigure
    for j = 1:length(saveInfo.type)
        saveFigure(CMGDataFig,'CMGData',saveInfo.type{j},saveInfo.info,true)
    end
end