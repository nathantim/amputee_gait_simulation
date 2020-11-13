%% obstacle
obstacle_height = 0.08;
obstacle_width = 0.15;
obstacle_depth = 0.05;
obstacle_x = 9.080;
obstacle_y = -1.6; %fall for Prosthetic_2D 1.2 m/s
obstacle_damping = 8E1;
obstacle_stiffness = 5E1;

%% CMG
CMGr = 0.04; % radius in m
CMGt = 0.005; % thickness in m

CMGmass = 1; % kg

GMantposOffset = 0;%0.015; % m
CMGdist2ShankCG = 0.05; %m
maxGMangle = 1000000;%60 *pi/180; % rad
maxTflywheelmotor = 1.83E-3; % Nm
maxGMTorque = 15; % Nm
angleOffset = -70 *pi/180; % rad
maxGammadot = 20; % rad/s

tripDetectThreshold = 2000; % m/s^2


% Modeled Cylinder shell with only rim + solid cylinder, both half the mass
CMGInertia_x = 1/12*CMGmass*(3*CMGr^2+CMGt^2) + CMGmass/8*CMGr^2; % kgm^2
CMGInertia_y = 1/12*CMGmass*(3*CMGr^2+CMGt^2) + CMGmass/8*CMGr^2; % kgm^2
CMGInertia_z = 3/4*CMGmass*(CMGr)^2; % kgm^2
CMGInertia = [CMGInertia_x CMGInertia_y CMGInertia_z]; % kgm^2

deltaLegAngleThr = 8*pi/180; %[rad]
legAngleSpeedMax = 10; %[rad/s]
TargetLegAngleTripFlex = 2/3*pi; % rad
KpGamma = 20; % Nm/(rad/s)
KiGamma = 1; % Nm/rad


KpGammaReset = 150; % Nm/(rad)
KdGammaReset = 40; % Nm/(rad/s)

RkneeFlexSpeedGain      = 6;
RkneeFlexPosGain        = 6;
RkneeStopGain           = 12000;
RkneeExtendGain         = 25000;
RlegAngleFilter = 100; %[1/s]
RlegLengthClrTrip = 1.1;


omegaRef = 2100; % rad/s


zeroOrderHoldTs = 1/1000; % s
lowpassbandFreq = 80; % Hz
highpassbandFreq = 10;%3; % Hz
