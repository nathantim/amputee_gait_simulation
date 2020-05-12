function [ICR_y,ICR_z,ICRo_y,ICRo_z,knee_angle_o] = getICR_otto(knee_angle,gait_phase,b_in_px)
if nargin < 3
    b_in_px = 0;
end
%% 'measured data'
% https://media.ottobock.com/_web-site/prosthetics/lower-limb/3r60/files/3r60-pro_information_for_practitioners.pdf
knee_angle_swing_o = [0;5;10;20;30;50;80;100;120;140];
% ICRoswing_y = 1*([363 209 149 159 192 249 300 337 333 320]' - 213)./3.36;  % mm
% ICRoswing_z = -1*([25 281 457 572 680 748 752 701 664 631] - 701)./3.36;   % mm

y_swing_px = [363 209 149 159 192 249 300 337 333 320]';
z_swing_px = [25 281 457 572 680 748 752 701 664 631]';

knee_angle_stance_o = [0;2;6;12;15];
y_stance_px = [205 241 327 474 514]';
z_stance_px = [393 336 206 62 70]';
if ~b_in_px
    [ICRostance_y,ICRostance_z] = px2mmICR(y_stance_px,z_stance_px,"stance");
    [ICRoswing_y,ICRoswing_z] = px2mmICR(y_swing_px,z_swing_px , "swing");
else
    ICRoswing_y = y_swing_px;
    ICRoswing_z = z_swing_px;
    ICRostance_y = y_stance_px;
    ICRostance_z = z_stance_px;
end
%%
if strcmp(gait_phase,"swing")
    ICR_y = interp1(knee_angle_swing_o,ICRoswing_y,knee_angle,'pchip');
    ICR_z = interp1(knee_angle_swing_o,ICRoswing_z,knee_angle,'pchip');
    ICRo_y = ICRoswing_y;
    ICRo_z = ICRoswing_z;
    knee_angle_o = knee_angle_swing_o;
elseif strcmp(gait_phase,"stance")
    ICR_y = interp1(knee_angle_stance_o,ICRostance_y,knee_angle,'pchip');
    ICR_z = interp1(knee_angle_stance_o,ICRostance_z,knee_angle,'pchip');
    ICRo_y = ICRostance_y;
    ICRo_z = ICRostance_z;
    knee_angle_o = knee_angle_stance_o;
else
    error("Unknown gait phase");
end

