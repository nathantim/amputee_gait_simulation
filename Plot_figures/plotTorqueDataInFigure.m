function [plotHandles,axesHandles] = plotTorqueDataInFigure(torqueDataFig,axesHandles,t,hipTorque_avg,hipTorque_sd,hipRollTorque_avg,hipRollTorque_sd,kneeTorque_avg,kneeTorque_sd,ankleTorque_avg,ankleTorque_sd,subplotStart,b_oneGaitPhase)
plotHandles = nan(4,2);
if isempty(axesHandles)
    for i = 1:size(plotHandles,1)
        axesHandles(i) = axes(torqueDataFig);
    end
end
if  nargin <= 12
    b_oneGaitPhase = true;
end

% subplotStart = dec2base(subplotStart,10) - '0';

%%
axidx = 1;
axesHandles(axidx) = subplot(subplotStart(1),subplotStart(2),subplotStart(3),axesHandles(axidx));
if ~isempty(hipRollTorque_sd)
    plotHandles(axidx,2) = fill(axesHandles(axidx),[t;flipud(t)],[hipRollTorque_avg-hipRollTorque_sd;flipud(hipRollTorque_avg+hipRollTorque_sd)],[0.8 0.8 0.8]);
end
hold(axesHandles(axidx),'on');
if ~isempty(hipRollTorque_avg)
    plotHandles(axidx,1) = plot(axesHandles(axidx),t,hipRollTorque_avg);
end


% h = get(axesHandles(axidx),'Children');
% set(axesHandles(axidx),'Children',h) % 

title(axesHandles(axidx),'Hip abduction')
ylabel(axesHandles(axidx),'Nm/kg');

%%
subplotStart(3) = subplotStart(3) +1;
axidx = 2;
axesHandles(axidx) = subplot(subplotStart(1),subplotStart(2),subplotStart(3),axesHandles(axidx));
if ~isempty(hipTorque_sd)
    plotHandles(axidx,2) = fill(axesHandles(axidx),[t;flipud(t)],[hipTorque_avg-hipTorque_sd;flipud(hipTorque_avg+hipTorque_sd)],[0.8 0.8 0.8]);
end
hold(axesHandles(axidx),'on');
plotHandles(axidx,1) = plot(axesHandles(axidx),t,hipTorque_avg);


% h = get(axesHandles(1),'Children');
% set(axesHandles(1),'Children',h) % 

title(axesHandles(axidx),'Hip flexion')
ylabel(axesHandles(axidx),'Nm/kg');


%%
subplotStart(3) = subplotStart(3) +1;
axidx = 3;
axesHandles(axidx) = subplot(subplotStart(1),subplotStart(2),subplotStart(3),axesHandles(axidx));
if ~isempty(kneeTorque_sd)
    plotHandles(axidx,2) = fill(axesHandles(axidx),[t;flipud(t)],[kneeTorque_avg-kneeTorque_sd;flipud(kneeTorque_avg+kneeTorque_sd)],[0.8 0.8 0.8]);
end
hold(axesHandles(axidx),'on');
plotHandles(axidx,1) = plot(axesHandles(axidx),t,kneeTorque_avg);

% h = get(axesHandles(axidx),'Children');
% set(axesHandles(axidx),'Children',flipud(h))
title(axesHandles(axidx),'Knee flexion')
ylabel(axesHandles(axidx),'Nm/kg');

%%
subplotStart(3) = subplotStart(3) +1;
axidx = 4;
axesHandles(axidx) = subplot(subplotStart(1),subplotStart(2),subplotStart(3),axesHandles(axidx));
if ~isempty(ankleTorque_sd)
    plotHandles(axidx,2) = fill(axesHandles(axidx),[t;flipud(t)],[ankleTorque_avg-ankleTorque_sd;flipud(ankleTorque_avg+ankleTorque_sd)],[0.8 0.8 0.8]);
end
hold(axesHandles(axidx),'on');
plotHandles(axidx,1) = plot(axesHandles(axidx),t,ankleTorque_avg);

% h = get(axesHandles(axidx),'Children');
% set(axesHandles(axidx),'Children',flipud(h))
title(axesHandles(axidx),'Ankle dorsiflexion')
ylabel(axesHandles(axidx),'Nm/kg');


if b_oneGaitPhase
    xlabel(axesHandles(4),'%_{stride}','interpreter','tex')
else
    xlabel(axesHandles(4),'s')
end
