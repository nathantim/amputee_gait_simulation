function [ICR_y,ICR_z,ICRo_y,ICRo_z,knee_angle_o] = getICR_otto(knee_angle,gait_phase)

%% 'measured data'
% https://media.ottobock.com/_web-site/prosthetics/lower-limb/3r60/files/3r60-pro_information_for_practitioners.pdf
knee_angle_swing_o = [0;5;10;20;30;50;80;100;120;140];
ICRoswing_y = 1*([363 209 149 159 192 249 300 337 333 320]' - 213)./3.36;  % mm
ICRoswing_z = -1*([25 281 457 572 680 748 752 701 664 631] - 701)./3.36;   % mm

knee_angle_stance_o = [0;2;6;12;15];
ICRostance_y = 1*([205 241 327 474 514]' - 89)./1.48;  % mm
ICRostance_z = -1*([393 336 206 62 70] - 824)./1.48;   % mm

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

