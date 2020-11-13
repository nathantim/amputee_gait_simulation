function [plotHandles,axesHandles] = plotAngularDataInFigure(angularDataFig,axesHandles,t,hipAngle_avg,hipAngle_sd,hipRollAngle_avg,hipRollAngle_sd,...
                                                             kneeAngle_avg,kneeAngle_sd,ankleAngle_avg,ankleAngle_sd,subplotStart,b_addTitle)
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
plotHandles = nan(4,2);
if isempty(axesHandles)
    for ii = 1:size(plotHandles,1)
        axesHandles(ii) = axes(angularDataFig);
    end
end
if nargin < 13
   b_addTitle = true; 
end

%% Plot hip abduction angle
axidx = 1;
axesHandles(axidx) = subplot(subplotStart(1),subplotStart(2),subplotStart(3),axesHandles(axidx));

if ~isempty(hipRollAngle_sd)
    plotHandles(axidx,2) = fill(axesHandles(axidx),[t;flipud(t)],[hipRollAngle_avg-hipRollAngle_sd;flipud(hipRollAngle_avg+hipRollAngle_sd)],[0.8 0.8 0.8]);
end
hold(axesHandles(axidx),'on');
if ~isempty(hipRollAngle_avg)
    plotHandles(axidx,1) = plot(axesHandles(axidx),t,hipRollAngle_avg);
end

set(axesHandles(axidx),'XLim',[t(1),t(end)]);

if b_addTitle
    title(axesHandles(axidx),{'Hip'; 'abduction'});
    ylabel(axesHandles(axidx),'Angle (deg)');
end

%% Plot hip flexion angle
subplotStart(3) = subplotStart(3) +1;
axidx = 2;
axesHandles(axidx) = subplot(subplotStart(1),subplotStart(2),subplotStart(3),axesHandles(axidx));

if ~isempty(hipAngle_sd)
    plotHandles(axidx,2) = fill(axesHandles(axidx),[t;flipud(t)],[hipAngle_avg-hipAngle_sd;flipud(hipAngle_avg+hipAngle_sd)],[0.8 0.8 0.8]);
end
hold(axesHandles(axidx),'on');
plotHandles(axidx,1) = plot(axesHandles(axidx),t,hipAngle_avg);
set(axesHandles(axidx),'XLim',[t(1),t(end)]);

if b_addTitle
    title(axesHandles(axidx),{'Hip';'flexion'});
end

%% Plot knee flexion angle
subplotStart(3) = subplotStart(3) +1;
axidx = 3;
axesHandles(axidx) = subplot(subplotStart(1),subplotStart(2),subplotStart(3),axesHandles(axidx));
if ~isempty(kneeAngle_sd)
    plotHandles(axidx,2) = fill(axesHandles(axidx),[t;flipud(t)],[kneeAngle_avg-kneeAngle_sd;flipud(kneeAngle_avg+kneeAngle_sd)],[0.8 0.8 0.8]);
end
hold(axesHandles(axidx),'on');
plotHandles(axidx,1) = plot(axesHandles(axidx),t,kneeAngle_avg);
set(axesHandles(axidx),'XLim',[t(1),t(end)]);

if b_addTitle
    title(axesHandles(axidx),{'Knee';'flexion'});
end

%% Plot ankle dorsiflexion angle
subplotStart(3) = subplotStart(3) + 1;
axidx = 4;
axesHandles(axidx) = subplot(subplotStart(1),subplotStart(2),subplotStart(3),axesHandles(axidx));
if ~isempty(ankleAngle_sd)
    plotHandles(axidx,2) = fill(axesHandles(axidx),[t;flipud(t)],[ankleAngle_avg-ankleAngle_sd;flipud(ankleAngle_avg+ankleAngle_sd)],[0.8 0.8 0.8]);
end
hold(axesHandles(axidx),'on');
plotHandles(axidx,1) = plot(axesHandles(axidx),t,ankleAngle_avg);
set(axesHandles(axidx),'XLim',[t(1),t(end)]);

if b_addTitle
    title(axesHandles(axidx),{'Ankle';'dorsiflexion'});
end
