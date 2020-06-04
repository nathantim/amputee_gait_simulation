function [angle_knee,t,ICR_y,ICR_z,y_14_1,z_14_1,y_14_2,z_14_2,y_25_1,z_25_1,y_25_2,z_25_2] = getICR_model(knee_angle,gait_phase,time,ICR,pos14_1,pos14_2,pos25_1,pos25_2)
idx_length = [];

ICR_y = ICR(:,1)*1000; % mm
ICR_z = ICR(:,2)*1000; % mm

y_14_1 = pos14_1(:,1)*1000;
z_14_1 = pos14_1(:,3)*1000;
y_14_2 = pos14_2(:,1)*1000;
z_14_2 = pos14_2(:,3)*1000;
if ~isempty(pos25_1) && ~isempty(pos25_2)
    y_25_1 = pos25_1(:,1)*1000;
    z_25_1 = pos25_1(:,3)*1000;
    y_25_2 = pos25_2(:,1)*1000;
    z_25_2 = pos25_2(:,3)*1000;
else
    y_25_1 = [];
    z_25_1 = [];
    y_25_2 = [];
    z_25_2 = [];
end
% angle_knee = knee_angle; % deg

origin_swing_y = y_14_2;
origin_swing_z = z_14_2;
origin_stance_y = y_14_1;
origin_stance_z = z_14_1;

if strcmp(gait_phase,"swing")
    idx_length = find(knee_angle>=min(140,max(knee_angle)),1,'first')+1;
    origin_y = origin_swing_y;
    origin_z = origin_swing_z;
elseif strcmp(gait_phase,"stance")
    idx_length = find(knee_angle>=max(knee_angle),1,'first')+1;
    origin_y = origin_stance_y;
    origin_z = origin_stance_z;
else
    error("Unknown gait phase");
end

if isempty(idx_length) || idx_length > length(knee_angle)
    idx_length = length(knee_angle);
end
angle_knee = knee_angle(1:idx_length);
if ~isempty(time)
    t = time(1:idx_length);
else 
    t = [];
end

ICR_y = (ICR_y(1:idx_length) - origin_y(1:idx_length));
ICR_z = ICR_z(1:idx_length) - origin_z(1:idx_length);
y_14_1 = (y_14_1(1:idx_length) - origin_y(1:idx_length));
z_14_1 = z_14_1(1:idx_length) - origin_z(1:idx_length);
y_14_2 = (y_14_2(1:idx_length) - origin_y(1:idx_length));
z_14_2 = z_14_2(1:idx_length) - origin_z(1:idx_length);
if ~isempty(pos25_1) && ~isempty(pos25_2)
    y_25_1 = (y_25_1(1:idx_length) - origin_y(1:idx_length));
    z_25_1 = z_25_1(1:idx_length) - origin_z(1:idx_length);
    y_25_2 = (y_25_2(1:idx_length) - origin_y(1:idx_length));
    z_25_2 =z_25_2(1:idx_length) - origin_z(1:idx_length);
end


