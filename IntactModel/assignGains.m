BodyMechParams;
ControlParams;
OptimParams;

% load('Results/Flat/v_0.5m_s.mat');
% load('Results/Flat/v_0.8m_s.mat');
% load('Results/Flat/v_1.1m_s.mat');
% load('Results/Flat/v_1.4m_s.mat');

GainGAS           = Gains( 1);
GainGLU           = Gains( 2);
GainHAM           = Gains( 3);
GainKneeOverExt   = Gains( 4);
GainSOL           = Gains( 5);
GainSOLTA         = Gains( 6);
GainTA            = Gains( 7);
GainVAS           = Gains( 8);
Kglu              = Gains( 9);
PosGainGG         = Gains(10);
SpeedGainGG       = Gains(11);
hipDGain          = Gains(12);
hipPGain          = Gains(13);
kneeExtendGain    = Gains(14);
kneeFlexGain      = Gains(15);
kneeHoldGain1     = Gains(16);
kneeHoldGain2     = Gains(17);
kneeStopGain      = Gains(18);
legAngleFilter    = Gains(19);
legLengthClr      = Gains(20);
simbiconGainD     = Gains(21);
simbiconGainV     = Gains(22);
simbiconLegAngle0 = Gains(23);

[groundX, groundZ, groundTheta] = generateGround('flat');
% [groundX, groundZ, groundTheta] = generateGround('const', .05,1);
%[groundX, groundZ, groundTheta] = generateGround('ramp');
