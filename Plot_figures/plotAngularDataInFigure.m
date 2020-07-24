function [plotHandles,axesHandles] = plotAngularDataInFigure(angularDataFig,axesHandles,t,hipAngles_avg,hipAngles_sd,kneeAngles_avg,kneeAngles_sd,ankleAngles_avg,ankleAngles_sd,subplotStart,b_oneGaitPhase)
plotHandles = nan(3,2);
if isempty(axesHandles)
    for i = 1:size(plotHandles,1)
        axesHandles(i) = axes(angularDataFig);
    end
end
if  nargin <= 10
    b_oneGaitPhase = true;
end

%%
subplotStartvec = dec2base(subplotStart,10) - '0';
axesHandles(1) = subplot(subplotStartvec(1),subplotStartvec(2),subplotStartvec(3),axesHandles(1));
plotHandles(1,1) = plot(axesHandles(1),t,hipAngles_avg);
hold(axesHandles(1),'on');
if ~isempty(hipAngles_sd)
    plotHandles(1,2) = fill(axesHandles(1),[t;flipud(t)],[hipAngles_avg-hipAngles_sd;flipud(hipAngles_avg+hipAngles_sd)],[0.8 0.8 0.8]);
end
h = get(axesHandles(1),'Children');
set(axesHandles(1),'Children',flipud(h))

title(axesHandles(1),'Hip flexion angle')
ylabel(axesHandles(1),'deg');


%%
subplotStartvec = dec2base(subplotStart+1,10) - '0';
axesHandles(2) = subplot(subplotStartvec(1),subplotStartvec(2),subplotStartvec(3),axesHandles(2));
plotHandles(2,1) = plot(axesHandles(2),t,kneeAngles_avg);
hold(axesHandles(2),'on');
if ~isempty(kneeAngles_sd)
    plotHandles(2,2) = fill(axesHandles(2),[t;flipud(t)],[kneeAngles_avg-kneeAngles_sd;flipud(kneeAngles_avg+kneeAngles_sd)],[0.8 0.8 0.8]);
end
h = get(axesHandles(2),'Children');
set(axesHandles(2),'Children',flipud(h))
title(axesHandles(2),'Knee flexion angle')
ylabel(axesHandles(2),'deg');

%%
subplotStartvec = dec2base(subplotStart+2,10) - '0';
axesHandles(3) = subplot(subplotStartvec(1),subplotStartvec(2),subplotStartvec(3),axesHandles(3));
plotHandles(3,1) = plot(axesHandles(3),t,ankleAngles_avg);
hold(axesHandles(3),'on');
if ~isempty(ankleAngles_sd)
    plotHandles(3,2) = fill(axesHandles(3),[t;flipud(t)],[ankleAngles_avg-ankleAngles_sd;flipud(ankleAngles_avg+ankleAngles_sd)],[0.8 0.8 0.8]);
end

h = get(axesHandles(3),'Children');
set(axesHandles(3),'Children',flipud(h))
title(axesHandles(3),'Ankle dorsiflexion angle')
ylabel(axesHandles(3),'deg');
if b_oneGaitPhase
    xlabel(axesHandles(3),'%_{stride}','interpreter','tex')
else
    xlabel(axesHandles(3),'s')
end

