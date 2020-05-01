t = stance_unit.Time;
stance_Fs = stance_unit.Data(:,1);
stance_Fd = stance_unit.Data(:,2);
stance_x = stance_unit.Data(:,3);
stance_dx = stance_unit.Data(:,4);

plot(stance_dx,stance_Fd);
figure();
subplot(2,1,1)
plot(t,stance_Fd)
subplot(2,1,2);
plot(t,stance_dx)
figure();
plot3(t,stance_dx,stance_Fd)
xlabel('$t$');
ylabel('$\dot{x}$');
zlabel('$F_D$');