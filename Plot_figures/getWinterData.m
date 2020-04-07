function [time,hipAngle, kneeAngle, ankleAngle, vertGRF, horGRF] = getWinterData(speed)
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

hip_entry=[2 9 16];
knee_entry=hip_entry+2;
ankle_entry=hip_entry+4;
vertGRF_entry = [2 9 16];
horGRF_entry = vertGRF_entry + 2;

hip_entry = hip_entry(select_gait);
knee_entry = knee_entry(select_gait);
ankle_entry = ankle_entry(select_gait);
vertGRF_entry = vertGRF_entry(select_gait);
horGRF_entry = horGRF_entry(select_gait);

hipAngle = Jang(:,hip_entry);
kneeAngle = Jang(:,knee_entry);
ankleAngle = Jang(:,ankle_entry);
vertGRF = Fgt(1:max(size(hipAngle)),vertGRF_entry);
horGRF = Fgt(1:max(size(hipAngle)),horGRF_entry);


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