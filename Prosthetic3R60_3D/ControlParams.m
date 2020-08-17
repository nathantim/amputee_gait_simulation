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
LsimbiconLegAngle0_C       =(-1)   *pi/180; 
LsimbiconGainD_C           = 10     *pi/180;    % [rad/m]
LsimbiconGainV_C           = 10     *pi/180;    % [rad*s/m]

RsimbiconLegAngle0_C       =(-1)   *pi/180; 
RsimbiconGainD_C           = 10     *pi/180;    % [rad/m]
RsimbiconGainV_C           = 10     *pi/180;    % [rad*s/m]


% 0: prestimulations
LPreStimHABst       	= 0.01;
LPreStimHADst        = 0.01;

RPreStimHABst       	= 0.01;
RPreStimHADst        = 0.01;


% M1: realize compliant leg
LGainFHABst    	= .45/FmaxHAB;
RGainFHABst    	= .45/FmaxHAB;

% M3: balance trunk
LGainPhiHATHABst     = 2.4;
LGainDphiHATHABst    = .4;
LGainPhiHATHADst     = .5;
LGainDphiHATHADst    = .55;

RGainPhiHATHABst     = 2.4;
RGainDphiHATHABst    = .4;
RGainPhiHATHADst     = .5;
RGainDphiHATHADst    = .55;


% M4: compensate swing leg
LGainSHABcHABst  = 1.5;
LGainSHADcHADst  = .4;

RGainSHABcHABst  = 1.5;
RGainSHADcHADst  = .4;


% -------------
% swing control
% -------------

% constants (measurment parameters)
a2loptHAB     = 0.5442*rHAB*rhoHAB/loptHAB;
aRefHAB       = 0.8628*(pi/2 - phirefHAB);
a2loptHAD     = 0.6798*rHAD*rhoHAD/loptHAD;
aRefHAD       = 0.8053*(pi/2 - phirefHAD);

% 0: prestimulations
LPreStimHABsw       	= 0.01;
LPreStimHADsw        = 0.01;

RPreStimHABsw       	= 0.01;
RPreStimHADsw        = 0.01;


% M6: swing hip
LGainLHABsw      = 1/a2loptHAB;
LGainLHADsw      = 1/a2loptHAD;

RGainLHABsw      = 1/a2loptHAB;
RGainLHADsw      = 1/a2loptHAD;

% ----------------------------------
% stance -> swing transition control
% ----------------------------------


LtransSupst_C       = 1;
Ltranssw_C          = 1;

RtransSupst_C       = 1;
Rtranssw_C          = 1;

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
LlegLengthClr = 0.85; %[m]
LsimbiconLegAngle0 = 70*pi/180;
LsimbiconGainD = 5*pi/180; %[rad/m]
LsimbiconGainV = 5*pi/180; %[rad s/m]

RlegLengthClr = 0.85; %[m]
RsimbiconLegAngle0 = 70*pi/180;
RsimbiconGainD = 5*pi/180; %[rad/m]
RsimbiconGainV = 5*pi/180; %[rad s/m]

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
LPreStimHFLst    = 0.05; %[]
LPreStimGLUst    = 0.05; %[]
LPreStimHAMst    = 0.05; %[]
LPreStimRFst     = 0.01; %[]
LPreStimVASst    = 0.08; %[]
LPreStimBFSHst   = 0.02; %[]
LPreStimGASst    = 0.01;  %[]
LPreStimSOLst    = 0.01; %[]
LPreStimTAst     = 0.01; %[]

RPreStimHFLst    = 0.05; %[]
RPreStimGLUst    = 0.05; %[]
RPreStimHAMst    = 0.05; %[]
RPreStimRFst     = 0.01; %[]

RPreStimVASst    = 0.08; %[]
RPreStimBFSHst   = 0.02; %[]
RPreStimGASst    = 0.01;  %[]
RPreStimSOLst    = 0.01; %[]
RPreStimTAst     = 0.01; %[]


% M1: realize compliant leg
LGainFGLUst   = 1.0/FmaxGLU; %[1/N]
LGainFVASst   = 1.2/FmaxVAS; %[1/N] M1: realize compliant leg
LGainFSOLst   = 1.2/FmaxSOL; %[1/N] M1: realize compliant leg

RGainFGLUst   = 1.0/FmaxGLU; %[1/N]
RGainFVASst   = 1.2/FmaxVAS; %[1/N] M1: realize compliant leg
RGainFSOLst   = 1.2/FmaxSOL; %[1/N] M1: realize compliant leg


% M2: prevent knee overextension
LGainFHAMst          = 1.0/FmaxHAM;  %[1/N] F gain
LLceOffsetBFSHVASst  = 2;            %[loptBFSH] 
LGainLBFSHVASst      = 0.0680;       % VAS gain on BFSH L  
LLceOffsetBFSHst     = 1.1;          %[loptBFSH] 
LGainLBFSHst         = 2;            %[1/N] L gain on self
LGainFGASst          = 1.22/FmaxGAS; %[1/N]  F gain

RGainFHAMst          = 1.0/FmaxHAM;  %[1/N] F gain
RLceOffsetBFSHVASst  = 2;            %[loptBFSH] 
RGainLBFSHVASst      = 0.0680;       % VAS gain on BFSH L  
RLceOffsetBFSHst     = 1.1;          %[loptBFSH] 
RGainLBFSHst         = 2;            %[1/N] L gain on self
RGainFGASst          = 1.22/FmaxGAS; %[1/N]  F gain


% M3: balance trunk
LGainPhiHATHFLst     = 1;    % Gain with HAT pitch
LGainDphiHATHFLst    = 0.3;  % Gain with HAT pitch velocity
LGainPhiHATGLUst     = 0.5;  % Gain with HAT pitch
LGainDphiHATGLUst    = 0.1;  % Gain with HAT pitch velocity
LGainSGLUHAMst       = 1;    % Gain with GLU stim

RGainPhiHATHFLst     = 1;    % Gain with HAT pitch
RGainDphiHATHFLst    = 0.3;  % Gain with HAT pitch velocity
RGainPhiHATGLUst     = 0.5;  % Gain with HAT pitch
RGainDphiHATGLUst    = 0.1;  % Gain with HAT pitch velocity
RGainSGLUHAMst       = 1;    % Gain with GLU stim


% M4: compensate swing leg
LGainSGLUcHFLst    = 0.1;
LGainSHAMcHFLst    = 0.1;
LGainSHFLcGLUst    = 0.1;
LGainSRFcGLUst     = 0.1;

RGainSGLUcHFLst    = 0.1;
RGainSHAMcHFLst    = 0.1;
RGainSHFLcGLUst    = 0.1;
RGainSRFcGLUst     = 0.1;


% M5: flex ankle
LLceOffsetTAst   = 1-0.65*w; %[loptTA]
LGainLTAst       = 1.1;
LGainFSOLTAst    = 0.4/FmaxSOL;

RLceOffsetTAst   = 1-0.65*w; %[loptTA]
RGainLTAst       = 1.1;
RGainFSOLTAst    = 0.4/FmaxSOL;


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
LPreStimHFLsw    = 0.01; %[]
LPreStimGLUsw    = 0.01; %[]
LPreStimHAMsw    = 0.01; %[]
LPreStimRFsw     = 0.01; %[]
LPreStimVASsw    = 0.01; %[]
LPreStimBFSHsw   = 0.02; %[]
LPreStimGASsw    = 0.01;  %[]
LPreStimSOLsw    = 0.01; %[]
LPreStimTAsw     = 0.01; %[]

RPreStimHFLsw    = 0.01; %[]
RPreStimGLUsw    = 0.01; %[]
RPreStimHAMsw    = 0.01; %[]
RPreStimRFsw     = 0.01; %[]
RPreStimVASsw    = 0.01; %[]
RPreStimBFSHsw   = 0.02; %[]
RPreStimGASsw    = 0.01;  %[]
RPreStimSOLsw    = 0.01; %[]
RPreStimTAsw     = 0.01; %[]


% swing phase
LdeltaLegAngleThr = 12*pi/180; %[rad]

RdeltaLegAngleThr = 12*pi/180; %[rad]


% swing Ctrl (hip) M6
LGainLRFHFLsw      = 1/a2loptRFsw;
LGainVRFHFLsw      = .5;
LGainLHAMGLUsw     = 0.5/a2loptHAMsw;
LGainVHAMGLUsw     = .5;

RGainLRFHFLsw      = 1/a2loptRFsw;
RGainVRFHFLsw      = .5;
RGainLHAMGLUsw     = 0.5/a2loptHAMsw;
RGainVHAMGLUsw     = .5;


% swing Ctrl (ankle) M5
LGainLTAsw       = 1.1;
LLceOffsetTAsw   = (1-0.65*w);

RGainLTAsw       = 1.1;
RLceOffsetTAsw   = (1-0.65*w);


% swing Ctrl (knee_i) M7
LGainVRFBFSHsw   	= 0.4*loptRF/(rRFh*rhoRFh);

RGainVRFBFSHsw   	= 0.4*loptRF/(rRFh*rhoRFh);


% swing Ctrl (knee_ii)
LGainVVASRFsw        = 0.08*loptBFSH/(rBFSH*rhoBFSH);
LGainVBFSHsw     	= 2.5/a2loptRFsw;

RGainVVASRFsw        = 0.08*loptBFSH/(rBFSH*rhoBFSH);
RGainVBFSHsw     	= 2.5/a2loptRFsw;


% swing Ctrl (knee_iii)
LGainLHAMsw          = 2/a2loptHAMsw;
LGainSHAMBFSHsw   	= 6;
LGainSHAMGASsw       = 2;
LSHAMthresholdsw     = 0.65;

RGainLHAMsw          = 2/a2loptHAMsw;
RGainSHAMBFSHsw   	= 6;
RGainSHAMGASsw       = 2;
RSHAMthresholdsw     = 0.65;


% swing Ctrl (stance preparation)
LGainLHFLsw       = 0.4;
LGainLGLUsw       = 0.4;
LLceOffsetVASsw   = 0.1;
LGainLVASsw       = 0.3;

RGainLHFLsw       = 0.4;
RGainLGLUsw       = 0.4;
RLceOffsetVASsw   = 0.1;
RGainLVASsw       = 0.3;


% ----------------------------------
% stance -> swing transition control
% ----------------------------------

LtransSupst       = 1;
Ltranssw          = 1;

RtransSupst       = 1;
Rtranssw          = 1;


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
