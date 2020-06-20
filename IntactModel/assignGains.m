BodyMechParams;
ControlParams;
OptimParams;

% load('Results/Flat/v_0.5m_s.mat');
% load('Results/Flat/v_0.8m_s.mat');
% load('Results/Flat/v_1.1m_s.mat');
% load('Results/Flat/v_1.4m_s.mat');

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

%% Target leg angle stuff
legLengthClr        = Gains(39);
simbiconLegAngle0   = Gains(40);
simbiconGainD       = Gains(41);
simbiconGainV       = Gains(42); 

phiHATref           = Gains(43); % stance phase
deltaLegAngleThr    = Gains(44); % swing phase

%% transition from stance to swing
transSupst          = Gains(45);
transsw             = Gains(46);

%% Prestimulations
% Stance
PreStimHFLst        = Gains(47);
PreStimGLUst        = Gains(48);
PreStimHAMst        = Gains(49);
PreStimRFst         = Gains(50);
PreStimVASst        = Gains(51);
PreStimBFSHst       = Gains(52);
PreStimGASst        = Gains(53);
PreStimSOLst        = Gains(54);
PreStimTAst         = Gains(55);

% Swing
PreStimHFLsw        = Gains(56);
PreStimGLUsw        = Gains(57);
PreStimHAMsw        = Gains(58);
PreStimRFsw         = Gains(59);
PreStimVASsw        = Gains(60);
PreStimBFSHsw       = Gains(61);
PreStimGASsw        = Gains(62);
PreStimSOLsw        = Gains(63);
PreStimTAsw         = Gains(64);

[groundX, groundZ, groundTheta] = generateGround('flat');
% [groundX, groundZ, groundTheta] = generateGround('const', .05,1);
%[groundX, groundZ, groundTheta] = generateGround('ramp');


