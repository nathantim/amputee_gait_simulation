% load('Results/Rough/Umb10_1.5cm_1.2ms_kneelim1_mstoptorque2.mat');
% 
% evalc('assignGainsSagittal');
% % evalc('initSignals');
% evalc('setInitAmputee');
% evalc('assignInit');
% 
% 
% dt_visual = 1/30;
% % [groundX, groundZ, groundTheta] = generateGround('const', 0.015,1,true);
% [groundX, groundZ, groundTheta] = generateGround('flat');
% % [groundX, groundZ, groundTheta] = generateGround('const', .05,1);
% %[groundX, groundZ, groundTheta] = generateGround('ramp');
