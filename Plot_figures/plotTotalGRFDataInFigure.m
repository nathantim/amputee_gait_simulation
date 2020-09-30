function [plotHandles,axesHandles] = plotTotalGRFDataInFigure(GRFDataFig,axesHandles,t,GRFhor_avg,GRFhor_sd,GRFv_avg,GRFv_sd,b_oneGaitPhase,subplotStart)
plotHandles = nan(2,2);
if isempty(axesHandles)
    for i = 1:size(plotHandles,1)
        axesHandles(i) = axes(GRFDataFig);
    end
end
if  nargin <= 7
    b_oneGaitPhase = true;
end

% subplotStart = dec2base(subplotStart,10) - '0';

%%
axesHandles(1) = subplot(subplotStart(1),subplotStart(2),subplotStart(3),axesHandles(1));
if ~isempty(GRFhor_sd)
    plotHandles(1,2) = fill(axesHandles(1),[t;flipud(t)],[GRFhor_avg-GRFhor_sd;flipud(GRFhor_avg+GRFhor_sd)],[0.8 0.8 0.8]);
end
hold(axesHandles(1),'on');
plotHandles(1,1) = plot(axesHandles(1),t,GRFhor_avg);

title(axesHandles(1),'Total x')
ylabel(axesHandles(1),'N/kg');

%%
subplotStart(3) = subplotStart(3) +1;
axesHandles(2) = subplot(subplotStart(1),subplotStart(2),subplotStart(3),axesHandles(2));
if ~isempty(GRFv_sd)
    plotHandles(2,2) = fill(axesHandles(2),[t;flipud(t)],[GRFv_avg-GRFv_sd;flipud(GRFv_avg+GRFv_sd)],[0.8 0.8 0.8]);
end
hold(axesHandles(2),'on');
plotHandles(2,1) = plot(axesHandles(2),t,GRFv_avg);


title(axesHandles(2),'Total z')
ylabel(axesHandles(2),'N/kg');
if b_oneGaitPhase
    xlabel(axesHandles(2),'%_{stride}','interpreter','tex')
else
    xlabel(axesHandles(2),'s')
end



