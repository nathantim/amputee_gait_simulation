function [plotHandles,axesHandles] = plotAngularDataInFigure(angularDataFig,axesHandles,t,hipAngles_avg,hipAngles_sd,hipRollAngles_avg,hipRollAngles_sd,kneeAngles_avg,kneeAngles_sd,ankleAngles_avg,ankleAngles_sd,subplotStart,b_oneGaitPhase)
plotHandles = nan(4,2);
if isempty(axesHandles)
    for i = 1:size(plotHandles,1)
        axesHandles(i) = axes(angularDataFig);
    end
end
if  nargin <= 12
    b_oneGaitPhase = true;
end

%%
subplotStartvec = dec2base(subplotStart,10) - '0';
axesHandles(1) = subplot(subplotStartvec(1),subplotStartvec(2),subplotStartvec(3),axesHandles(1));
if ~isempty(hipAngles_sd)
    plotHandles(1,2) = fill(axesHandles(1),[t;flipud(t)],[hipAngles_avg-hipAngles_sd;flipud(hipAngles_avg+hipAngles_sd)],[0.8 0.8 0.8]);
end
hold(axesHandles(1),'on');
plotHandles(1,1) = plot(axesHandles(1),t,hipAngles_avg);


% h = get(axesHandles(1),'Children');
% set(axesHandles(1),'Children',h) % 

title(axesHandles(1),'Hip flexion angle')
ylabel(axesHandles(1),'deg');


%%
subplotStartvec = dec2base(subplotStart+1,10) - '0';
axesHandles(2) = subplot(subplotStartvec(1),subplotStartvec(2),subplotStartvec(3),axesHandles(2));
if ~isempty(kneeAngles_sd)
    plotHandles(2,2) = fill(axesHandles(2),[t;flipud(t)],[kneeAngles_avg-kneeAngles_sd;flipud(kneeAngles_avg+kneeAngles_sd)],[0.8 0.8 0.8]);
end
hold(axesHandles(2),'on');
plotHandles(2,1) = plot(axesHandles(2),t,kneeAngles_avg);

% h = get(axesHandles(2),'Children');
% set(axesHandles(2),'Children',flipud(h))
title(axesHandles(2),'Knee flexion angle')
ylabel(axesHandles(2),'deg');

%%
subplotStartvec = dec2base(subplotStart+2,10) - '0';
axesHandles(3) = subplot(subplotStartvec(1),subplotStartvec(2),subplotStartvec(3),axesHandles(3));
if ~isempty(ankleAngles_sd)
    plotHandles(3,2) = fill(axesHandles(3),[t;flipud(t)],[ankleAngles_avg-ankleAngles_sd;flipud(ankleAngles_avg+ankleAngles_sd)],[0.8 0.8 0.8]);
end
hold(axesHandles(3),'on');
plotHandles(3,1) = plot(axesHandles(3),t,ankleAngles_avg);

% h = get(axesHandles(3),'Children');
% set(axesHandles(3),'Children',flipud(h))
title(axesHandles(3),'Ankle dorsiflexion angle')
ylabel(axesHandles(3),'deg');
if b_oneGaitPhase
    xlabel(axesHandles(3),'%_{stride}','interpreter','tex')
else
    xlabel(axesHandles(3),'s')
end

%%
subplotStartvec = dec2base(subplotStart+3,10) - '0';
axesHandles(4) = subplot(subplotStartvec(1),subplotStartvec(2),subplotStartvec(3),axesHandles(4));
if ~isempty(hipRollAngles_sd)
    plotHandles(4,2) = fill(axesHandles(4),[t;flipud(t)],[hipRollAngles_avg-hipRollAngles_sd;flipud(hipRollAngles_avg+hipRollAngles_sd)],[0.8 0.8 0.8]);
end
hold(axesHandles(4),'on');
if ~isempty(hipRollAngles_avg)
    plotHandles(4,1) = plot(axesHandles(4),t,hipRollAngles_avg);
end


% h = get(axesHandles(4),'Children');
% set(axesHandles(4),'Children',h) % 

title(axesHandles(4),'Hip abduction angle')
ylabel(axesHandles(4),'deg');

