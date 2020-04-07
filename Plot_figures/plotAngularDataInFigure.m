function plotHandles = plotAngularDataInFigure(t,hipAngles,kneeAngles,ankleAngles)
plotHandles = nan(3,1);
%%
subplot(4,1,2);
plotHandles(1) = plot(t,hipAngles);
title('Hip angle')
ylabel('rad');
hold on;

%%
subplot(4,1,3);
plotHandles(2) = plot(t,kneeAngles);
title('Knee angle')
ylabel('rad');
hold on;


%%
subplot(4,1,4);
plotHandles(3) = plot(t,ankleAngles);
title('Ankle angle')
ylabel('rad');
xlabel('%_s_t_r_i_d_e')
hold on;

