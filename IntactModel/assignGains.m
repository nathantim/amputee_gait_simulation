BodyMechParams;
ControlParams;
OptimParams;

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
