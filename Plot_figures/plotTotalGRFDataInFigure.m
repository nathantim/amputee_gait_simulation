function [plotHandles,axesHandles] = plotTotalGRFDataInFigure(GRFDataFig,axesHandles,t,GRFx_avg,GRFx_sd,GRFy_avg,GRFy_sd,...
                                                              GRFz_avg,GRFz_sd,subplotStart,b_addTitle)
% PLOTANGULARDATAINFIGURE       Function that plots the joint angles
% INPUTS:
%   - angularDataFig            Pre-created figure in which the joint angle data is to be plotted.
%   - axesHandles               Pre-created, or empty, axes in which the  joint angle data is to be plotted.
%   - angularData               Structure with time of the joint angle data from the simulation.
% 
%   - All the data
% 
%   - subplotStart              This says in which subfigure to start.
%   - b_addTitle                Optional, boolean which selects if title of axis has to be put in the figure.
%
% OUTPUTS:
%   - plotHandles               Handles of all the plots, which can be used for later changes in line style etc, or for
%                               adding a legend.
%   - axesHandles               Handles of all the axes, which can be used for later changes in axes size, axes title
%                               locations etc.
%%                                                          
plotHandles = nan(3,2);
if isempty(axesHandles)
    for ii = 1:size(plotHandles,1)
        axesHandles(ii) = axes(GRFDataFig);
    end
end
if nargin < 11
    b_addTitle = true;
end

%% Plot anterior-posterior GRF
axidx = 1;
axesHandles(axidx) = subplot(subplotStart(1),subplotStart(2),subplotStart(3),axesHandles(axidx));
if ~isempty(GRFx_sd)
    plotHandles(axidx,2) = fill(axesHandles(axidx),[t;flipud(t)],[GRFx_avg-GRFx_sd;flipud(GRFx_avg+GRFx_sd)],[0.8 0.8 0.8]);
end
hold(axesHandles(axidx),'on');
plotHandles(axidx,1) = plot(axesHandles(axidx),t,GRFx_avg);

if b_addTitle
    title(axesHandles(axidx),{'Anterior';'posterior'});
    ylabel(axesHandles(axidx),'GRF (N/kg)');
end

%% Plot medio-lateral GRF
axidx = 2;
subplotStart(3) = subplotStart(3) +1;
axesHandles(axidx) = subplot(subplotStart(1),subplotStart(2),subplotStart(3),axesHandles(axidx));
if ~isempty(GRFy_sd)
    plotHandles(axidx,2) = fill(axesHandles(axidx),[t;flipud(t)],[GRFy_avg-GRFy_sd;flipud(GRFy_avg+GRFy_sd)],[0.8 0.8 0.8]);
end
hold(axesHandles(axidx),'on');
plotHandles(axidx,1) = plot(axesHandles(axidx),t,GRFy_avg);

if b_addTitle
    title(axesHandles(axidx),{'Medio';'lateral'});
end

%% Plot vertical GRF
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


