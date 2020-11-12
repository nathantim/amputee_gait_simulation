% ASSIGNGAINSSAGITTAL        Script that assigns values to the Sagittal neurological controller variables from the Gain vector 

%% Left
%% stance gains
% M1
GainFGLUst          = GainsSagittal( 1);
GainFVASst          = GainsSagittal( 2);
GainFSOLst          = GainsSagittal( 3);

% M2 
GainFHAMst          = GainsSagittal( 4);
LceOffsetBFSHVASst  = GainsSagittal( 5);
GainLBFSHVASst      = GainsSagittal( 6);
LceOffsetBFSHst     = GainsSagittal( 7);
GainLBFSHst         = GainsSagittal( 8);
GainFGASst          = GainsSagittal( 9);

% M3
GainPhiHATHFLst     = GainsSagittal(10);
GainDphiHATHFLst    = GainsSagittal(11);
GainPhiHATGLUst     = GainsSagittal(12);
GainDphiHATGLUst    = GainsSagittal(13);
GainSGLUHAMst       = GainsSagittal(14);

% M4 
GainSGLUcHFLst      = GainsSagittal(15);
GainSHAMcHFLst      = GainsSagittal(16);
GainSHFLcGLUst      = GainsSagittal(17);
GainSRFcGLUst       = GainsSagittal(18);

% M5
LceOffsetTAst       = GainsSagittal(19);
GainLTAst           = GainsSagittal(20);
GainFSOLTAst        = GainsSagittal(21);

%% Swing gains
% M5
GainLTAsw           = GainsSagittal(22);
LceOffsetTAsw       = GainsSagittal(23);

% M6
GainLRFHFLsw        = GainsSagittal(24);
GainVRFHFLsw        = GainsSagittal(25);
GainLHAMGLUsw       = GainsSagittal(26);
GainVHAMGLUsw       = GainsSagittal(27);

% swing Ctrl (knee_i) M7
GainVRFBFSHsw       = GainsSagittal(28);

% swing Ctrl (knee_ii) M7
GainVVASRFsw        = GainsSagittal(29);
GainVBFSHsw         = GainsSagittal(30);

% swing Ctrl (knee_iii)
GainLHAMsw          = GainsSagittal(31);
GainSHAMBFSHsw      = GainsSagittal(32);
GainSHAMGASsw       = GainsSagittal(33);
SHAMthresholdsw     = GainsSagittal(34);

% swing Ctrl (stance preparation)
GainLHFLsw          = GainsSagittal(35);
GainLGLUsw          = GainsSagittal(36);
LceOffsetVASsw      = GainsSagittal(37);
GainLVASsw          = GainsSagittal(38);

%% Target leg angle stuff
legLengthClr        = GainsSagittal(39);
simbiconLegAngle0   = GainsSagittal(40);
simbiconGainD       = GainsSagittal(41);
simbiconGainV       = GainsSagittal(42); 

deltaLegAngleThr    = GainsSagittal(43); % swing phase

%% transition from stance to swing
transSupst          = GainsSagittal(44);
transsw             = GainsSagittal(45);

%% Prestimulations
% Stance
PreStimHFLst        = GainsSagittal(46);
PreStimGLUst        = GainsSagittal(47);
PreStimHAMst        = GainsSagittal(48);
PreStimRFst         = GainsSagittal(49);
PreStimVASst        = GainsSagittal(50);
PreStimBFSHst       = GainsSagittal(51);
PreStimGASst        = GainsSagittal(52);
PreStimSOLst        = GainsSagittal(53);
PreStimTAst         = GainsSagittal(54);

% Swing
PreStimHFLsw        = GainsSagittal(55);
PreStimGLUsw        = GainsSagittal(56);
PreStimHAMsw        = GainsSagittal(57);
PreStimRFsw         = GainsSagittal(58);
PreStimVASsw        = GainsSagittal(59);
PreStimBFSHsw       = GainsSagittal(60);
PreStimGASsw        = GainsSagittal(61);
PreStimSOLsw        = GainsSagittal(62);
PreStimTAsw         = GainsSagittal(63);

%%
phiHATref           = GainsSagittal(64); % stance phase

