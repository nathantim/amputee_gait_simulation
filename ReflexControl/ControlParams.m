% 
% ControlParams.m  -  Set neural control parameters of the model
%                             as well as initial conditions and simulink 
%                             control parameters.
%
% H.Geyer
% 5 October 2006
%


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

% hamstring group (self, F+, stance)
LGainHAM   = 0.30/FmaxHAM; %[1/N]
RGainHAM   = 0.30/FmaxHAM; %[1/N]
PreStimHAM = 0.01; %[]

% amputated hamstring group (self, F+, stance)
RGainHAMCut   = LGainHAM;
PreStimHAMCut = 0.01; %[]

% gluteus group (self, F+, stance)
LGainGLU   = 0.5/FmaxGLU; %[1/N]
RGainGLU   = 0.5/FmaxGLU; %[1/N]
PreStimGLU = 0.01; %[]

% soleus (self, F+)
LGainSOL   = 1.2/FmaxSOL; %[1/N]
RGainSOL   = 1.2/FmaxSOL; %[1/N]
PreStimSOL = 0.01; %[]

% soleus on tibialis anterior (F-)
LGainSOLTA = 0.4/FmaxSOL; %[1/N]
RGainSOLTA = 0.4/FmaxSOL; %[1/N]
PreStimTA  = 0.01; %[]

% tibialis (self, L+, stance & swing)
LGainTA     = 1.1;   %[]
RGainTA     = 1.1;   %[]
LceOffsetTA = 1-0.5*w; %[loptTA]

% gastrocnemius (self, F+)
LGainGAS   = 1.1/FmaxGAS; %[1/N] 
RGainGAS   = 1.1/FmaxGAS; %[1/N] 
PreStimGAS = 0.01; %[]

% vasti group (self, F+)
LGainVAS   = 1.5/FmaxVAS; %[1/N]
RGainVAS   = 1.5/FmaxVAS; %[1/N]
PreStimVAS = 0.08; %[]

% knee overextension on vasti (Phi-, directional)
LGainKneeOverExt = 2;%
RGainKneeOverExt = 2;%
kneeAngleOffset  = 10*pi/180;

% -----------------------------------------------
% 2.1 Stance-Leg HAT Reference Posture PD-Control
% -----------------------------------------------

% stance hip joint position gain
LPosGainGG   = 1/(30*pi/180); %[1/rad]
RPosGainGG   = 1/(30*pi/180); %[1/rad]

% stance hip joint speed gain
LSpeedGainGG = 0.2; %[s/rad] 
RSpeedGainGG = 0.2; %[s/rad] 

% stance posture control muscles pre-stimulation
PreStimGG   = 0.05; %[]

% stance reference posture
phiHATref      = 6*pi/180; %[rad]

% gluteus stance gain
LKglu = 0.7;
RKglu = 0.7;

% ------------------------------
% 2.2 Swing-leg Feedback Control 
% ------------------------------
deltaLegAngleThr = 8*pi/180; %[rad]
LlegLengthClr = .9; %[m]
RlegLengthClr = .9; %[m]
legAngleSpeedMax = 10; %[rad/s]

LhipPGain = 110; %[Nm/rad]
RhipPGain = 110; %[Nm/rad]

LhipDGain = 8.5; %[Nms/rad]
RhipDGain = 8.5; %[Nms/rad]

LlegAngleFilter = 100; %[1/s]
RlegAngleFilter = 100; %[1/s]

LkneeFlexGain = 13; %[Nms/rad]
RkneeFlexGain = 13; %[Nms/rad]

LkneeHoldGain1 = 5.5; %[Nms/rad]
LkneeHoldGain2 = 5.5; %[Nms/rad]
RkneeHoldGain1 = 5.5; %[Nms/rad]
RkneeHoldGain2 = 5.5; %[Nms/rad]

LkneeStopGain = 250; %[Nm/rad]
RkneeStopGain = 250; %[Nm/rad]

LkneeExtendGain = 200; %[Nm/rad]
RkneeExtendGain = 200; %[Nm/rad]

simbiconLegAngle0 = 85*pi/180;
simbiconGainD = 5*pi/180; %[rad/m]
simbiconGainV = 5*pi/180; %[rad s/m]

legAngleTgt = 1.2; 

% ******************************************** %
% 3. Initial Conditions and Simulation Control %
% ******************************************** %

% ----------------------
% 3.1 Initial Conditions
% ----------------------

% initial locomotion speed
vx0 = 1.3; %[m/s] 
%vx0 = 0; %[m/s] 

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
