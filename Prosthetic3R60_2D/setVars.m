initial_gains_filename = 'Results/Rough/Umb10_1.5cm_1.2ms_kneelim1_mstoptorque2.mat';
load(initial_gains_filename);
load('Results/Flat/SongGains_02_wC_IC.mat');
BodyMechParams;
ControlParams;
OptimParams;
Prosthesis3R60Params;
assignGains
setInit;

dt_visual = 1/30;
% [groundX, groundZ, groundTheta] = generateGround('const', 0.015,1,true);
[groundX, groundZ, groundTheta] = generateGround('flat');
% [groundX, groundZ, groundTheta] = generateGround('const', .05,1);
%[groundX, groundZ, groundTheta] = generateGround('ramp');