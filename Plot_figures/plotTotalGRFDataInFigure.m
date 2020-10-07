function [plotHandles,axesHandles] = plotTotalGRFDataInFigure(GRFDataFig,axesHandles,t,GRFx_avg,GRFx_sd,GRFy_avg,GRFy_sd,GRFz_avg,GRFz_sd,subplotStart,b_addTitle)
plotHandles = nan(3,2);
if isempty(axesHandles)
    for i = 1:size(plotHandles,1)
        axesHandles(i) = axes(GRFDataFig);
    end
end

if nargin < 11
    b_addTitle = true;
end
    

% subplotStart = dec2base(subplotStart,10) - '0';

%%
axidx = 1;
axesHandles(axidx) = subplot(subplotStart(1),subplotStart(2),subplotStart(3),axesHandles(axidx));
if ~isempty(GRFx_sd)
    plotHandles(axidx,2) = fill(axesHandles(axidx),[t;flipud(t)],[GRFx_avg-GRFx_sd;flipud(GRFx_avg+GRFx_sd)],[0.8 0.8 0.8]);
end
hold(axesHandles(axidx),'on');
plotHandles(axidx,1) = plot(axesHandles(axidx),t,GRFx_avg);

if b_addTitle
    title(axesHandles(axidx),'Anterior-posterior');
end
ylabel(axesHandles(axidx),'GRF (N/kg)');

%% Y
axidx = 2;
subplotStart(3) = subplotStart(3) +1;
axesHandles(axidx) = subplot(subplotStart(1),subplotStart(2),subplotStart(3),axesHandles(axidx));
if ~isempty(GRFy_sd)
    plotHandles(axidx,2) = fill(axesHandles(axidx),[t;flipud(t)],[GRFy_avg-GRFy_sd;flipud(GRFy_avg+GRFy_sd)],[0.8 0.8 0.8]);
end
hold(axesHandles(axidx),'on');
plotHandles(axidx,1) = plot(axesHandles(axidx),t,GRFy_avg);

if b_addTitle
    title(axesHandles(axidx),'Medio-lateral');
end

%% Vertical
axidx = 3;
subplotStart(3) = subplotStart(3) +1;
axesHandles(axidx) = subplot(subplotStart(1),subplotStart(2),subplotStart(3),axesHandles(axidx));
if ~isempty(GRFz_sd)
    plotHandles(axidx,2) = fill(axesHandles(axidx),[t;flipud(t)],[GRFz_avg-GRFz_sd;flipud(GRFz_avg+GRFz_sd)],[0.8 0.8 0.8]);
end
hold(axesHandles(axidx),'on');
plotHandles(axidx,1) = plot(axesHandles(axidx),t,GRFz_avg);

if b_addTitle
    title(axesHandles(axidx),'Vertical');
end



