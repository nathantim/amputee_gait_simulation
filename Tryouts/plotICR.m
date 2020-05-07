ICR_y = ICR.data(:,1)*1000; % mm 
ICR_z = ICR.data(:,2)*1000; % mm

y_14_1 = pos14_1.data(:,2)*1000;
z_14_1 = pos14_1.data(:,3)*1000;
y_14_2 = pos14_2.data(:,2)*1000;
z_14_2 = pos14_2.data(:,3)*1000;
y_25_1 = pos25_1.data(:,2)*1000;
z_25_1 = pos25_1.data(:,3)*1000;
y_25_2 = pos25_2.data(:,2)*1000;
z_25_2 = pos25_2.data(:,3)*1000;
angle_knee = knee_angle.data; % deg
t = ICR.Time;

origin_swing_y = y_14_2;
origin_swing_z = z_14_2;
origin_stance_y = y_14_1;
origin_stance_z = z_14_1;
origin_y = origin_stance_y;
origin_z = origin_stance_z;

y_14_1 = pos14_1.data(:,2)*1000 - origin_y;
z_14_1 = pos14_1.data(:,3)*1000 - origin_z;
y_14_2 = pos14_2.data(:,2)*1000 - origin_y;
z_14_2 = pos14_2.data(:,3)*1000 - origin_z;
y_25_1 = pos25_1.data(:,2)*1000 - origin_y;
z_25_1 = pos25_1.data(:,3)*1000 - origin_z;
y_25_2 = pos25_2.data(:,2)*1000 - origin_y;
z_25_2 = pos25_2.data(:,3)*1000 - origin_z;
% plot3(ICR_y,ICR_z,knee_angle.data)
% xlabel('x');ylabel('z'); zlabel('knee angle')
% % plot3(ICR.data(:,1)*1000,ICR.data(:,2)*1000,knee_angle.data)
% xlabel('x');ylabel('z'); zlabel('knee angle')
figure();
barandicr = subplot(3,1,1);
set(barandicr,'NextPlot','Add');
bar14 = plot(barandicr,[y_14_1(1);y_14_2(1)],[z_14_1(1);z_14_2(1)],'Color',[197 90 17]./255);
bar25 = plot(barandicr,[y_25_1(1);y_25_2(1)],[z_25_1(1);z_25_2(1)],'Color',[191 144 0]./255);
icrplot = plot(barandicr,ICR_y(1),ICR_z(1),'*');
axis(barandicr,5.*[-200 200 -100 100])
ylabel(barandicr,'z in mm');
xlabel(barandicr,'y in mm')

icraxes = subplot(3,1,2);
set(icraxes,'NextPlot','Add');
icrmark = plot(icraxes,ICR_y(1),ICR_z(1),'o');
icrline = plot(icraxes,ICR_y(1),ICR_z(1));
axis(icraxes,[-50 300, -100 550]);
ylabel(icraxes,'z in mm');
xlabel(icraxes,'y in mm')

kneeangleplot = subplot(3,1,3);
kneeline = plot(kneeangleplot,t(1),angle_knee(1));
axis(kneeangleplot,[0 max(t), min(angle_knee) max(angle_knee)]);
ylabel(kneeangleplot,'knee angle in deg');
xlabel(kneeangleplot,'time in s');

%%
for i = 2:3:length(ICR_y)
    set(bar14,'XData',[y_14_1(i);y_14_2(i)],'YData',[z_14_1(i);z_14_2(i)]);
    set(bar25,'XData',[y_25_1(i);y_25_2(i)],'YData',[z_25_1(i);z_25_2(i)]);
    set(icrplot,'XData',ICR_y(i),'YData',ICR_z(i));
    set(icrmark,'XData',ICR_y(i),'YData',ICR_z(i));
    set(icrline,'XData',ICR_y(1:i),'YData',ICR_z(1:i));
    set(kneeline,'XData',t(1:i) , 'YData',angle_knee(1:i));
   drawnow
%    pause(0.01);
    input('Press key to continue');
end
    