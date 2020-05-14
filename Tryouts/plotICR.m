close all;
%%
% gait_phase = input(char('Which phase of the gait are we looking at? (swing/stance)\n        '),'s');

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
phases = ["swing","stance"];
for j = 1:length(phases)
    gait_phase = phases(j);
    
    [angle_knee,t,ICR_y,ICR_z,y_14_1,z_14_1,y_14_2,z_14_2,y_25_1,z_25_1,y_25_2,z_25_2] = getICR_model(knee_angle(:,j),gait_phase,time,ICR(:,j*2-1:j*2),pos14_1(:,j*3-2:j*3),pos14_2(:,j*3-2:j*3),pos25_1(:,j*3-2:j*3),pos25_2(:,j*3-2:j*3));
    
    if strcmp(gait_phase,"swing")
    ICRo_y_interp = ICRoswing_y_interp;
    ICRo_z_interp = ICRoswing_z_interp;
    ICRo_y = ICRoswing_y;
    ICRo_z = ICRoswing_z;
    knee_angle_o = knee_angle_swing_o;
elseif strcmp(gait_phase,"stance")
    ICRo_y_interp = ICRostance_y_interp;
    ICRo_z_interp = ICRostance_z_interp;
    ICRo_y = ICRostance_y;
    ICRo_z = ICRostance_z;
    knee_angle_o = knee_angle_stance_o;
else
    error("Unknown gait phase");
    end

    figure();
    
    icraxes(j) = subplot(1,3,[1 2]);
    icrplot(j) = plot(icraxes(j),ICR_y(1),ICR_z(1),'g*');
    hold on;
    bar14(j) = plot(icraxes(j),[y_14_1(1);y_14_2(1)],[z_14_1(1);z_14_2(1)],'Color',[197 90 17]./255);
    bar25(j) = plot(icraxes(j),[y_25_1(1);y_25_2(1)],[z_25_1(1);z_25_2(1)],'Color',[191 144 0]./255);
    ottoplotswingline= plot(icraxes(j),ICRo_y_interp,ICRo_z_interp,'r');
    plot(icraxes(j),ICRo_y,ICRo_z,'ro');
    text(icraxes(j),ICRo_y+5,ICRo_z+2,strcat(num2str(knee_angle_o),'$^o $'))
    plot(icraxes(j),icraxes(j).XLim,[ 0 0],'Color',[0.8 0.8 0.8])
    plot(icraxes(j),[ 0 0], icraxes(j).YLim,'Color',[0.8 0.8 0.8]);
    axis equal
    set(icraxes(j),'YLimMode','manual');
    
    bar_workline = @(y_1,y_2,z_1,z_2,xlim)(interp1([y_1(1);y_2(1)],[z_1(1);z_2(1)],xlim','linear','extrap'));
    xlimits_workline = icraxes(j).XLim;
    bar14_worklineplot(j) = plot(icraxes(j),xlimits_workline,bar_workline(y_14_1(1),y_14_2(1),z_14_1(1),z_14_2(1),xlimits_workline),'--','Color',[0.3 0.3 0.3],'LineWidth',1);
    bar25_worklineplot(j) = plot(icraxes(j),xlimits_workline,bar_workline(y_25_1(1),y_25_2(1),z_25_1(1),z_25_2(1),xlimits_workline),'--','Color',[0.3 0.3 0.3],'LineWidth',1);
    
    h = get(icraxes(j),'Children');
    set(icraxes(j),'Children',flipud(h));
    set(icraxes(j),'XLimMode','manual');
    
    
    % barandicr = subplot(2,1,2);
    % set(barandicr,'NextPlot','Add');
    % axis(barandicr,2.*[-200 200 -100 100])
    ylabel(icraxes(j),'z in mm');
    xlabel(icraxes(j),'y in mm')
    title(icraxes(j),strcat("Location instantenous center of rotation during ",gait_phase))
    
    % set(icraxes,'NextPlot','Add');
    icrmark(j) = plot(icraxes(j),ICR_y(1),ICR_z(1),'o');
    icrline(j) = plot(icraxes(j),ICR_y(1),ICR_z(1));
    % axis(icraxes,[-50 300, -100 550]);
    % ylabel(icraxes,'z in mm');
    % xlabel(icraxes,'y in mm')
    % set(icraxes,'DataAspectRatio',[1 1 1]);
    
    kneeangleplot(j) = subplot(1,3,3);
    kneeline(j) = plot(kneeangleplot(j),t(1),angle_knee(1));
    axis(kneeangleplot(j),[0 max(t), min(angle_knee) max(angle_knee)]);
    ylabel(kneeangleplot(j),'deg');
    xlabel(kneeangleplot(j),'time in s');
    title(kneeangleplot(j),strcat("knee angle during ", gait_phase));
    
    %%
    % idx_length = length(ICR_y);
    clear icrpoint;
    latest_angle = nan;
    addpoint = false;
    % input('Press a key to continue')
    for i = 2:3:length(angle_knee)
        set(bar14(j),'XData',[y_14_1(i);y_14_2(i)],'YData',[z_14_1(i);z_14_2(i)]);
        set(bar25(j),'XData',[y_25_1(i);y_25_2(i)],'YData',[z_25_1(i);z_25_2(i)]);
        set(icrplot(j),'XData',ICR_y(i),'YData',ICR_z(i));
        set(icrmark(j),'XData',ICR_y(i),'YData',ICR_z(i));
        set(icrline(j),'XData',ICR_y(1:i),'YData',ICR_z(1:i));
        set(bar14_worklineplot(j),'YData',bar_workline(y_14_1(i),y_14_2(i),z_14_1(i),z_14_2(i),xlimits_workline));
        set(bar25_worklineplot(j),'YData',bar_workline(y_25_1(i),y_25_2(i),z_25_1(i),z_25_2(i),xlimits_workline));
        
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
            icrpoint(j) = plot(icraxes(j),ICR_y(i),ICR_z(i),'o');
            latest_angle = angle_knee(i);
            text(icraxes(j),ICR_y(i)-10,ICR_z(i)+10,strcat(num2str(round(angle_knee(i))),'$^o $'),'Color','r');
            addpoint = false;
        end
        set(kneeline(j),'XData',t(1:i) , 'YData',angle_knee(1:i));
        drawnow
        pause(0.01);
        %     input('Press key to continue');
    end
end