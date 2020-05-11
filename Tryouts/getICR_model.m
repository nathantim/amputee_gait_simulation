function [angle_knee,ICR_y,ICR_z] = getICR_model(model,gait_phase)
sim(model);
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
idx_length = find(angle_knee>140,1,'first')+1;
if isempty(idx_length)
    idx_length = length(angle_knee);
end
t = ICR.Time(1:idx_length);

origin_swing_y = y_14_2;
origin_swing_z = z_14_2;
origin_stance_y = y_14_1;
origin_stance_z = z_14_1;

if strcmp(gait_phase,"swing")
    origin_y = origin_swing_y;
    origin_z = origin_swing_z;
elseif strcmp(gait_phase,"stance")
    origin_y = origin_stance_y;
    origin_z = origin_stance_z;
else
    error("Unknown gait phase");
end

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



