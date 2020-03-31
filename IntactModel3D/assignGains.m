BodyMechParams;
ControlParams;

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

PosGainGGHAB    = Gains(24);
PosGainGGHAD    = Gains(25);
SpeedGainGGHAB  = Gains(26);
SpeedGainGGHAD  = Gains(27);
GainCHAB  = Gains(28);
GainCHAD  = Gains(29);

hipPGainAbd = Gains(30);
hipDGainAbd = Gains(31);
simbiconLegAngle0Abd = Gains(32);
simbiconGainDAbd = Gains(33);
simbiconGainVAbd = Gains(34);

[groundX, groundZ, groundTheta] = generateGround('flat');
% [groundX, groundZ, groundTheta] = generateGround('const', .05,1);
%[groundX, groundZ, groundTheta] = generateGround('ramp');
