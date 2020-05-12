function [y_px, z_px] = mm2pxICR(y_mm, z_mm, gait_phase)

% knee_angle_swing_o = [0;5;10;20;30;50;80;100;120;140];
% ICRoswing_y = 1*([363 209 149 159 192 249 300 337 333 320]' - 213)./3.36;  % mm
% ICRoswing_z = -1*([25 281 457 572 680 748 752 701 664 631] - 701)./3.36;   % mm
% 
% knee_angle_stance_o = [0;2;6;12;15];
% ICRostance_y = 1*([205 241 327 474 514]' - 89)./1.48;  % mm
% ICRostance_z = -1*([393 336 206 62 70] - 824)./1.48;   % mm

if (strcmp(gait_phase,"swing"))
    origin_y = 213; 
    origin_z = 701;
    px_factor = 3.36;
elseif (strcmp(gait_phase,"stance"))
    origin_y = 89; 
    origin_z = 824;
    px_factor = 1.48;
else
    error("Unknown gait phase");
end

y_px = y_mm.*px_factor + origin_y;
z_px = -z_mm.*px_factor + origin_z;