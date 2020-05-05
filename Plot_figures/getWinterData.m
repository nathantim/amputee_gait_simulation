function [time,hipAngle_avg,hipAngle_sd, kneeAngle_avg,kneeAngle_sd, ankleAngle_avg,ankleAngle_sd, vertGRF_avg,vertGRF_sd, horGRF_avg,horGRF_sd] = getWinterData(speed,angleUnit)
% close all;
% clear all
% Note that angles and moments do not have concisten signs in Winter's excel(so Jpower=dAng/dt*-Mom)

Jang = xlsread('winterdata.xlsx','JAt snf')*(pi/180);
time = xlsread('winterdata.xlsx','JAt snf','A4:A54'); % Note time is not in second but in % of gait cycle
Fgt = xlsread('winterdata.xlsx','Ft snf');
% taking the negative of the winters moments make things concistent such
% that powers are correctly calculated, and Bogert results can be
% replicated, and angle versus moments plots make sense
Jmom = -xlsread('winterdata.xlsx','JTt snf'); 
Jpow = xlsread('winterdata.xlsx','JPt snf');

gaittypes = {'slow gait', 'normal gait', 'fast gait'};
%%
% vertical column: 1 = norm cycle time,hip [2 9 16], knee [4 11 18], ankl
% [5 12 19] for slow (1), normal(2), fast(3)
switch char(speed)
    case 'slow'
        select_gait = 1;
    case 'normal'
        select_gait = 2;
    case 'fast'
        select_gait = 3;
    otherwise
        select_gait = 2;
end

    
% select_gait = [2];

hip_entry_avg       =[2 9 16];
hip_entry_sd        = hip_entry_avg+1;
knee_entry_avg      = hip_entry_avg+2;
knee_entry_sd       = knee_entry_avg + 1;
ankle_entry_avg     = hip_entry_avg+4;
ankle_entry_sd      = ankle_entry_avg + 1;
vertGRF_entry_avg   = [2 9 16];
vertGRF_entry_sd    = vertGRF_entry_avg + 1;
horGRF_entry_avg    = vertGRF_entry_avg + 2;
horGRF_entry_sd      = horGRF_entry_avg + 1;

hip_entry_avg       = hip_entry_avg(select_gait);
hip_entry_sd        = hip_entry_sd(select_gait);
knee_entry_avg      = knee_entry_avg(select_gait);
knee_entry_sd       = knee_entry_sd(select_gait);
ankle_entry_avg     = ankle_entry_avg(select_gait);
ankle_entry_sd      = ankle_entry_sd(select_gait);
vertGRF_entry_avg   = vertGRF_entry_avg(select_gait);
vertGRF_entry_sd 	= vertGRF_entry_sd(select_gait);
horGRF_entry_avg    = horGRF_entry_avg(select_gait);
horGRF_entry_sd     = horGRF_entry_sd(select_gait);

hipAngle_avg        = Jang(:,hip_entry_avg);
hipAngle_sd         = Jang(:,hip_entry_sd);
kneeAngle_avg       = Jang(:,knee_entry_avg);
kneeAngle_sd        = Jang(:,knee_entry_sd);
ankleAngle_avg      = Jang(:,ankle_entry_avg);
ankleAngle_sd       = Jang(:,ankle_entry_sd);
vertGRF_avg         = Fgt(1:max(size(hipAngle_avg)),vertGRF_entry_avg);
vertGRF_sd          = Fgt(1:max(size(hipAngle_avg)),vertGRF_entry_sd);
horGRF_avg          = Fgt(1:max(size(hipAngle_avg)),horGRF_entry_avg);
horGRF_sd          = Fgt(1:max(size(hipAngle_avg)),horGRF_entry_sd);


if exist('angleUnit','var') && strcmp(angleUnit,"deg")
   hipAngle_avg     = 180/pi*hipAngle_avg;
   hipAngle_sd      = 180/pi*hipAngle_sd;
   kneeAngle_avg    = 180/pi*kneeAngle_avg;
   kneeAngle_sd     = 180/pi*kneeAngle_sd; 
   ankleAngle_avg   = 180/pi*ankleAngle_avg;
   ankleAngle_sd    = 180/pi*ankleAngle_sd;
   
end

% figure(1);

% % angles
% subplot(331)
% plot(time,Jang(:,hip_entry));
% title('Hip');
% ylabel('Angle [rad]');set(gca,'Fontsize',20)
% subplot(332)
% plot(time,Jang(:,knee_entry));set(gca,'Fontsize',20)
% title('Knee');
% subplot(333)
% plot(time,Jang(:,ankle_entry));set(gca,'Fontsize',20)
% title('Ankle');


%%
% height = 1.80;
% L_thigh = (0.530-0.285)*height;
% L_shank = (0.285)*height;
% L_ankle = 0.039*height;
% L_foot = 0.152*height;
% 
% % location of foot w.r.t. hip
% x_knee = sin(hipA)*L_thigh;
% x_ankle = x_knee - sin(kneeA)*L_shank;
% x_toe = x_ankle - sin(ankleA - pi/2)*L_foot;
% 
% y_knee = -cos(hipA)*L_thigh;
% y_ankle = y_knee - cos(kneeA)*L_shank;
% y_toe = y_ankle - cos(ankleA - pi/2)*L_foot;

%%
% figure();
% for i = 1:max(size(Jang(:,hip_entry)))
%     
%     plot([0 x_knee(i) x_ankle(i) x_toe(i)], [0 y_knee(i) y_ankle(i) y_toe(i)]);
%     title(['%_s_t_r_i_d_e = ',num2str(time(i)), '%'])
%     axis([-1.0 1.0 -1.0 0.1]);
%     drawnow
%     pause(0.2)
% end
% %% joint angles swing phase
% figure();
% ValueArray = {'-','--'}';
% for k = 1:size(hipA,2)
%     swingphase_i = find(vertGRF(:,k)==0,1,'first');
%     swingphase_t = linspace(0,100,max(size(hipA)) - swingphase_i+1);
%     
%     ax1 = subplot(311); hold(ax1,'on');
%     plot(ax1,swingphase_t,hipA(swingphase_i:end,k),ValueArray{k});
%     title('Hip');
%     ylabel('Angle [rad]');set(gca,'Fontsize',20)
%     
%     ax2 = subplot(312); hold(ax2,'on');
%     plot(ax2,swingphase_t,kneeA(swingphase_i:end,k),ValueArray{k});set(gca,'Fontsize',20)
%     ylabel('Angle [rad]');set(gca,'Fontsize',20)
%     title('Knee');
%     
%     ax3 = subplot(313); hold(ax3,'on');
%     plot(ax3,swingphase_t,ankleA(swingphase_i:end,k),ValueArray{k});set(gca,'Fontsize',20)
%     ylabel('Angle [rad]');set(gca,'Fontsize',20)
%     title('Ankle');
%     
%     xlabel('%_s_w_i_n_g_p_h_a_s_e');
% 
% end
% NameArray = 'LineStyle';
% title(ax1,'Joint angles during swing phase');
% legend(gaittypes{select_gait});

% %% foot swingphase
% figure();
% for k = 1:size(hipA,2)
% swingphase_i = find(vertGRF(:,k)==0,1,'first');
% swingphase_t = linspace(0,100,max(size(hipA)) - swingphase_i+1);
% plot([0,swingphase_t(2:end)],[0;diff(x_toe(swingphase_i:end,k))/(diff(swingphase_t(1:2))/100*(1.3))],ValueArray{k});
% hold on;
% end
% xlabel('%_s_w_i_n_g_p_h_a_s_e')
% ylabel('m/s');
% title('Foot velocity relative to hip during swing phase');
% legend(gaittypes{select_gait});