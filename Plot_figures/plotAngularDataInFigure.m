function plotAngularDataInFigure(t,hipAngles,hipAnglesVel,kneeAngles,kneeAnglesVel,ankleAngles,ankleAnglesVel)

%%
subplot(4,2,3);
plot(t,hipAngles);
title('Hip angle')
ylabel('rad');
hold on;

subplot(4,2,4);
plot(t,hipAnglesVel);
title('Hip angular velocity')
ylabel('rad/s')
hold on;

%%
subplot(4,2,5);
plot(t,kneeAngles);
title('Knee angle')
ylabel('rad');
hold on;

subplot(4,2,6);
plot(t,kneeAnglesVel);
title('Knee angular velocity')
ylabel('rad/s')
hold on;

%%
subplot(4,2,7);
plot(t,ankleAngles);
title('Ankle angle')
ylabel('rad');
xlabel('s');
hold on;

subplot(4,2,8);
plot(t,ankleAnglesVel);
title('Ankle angular velocity')
ylabel('rad/s')
xlabel('s')
hold on;