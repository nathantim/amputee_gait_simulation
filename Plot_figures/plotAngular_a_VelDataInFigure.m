function plotHandles = plotAngular_a_VelDataInFigure(t,hipAngles,hipAnglesVel,kneeAngles,kneeAnglesVel,ankleAngles,ankleAnglesVel,b_oneGaitPhase)
if  nargin <= 7
    b_oneGaitPhase = true;
end

plotHandles = nan(6,1);
%%
subplot(4,2,3);
plotHandles(1) = plot(t,hipAngles);
title('Hip angle')
ylabel('rad');
hold on;

if (max(size(hipAnglesVel))~= 0)
    subplot(4,2,4);
    plotHandles(2) = plot(t,hipAnglesVel);
    title('Hip angular velocity')
    ylabel('rad/s')
    hold on;
end
%%
subplot(4,2,5);
plotHandles(3) = plot(t,kneeAngles);
title('Knee angle')
ylabel('rad');
hold on;

if (max(size(kneeAnglesVel))~= 0)
subplot(4,2,6);
plotHandles(4) = plot(t,kneeAnglesVel);
title('Knee angular velocity')
ylabel('rad/s')
hold on;
end

%%
subplot(4,2,7);
plotHandles(5) = plot(t,ankleAngles);
title('Ankle angle')
ylabel('rad');
if b_oneGaitPhase
    xlabel('%_s_t_r_i_d_e')
else
    xlabel('s')
end
hold on;

if (max(size(ankleAnglesVel))~= 0)
subplot(4,2,8);
plotHandles(6) = plot(t,ankleAnglesVel);
title('Ankle angular velocity')
ylabel('rad/s')
if b_oneGaitPhase
    xlabel('%_s_t_r_i_d_e')
else
    xlabel('s')
end
hold on;
end