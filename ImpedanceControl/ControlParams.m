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
kneeAngleOffset = 10*pi/180;

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
legAngleSpeedMax = 10; %[rad/s]
legLengthClr = .9; %[m]

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

% ---------------------------------
% 2.3 Vanderbilt Prosthetic Control
% ---------------------------------
phiKneeStance1   = 8*pi/180; %[rad]
k1KneeStance1    = 3.7*180/pi; %[Nm/rad] 

phiKneeStance2   = 16*pi/180; %[rad]
k1KneeStance2    = 2.53*180/pi; %[Nm/rad] 
k2KneeStance2    = 7e-4*(180/pi)^3; %[Nm/rad^3]

phiKneeSwing1    = 16.5*pi/180; %[rad] 20
k1KneeSwing1     = 0.05*180/pi; %[Nm/rad]
bKneeSwing1      = 0.005*180/pi; %[Nms/rad] 

phiKneeSwing2    = 10*pi/180; %[rad] 
k1KneeSwing2     = 2.3*180/pi; %[Nm/rad] 
bKneeSwing2      = 0.012*180/pi; %[Nms/rad]

ankleAngleThr    = 2*pi/180; %[rad]

phiAnkleStance1  = 5*pi/180; %[rad] 
phiAnkleStance12 = 2*pi/180; %[rad]
k1AnkleStance1   = 5*180/pi; %[Nm/rad] 
k2AnkleStance1   = .5*(180/pi)^3; %[Nm/rad^3] 

phiAnkleStance2  = 10*pi/180; %[rad]
k1AnkleStance2   = 5*180/pi; %[Nm/rad]

k1AnkleSwing1    = .5*180/pi; %[Nm/rad] 
k1AnkleSwing2    = 0.75*180/pi; %[Nm/rad]

% -------------------------------------
% 2.4 Vanderbilt Prosthetic Control New
% -------------------------------------
%{
kneeFilterVander = 100;
ankleFilterVander = 100;

phiKneeStanceEarly  = 8*pi/180; %[rad]
kKneeStanceEarly    = 2.5*180/pi; %[Nm/rad]
bKneeStanceEarly    = 0.05;%*180/pi; %[Nm/rad] 

phiKneeStanceMid    = 6*pi/180; %[rad] 
kKneeStanceMid      = 4*180/pi; %[Nm/rad] 
bKneeStanceMid      = 0.06;%*180/pi; %[Nm/rad^3]

phiKneeStanceLate   = 14*pi/180; %[rad] 
kKneeStanceLate     = 3.0*180/pi; %[Nm/rad] 
bKneeStanceLate     = 0.02;%*180/pi; %[Nm/rad^3]

phiKneeSwing1       = 65*pi/180; %[rad] 20
kKneeSwing1         = 0.15*180/pi; %[Nm/rad]
bKneeSwing1         = 0.02;%*180/pi; %[Nm/rad]

phiKneeSwing2       = 40*pi/180; %[rad] 8
kKneeSwing2         =  0.10*180/pi; %[Nm/rad] 
bKneeSwing2         = 0.03;%*180/pi; %[Nm/rad]

phiAnkleStanceEarly = 1*pi/180; %[rad]
kAnkleStanceEarly   = 3*180/pi; %[Nm/rad] 
bAnkleStanceEarly   = .04;%*180/pi; %[Nm/rad] 

%phiAnkleStanceMid   = 2*pi/180; %[rad]
kAnkleStanceMid     = 5*180/pi; %[Nm/rad]
bAnkleStanceMid     = 0.04;%*180/pi; %[Nm/rad]

phiAnkleStanceLate  = 16*pi/180; %[rad]
kAnkleStanceLate    = 4.0*180/pi; %[Nm/rad]
bAnkleStanceLate    = 0.01;%*180/pi; %[Nm/rad]

kAnkleSwing1        = 0.4*180/pi; %[Nm/rad] 
bAnkleSwing1        = 0.05;%*180/pi; %[Nm/rad]

kAnkleSwing2        = 0.7*180/pi; %[Nm/rad] 
bAnkleSwing2        = 0.03;%*180/pi; %[Nm/rad]

ankleAngleThr       = 2*pi/180; %[rad]
loadThr = 40;
%}

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
% for standing
%{
RphiAnkle0  =  -5*pi/180; %[rad]
RphiKnee0  = 5*pi/180; %[rad]
RphiHip0  = -5*pi/180; %[rad]
%}

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
