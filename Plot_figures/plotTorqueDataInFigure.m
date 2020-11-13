function [plotHandles,axesHandles] = plotTorqueDataInFigure(torqueDataFig,axesHandles,t,hipTorque_avg,hipTorque_sd,hipRollTorque_avg,hipRollTorque_sd,...
                                                            kneeTorque_avg,kneeTorque_sd,ankleTorque_avg,ankleTorque_sd,subplotStart,b_addTitle)
% PLOTTORQUEDATAINFIGURE        Function that plots the joint torques
% INPUTS:
%   - torqueDataFig             Pre-created figure in which the joint angle data is to be plotted.
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
        axesHandles(ii) = axes(torqueDataFig);
    end
end
if nargin < 13
    b_addTitle = true;
end

%% Plot hip abduction torquue
axidx = 1;
axesHandles(axidx) = subplot(subplotStart(1),subplotStart(2),subplotStart(3),axesHandles(axidx));
if ~isempty(hipRollTorque_sd)
    plotHandles(axidx,2) = fill(axesHandles(axidx),[t;flipud(t)],[hipRollTorque_avg-hipRollTorque_sd;flipud(hipRollTorque_avg+hipRollTorque_sd)],[0.8 0.8 0.8]);
end
hold(axesHandles(axidx),'on');
if ~isempty(hipRollTorque_avg)
    plotHandles(axidx,1) = plot(axesHandles(axidx),t,hipRollTorque_avg);
end

if b_addTitle
    title(axesHandles(axidx),{'Hip'; 'abduction'});
    ylabel(axesHandles(axidx),'Torque (Nm/kg)');
end

%% Plot hip flexion torque
subplotStart(3) = subplotStart(3) +1;
axidx = 2;
axesHandles(axidx) = subplot(subplotStart(1),subplotStart(2),subplotStart(3),axesHandles(axidx));
if ~isempty(hipTorque_sd)
    plotHandles(axidx,2) = fill(axesHandles(axidx),[t;flipud(t)],[hipTorque_avg-hipTorque_sd;flipud(hipTorque_avg+hipTorque_sd)],[0.8 0.8 0.8]);
end
hold(axesHandles(axidx),'on');
plotHandles(axidx,1) = plot(axesHandles(axidx),t,hipTorque_avg);

if b_addTitle
    title(axesHandles(axidx),{'Hip';'flexion'});
end

%% Plot knee flexion torque
subplotStart(3) = subplotStart(3) +1;
axidx = 3;
axesHandles(axidx) = subplot(subplotStart(1),subplotStart(2),subplotStart(3),axesHandles(axidx));
if ~isempty(kneeTorque_sd)
    plotHandles(axidx,2) = fill(axesHandles(axidx),[t;flipud(t)],[kneeTorque_avg-kneeTorque_sd;flipud(kneeTorque_avg+kneeTorque_sd)],[0.8 0.8 0.8]);
end
hold(axesHandles(axidx),'on');
plotHandles(axidx,1) = plot(axesHandles(axidx),t,kneeTorque_avg);

if b_addTitle
    title(axesHandles(axidx),{'Knee';'flexion'});
end

%% Plot ankle dorsiflexion torque
subplotStart(3) = subplotStart(3) +1;
axidx = 4;
axesHandles(axidx) = subplot(subplotStart(1),subplotStart(2),subplotStart(3),axesHandles(axidx));
if ~isempty(ankleTorque_sd)
    plotHandles(axidx,2) = fill(axesHandles(axidx),[t;flipud(t)],[ankleTorque_avg-ankleTorque_sd;flipud(ankleTorque_avg+ankleTorque_sd)],[0.8 0.8 0.8]);
end
hold(axesHandles(axidx),'on');
plotHandles(axidx,1) = plot(axesHandles(axidx),t,ankleTorque_avg);

if b_addTitle
    title(axesHandles(axidx),{'Ankle';'dorsiflexion'});
end


