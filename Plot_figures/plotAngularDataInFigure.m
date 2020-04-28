function plotHandles = plotAngularDataInFigure(t,hipAngles,kneeAngles,ankleAngles,subplotStart,b_oneGaitPhase)
if  nargin <= 5
    b_oneGaitPhase = true;
end
plotHandles = nan(3,1);
%%
subplot(subplotStart);
plotHandles(1) = plot(t,hipAngles);
title('Hip angle')
ylabel('deg');
hold on;

%%
subplot(subplotStart+1);
plotHandles(2) = plot(t,kneeAngles);
title('Knee angle')
ylabel('deg');
hold on;


%%
subplot(subplotStart+2);
plotHandles(3) = plot(t,ankleAngles);
title('Ankle angle')
ylabel('deg');
if b_oneGaitPhase
    xlabel('%_{stride}','interpreter','tex')
else
    xlabel('s')
end
hold on;

