BodyMechParams;
ControlParams;
OptimParams;

%  load('SongGains_02_wC.mat');
 thetaHATref = 0;
%% stance gains
% M1
GainFGLUst          = Gains( 1);
GainFVASst          = Gains( 2);
GainFSOLst          = Gains( 3);

% M2 
GainFHAMst          = Gains( 4);
LceOffsetBFSHVASst  = Gains( 5);
GainLBFSHVASst      = Gains( 6);
LceOffsetBFSHst     = Gains( 7);
GainLBFSHst         = Gains( 8);
GainFGASst          = Gains( 9);

% M3
GainPhiHATHFLst     = Gains(10);
GainDphiHATHFLst    = Gains(11);
GainPhiHATGLUst     = Gains(12);
GainDphiHATGLUst    = Gains(13);
GainSGLUHAMst       = Gains(14);

% M4 
GainSGLUcHFLst      = Gains(15);
GainSHAMcHFLst      = Gains(16);
GainSHFLcGLUst      = Gains(17);
GainSRFcGLUst       = Gains(18);

% M5
LceOffsetTAst       = Gains(19);
GainLTAst           = Gains(20);
GainFSOLTAst        = Gains(21);

%% Swing gains
% M5
GainLTAsw           = Gains(22);
LceOffsetTAsw       = Gains(23);

% M6
GainLRFHFLsw        = Gains(24);
GainVRFHFLsw        = Gains(25);
GainLHAMGLUsw       = Gains(26);
GainVHAMGLUsw       = Gains(27);

% swing Ctrl (knee_i) M7
GainVRFBFSHsw       = Gains(28);

% swing Ctrl (knee_ii) M7
GainVVASRFsw        = Gains(29);
GainVBFSHsw         = Gains(30);

% swing Ctrl (knee_iii)
GainLHAMsw          = Gains(31);
GainSHAMBFSHsw      = Gains(32);
GainSHAMGASsw       = Gains(33);
SHAMthresholdsw     = Gains(34);

% swing Ctrl (stance preparation)
GainLHFLsw          = Gains(35);
GainLGLUsw          = Gains(36);
LceOffsetVASsw      = Gains(37);
GainLVASsw          = Gains(38);

%% Coronal 
%stance
% M1: realize compliant leg
GainFHABst          = Gains(39);

% M3: balance trunk
GainPhiHATHABst     = Gains(40);
GainDphiHATHABst    = Gains(41);
GainPhiHATHADst     = Gains(42);
GainDphiHATHADst    = Gains(43);

% M4: compensate swing leg
GainSHABcHABst      = Gains(44);
GainSHADcHADst      = Gains(45);

% swing
% M6: swing hip
GainLHABsw          = Gains(46);
GainLHADsw          = Gains(47);

%% Target leg angle stuff
legLengthClr        = Gains(48);
simbiconLegAngle0   = Gains(49);
simbiconGainD       = Gains(50);
simbiconGainV       = Gains(51); 

phiHATref           = Gains(52); % stance phase
deltaLegAngleThr    = Gains(53); % swing phase

simbiconLegAngle0_C = Gains(54);
simbiconGainD_C     = Gains(55);
simbiconGainV_C     = Gains(56);

%% transition from stance to swing
transSupst          = Gains(57);
transsw             = Gains(58);
transSupst_C        = Gains(59);
transsw_C           = Gains(60);

%% Prestimulations
% Stance
PreStimHFLst        = Gains(61);
PreStimGLUst        = Gains(62);
PreStimHAMst        = Gains(63);
PreStimRFst         = Gains(64);
PreStimVASst        = Gains(65);
PreStimBFSHst       = Gains(66);
PreStimGASst        = Gains(67);
PreStimSOLst        = Gains(68);
PreStimTAst         = Gains(69);

PreStimHABst       	= Gains(70);
PreStimHADst        = Gains(71);

% Swing
PreStimHFLsw        = Gains(72);
PreStimGLUsw        = Gains(73);
PreStimHAMsw        = Gains(74);
PreStimRFsw         = Gains(75);
PreStimVASsw        = Gains(76);
PreStimBFSHsw       = Gains(77);
PreStimGASsw        = Gains(78);
PreStimSOLsw        = Gains(79);
PreStimTAsw         = Gains(80);

PreStimHABsw       	= Gains(81);
PreStimHADsw        = Gains(82);


[groundX, groundZ, groundTheta] = generateGround('flat');
% [groundX, groundZ, groundTheta] = generateGround('const', .05,1);
%[groundX, groundZ, groundTheta] = generateGround('ramp');


