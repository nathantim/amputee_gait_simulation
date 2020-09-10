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
axesHandles(1) = subplot(subplotStart(1),subplotStart(2),subplotStart(3),axesHandles(1));
if ~isempty(hipTorque_sd)
    plotHandles(1,2) = fill(axesHandles(1),[t;flipud(t)],[hipTorque_avg-hipTorque_sd;flipud(hipTorque_avg+hipTorque_sd)],[0.8 0.8 0.8]);
end
hold(axesHandles(1),'on');
plotHandles(1,1) = plot(axesHandles(1),t,hipTorque_avg);


% h = get(axesHandles(1),'Children');
% set(axesHandles(1),'Children',h) % 

title(axesHandles(1),'Hip flexion')
ylabel(axesHandles(1),'Nm/kg');


%%
subplotStart(3) = subplotStart(3) +1;
axesHandles(2) = subplot(subplotStart(1),subplotStart(2),subplotStart(3),axesHandles(2));
if ~isempty(kneeTorque_sd)
    plotHandles(2,2) = fill(axesHandles(2),[t;flipud(t)],[kneeTorque_avg-kneeTorque_sd;flipud(kneeTorque_avg+kneeTorque_sd)],[0.8 0.8 0.8]);
end
hold(axesHandles(2),'on');
plotHandles(2,1) = plot(axesHandles(2),t,kneeTorque_avg);

% h = get(axesHandles(2),'Children');
% set(axesHandles(2),'Children',flipud(h))
title(axesHandles(2),'Knee flexion')
ylabel(axesHandles(2),'Nm/kg');

%%
subplotStart(3) = subplotStart(3) +1;
axesHandles(3) = subplot(subplotStart(1),subplotStart(2),subplotStart(3),axesHandles(3));
if ~isempty(ankleTorque_sd)
    plotHandles(3,2) = fill(axesHandles(3),[t;flipud(t)],[ankleTorque_avg-ankleTorque_sd;flipud(ankleTorque_avg+ankleTorque_sd)],[0.8 0.8 0.8]);
end
hold(axesHandles(3),'on');
plotHandles(3,1) = plot(axesHandles(3),t,ankleTorque_avg);

% h = get(axesHandles(3),'Children');
% set(axesHandles(3),'Children',flipud(h))
title(axesHandles(3),'Ankle dorsiflexion')
ylabel(axesHandles(3),'Nm/kg');


%%
subplotStart(3) = subplotStart(3) +1;
axesHandles(4) = subplot(subplotStart(1),subplotStart(2),subplotStart(3),axesHandles(4));
if ~isempty(hipRollTorque_sd)
    plotHandles(4,2) = fill(axesHandles(4),[t;flipud(t)],[hipRollTorque_avg-hipRollTorque_sd;flipud(hipRollTorque_avg+hipRollTorque_sd)],[0.8 0.8 0.8]);
end
hold(axesHandles(4),'on');
if ~isempty(hipRollTorque_avg)
    plotHandles(4,1) = plot(axesHandles(4),t,hipRollTorque_avg);
end


% h = get(axesHandles(4),'Children');
% set(axesHandles(4),'Children',h) % 

title(axesHandles(4),'Hip abduction')
ylabel(axesHandles(4),'Nm/kg');

if b_oneGaitPhase
    xlabel(axesHandles(4),'%_{stride}','interpreter','tex')
else
    xlabel(axesHandles(4),'s')
end
