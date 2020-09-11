function [plotHandles,axesHandles] = plotAngularDataInFigure(angularDataFig,axesHandles,t,hipAngle_avg,hipAngle_sd,hipRollAngle_avg,hipRollAngle_sd,kneeAngle_avg,kneeAngle_sd,ankleAngle_avg,ankleAngle_sd,subplotStart,b_oneGaitPhase)
plotHandles = nan(4,2);
if isempty(axesHandles)
    for i = 1:size(plotHandles,1)
        axesHandles(i) = axes(angularDataFig);
    end
end
if  nargin <= 12
    b_oneGaitPhase = true;
end

% subplotStart = dec2base(subplotStart,10) - '0';

%%
axidx = 1;
axesHandles(axidx) = subplot(subplotStart(1),subplotStart(2),subplotStart(3),axesHandles(axidx));
if ~isempty(hipRollAngle_sd)
    plotHandles(axidx,2) = fill(axesHandles(axidx),[t;flipud(t)],[hipRollAngle_avg-hipRollAngle_sd;flipud(hipRollAngle_avg+hipRollAngle_sd)],[0.8 0.8 0.8]);
end
hold(axesHandles(axidx),'on');
if ~isempty(hipRollAngle_avg)
    plotHandles(axidx,1) = plot(axesHandles(axidx),t,hipRollAngle_avg);
end


% h = get(axesHandles(axidx),'Children');
% set(axesHandles(axidx),'Children',h) % 

title(axesHandles(axidx),'Hip abduction')
ylabel(axesHandles(axidx),'deg');

%%
subplotStart(3) = subplotStart(3) +1;
axidx = 2;
axesHandles(axidx) = subplot(subplotStart(1),subplotStart(2),subplotStart(3),axesHandles(axidx));
if ~isempty(hipAngle_sd)
    plotHandles(axidx,2) = fill(axesHandles(axidx),[t;flipud(t)],[hipAngle_avg-hipAngle_sd;flipud(hipAngle_avg+hipAngle_sd)],[0.8 0.8 0.8]);
end
hold(axesHandles(axidx),'on');
plotHandles(axidx,1) = plot(axesHandles(axidx),t,hipAngle_avg);


% h = get(axesHandles(1),'Children');
% set(axesHandles(1),'Children',h) % 

title(axesHandles(axidx),'Hip flexion')
ylabel(axesHandles(axidx),'deg');


%%
subplotStart(3) = subplotStart(3) +1;
axidx = 3;
axesHandles(axidx) = subplot(subplotStart(1),subplotStart(2),subplotStart(3),axesHandles(axidx));
if ~isempty(kneeAngle_sd)
    plotHandles(axidx,2) = fill(axesHandles(axidx),[t;flipud(t)],[kneeAngle_avg-kneeAngle_sd;flipud(kneeAngle_avg+kneeAngle_sd)],[0.8 0.8 0.8]);
end
hold(axesHandles(axidx),'on');
plotHandles(axidx,1) = plot(axesHandles(axidx),t,kneeAngle_avg);

% h = get(axesHandles(axidx),'Children');
% set(axesHandles(axidx),'Children',flipud(h))
title(axesHandles(axidx),'Knee flexion')
ylabel(axesHandles(axidx),'deg');

%%
subplotStart(3) = subplotStart(3) +1;
axidx = 4;
axesHandles(axidx) = subplot(subplotStart(1),subplotStart(2),subplotStart(3),axesHandles(axidx));
if ~isempty(ankleAngle_sd)
    plotHandles(axidx,2) = fill(axesHandles(axidx),[t;flipud(t)],[ankleAngle_avg-ankleAngle_sd;flipud(ankleAngle_avg+ankleAngle_sd)],[0.8 0.8 0.8]);
end
hold(axesHandles(axidx),'on');
plotHandles(axidx,1) = plot(axesHandles(axidx),t,ankleAngle_avg);

% h = get(axesHandles(axidx),'Children');
% set(axesHandles(axidx),'Children',flipud(h))
title(axesHandles(axidx),'Ankle dorsiflexion')
ylabel(axesHandles(axidx),'deg');


if b_oneGaitPhase
    xlabel(axesHandles(4),'%_{stride}','interpreter','tex')
else
    xlabel(axesHandles(4),'s')
end
