function [plotHandles,axesHandles] = plotPowerDataInFigure(powerDataFig,axesHandles,t,hipPower_avg,hipPower_sd,hipRollPower_avg,hipRollPower_sd,kneePower_avg,kneePower_sd,anklePower_avg,anklePower_sd,subplotStart,b_oneGaitPhase)
plotHandles = nan(4,2);
if isempty(axesHandles)
    for i = 1:size(plotHandles,1)
        axesHandles(i) = axes(powerDataFig);
    end
end
if  nargin <= 12
    b_oneGaitPhase = true;
end

% subplotStart = dec2base(subplotStart,10) - '0';

%%
axidx = 1;
axesHandles(axidx) = subplot(subplotStart(1),subplotStart(2),subplotStart(3),axesHandles(axidx));
if ~isempty(hipRollPower_sd)
    plotHandles(axidx,2) = fill(axesHandles(axidx),[t;flipud(t)],[hipRollPower_avg-hipRollPower_sd;flipud(hipRollPower_avg+hipRollPower_sd)],[0.8 0.8 0.8]);
end
hold(axesHandles(axidx),'on');
if ~isempty(hipRollPower_avg)
    plotHandles(axidx,1) = plot(axesHandles(axidx),t,hipRollPower_avg);
end


% h = get(axesHandles(axidx),'Children');
% set(axesHandles(axidx),'Children',h) % 

title(axesHandles(axidx),'Hip abduction')
ylabel(axesHandles(axidx),'W/kg');

%%
subplotStart(3) = subplotStart(3) +1;
axidx = 2;
axesHandles(axidx) = subplot(subplotStart(1),subplotStart(2),subplotStart(3),axesHandles(axidx));
if ~isempty(hipPower_sd)
    plotHandles(axidx,2) = fill(axesHandles(axidx),[t;flipud(t)],[hipPower_avg-hipPower_sd;flipud(hipPower_avg+hipPower_sd)],[0.8 0.8 0.8]);
end
hold(axesHandles(axidx),'on');
plotHandles(axidx,1) = plot(axesHandles(axidx),t,hipPower_avg);


% h = get(axesHandles(1),'Children');
% set(axesHandles(1),'Children',h) % 

title(axesHandles(axidx),'Hip flexion')
ylabel(axesHandles(axidx),'W/kg');


%%
subplotStart(3) = subplotStart(3) +1;
axidx = 3;
axesHandles(axidx) = subplot(subplotStart(1),subplotStart(2),subplotStart(3),axesHandles(axidx));
if ~isempty(kneePower_sd)
    plotHandles(axidx,2) = fill(axesHandles(axidx),[t;flipud(t)],[kneePower_avg-kneePower_sd;flipud(kneePower_avg+kneePower_sd)],[0.8 0.8 0.8]);
end
hold(axesHandles(axidx),'on');
plotHandles(axidx,1) = plot(axesHandles(axidx),t,kneePower_avg);

% h = get(axesHandles(axidx),'Children');
% set(axesHandles(axidx),'Children',flipud(h))
title(axesHandles(axidx),'Knee flexion')
ylabel(axesHandles(axidx),'W/kg');

%%
subplotStart(3) = subplotStart(3) +1;
axidx = 4;
axesHandles(axidx) = subplot(subplotStart(1),subplotStart(2),subplotStart(3),axesHandles(axidx));
if ~isempty(anklePower_sd)
    plotHandles(axidx,2) = fill(axesHandles(axidx),[t;flipud(t)],[anklePower_avg-anklePower_sd;flipud(anklePower_avg+anklePower_sd)],[0.8 0.8 0.8]);
end
hold(axesHandles(axidx),'on');
plotHandles(axidx,1) = plot(axesHandles(axidx),t,anklePower_avg);

% h = get(axesHandles(axidx),'Children');
% set(axesHandles(axidx),'Children',flipud(h))
title(axesHandles(axidx),'Ankle dorsiflexion')
ylabel(axesHandles(axidx),'W/kg');


if b_oneGaitPhase
    xlabel(axesHandles(4),'%_{stride}','interpreter','tex')
else
    xlabel(axesHandles(4),'s')
end
