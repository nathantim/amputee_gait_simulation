function plotHandles = plotAngularDataInFigure(t,hipAngles,kneeAngles,ankleAngles,b_oneGaitPhase)
if  nargin <= 4
    b_oneGaitPhase = true;
end
plotHandles = nan(3,1);
%%
subplot(5,1,3);
plotHandles(1) = plot(t,hipAngles);
title('Hip angle')
ylabel('deg');
hold on;

%%
subplot(5,1,4);
plotHandles(2) = plot(t,kneeAngles);
title('Knee angle')
ylabel('deg');
hold on;


%%
subplot(5,1,5);
plotHandles(3) = plot(t,ankleAngles);
title('Ankle angle')
ylabel('deg');
if b_oneGaitPhase
    xlabel('%_s_t_r_i_d_e')
else
    xlabel('s')
end
hold on;

