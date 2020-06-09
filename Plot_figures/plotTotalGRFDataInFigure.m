function [plotHandles,axesHandles] = plotTotalGRFDataInFigure(GRFDataFig,axesHandles,t,GRFhor_avg,GRFhor_sd,GRFv_avg,GRFv_sd,b_oneGaitPhase)
plotHandles = nan(2,2);
if isempty(axesHandles)
    for i = 1:size(plotHandles,1)
        axesHandles(i) = axes(GRFDataFig);
    end
end
if  nargin <= 7
    b_oneGaitPhase = true;
end


%%
axesHandles(1) = subplot(2,1,1,axesHandles(1));
plotHandles(1,1) = plot(axesHandles(1),t,GRFhor_avg);
hold(axesHandles(1),'on');
if ~isempty(GRFhor_sd)
    plotHandles(1,2) = fill(axesHandles(1),[t;flipud(t)],[GRFhor_avg-GRFhor_sd;flipud(GRFhor_avg+GRFhor_sd)],[0.8 0.8 0.8]);
end
h = get(axesHandles(1),'Children');
set(axesHandles(1),'Children',flipud(h))

title(axesHandles(1),'Total x')
ylabel(axesHandles(1),'N/kg');

%%
axesHandles(2) = subplot(2,1,2,axesHandles(2));
plotHandles(2,1) = plot(axesHandles(2),t,GRFv_avg);
hold(axesHandles(2),'on');
if ~isempty(GRFv_sd)
    plotHandles(2,2) = fill(axesHandles(2),[t;flipud(t)],[GRFv_avg-GRFv_sd;flipud(GRFv_avg+GRFv_sd)],[0.8 0.8 0.8]);
end
h = get(axesHandles(2),'Children');
set(axesHandles(2),'Children',flipud(h))
title(axesHandles(2),'Total z')
ylabel(axesHandles(2),'N/kg');
if b_oneGaitPhase
    xlabel(axesHandles(2),'%_{stride}','interpreter','tex')
else
    xlabel(axesHandles(2),'s')
end



