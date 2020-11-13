function [axesHandles] = plotCMGData(CMGData,plotInfo,GaitInfo,saveInfo,CMGDataFigure,axesHandles,subplotStart,b_addTitle,b_addAxesTitle,b_addLegend,tCollision)
% PLOTCMGDATA                       Function that plots the data of healthy and prosthetic simulation together, with optional 
%                                   amputee with CMG simulation
% INPUTS:
%   - angularData               Structure with time of the joint angle and angular velocity data from the simulation.
%   - plotInfo                  Structure containing linestyle, -width, -color etc.
%   - GaitInfo                  Structure containing information on where a stride begins and ends, whether to show average
%                               for stride, or just all the data.
%   - saveInfo                  Structure with info on how and if to save the figure
%   - CMGDataFigure             Optional, pre-created figure in which the CMG data can be plotted.
%   - axesHandles               Optional, pre-created axes in which the CMG data can be plotted.
%   - subplotStart              Optional, in case of multiple subfigures, this says in which subfigure to start.
%   - legToPlot                 Optional, select if you want to plot 'both' legs, or 'left', or 'right' leg.
%   - b_addTitle                Optional, boolean which selects if title of figure has to be put in the figure.
%   - b_addAxesTitle            Optional, boolean which selects if title of axis has to be put in the figure.
%   - b_addLegend               Optional, boolean which selects if legend is shown in the figure.
%   - b_showCollision           Optional, boolean which selects if moment of collision and active trip prevention is shown.
%
% OUTPUTS:
%   - axesHandles               Handles of all the axes, which can be used for later changes in axes size, axes title
%    
%%
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
if nargin < 11 || isempty(tCollision)
   b_showCollision = false; 
else
    % time of trip and time trip prevention active
    b_showCollision = true;
    t_CMGPreventActive = [CMGData.time( find(CMGData.signals.values(:,14)~=0,1,'first')) CMGData.time( find(CMGData.signals.values(:,14)~=0,1,'last'))];
end
idxSkip = subplotStart(2);

t = CMGData.time;

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
[gamma_avg,             gamma_sd]               = interpData2perc(t,GaitInfo.tp,gamma,GaitInfo.start.rightV,GaitInfo.end.rightV,GaitInfo.b_oneGaitPhase);
[gammadot_avg,          gammadot_sd]            = interpData2perc(t,GaitInfo.tp,gammadot,GaitInfo.start.rightV,GaitInfo.end.rightV,GaitInfo.b_oneGaitPhase);
[gammadotref_avg,       gammadotref_sd]         = interpData2perc(t,GaitInfo.tp,gammadotref,GaitInfo.start.rightV,GaitInfo.end.rightV,GaitInfo.b_oneGaitPhase);
[torqueTotal_avg,       torqueTotal_sd]         = interpData2perc(t,GaitInfo.tp,torqueTotal,GaitInfo.start.rightV,GaitInfo.end.rightV,GaitInfo.b_oneGaitPhase);
[torqueReset_avg,       torqueReset_sd]         = interpData2perc(t,GaitInfo.tp,torqueReset,GaitInfo.start.rightV,GaitInfo.end.rightV,GaitInfo.b_oneGaitPhase);
[torqueLowLevel_avg,    torqueLowLevel_sd]      = interpData2perc(t,GaitInfo.tp,torqueLowLevel,GaitInfo.start.rightV,GaitInfo.end.rightV,GaitInfo.b_oneGaitPhase);
[torqueFeedForward_avg, torqueFeedForward_sd]   = interpData2perc(t,GaitInfo.tp,torqueFeedForward,GaitInfo.start.rightV,GaitInfo.end.rightV,GaitInfo.b_oneGaitPhase);
[Hmag_avg,              Hmag_sd]                = interpData2perc(t,GaitInfo.tp,Hmag,GaitInfo.start.rightV,GaitInfo.end.rightV,GaitInfo.b_oneGaitPhase);
[deltaH_ML_avg,         deltaH_ML_sd]           = interpData2perc(t,GaitInfo.tp,deltaH_ML,GaitInfo.start.rightV,GaitInfo.end.rightV,GaitInfo.b_oneGaitPhase);
[deltaH_AP_avg,         deltaH_AP_sd]           = interpData2perc(t,GaitInfo.tp,deltaH_AP,GaitInfo.start.rightV,GaitInfo.end.rightV,GaitInfo.b_oneGaitPhase);
[deltaHmag_avg,         deltaHmag_sd]           = interpData2perc(t,GaitInfo.tp,deltaHmag,GaitInfo.start.rightV,GaitInfo.end.rightV,GaitInfo.b_oneGaitPhase);
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
    set(CMGDataFig, 'Position',[50 10 540 970]);
else
    CMGDataFig = CMGDataFigure;
end

%%
if isempty(axesHandles)
    for ii = 1:subplotStart(1)
        axesHandles(ii) = axes(CMGDataFig);
    end
end
fontSizeLeg = 16;

%% Plot GM Angle
axidx = 1;
axesHandles(axidx) = subplot(subplotStart(1),subplotStart(2),subplotStart(3),axesHandles(axidx)); 
subplotStart(3) = subplotStart(3) + idxSkip;


if ~isempty(gamma_sd)
    plotHandles1(1,2) = fill(axesHandles(axidx),[GaitInfo.tp;flipud(GaitInfo.tp)],[gamma_avg-gamma_sd;flipud(gamma_avg+gamma_sd)],[0.8 0.8 0.8]);
else
    plotHandles1(1,2) = nan;
end
hold(axesHandles(axidx),'on');   
plotHandles1(1,1) = plot(axesHandles(axidx), GaitInfo.tp,gamma_avg); 

if b_showCollision
    plotHandles1(2,1) = plot(axesHandles(axidx), [tCollision, tCollision], get(axesHandles(axidx)).YLim,'--o','Color','#454545');
    plotHandles1(3,1) = plot(axesHandles(axidx), t_CMGPreventActive, ones(1,2)*get(axesHandles(axidx)).YLim(2)-0.001,'-*','color','#9F9F9F');
    h = get(axesHandles(axidx),'children');
    set(axesHandles(axidx),'children',[h(3:end); h(1:2)] );
end
if  b_addTitle
    title(axesHandles(axidx),'GM angle');
end
if  b_addAxesTitle
    ylabel(axesHandles(axidx),'$\gamma$(t) (deg)'); 
end
if b_addLegend
    warning('off')
    legend(plotHandles1(1:end,1),'$\gamma$(t)','Collision','Prevent','Location','northeastoutside','FontSize',fontSizeLeg,'Box','off');
    warning('on')
end


for ii = 1:1
    set(plotHandles1(ii,1),plotInfo.plotProp,plotInfo.plotProp_entries(ii,:));
    if isgraphics(plotHandles1(ii,2))
        set(plotHandles1(ii,2),plotInfo.fillProp,plotInfo.fillProp_entries(ii,:));
    end
end
    
%% Plot GM Angular velocity and reference
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
    legend(plotHandles2(1:end,1),'$\dot{\gamma}(t)$','$\dot{\gamma}_{\mathrm{ref}}$','Location','northeastoutside','FontSize',fontSizeLeg,'Box','off');
    warning('on');
end

for ii = 1:size(plotHandles2,1)
    set(plotHandles2(ii,1),plotInfo.plotProp,plotInfo.plotProp_entries(ii,:));
    if isgraphics(plotHandles2(ii,2))
        set(plotHandles2(ii,2),plotInfo.fillProp,plotInfo.fillProp_entries(ii,:));
    end
end


%% Plot GM torque
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
    legend(plotHandles3([1,3:end],1),'$\tau_{\mathrm{GM}}(t)$','$\tau_{\mathrm{lim}}$','$\tau_{{\mathrm{r}0}}(t)$','$\tau_{\mathrm{L}}(t)$','$\tau_{\mathrm{ff}}(t)$','Location','northeastoutside','FontSize',fontSizeLeg,'Box','off');
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

%% Plot exchanged Angular momentum
axidx = 4;
axesHandles(axidx) = subplot(subplotStart(1),subplotStart(2),subplotStart(3),axesHandles(axidx)); 
subplotStart(3) = subplotStart(3) + idxSkip;
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



if  b_addTitle
    title(axesHandles(axidx),{'Exch. angular momentum'});
%     title(axesHandles(axidx),{'Exchanged angular momentum'});
end
if  b_addAxesTitle
    ylabel(axesHandles(axidx),'$\Delta H(t)$ (Nms)');
end
if b_addLegend
    warning('off');
    legend(plotHandles4(1:end,1),'$||\Delta\mathbf{H}(t)||$','$\Delta H_{\mathrm{ML}}(t)$','$\Delta H_{\mathrm{AP}}(t)$','$||\mathbf{H}(t)||$','location','northeastoutside','FontSize',fontSizeLeg,'Box','off');
    warning('on');
end

if GaitInfo.b_oneGaitPhase
    xlabel(axesHandles(end),'gait cycle ($\%$)');
else
    xlabel(axesHandles(end),'time (s)');
end

for ii = 1:size(plotHandles4,1)
    set(plotHandles4(ii,1),plotInfo.plotProp,plotInfo.plotProp_entries(ii,:));
    if isgraphics(plotHandles4(ii,2))
        set(plotHandles4(ii,2),plotInfo.fillProp,plotInfo.fillProp_entries(ii,:));
    end
end

%% Plot moment of collision and trip prevention active
if b_showCollision
    for jj = 2:length(axesHandles)
        axidx = jj;
        plot(axesHandles(axidx), [tCollision, tCollision], get(axesHandles(axidx)).YLim,'--o','Color','#454545','HandleVisibility','off');
        plot(axesHandles(axidx), t_CMGPreventActive, ones(1,2)*get(axesHandles(axidx)).YLim(2)-0.001,'-*','color','#9F9F9F','HandleVisibility','off');
        h = get(axesHandles(axidx),'children');
        set(axesHandles(axidx),'children',[h(3:end); h(1:2)] );
    end
end

%%

if saveInfo.b_saveFigure
        saveFigure(CMGDataFig,'CMGData',saveInfo.type,saveInfo.info,true)
end