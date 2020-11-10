function [axesHandles] = plotCMGData(CMGData,plotInfo,GaitInfo,saveInfoInput,CMGDataFigure,axesHandles,subplotStart,b_addTitle,b_addAxesTitle,b_addLegend,showCollision)
if nargin <5
   CMGDataFigure = []; 
end
if nargin < 6
    axesHandles = [];
end
if nargin < 7
    subplotStart = [4,1,1];
end
if nargin < 8
    b_addTitle = true;
end
if nargin < 9
    b_addAxesTitle = true;
end
if nargin < 10
    b_addLegend = true;
end
if nargin < 11
   showCollision = false; 
end
idxSkip = subplotStart(2);

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
[gamma_avg,gamma_sd] = interpData2perc(t,GaitInfo.tp,gamma,GaitInfo.start.rightV,GaitInfo.end.rightV,GaitInfo.b_oneGaitPhase);
[gammadot_avg,gammadot_sd] = interpData2perc(t,GaitInfo.tp,gammadot,GaitInfo.start.rightV,GaitInfo.end.rightV,GaitInfo.b_oneGaitPhase);
[gammadotref_avg,gammadotref_sd] = interpData2perc(t,GaitInfo.tp,gammadotref,GaitInfo.start.rightV,GaitInfo.end.rightV,GaitInfo.b_oneGaitPhase);
[torqueTotal_avg,torqueTotal_sd] = interpData2perc(t,GaitInfo.tp,torqueTotal,GaitInfo.start.rightV,GaitInfo.end.rightV,GaitInfo.b_oneGaitPhase);
[torqueReset_avg,torqueReset_sd] = interpData2perc(t,GaitInfo.tp,torqueReset,GaitInfo.start.rightV,GaitInfo.end.rightV,GaitInfo.b_oneGaitPhase);
[torqueLowLevel_avg,torqueLowLevel_sd] = interpData2perc(t,GaitInfo.tp,torqueLowLevel,GaitInfo.start.rightV,GaitInfo.end.rightV,GaitInfo.b_oneGaitPhase);
[torqueFeedForward_avg,torqueFeedForward_sd] = interpData2perc(t,GaitInfo.tp,torqueFeedForward,GaitInfo.start.rightV,GaitInfo.end.rightV,GaitInfo.b_oneGaitPhase);
[Hmag_avg,Hmag_sd] = interpData2perc(t,GaitInfo.tp,Hmag,GaitInfo.start.rightV,GaitInfo.end.rightV,GaitInfo.b_oneGaitPhase);
[deltaH_ML_avg,deltaH_ML_sd] = interpData2perc(t,GaitInfo.tp,deltaH_ML,GaitInfo.start.rightV,GaitInfo.end.rightV,GaitInfo.b_oneGaitPhase);
[deltaH_AP_avg,deltaH_AP_sd] = interpData2perc(t,GaitInfo.tp,deltaH_AP,GaitInfo.start.rightV,GaitInfo.end.rightV,GaitInfo.b_oneGaitPhase);
[deltaHmag_avg,deltaHmag_sd] = interpData2perc(t,GaitInfo.tp,deltaHmag,GaitInfo.start.rightV,GaitInfo.end.rightV,GaitInfo.b_oneGaitPhase);
% [gyroscopicTorqueML_avg,gyroscopicTorqueML_sd] = interpData2perc(t,GaitInfo.tp,gyroscopicTorqueML,GaitInfo.start.rightV,GaitInfo.end.rightV,GaitInfo.b_oneGaitPhase);
% [gyroscopicTorqueAP_avg,gyroscopicTorqueAP_sd] = interpData2perc(t,GaitInfo.tp,gyroscopicTorqueAP,GaitInfo.start.rightV,GaitInfo.end.rightV,GaitInfo.b_oneGaitPhase);
% [gyroscopicTorqueL_avg,gyroscopicTorqueL_sd] = interpData2perc(t,GaitInfo.tp,gyroscopicTorqueL,GaitInfo.start.rightV,GaitInfo.end.rightV,GaitInfo.b_oneGaitPhase);

if ~plotInfo.showSD
    gamma_sd                = zeros(size(gamma_avg));
    gammadot_sd             = zeros(size(gammadot_avg));
    gammadotref_sd          = zeros(size(gammadotref_avg));
    torqueTotal_sd          = zeros(size(torqueTotal_avg));
    torqueReset_sd          = zeros(size(torqueReset_avg));
    torqueLowLevel_sd       = zeros(size(torqueLowLevel_avg));
    torqueFeedForward_sd    = zeros(size(torqueFeedForward_avg));
    Hmag_sd                 = zeros(size(Hmag_avg));
    deltaH_ML_sd            = zeros(size(deltaH_ML_avg));
    deltaH_AP_sd            = zeros(size(deltaH_AP_avg));
    deltaHmag_sd            = zeros(size(deltaHmag_avg));
%     gyroscopicTorqueML_sd   = zeros(size(gyroscopicTorqueML_avg));
%     gyroscopicTorqueAP_sd   = zeros(size(gyroscopicTorqueAP_avg));
%     gyroscopicTorqueL_sd    = zeros(size(gyroscopicTorqueL_avg));
end

%%

if isempty(CMGDataFigure) && isempty(axesHandles)
    CMGDataFig = figure();
    fullScreen = get(0,'screensize');
%     set(CMGDataFig, 'Position',[fullScreen(1:2)+20 fullScreen(3:4)*0.9]);
    set(CMGDataFig, 'Position',[50 10 540 970]);
else
    CMGDataFig = CMGDataFigure;
end

%%
if isempty(axesHandles)
    for ii = 1:subplotStart(1)
        axesHandles(ii) = axes(CMGDataFig);
        
        %     set(axesHandles(i),'Position', [0.13
    end
end
fontSizeLeg = 16;

%% Angle
axidx = 1;
axesHandles(axidx) = subplot(subplotStart(1),subplotStart(2),subplotStart(3),axesHandles(axidx)); 
subplotStart(3) = subplotStart(3) + idxSkip;

t_trip = 7.2190;
t_CMGPreventActive = [7.4450 7.8830];

if ~isempty(gamma_sd)
    plotHandles1(1,2) = fill(axesHandles(axidx),[GaitInfo.tp;flipud(GaitInfo.tp)],[gamma_avg-gamma_sd;flipud(gamma_avg+gamma_sd)],[0.8 0.8 0.8]);
else
    plotHandles1(1,2) = nan;
end
hold(axesHandles(axidx),'on');   
plotHandles1(1,1) = plot(axesHandles(axidx), GaitInfo.tp,gamma_avg); 

if showCollision
    plotHandles1(2,1) = plot(axesHandles(axidx), [t_trip, t_trip], get(axesHandles(axidx)).YLim,'--','Color','#454545');
    plotHandles1(3,1) = plot(axesHandles(axidx), t_CMGPreventActive, ones(1,2)*get(axesHandles(axidx)).YLim(2)-0.001,'color','#848484');
    h = get(axesHandles(axidx),'children');
    set(axesHandles(axidx),'children',[h(3:end) h(1:2)] );
end
if  b_addTitle
    title(axesHandles(axidx),'GM angle');
end
if  b_addAxesTitle
    ylabel(axesHandles(axidx),'$\gamma$(t) (deg)'); 
end
if b_addLegend
    warning('off')
    legend(plotHandles1(1:end,1),'$\gamma$(t)','Collision','Prevent','Location','northeastoutside','FontSize',fontSizeLeg);
    warning('on')
end



for ii = 1:1
    set(plotHandles1(ii,1),plotInfo.plotProp,plotInfo.plotProp_entries(ii,:));
    if isgraphics(plotHandles1(ii,2))
        set(plotHandles1(ii,2),plotInfo.fillProp,plotInfo.fillProp_entries(ii,:));
    end
end
    
%% Angular velocity
axidx = 2;
axesHandles(axidx) = subplot(subplotStart(1),subplotStart(2),subplotStart(3),axesHandles(axidx)); 
subplotStart(3) = subplotStart(3) + idxSkip;
if ~isempty(gammadot_sd)
    plotHandles2(1,2) = fill(axesHandles(axidx),[GaitInfo.tp;flipud(GaitInfo.tp)],[gammadot_avg-gammadot_sd;flipud(gammadot_avg+gammadot_sd)],[0.8 0.8 0.8]);
else
    plotHandles2(1,2) = nan;
end
hold(axesHandles(axidx),'on');
if ~isempty(gammadot_sd)
    plotHandles2(2,2) = fill(axesHandles(axidx),[GaitInfo.tp;flipud(GaitInfo.tp)],[gammadotref_avg-gammadotref_sd;flipud(gammadotref_avg+gammadotref_sd)],[0.8 0.8 0.8]);
end



plotHandles2(1,1) = plot(axesHandles(axidx),GaitInfo.tp,gammadot_avg); 
plotHandles2(2,1) = plot(axesHandles(axidx),GaitInfo.tp,gammadotref_avg,':'); 

minmax = 20;
set(axesHandles(axidx),'YLim',[ [ max(-minmax,(min( [gammadot_avg-gammadot_sd;gammadotref_avg-gammadotref_sd] )*1.1)), min((max( [gammadot_avg+gammadot_sd;gammadotref_avg+gammadotref_sd] )*1.1)) ]]);
if  b_addTitle
%     title(axesHandles(axidx),{'GM angular'; 'velocity'});
    title(axesHandles(axidx),{'GM angular velocity'});
end
if  b_addAxesTitle
    ylabel(axesHandles(axidx),'$\dot{\gamma}(t)$ (rad/s)');
end
if b_addLegend
    warning('off')
    legend(plotHandles2(1:end,1),'$\dot{\gamma}(t)$','$\dot{\gamma}_{\mathrm{ref}}$','Location','northeastoutside','FontSize',fontSizeLeg);
    warning('on');
end

for ii = 1:size(plotHandles2,1)
    set(plotHandles2(ii,1),plotInfo.plotProp,plotInfo.plotProp_entries(ii,:));
    if isgraphics(plotHandles2(ii,2))
        set(plotHandles2(ii,2),plotInfo.fillProp,plotInfo.fillProp_entries(ii,:));
    end
end


%% torque
taumax = 15;
axidx = 3;
axesHandles(axidx) = subplot(subplotStart(1),subplotStart(2),subplotStart(3),axesHandles(axidx)); 
colorOrder = get(axesHandles(axidx),'colororder');
subplotStart(3) = subplotStart(3) + idxSkip;
if ~isempty(torqueTotal_sd)
    plotHandles3(1,2) = fill(axesHandles(axidx),[GaitInfo.tp;flipud(GaitInfo.tp)],[torqueTotal_avg-torqueTotal_sd;flipud(torqueTotal_avg+torqueTotal_sd)],[0.8 0.8 0.8]);
else
    plotHandles3(1,2) = nan;
end
hold(axesHandles(axidx),'on');
plotHandles3(1,1) =  plot(axesHandles(axidx),GaitInfo.tp,torqueTotal_avg); % total torque
plotHandles3(2,1) =  plot(axesHandles(axidx), GaitInfo.tp([1,end]),taumax*ones(2,1),'--','Color',colorOrder(6,:));  % max torque
plotHandles3(3,1) =  plot(axesHandles(axidx), GaitInfo.tp([1,end]),-taumax*ones(2,1),'--','Color',colorOrder(6,:));  % min torque

% plotHandles3(4,1) =  plot(axesHandles(axidx), GaitInfo.tp,torqueReset_avg,'--');  % reset torque
% plotHandles3(5,1) =  plot(axesHandles(axidx), GaitInfo.tp,torqueLowLevel_avg,'-.');  % low-level torque
% plotHandles3(6,1) =  plot(axesHandles(axidx), GaitInfo.tp,torqueFeedForward_avg,':');  % feed-forward torque

set(axesHandles(axidx),'YLim',[[max(-taumax-1,min(min((torqueTotal_avg-torqueTotal_sd)*1.1))),min(taumax+1,max(max(1.1*(torqueTotal_avg+torqueTotal_sd))))]]);
if  b_addTitle
    title(axesHandles(axidx),'GM torque');
end
if  b_addAxesTitle
    ylabel(axesHandles(axidx),'$\tau(t)$ (Nm)');
end
if b_addLegend
    warning('off')
    legend(plotHandles3([1,3:end],1),'$\tau_{\mathrm{GM}}(t)$','$\tau_{\mathrm{lim}}$','$\tau_{{\mathrm{r}0}}(t)$','$\tau_{\mathrm{L}}(t)$','$\tau_{\mathrm{ff}}(t)$','Location','northeastoutside','FontSize',fontSizeLeg);
    % legend(plotHandles3([1,4:end],1),'$\tau_{\mathrm{GM}}(t)$','$\tau_{{\mathrm{r}0}}(t)$','$\tau_{\mathrm{L}}(t)$','$\tau_{\mathrm{ff}}(t)$','Location','northeastoutside','FontSize',fontSizeLeg);
    warning('on')
end

offsetIdx = 0;
for ii = 1:size(plotHandles3,1) - 2
    if ii ~= 1
        offsetIdx = 2;       
    end
    set(plotHandles3(ii+offsetIdx,1),plotInfo.plotProp,plotInfo.plotProp_entries(ii,:));
    if isgraphics(plotHandles3(ii+offsetIdx,2))
        set(plotHandles3(ii+offsetIdx,2),plotInfo.fillProp,plotInfo.fillProp_entries(ii,:));
    end
end

%% Angular momentum
axidx = 4;
axesHandles(axidx) = subplot(subplotStart(1),subplotStart(2),subplotStart(3),axesHandles(axidx)); 
subplotStart(3) = subplotStart(3) + idxSkip;
colorOrder = get(axesHandles(axidx),'colororder');
if ~isempty(deltaHmag_sd)
    plotHandles4(1,2) = fill(axesHandles(axidx),[GaitInfo.tp;flipud(GaitInfo.tp)],[deltaHmag_avg-deltaHmag_sd;flipud(deltaHmag_avg+deltaHmag_sd)],[0.8 0.8 0.8]);
else
    plotHandles4(1,2) = nan;
end
hold(axesHandles(axidx),'on');
plotHandles4(1,1) = plot(axesHandles(axidx),GaitInfo.tp,deltaHmag_avg); 

if ~isempty(deltaH_ML_sd)
    plotHandles4(2,2) = fill(axesHandles(axidx),[GaitInfo.tp;flipud(GaitInfo.tp)],[deltaH_ML_avg-deltaH_ML_sd;flipud(deltaH_ML_avg+deltaH_ML_sd)],[0.8 0.8 0.8]);

end
plotHandles4(2,1) = plot(axesHandles(axidx),GaitInfo.tp,deltaH_ML_avg); 

if ~isempty(deltaH_ML_sd)
    plotHandles4(3,2) = fill(axesHandles(axidx),[GaitInfo.tp;flipud(GaitInfo.tp)],[deltaH_AP_avg-deltaH_AP_sd;flipud(deltaH_AP_avg+deltaH_AP_sd)],[0.8 0.8 0.8]);
end
plotHandles4(3,1) = plot(axesHandles(axidx),GaitInfo.tp,deltaH_AP_avg); 


% plotHandles4(4) = plot(axesHandles(axidx),GaitInfo.tp,Hmag_avg,'--','color',colorOrder(3,:)); 


if  b_addTitle
    title(axesHandles(axidx),{'Exch. angular momentum'});
%     title(axesHandles(axidx),{'Exchanged angular momentum'});
end
if  b_addAxesTitle
    ylabel(axesHandles(axidx),'$\Delta H(t)$ (Nms)');
end
if b_addLegend
    warning('off');
    legend(plotHandles4(1:end,1),'$||\Delta\mathbf{H}(t)||$','$\Delta H_{\mathrm{ML}}(t)$','$\Delta H_{\mathrm{AP}}(t)$','$||\mathbf{H}(t)||$','location','northeastoutside','FontSize',fontSizeLeg);
    warning('on');
end

if GaitInfo.b_oneGaitPhase
    xlabel(axesHandles(end),'gait cycle ($\%$)');
else
    xlabel(axesHandles(end),'time (s)');
end

% %% Gyroscopic Torque
% % axidx = 5;
% figure();
% axesHandles(axidx) = axes(gcf);
% % axesHandles(axidx) = subplot(subplotStart(1),subplotStart(2),subplotStart(3),axesHandles(axidx)); 
% % colorOrder = get(axesHandles(axidx),'colororder');
% subplotStart(3) = subplotStart(3) + idxSkip;
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

for ii = 1:size(plotHandles4,1)
    set(plotHandles4(ii,1),plotInfo.plotProp,plotInfo.plotProp_entries(ii,:));
    if isgraphics(plotHandles4(ii,2))
        set(plotHandles4(ii,2),plotInfo.fillProp,plotInfo.fillProp_entries(ii,:));
    end
end

%%
if showCollision
    for jj = 2:length(axesHandles)
        axidx = jj;
        plot(axesHandles(axidx), [t_trip, t_trip], get(axesHandles(axidx)).YLim,'k--','Color','#454545','HandleVisibility','off');
        plot(axesHandles(axidx), t_CMGPreventActive, ones(1,2)*get(axesHandles(axidx)).YLim(2)-0.001,'color','#848484','HandleVisibility','off');
        h = get(axesHandles(axidx),'children');
        set(axesHandles(axidx),'children',[h(3:end); h(1:2)] );
    end
end

% for ii = 1:length(axesHandles)
%     setPos = get(axesHandles(ii),'Position');
%     set(axesHandles(ii),'Position', [setPos(1:2), 0.55,setPos(4)]);
% end
%%

if saveInfo.b_saveFigure
        saveFigure(CMGDataFig,'CMGData',saveInfo.type,saveInfo.info,true)
end