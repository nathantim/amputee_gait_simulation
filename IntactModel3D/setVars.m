initial_gains_filename = 'Results/Flat/Umb10_SONG3D_kneelim1_2.mat';
load(initial_gains_filename);
load('Results/Flat/SongGains_02_wC_IC.mat');
evalc('BodyMechParams');
evalc('ControlParams');
evalc('OptimParams');
% evalc('Prosthesis3R60Params');
evalc('assignGains');
evalc('setInit');

dt_visual = 1/30;
% [groundX, groundZ, groundTheta] = generateGround('const', 0.015,1,true);
[groundX, groundZ, groundTheta] = generateGround('flat');
% [groundX, groundZ, groundTheta] = generateGround('const', .05,1);
%[groundX, groundZ, groundTheta] = generateGround('ramp');
