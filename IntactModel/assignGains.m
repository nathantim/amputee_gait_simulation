BodyMechParams;
ControlParams;
OptimParams;

% load('Results/Flat/GeyerHerrInit.mat');
% load('Results/Flat/optandGeyerHerrInit.mat');
load('Results/Flat/SCONE.mat');
% load('Results/Flat/v_0.5m_s.mat');
% load('Results/Flat/v_0.8m_s.mat');
% load('Results/Flat/v_1.1m_s.mat');
% load('Results/Flat/v_1.4m_s.mat');

GainGAS           = Gains( 1);
GainGLU           = Gains( 2);
GainHAM           = Gains( 3);
GainKneeOverExt   = Gains( 4); % k_phi
GainSOL           = Gains( 5);
GainSOLTA         = Gains( 6);
GainTA            = Gains( 7);
GainVAS           = Gains( 8);
Kglu              = Gains( 9);
PosGainGG         = Gains(10);
SpeedGainGG       = Gains(11);
GainHAMHFL        = Gains(12);
GainHFL           = Gains(13);
Klean             = Gains(14);


[groundX, groundZ, groundTheta] = generateGround('flat');
% [groundX, groundZ, groundTheta] = generateGround('const', .05,1);
%[groundX, groundZ, groundTheta] = generateGround('ramp');
