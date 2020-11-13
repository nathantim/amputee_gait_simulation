function [plotHandles,axesHandles] = plotPowerDataInFigure(powerDataFig,axesHandles,t,hipPower_avg,hipPower_sd,hipRollPower_avg,hipRollPower_sd,...
                                                           kneePower_avg,kneePower_sd,anklePower_avg,anklePower_sd,subplotStart,b_addTitle)
% PLOTPOWERDATAINFIGURE       Function that plots the joint angles
% INPUTS:
%   - powerDataFig              Pre-created figure in which the joint power data is to be plotted.
%   - axesHandles               Pre-created, or empty, axes in which the  joint power data is to be plotted.
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
        axesHandles(ii) = axes(powerDataFig);
    end
end
if nargin < 13
    b_addTitle = true;
end

%% Plot hip 'abduction' power
axidx = 1;
axesHandles(axidx) = subplot(subplotStart(1),subplotStart(2),subplotStart(3),axesHandles(axidx));
if ~isempty(hipRollPower_sd)
    plotHandles(axidx,2) = fill(axesHandles(axidx),[t;flipud(t)],[hipRollPower_avg-hipRollPower_sd;flipud(hipRollPower_avg+hipRollPower_sd)],[0.8 0.8 0.8]);
end
hold(axesHandles(axidx),'on');
if ~isempty(hipRollPower_avg)
    plotHandles(axidx,1) = plot(axesHandles(axidx),t,hipRollPower_avg);
end

if b_addTitle
    title(axesHandles(axidx),{'Hip'; 'abduction'});
    ylabel(axesHandles(axidx),'Power (W/kg)');
end


%% Plot hip 'flexion' power
subplotStart(3) = subplotStart(3) +1;
axidx = 2;
axesHandles(axidx) = subplot(subplotStart(1),subplotStart(2),subplotStart(3),axesHandles(axidx));
if ~isempty(hipPower_sd)
    plotHandles(axidx,2) = fill(axesHandles(axidx),[t;flipud(t)],[hipPower_avg-hipPower_sd;flipud(hipPower_avg+hipPower_sd)],[0.8 0.8 0.8]);
end
hold(axesHandles(axidx),'on');
plotHandles(axidx,1) = plot(axesHandles(axidx),t,hipPower_avg);

if b_addTitle
    title(axesHandles(axidx),{'Hip';'flexion'});
end


%% Plot knee power
subplotStart(3) = subplotStart(3) +1;
axidx = 3;
axesHandles(axidx) = subplot(subplotStart(1),subplotStart(2),subplotStart(3),axesHandles(axidx));
if ~isempty(kneePower_sd)
    plotHandles(axidx,2) = fill(axesHandles(axidx),[t;flipud(t)],[kneePower_avg-kneePower_sd;flipud(kneePower_avg+kneePower_sd)],[0.8 0.8 0.8]);
end
hold(axesHandles(axidx),'on');
plotHandles(axidx,1) = plot(axesHandles(axidx),t,kneePower_avg);

if b_addTitle
    title(axesHandles(axidx),{'Knee';'flexion'});
end

%% Plot ankle power
subplotStart(3) = subplotStart(3) +1;
axidx = 4;
axesHandles(axidx) = subplot(subplotStart(1),subplotStart(2),subplotStart(3),axesHandles(axidx));
if ~isempty(anklePower_sd)
    plotHandles(axidx,2) = fill(axesHandles(axidx),[t;flipud(t)],[anklePower_avg-anklePower_sd;flipud(anklePower_avg+anklePower_sd)],[0.8 0.8 0.8]);
end
hold(axesHandles(axidx),'on');
plotHandles(axidx,1) = plot(axesHandles(axidx),t,anklePower_avg);

if b_addTitle
    title(axesHandles(axidx),{'Ankle';'dorsiflexion'});
end
