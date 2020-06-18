% 
% ControlParams.m  -  Set neural control parameters of the model
%                             as well as initial conditions and simulink 
%                             control parameters.
%
% H.Geyer
% 5 October 2006
%
termination_height = 0.5;

%% %
deltaLegAngleThr = 8*pi/180; %[rad]
legLengthClr = 0.8328; %[m]
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

simbiconLegAngle0 = 62.1933*pi/180;
simbiconGainD = 0.0253*pi/180; %[rad/m]
simbiconGainV = 0.0110*pi/180; %[rad s/m]
%% %

% ************************************ %
% 1. General Neural Control Parameters %
% ************************************ %

% feedback delays
% LongLoopDelay	= 0.030;    % [s] additional to spinal reflexes
% LongDelay  = 0.020; % ankle joint muscles [s]
% MidDelay   = 0.010; % knee joint muscles [s]
% ShortDelay = 0.005; % hip joint muscles [s]
% MinDelay        = 0.001;  % [s] between neurons in the spinal cord

% Song:
LongLoopDelay	= 0.030;    % [s] additional to spinal reflexes
LongDelay       = 0.020/2;  % [s] ankle joint muscles
MidDelay        = 0.010/2;  % [s] knee joint muscles
ShortDelay      = 0.005/2;  % [s] hip joint muscles
MinDelay        = 0.001/2;  % [s] between neurons in the spinal cord

% ****************************** %
% 2. Specific Control Parameters %
% ****************************** %

% -------------------------------
% 2.1 Stance-Leg Feedback Control 
% -------------------------------

% 0: prestimulations
PreStimHFLst    = 0.05; %[]
PreStimGLUst    = 0.05; %[]
PreStimHAMst    = 0.05; %[]
PreStimRFst     = 0.01; %[]
PreStimVASst    = 0.08; %[]
PreStimBFSHst   = 0.02; %[]
PreStimGASst    = 0.01;  %[]
PreStimTAst     = 0.01; %[]
PreStimSOLst    = 0.01; %[]

% M1: realize compliant leg
GainFGLUst   = 1.0/FmaxGLU; %[1/N]
GainFVASst   = 1.2/FmaxVAS; %[1/N] M1: realize compliant leg
GainFSOLst   = 1.2/FmaxSOL; %[1/N] M1: realize compliant leg
  
% M2: prevent knee overextension
GainFHAMst          = 1.0/FmaxHAM;  %[1/N] F gain
LceOffsetBFSHVASst  = 2.3951;       %[loptBFSH] 
GainLBFSHVASst      = 0.0680;       % VAS gain on BFSH L  
LceOffsetBFSHst     = 1.2231;       %[loptBFSH] 
GainLBFSHst         = 1.5/FmaxBFSH; %[1/N] L gain on self
GainFGASst          = 1.22/FmaxGAS; %[1/N]  F gain

% M3: balance trunk
GainPhiHATHFLst     = 0.1504; % Gain with HAT pitch
GainDphiHATHFLst    = 0.1709; % Gain with HAT pitch velocity
GainPhiHATGLUst     = 0.4729; % Gain with HAT pitch
GainDphiHATGLUst    = 0.1465; % Gain with HAT pitch velocity
GainSGLUHAMst       = 1.2707; % Gain with GLU stim

% M4: compensate swing leg
GainSGLUcHFLst    = 0.0541;
GainSHAMcHFLst    = 0.0121;
GainSHFLcGLUst    = 0.0225;
GainSRFcGLUst     = 0.0546;

% M5: flex ankle
LceOffsetTAst   = 1-0.65*w; %[loptTA]
GainLTAst       = 1.1;
GainFSOLTAst    = 0.4/FmaxSOL;



% PreStimBFSHsw = 0.02; %[]
% 
% % hip flexors group (self, L+)
% GainHFL    = 0.35/FmaxHFL; %[1/N]
% 
% PreStimHFLsw = 0.05; %[]
% LceOffsetHFL = 0.6; %[loptTA]
% 
% % hip flexors group on hamstring (self, L+)
% GainHAMHFL    = 4/FmaxHFL; %[1/N]
% 
% % hamstring group (self, F+)
% GainHAMsw    = GainHAM;
% 
% PreStimHAMsw = 0.01; %[]
% LceOffsetHAM = 0.85; %[loptTA]
% 
% % gluteus group (self, F+)
% GainGLUsw    = GainGLU;
% 
% PreStimGLUsw = 0.01; %[]
% 
% % soleus (self, F+)
% 
% PreStimSOLsw = 0.01; %[]
% 
% % soleus on tibialis anterior (F-)
% 
% PreStimTAsw = 0.01; %[]
% 
% % tibialis (self, L+, stance and swing)
% GainTAswing      = 1.1; %[]
% 
% % gastrocnemius (self, F+)
% 
% PreStimGASsw = 0.01;  %[]
% 
% % vasti group (self, F+)
% 
% PreStimVASsw = 0.08; %[]
% 
% % Rectus Femoris
% GainRF    = 1.5/FmaxRF; %[1/N]
% 
% PreStimRFsw = 0.01; %[]
% 
% % BFSH 
% 
% 
% % knee overextension on vasti (Phi-, directional)
% GainKneeOverExt = 2;%
% kneeAngleOffset = 10*pi/180;

% -----------------------------------------------
% 2.1 Stance-Leg HAT Reference Posture PD-Control
% -----------------------------------------------

% % stance hip joint position gain
% % PosGainGG   = 1/(30*pi/180); %[1/rad]
% % 
% % stance hip joint speed gain
% % SpeedGainGG = 0.2; %[s/rad] 
% % 
% % stance posture control muscles pre-stimulation
% % PreStimGG   = 0.05; %[]
% % 
% % stance reference posture
% % phiHATref      = 6*pi/180; %[rad]
phiHATref      = 4.2158*pi/180; %[rad] song

% % gluteus stance gain
% Kglu = 0.7;
% Khfl = 1;
% Kham = 1;
% 
% % HFL lean gain
% Klean = 1.15;
% 
% % Body weight gain
% Kbw = 1.2;
% 
% DeltaS = 0.25;
% DeltaSGLU = DeltaS;
% DeltaSHFL = DeltaS;

% ------------------------------
% 2.2 Swing-leg Feedback Control 
% ------------------------------

% constants (measurment parameters)
phi2loptBFSHsw    = 0.8520*rBFSH*rhoBFSH/loptBFSH;
phiRefBFSHsw      = 1.0557*phirefBFSH;
a2loptRFsw        = 0.7999*rRFh*rhoRFh/loptRF;
aRefRFsw          = 1.2605*(phirefRFh-phirefRFk/2);
a2loptHAMsw       = 0.8178*rHAMh*rhoHAMh/loptHAM;
aRefHAMsw         = 0.7239*(phirefHAMh-phirefHAMk/2);
phi2loptHFLsw     = 1.0045*rHFL*rhoHFL/loptHFL;
phirefHFLsw       = 1.0170*phirefHFL;
phi2loptGLUsw     = 0.9969*rGLU*rhoGLU/loptGLU;
phirefGLUsw       = 0.9876*phirefGLU;

% 0: prestimulations
PreStimHFLsw    = 0.01; %[]
PreStimGLUsw    = 0.01; %[]
PreStimHAMsw    = 0.01; %[]
PreStimRFsw     = 0.01; %[]
PreStimVASsw    = 0.01; %[]
PreStimBFSHsw   = 0.02; %[]
PreStimGASsw    = 0.01;  %[]
PreStimTAsw     = 0.01; %[]
PreStimSOLsw    = 0.01; %[]

% swing phase
aDelsw            = 12*pi/180;

% swing Ctrl (hip) M6
GainLRFHFLsw      = 1/a2loptRFsw;
GainVRFHFLsw      = .5;
GainLHAMGLUsw     = -0.5/a2loptHAMsw;
GainVHAMGLUsw     = .5;

% swing Ctrl (ankle) M5
GainLTAsw       = 1.1;
LceOffsetTAsw   = (1-0.65*w);

% swing Ctrl (knee_i) M7
GainVRFBFSHsw   	= 0.4*loptRF/(rRFh*rhoRFh);

% swing Ctrl (knee_ii)
GainVVASRFsw        = 0.08*loptBFSH/(rBFSH*rhoBFSH);
GainVBFSHsw     	= 2.5/a2loptRFsw;

% swing Ctrl (knee_iii)
GainLHAMsw          = 2/a2loptHAMsw;
GainSHAMBFSHsw   	= -6;
GainSHAMGASsw       = 2;
SHAMthresholdsw     = -5.1936e-04;%-0.65;

% swing Ctrl (stance preparation)
GainLHFLsw       = -0.4;
GainLGLUsw       = 0.4;
LceOffsetVASsw   = 0.1;
GainLVASsw       = 0.3;

% ----------------------------------
% stance -> swing transition control
% ----------------------------------

transSupst       = 1;
transsw          = 1;



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

warning('Initial conditions not the same as in Song')
% ----------------------
% 3.2 Simulation Control
% ----------------------
% ----------

% integrator max time step
ts_max = 1e-1;
