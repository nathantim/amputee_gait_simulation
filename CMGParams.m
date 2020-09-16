CMGr = 0.04; % radius in m
CMGt = 0.005; % thickness in m

CMGmass = 1; % kg

GMantposOffset = 0;%0.015; % m
maxGMangle = 1000000;%60 *pi/180; % rad
maxTflywheelmotor = 1.83E-3; % Nm
maxGMTorque = 15; % Nm
angleOffset = -90 *pi/180; % rad
maxGammadot = 500; % rad/s

% tripDetectThreshold = -100; % m/s^2   0.9 m/s
% tripDetectThreshold = -60; % m/s^2   1.2 m/s

% tripDetectThreshold = -35; % m/s^2 2D
tripDetectThreshold = -2000; % m/s^2

% Modeled Cylinder shell with only rim + solid cylinder, both half the mass
CMGInertia_x = 1/12*CMGmass*(3*CMGr^2+CMGt^2) + CMGmass/8*CMGr^2; % kgm^2
CMGInertia_y = 1/12*CMGmass*(3*CMGr^2+CMGt^2) + CMGmass/8*CMGr^2; % kgm^2
CMGInertia_z = 3/4*CMGmass*(CMGr)^2; % kgm^2
CMGInertia = [CMGInertia_x CMGInertia_y CMGInertia_z]; % kgm^2

deltaLegAngleThr = 8*pi/180; %[rad]
legAngleSpeedMax = 10; %[rad/s]
TargetLegAngleTripFlex = 2/3*pi; % rad
KpGamma = 10; % Nm/(rad/s)
KiGamma = 1; % Nm/rad

% KpGammaReset = 10; % Nm/(rad)
% KdGammaReset = 2; % Nm/(rad/s)
KpGammaReset = 30000; % Nm/(rad)
KdGammaReset = 6000; % Nm/(rad/s)

RkneeFlexSpeedGain      = 6;
RkneeFlexPosGain        = 6;
RkneeStopGain           = 12000;
RkneeExtendGain         = 25000;
RlegAngleFilter = 100; %[1/s]



omegaRef = 2100; % rad/s


zeroOrderHoldTs = 1/1000; % s
lowpassbandFreq = 80; % Hz
highpassbandFreq = 10;%3; % Hz
% CMGmass = 0.0000001;

% idx1 = (find(time==5):(find(GRFData.signals.values(:,1)>470,1,'first')))-13;
% idx2 = (find(GRFData.signals.values(:,1)>470,1,'first'):(find(GRFData.signals.values(:,1)>470,1,'first')+100))-13;
% figure(); plot(angularData.signals.values(idx1,7),angularData.signals.values(idx1,8)); hold on; plot(angularData.signals.values(idx2,7),angularData.signals.values(idx2,8)); plot(angularData.signals.values(idx1(end),7),angularData.signals.values(idx1(end),8),'g*');
