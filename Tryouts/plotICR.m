close all;
%%
gait_phase = input("Which phase of the gait are we looking at? (swing/stance)",'s');

%% Otto-bock 'data'

knee_angle_swing_to_plot = (0:0.5:140)';
[ICRoswing_y_interp,ICRoswing_z_interp,ICRoswing_y,ICRoswing_z,knee_angle_swing_o]= getICR_otto(knee_angle_swing_to_plot,"swing");

knee_angle_stance_to_plot = (0:0.5:15)';
[ICRostance_y_interp,ICRostance_z_interp,ICRostance_y,ICRostance_z,knee_angle_stance_o] = getICR_otto(knee_angle_stance_to_plot,"stance");

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
% alpha25_o = atan(ICRoswing_z_interp./ICRoswing_y_interp).*180/pi ; 
% line25_z = @(y,alpha14)(tan(alpha25)*(y-y_25_1) + z_25_1) ; 

% line25_y = @(z,alpha14)(1/tan(alpha25)*(z-z_25_1) + y_25_1) ; 
%%

% plot3(ICR_y,ICR_z,knee_angle.data)
% xlabel('x');ylabel('z'); zlabel('knee angle')
% % plot3(ICR.data(:,1)*1000,ICR.data(:,2)*1000,knee_angle.data)
% xlabel('x');ylabel('z'); zlabel('knee angle')
%%
idx_length = [];
ICR_y = ICR(:,1)*1000; % mm
ICR_z = ICR(:,2)*1000; % mm

y_14_1 = pos14_1(:,2)*1000;
z_14_1 = pos14_1(:,3)*1000;
y_14_2 = pos14_2(:,2)*1000;
z_14_2 = pos14_2(:,3)*1000;
y_25_1 = pos25_1(:,2)*1000;
z_25_1 = pos25_1(:,3)*1000;
y_25_2 = pos25_2(:,2)*1000;
z_25_2 = pos25_2(:,3)*1000;
angle_knee = knee_angle; % deg

origin_swing_y = y_14_2;
origin_swing_z = z_14_2;
origin_stance_y = y_14_1;
origin_stance_z = z_14_1;

if strcmp(gait_phase,"swing")
    idx_length = find(angle_knee>140,1,'first')+1;
    origin_y = origin_swing_y;
    origin_z = origin_swing_z;
    ICRo_y_interp = ICRoswing_y_interp;
    ICRo_z_interp = ICRoswing_z_interp;
    ICRo_y = ICRoswing_y;
    ICRo_z = ICRoswing_z;
    knee_angle_o = knee_angle_swing_o;
elseif strcmp(gait_phase,"stance")
    idx_length = find(angle_knee==max([angle_knee;15]),1,'first')+1;
    origin_y = origin_stance_y;
    origin_z = origin_stance_z;
    ICRo_y_interp = ICRostance_y_interp;
    ICRo_z_interp = ICRostance_z_interp;
    ICRo_y = ICRostance_y;
    ICRo_z = ICRostance_z;
    knee_angle_o = knee_angle_stance_o;
else
    error("Unknown gait phase");
end

if isempty(idx_length)
    idx_length = length(knee_angle);
end
angle_knee = knee_angle(1:idx_length);
t = time(1:idx_length);

ICR_y = ICR_y - origin_y;
ICR_z = ICR_z - origin_z;
y_14_1 = y_14_1 - origin_y;
z_14_1 = z_14_1 - origin_z;
y_14_2 = y_14_2 - origin_y;
z_14_2 = z_14_2 - origin_z;
y_25_1 = y_25_1 - origin_y;
z_25_1 = z_25_1 - origin_z;
y_25_2 = y_25_2 - origin_y;
z_25_2 =z_25_2 - origin_z;

figure();

icraxes = subplot(1,3,[1 2]);
icrplot = plot(icraxes,ICR_y(1),ICR_z(1),'g*');
hold on;
bar14 = plot(icraxes,[y_14_1(1);y_14_2(1)],[z_14_1(1);z_14_2(1)],'Color',[197 90 17]./255);
bar25 = plot(icraxes,[y_25_1(1);y_25_2(1)],[z_25_1(1);z_25_2(1)],'Color',[191 144 0]./255);
ottoplotswingline= plot(icraxes,ICRo_y_interp,ICRo_z_interp,'r'); 
plot(icraxes,ICRo_y,ICRo_z,'ro');
text(icraxes,ICRo_y+5,ICRo_z+2,strcat(num2str(knee_angle_o),'$^o $'))
plot(icraxes,icraxes.XLim,[ 0 0],'Color',[0.8 0.8 0.8])
plot(icraxes,[ 0 0], icraxes.YLim,'Color',[0.8 0.8 0.8]);
axis equal
set(icraxes,'YLimMode','manual');

bar_workline = @(y_1,y_2,z_1,z_2,xlim)(interp1([y_1(1);y_2(1)],[z_1(1);z_2(1)],xlim','linear','extrap'));
xlimits_workline = icraxes.XLim;
bar14_worklineplot = plot(icraxes,icraxes.XLim,bar_workline(y_14_1(1),y_14_2(1),z_14_1(1),z_14_2(1),xlimits_workline),'--','Color',[0.3 0.3 0.3],'LineWidth',1);
bar25_worklineplot = plot(icraxes,icraxes.XLim,bar_workline(y_25_1(1),y_25_2(1),z_25_1(1),z_25_2(1),xlimits_workline),'--','Color',[0.3 0.3 0.3],'LineWidth',1);

h = get(icraxes,'Children');
set(icraxes,'Children',flipud(h));
set(icraxes,'XLimMode','manual');


% barandicr = subplot(2,1,2);
% set(barandicr,'NextPlot','Add');
% axis(barandicr,2.*[-200 200 -100 100])
ylabel(icraxes,'z in mm');
xlabel(icraxes,'y in mm')
title(icraxes,'Location instantenous center of rotation')

% set(icraxes,'NextPlot','Add');
icrmark = plot(icraxes,ICR_y(1),ICR_z(1),'o');
icrline = plot(icraxes,ICR_y(1),ICR_z(1));
% axis(icraxes,[-50 300, -100 550]);
% ylabel(icraxes,'z in mm');
% xlabel(icraxes,'y in mm')
% set(icraxes,'DataAspectRatio',[1 1 1]);

kneeangleplot = subplot(1,3,3);
kneeline = plot(kneeangleplot,t(1),angle_knee(1));
axis(kneeangleplot,[0 max(t), min(angle_knee) max(angle_knee)]);
ylabel(kneeangleplot,'deg');
xlabel(kneeangleplot,'time in s');
title(kneeangleplot,'knee angle');

%%
% idx_length = length(ICR_y);
clear icrpoint;
latest_angle = nan;
addpoint = false;
input('Press a key to continue')
for i = 2:3:idx_length
    set(bar14,'XData',[y_14_1(i);y_14_2(i)],'YData',[z_14_1(i);z_14_2(i)]);
    set(bar25,'XData',[y_25_1(i);y_25_2(i)],'YData',[z_25_1(i);z_25_2(i)]);
    set(icrplot,'XData',ICR_y(i),'YData',ICR_z(i));
    set(icrmark,'XData',ICR_y(i),'YData',ICR_z(i));
    set(icrline,'XData',ICR_y(1:i),'YData',ICR_z(1:i));
    set(bar14_worklineplot,'YData',bar_workline(y_14_1(i),y_14_2(i),z_14_1(i),z_14_2(i),xlimits_workline));
    set(bar25_worklineplot,'YData',bar_workline(y_25_1(i),y_25_2(i),z_25_1(i),z_25_2(i),xlimits_workline));
    
    if strcmp(gait_phase,"swing")
        if exist('icrpoint','var')==0 || (angle_knee(i) < 10 && mod(angle_knee(i),5) < 1 && abs(latest_angle-angle_knee(i))>1 )
            addpoint = true;
        elseif (angle_knee(i) <= 55 && mod(angle_knee(i),10) < 1 && abs(latest_angle-angle_knee(i))>1 )
            addpoint = true;
        elseif (angle_knee(i) >= 70 && mod(angle_knee(i),20) < 1 && abs(latest_angle-angle_knee(i))>1 )
            addpoint = true;
        end
    elseif strcmp(gait_phase,"stance")
        if exist('icrpoint','var')==0 || (angle_knee(i) < 4 && mod(angle_knee(i),2) < 1 && abs(latest_angle-angle_knee(i))>1 )
            addpoint = true;
        elseif (angle_knee(i) <= 12 && mod(angle_knee(i),6) < 1 && abs(latest_angle-angle_knee(i))>1 )
            addpoint = true;
        elseif (angle_knee(i) >= 12 && mod(angle_knee(i),15) < 1 && abs(latest_angle-angle_knee(i))>1 )
            addpoint = true;
        end
    else
        error("Unknown gait phase");
    end
    if addpoint
       icrpoint = plot(icraxes,ICR_y(i),ICR_z(i),'o');
       latest_angle = angle_knee(i);
       text(icraxes,ICR_y(i)-10,ICR_z(i)+10,strcat(num2str(round(angle_knee(i))),'$^o $'),'Color','r');
       addpoint = false;
    end
    set(kneeline,'XData',t(1:i) , 'YData',angle_knee(1:i));
   drawnow
   pause(0.01);
%     input('Press key to continue');
end
    