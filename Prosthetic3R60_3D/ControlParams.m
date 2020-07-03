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


% ==================================== %
% SET LATERAL PLANE CONTROL PARAMETERS %
% ==================================== %

% --------------------
% higher layer control
% --------------------

% foot placement Ctrl %
simbiconLegAngle0_C       =(-1)   *pi/180; 
simbiconGainD_C           = 10     *pi/180;    % [rad/m]
simbiconGainV_C           = 10     *pi/180;    % [rad*s/m]

% 0: prestimulations
PreStimHABst       	= 0.01;
PreStimHADst        = 0.01;

% M1: realize compliant leg
GainFHABst    	= .45/FmaxHAB;

% M3: balance trunk
GainPhiHATHABst     = 2.4;
GainDphiHATHABst    = .4;
GainPhiHATHADst     = .5;
GainDphiHATHADst    = .55;

% M4: compensate swing leg
GainSHABcHABst  = 1.5;
GainSHADcHADst  = .4;


% -------------
% swing control
% -------------

% constants (measurment parameters)
a2loptHAB     = 0.5442*rHAB*rhoHAB/loptHAB;
aRefHAB       = 0.8628*(pi/2 - phirefHAB);
a2loptHAD     = 0.6798*rHAD*rhoHAD/loptHAD;
aRefHAD       = 0.8053*(pi/2 - phirefHAD);

% 0: prestimulations
PreStimHABsw       	= 0.01;
PreStimHADsw        = 0.01;

% M6: swing hip
GainLHABsw      = 1/a2loptHAB;
GainLHADsw      = 1/a2loptHAD;

% ----------------------------------
% stance -> swing transition control
% ----------------------------------


transSupst_C       = 1;
transsw_C          = 1;

thetaHATref      = 0; %[rad] song

%%


% legAngleSpeedMax = 10; %[rad/s]

% hipPGain = 110; %[Nm/rad]
% hipDGain = 8.5; %[Nms/rad]
% legAngleFilter = 100; %[1/s]
% kneeFlexGain   = 13; %[Nms/rad]
% kneeHoldGain1  = 5.5; %[Nms/rad]
% kneeHoldGain   = 5.5; %[Nms/rad]
% kneeHoldGain2  = 5.5; %[Nms/rad]
% kneeStopGain   = 250; %[Nm/rad]
% kneeExtendGain = 200; %[Nm/rad]

% Foot placement
legLengthClr = 0.85; %[m]
simbiconLegAngle0 = 70*pi/180;
simbiconGainD = 5*pi/180; %[rad/m]
simbiconGainV = 5*pi/180; %[rad s/m]

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
PreStimSOLst    = 0.01; %[]
PreStimTAst     = 0.01; %[]

% M1: realize compliant leg
GainFGLUst   = 1.0/FmaxGLU; %[1/N]
GainFVASst   = 1.2/FmaxVAS; %[1/N] M1: realize compliant leg
GainFSOLst   = 1.2/FmaxSOL; %[1/N] M1: realize compliant leg
  
% M2: prevent knee overextension
GainFHAMst          = 1.0/FmaxHAM;  %[1/N] F gain
LceOffsetBFSHVASst  = 2;            %[loptBFSH] 
GainLBFSHVASst      = 0.0680;       % VAS gain on BFSH L  
LceOffsetBFSHst     = 1.1;          %[loptBFSH] 
GainLBFSHst         = 2;            %[1/N] L gain on self
GainFGASst          = 1.22/FmaxGAS; %[1/N]  F gain

% M3: balance trunk
GainPhiHATHFLst     = 1;    % Gain with HAT pitch
GainDphiHATHFLst    = 0.3;  % Gain with HAT pitch velocity
GainPhiHATGLUst     = 0.5;  % Gain with HAT pitch
GainDphiHATGLUst    = 0.1;  % Gain with HAT pitch velocity
GainSGLUHAMst       = 1;    % Gain with GLU stim

% M4: compensate swing leg
GainSGLUcHFLst    = 0.1;
GainSHAMcHFLst    = 0.1;
GainSHFLcGLUst    = 0.1;
GainSRFcGLUst     = 0.1;

% M5: flex ankle
LceOffsetTAst   = 1-0.65*w; %[loptTA]
GainLTAst       = 1.1;
GainFSOLTAst    = 0.4/FmaxSOL;


phiHATref      = 1*pi/180; %[rad] song


% ------------------------------
% 2.2 Swing-leg Feedback Control 
% ------------------------------

% constants (measurment parameters)
phi2loptBFSHsw    = 0.8520*rBFSH*rhoBFSH/loptBFSH;
phiRefBFSHsw      = 1.0557*(pi - phirefBFSH);
a2loptRFsw        = 0.7999*rRFh*rhoRFh/loptRF;
aRefRFsw          = 1.2605*((phirefRFh+pi)-(pi-phirefRFk)/2);
a2loptHAMsw       = 0.8178*rHAMh*rhoHAMh/loptHAM;
aRefHAMsw         = 0.7239*((phirefHAMh+pi)-(pi-phirefHAMk)/2);
phi2loptHFLsw     = 1.0045*rHFL*rhoHFL/loptHFL;
phirefHFLsw       = 1.0170*(pi+phirefHFL);
phi2loptGLUsw     = 0.9969*rGLU*rhoGLU/loptGLU;
phirefGLUsw       = 0.9876*(pi+phirefGLU);

% 0: prestimulations
PreStimHFLsw    = 0.01; %[]
PreStimGLUsw    = 0.01; %[]
PreStimHAMsw    = 0.01; %[]
PreStimRFsw     = 0.01; %[]
PreStimVASsw    = 0.01; %[]
PreStimBFSHsw   = 0.02; %[]
PreStimGASsw    = 0.01;  %[]
PreStimSOLsw    = 0.01; %[]
PreStimTAsw     = 0.01; %[]

% swing phase
deltaLegAngleThr = 12*pi/180; %[rad]

% swing Ctrl (hip) M6
GainLRFHFLsw      = 1/a2loptRFsw;
GainVRFHFLsw      = .5;
GainLHAMGLUsw     = 0.5/a2loptHAMsw;
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
GainSHAMBFSHsw   	= 6;
GainSHAMGASsw       = 2;
SHAMthresholdsw     = 0.65;

% swing Ctrl (stance preparation)
GainLHFLsw       = 0.4;
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
vx0 = 1.4402; %[m/s] 

% left (stance) leg ankle, knee and hip joint angles
% LphiAnkle0  =  -5*pi/180; %[rad]
% LphiKnee0  = 5*pi/180; %[rad]
% LphiHip0  = -5*pi/180; %[rad]

LphiAnkle0  =  11.1730*pi/180; %[rad]
LphiKnee0  = 6.4653*pi/180; %[rad]
LphiHip0  = -39.3264*pi/180; %[rad]

% right (swing) leg ankle, knee and hip joint angles
% for walking
RphiAnkle0  =   -5.7446*pi/180; %[rad]
RphiKnee0  = 3.6426*pi/180; %[rad]
RphiHip0  = 23.7692*pi/180; %[rad]

initialTargetAngle  = 70*pi/180;

% warning('Initial conditions not the same as in Song')
% ----------------------
% 3.2 Simulation Control
% ----------------------
% ----------

% integrator max time step
ts_max = 1e-1;
