% 
% ControlParams.m  -  Set neural control parameters of the model
%                             as well as initial conditions and simulink 
%                             control parameters.
%
% H.Geyer
% 5 October 2006
%
termination_height = 0.5;


% ************************************ %
% 1. General Neural Control Parameters %
% ************************************ %

% feedback delays
LongDelay  = 0.020; % ankle joint muscles [s]
MidDelay   = 0.010; % knee joint muscles [s]
ShortDelay = 0.005; % hip joint muscles [s]

% ****************************** %
% 2. Specific Control Parameters %
% ****************************** %

% -------------------------------
% 2.1 Stance-Leg Feedback Control 
% -------------------------------

% hip flexors group (self, L+)
GainHFL    = 0.35/FmaxHFL; %[1/N]
PreStimHFL = 0.05; %[]
PreStimHFLswing = 0.05; %[]
LceOffsetHFL = 0.6; %[loptTA]

% hip flexors group on hamstring (self, L+)
GainHAMHFL    = 4/FmaxHFL; %[1/N]

% hamstring group (self, F+)
GainHAM    = 0.30/FmaxHAM; %[1/N]
GainHAMswing = GainHAM;
PreStimHAM = 0.01; %[]
PreStimHAMswing = 0.01; %[]
LceOffsetHAM = 0.85; %[loptTA]


% gluteus group (self, F+)
GainGLU    = 0.5/FmaxGLU; %[1/N]
GainGLUswing = GainGLU;
PreStimGLU = 0.01; %[]
PreStimGLUswing = 0.01; %[]

% soleus (self, F+)
GainSOL    = 1.2/FmaxSOL; %[1/N]
PreStimSOL = 0.01; %[]
PreStimSOLswing = 0.01; %[]


% soleus on tibialis anterior (F-)
GainSOLTA = 0.4/FmaxSOL; %[1/N]
PreStimTA = 0.01; %[]
PreStimTAswing = 0.01; %[]

% tibialis (self, L+, stance and swing)
GainTA      = 1.1; %[]
LceOffsetTA = 1-0.5*w; %[loptTA]
GainTAswing      = 1.1; %[]

% gastrocnemius (self, F+)
GainGAS     = 1.1/FmaxGAS; %[1/N] 
PreStimGAS  = 0.01;  %[]
PreStimGASswing  = 0.01;  %[]

% vasti group (self, F+)
GainVAS    = 1.5/FmaxVAS; %[1/N]
PreStimVAS = 0.08; %[]
PreStimVASswing = 0.08; %[]

% knee overextension on vasti (Phi-, directional)
GainKneeOverExt = 2;%
kneeAngleOffset = 10*pi/180;

% -----------------------------------------------
% 2.1 Stance-Leg HAT Reference Posture PD-Control
% -----------------------------------------------

% stance hip joint position gain
PosGainGG   = 1/(30*pi/180); %[1/rad]

% stance hip joint speed gain
SpeedGainGG = 0.2; %[s/rad] 

% stance posture control muscles pre-stimulation
PreStimGG   = 0.05; %[]

% stance reference posture
phiHATref      = 6*pi/180; %[rad]

% gluteus stance gain
Kglu = 0.7;
Khfl = 1;
Kham = 1;

% HFL lean gain
Klean = 1.15;

% Body weight gain
Kbw = 1.2;

DeltaS = 0.25;
DeltaSGLU = DeltaS;
DeltaSHFL = DeltaS;
% ------------------------------
% 2.2 Swing-leg Feedback Control 
% ------------------------------
deltaLegAngleThr = 8*pi/180; %[rad]
legLengthClr = .9; %[m]
legAngleSpeedMax = 10; %[rad/s]

hipPGain = 110; %[Nm/rad]
hipDGain = 8.5; %[Nms/rad]
legAngleFilter = 100; %[1/s]
kneeFlexGain   = 13; %[Nms/rad]
kneeHoldGain1  = 5.5; %[Nms/rad]
kneeHoldGain   = 5.5; %[Nms/rad]
kneeHoldGain2  = 5.5; %[Nms/rad]
kneeStopGain   = 250; %[Nm/rad]
kneeExtendGain = 200; %[Nm/rad]

simbiconLegAngle0 = 85*pi/180;
simbiconGainD = 5*pi/180; %[rad/m]
simbiconGainV = 5*pi/180; %[rad s/m]

% ******************************************** %
% 3. Initial Conditions and Simulation Control %
% ******************************************** %

% ----------------------
% 3.1 Initial Conditions
% ----------------------

% initial locomotion speed
vx0 = 1.3; %[m/s] 

% left (stance) leg ankle, knee and hip joint angles
LphiAnkle0  =  -5*pi/180; %[rad]
LphiKnee0  = 5*pi/180; %[rad]
LphiHip0  = -5*pi/180; %[rad]

% right (swing) leg ankle, knee and hip joint angles
% for walking
RphiAnkle0  =  0*pi/180; %[rad]
RphiKnee0  = 5*pi/180; %[rad]
RphiHip0  = -30*pi/180; %[rad]

% ----------------------
% 3.2 Simulation Control
% ----------------------
% ----------

% integrator max time step
ts_max = 1e-1;
