function plotHandles = plotAngularDataInFigure(t,hipAngles_avg,hipAngles_sd,kneeAngles_avg,kneeAngles_sd,ankleAngles_avg,ankleAngles_sd,subplotStart,b_oneGaitPhase)
if  nargin <= 8
    b_oneGaitPhase = true;
end
plotHandles = nan(3,2);
%%
subplot(subplotStart);
plotHandles(1,1) = plot(t,hipAngles_avg);
hold on;
if ~isempty(hipAngles_sd)
    plotHandles(1,2) = fill([t;flipud(t)],[hipAngles_avg-hipAngles_sd;flipud(hipAngles_avg+hipAngles_sd)],[0.8 0.8 0.8]);
end
h = get(gca,'Children');
set(gca,'Children',flipud(h))

title('Hip angle')
ylabel('deg');


%%
subplot(subplotStart+1);
plotHandles(2,1) = plot(t,kneeAngles_avg);
hold on;
if ~isempty(kneeAngles_sd)
    plotHandles(2,2) = fill([t;flipud(t)],[kneeAngles_avg-kneeAngles_sd;flipud(kneeAngles_avg+kneeAngles_sd)],[0.8 0.8 0.8]);
end
h = get(gca,'Children');
set(gca,'Children',flipud(h))
title('Knee angle')
ylabel('deg');

%%
subplot(subplotStart+2);
plotHandles(3,1) = plot(t,ankleAngles_avg);
hold on;
if ~isempty(ankleAngles_sd)
    plotHandles(3,2) = fill([t;flipud(t)],[ankleAngles_avg-ankleAngles_sd;flipud(ankleAngles_avg+ankleAngles_sd)],[0.8 0.8 0.8]);
end

h = get(gca,'Children');
set(gca,'Children',flipud(h))
title('Ankle angle')
ylabel('deg');
if b_oneGaitPhase
    xlabel('%_{stride}','interpreter','tex')
else
    xlabel('s')
end

