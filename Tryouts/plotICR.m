% Otto-bock 'data'
% https://media.ottobock.com/_web-site/prosthetics/lower-limb/3r60/files/3r60-pro_information_for_practitioners.pdf
knee_angle_swing_o = [0;5;10;20;30;50;80;100;120;140];
ICRoswing_y = ([363 209 149 159 192 249 300 337 333 320]' - 213)./3.36; % mm
ICRoswing_z = -1*([25 281 457 572 680 748 752 701 664 631] - 701)./3.36; % %mm

knee_angle_stance_o = [0;2;6;12;15];
ICRostance_y = ([205 241 327 474 514]' - 89)./1.48; % mm
ICRostance_z = -1*([393 336 206 62 70] - 824)./1.48; % %mm

knee_angle_swing_to_plot = (0:0.5:140)';
ICRoswing_y_interp = interp1(knee_angle_swing_o,ICRoswing_y,knee_angle_swing_to_plot,'pchip');
ICRoswing_z_interp = interp1(knee_angle_swing_o,ICRoswing_z,knee_angle_swing_to_plot,'pchip');

knee_angle_stance_to_plot = (0:0.5:15)';
ICRostance_y_interp = interp1(knee_angle_stance_o,ICRostance_y,knee_angle_stance_to_plot,'pchip');
ICRostance_z_interp = interp1(knee_angle_stance_o,ICRostance_z,knee_angle_stance_to_plot,'pchip');

figure();
ottoplotswingax = subplot(1,2,1);
ottoplotswingline= plot(ICRoswing_y_interp,ICRoswing_z_interp,'r'); 
hold on;
plot(ottoplotswingax,ICRoswing_y,ICRoswing_z,'ro');

axis equal
plot(ottoplotswingax,ottoplotswingax.XLim,[ 0 0],'Color',[0.8 0.8 0.8])
plot(ottoplotswingax,[ 0 0], ottoplotswingax.YLim,'Color',[0.8 0.8 0.8]);
h = get(ottoplotswingax,'Children');
set(ottoplotswingax,'Children',flipud(h));
text(ottoplotswingax,ICRoswing_y+5,ICRoswing_z+2,strcat(num2str(knee_angle_swing_o),'$^o $'))


% stance plot
ottoplotstanceax = subplot(1,2,2);
ottoplotstanceline= plot(ICRostance_y_interp,ICRostance_z_interp,'r'); 
hold on;
plot(ottoplotstanceax,ICRostance_y,ICRostance_z,'ro');
plot(ottoplotstanceax,0,0);%,'Visible','off');
axis equal
% plot(ottoplotstanceax,ottoplotstanceax.XLim,[ 0 0],'Color',[0.8 0.8 0.8])
plot(ottoplotstanceax,[ 0 0], ottoplotstanceax.YLim,'Color',[0.8 0.8 0.8]);
h = get(ottoplotstanceax,'Children');
set(ottoplotstanceax,'Children',flipud(h));
text(ottoplotstanceax,ICRostance_y-5,ICRostance_z-15,strcat(num2str(knee_angle_stance_o),'$^o $'))

sgtitle('\textbf{Location instantaneous center of rotation}')
title(ottoplotswingax,'Swing phase flexion');
title(ottoplotstanceax,'Stance phase flexion');
% plot(knee_angle_o,ICRoswing_z)

%%
% line14_y = @(z,alpha14)(1/tan(alpha14)*(z-z_14_1) + y_14_1) ; 
alpha14_o = atan(ICRoswing_z_interp./ICRoswing_y_interp).*180/pi ; 
alpha25_o = atan(ICRoswing_z_interp./ICRoswing_y_interp).*180/pi ; 
% line25_z = @(y,alpha14)(tan(alpha25)*(y-y_25_1) + z_25_1) ; 

% line25_y = @(z,alpha14)(1/tan(alpha25)*(z-z_25_1) + y_25_1) ; 
%%
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
idx_length = find(angle_knee>140,1,'first')+1;
t = ICR.Time(1:idx_length);

origin_swing_y = y_14_2;
origin_swing_z = z_14_2;
origin_stance_y = y_14_1;
origin_stance_z = z_14_1;
origin_y = origin_swing_y;
origin_z = origin_swing_z;

ICR_y = ICR_y - origin_y;
ICR_z = ICR_z - origin_z;
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
%%
figure();
barandicr = subplot(2,2,1);
set(barandicr,'NextPlot','Add');
bar14 = plot(barandicr,[y_14_1(1);y_14_2(1)],[z_14_1(1);z_14_2(1)],'Color',[197 90 17]./255);
bar25 = plot(barandicr,[y_25_1(1);y_25_2(1)],[z_25_1(1);z_25_2(1)],'Color',[191 144 0]./255);
icrplot = plot(barandicr,ICR_y(1),ICR_z(1),'*');
axis(barandicr,2.*[-200 200 -100 100])
ylabel(barandicr,'z in mm');
xlabel(barandicr,'y in mm')

icraxes = subplot(2,2,[2 4]);

ottoplotswingline= plot(icraxes,ICRoswing_y_interp,ICRoswing_z_interp,'r'); 
hold on;
plot(icraxes,ICRoswing_y,ICRoswing_z,'ro');

axis equal
plot(icraxes,icraxes.XLim,[ 0 0],'Color',[0.8 0.8 0.8])
plot(icraxes,[ 0 0], icraxes.YLim,'Color',[0.8 0.8 0.8]);
h = get(icraxes,'Children');
set(icraxes,'Children',flipud(h));
text(icraxes,ICRoswing_y+5,ICRoswing_z+2,strcat(num2str(knee_angle_swing_o),'$^o $'))


% set(icraxes,'NextPlot','Add');
icrmark = plot(icraxes,ICR_y(1),ICR_z(1),'o');
icrline = plot(icraxes,ICR_y(1),ICR_z(1));
% axis(icraxes,[-50 300, -100 550]);
ylabel(icraxes,'z in mm');
xlabel(icraxes,'y in mm')
% set(icraxes,'DataAspectRatio',[1 1 1]);

kneeangleplot = subplot(2,2,3);
kneeline = plot(kneeangleplot,t(1),angle_knee(1));
axis(kneeangleplot,[0 max(t), min(angle_knee) max(angle_knee)]);
ylabel(kneeangleplot,'knee angle in deg');
xlabel(kneeangleplot,'time in s');

%%
% idx_length = length(ICR_y);
clear icrpoint;
latest_angle = nan;
addpoint = false;
for i = 2:3:idx_length
    set(bar14,'XData',[y_14_1(i);y_14_2(i)],'YData',[z_14_1(i);z_14_2(i)]);
    set(bar25,'XData',[y_25_1(i);y_25_2(i)],'YData',[z_25_1(i);z_25_2(i)]);
    set(icrplot,'XData',ICR_y(i),'YData',ICR_z(i));
    set(icrmark,'XData',ICR_y(i),'YData',ICR_z(i));
    set(icrline,'XData',ICR_y(1:i),'YData',ICR_z(1:i));
    
    if exist('icrpoint','var')==0 || (angle_knee(i) < 10 && mod(angle_knee(i),5) < 1 && abs(latest_angle-angle_knee(i))>4 )
       addpoint = true;
    elseif (angle_knee(i) <= 55 && mod(angle_knee(i),10) < 1 && abs(latest_angle-angle_knee(i))>4 )
        addpoint = true;
    elseif (angle_knee(i) >= 70 && mod(angle_knee(i),20) < 1 && abs(latest_angle-angle_knee(i))>4 )
        addpoint = true;
    end
    if addpoint
       icrpoint = plot(icraxes,ICR_y(i),ICR_z(i),'o');
       latest_angle = angle_knee(i);
       text(icraxes,ICR_y(i)-10,ICR_z(i)+10,strcat(num2str(round(angle_knee(i))),'$^o $'));
       addpoint = false;
    end
    set(kneeline,'XData',t(1:i) , 'YData',angle_knee(1:i));
   drawnow
   pause(0.01);
%     input('Press key to continue');
end
    