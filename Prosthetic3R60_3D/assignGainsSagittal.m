BodyMechParams;
ControlParams;
OptimParams;
Prosthesis3R60Params;
 
%% Left
%% stance gains
% M1
LGainFGLUst          = GainsSagittal( 1);
LGainFVASst          = GainsSagittal( 2);
LGainFSOLst          = GainsSagittal( 3);

% M2 
LGainFHAMst          = GainsSagittal( 4);
LLceOffsetBFSHVASst  = GainsSagittal( 5);
LGainLBFSHVASst      = GainsSagittal( 6);
LLceOffsetBFSHst     = GainsSagittal( 7);
LGainLBFSHst         = GainsSagittal( 8);
LGainFGASst          = GainsSagittal( 9);

% M3
LGainPhiHATHFLst     = GainsSagittal(10);
LGainDphiHATHFLst    = GainsSagittal(11);
LGainPhiHATGLUst     = GainsSagittal(12);
LGainDphiHATGLUst    = GainsSagittal(13);
LGainSGLUHAMst       = GainsSagittal(14);

% M4 
LGainSGLUcHFLst      = GainsSagittal(15);
LGainSHAMcHFLst      = GainsSagittal(16);
LGainSHFLcGLUst      = GainsSagittal(17);
LGainSRFcGLUst       = GainsSagittal(18);

% M5
LLceOffsetTAst       = GainsSagittal(19);
LGainLTAst           = GainsSagittal(20);
LGainFSOLTAst        = GainsSagittal(21);

%% Swing gains
% M5
LGainLTAsw           = GainsSagittal(22);
LLceOffsetTAsw       = GainsSagittal(23);

% M6
LGainLRFHFLsw        = GainsSagittal(24);
LGainVRFHFLsw        = GainsSagittal(25);
LGainLHAMGLUsw       = GainsSagittal(26);
LGainVHAMGLUsw       = GainsSagittal(27);

% swing Ctrl (knee_i) M7
LGainVRFBFSHsw       = GainsSagittal(28);

% swing Ctrl (knee_ii) M7
LGainVVASRFsw        = GainsSagittal(29);
LGainVBFSHsw         = GainsSagittal(30);

% swing Ctrl (knee_iii)
LGainLHAMsw          = GainsSagittal(31);
LGainSHAMBFSHsw      = GainsSagittal(32);
LGainSHAMGASsw       = GainsSagittal(33);
LSHAMthresholdsw     = GainsSagittal(34);

% swing Ctrl (stance preparation)
LGainLHFLsw          = GainsSagittal(35);
LGainLGLUsw          = GainsSagittal(36);
LLceOffsetVASsw      = GainsSagittal(37);
LGainLVASsw          = GainsSagittal(38);

%% Target leg angle stuff
LlegLengthClr        = GainsSagittal(39);
LsimbiconLegAngle0   = GainsSagittal(40);
LsimbiconGainD       = GainsSagittal(41);
LsimbiconGainV       = GainsSagittal(42); 

LdeltaLegAngleThr    = GainsSagittal(43); % swing phase

%% transition from stance to swing
LtransSupst          = GainsSagittal(44);
Ltranssw             = GainsSagittal(45);

%% Prestimulations
% Stance
LPreStimHFLst        = GainsSagittal(46);
LPreStimGLUst        = GainsSagittal(47);
LPreStimHAMst        = GainsSagittal(48);
LPreStimRFst         = GainsSagittal(49);
LPreStimVASst        = GainsSagittal(50);
LPreStimBFSHst       = GainsSagittal(51);
LPreStimGASst        = GainsSagittal(52);
LPreStimSOLst        = GainsSagittal(53);
LPreStimTAst         = GainsSagittal(54);

% Swing
LPreStimHFLsw        = GainsSagittal(55);
LPreStimGLUsw        = GainsSagittal(56);
LPreStimHAMsw        = GainsSagittal(57);
LPreStimRFsw         = GainsSagittal(58);
LPreStimVASsw        = GainsSagittal(59);
LPreStimBFSHsw       = GainsSagittal(60);
LPreStimGASsw        = GainsSagittal(61);
LPreStimSOLsw        = GainsSagittal(62);
LPreStimTAsw         = GainsSagittal(63);


%% Right
%% stance gains
% M1
RGainFGLUst          = GainsSagittal(64);

% M2 
RGainFHAMst          = GainsSagittal(65);

% M3
RGainPhiHATHFLst     = GainsSagittal(66);
RGainDphiHATHFLst    = GainsSagittal(67);
RGainPhiHATGLUst     = GainsSagittal(68);
RGainDphiHATGLUst    = GainsSagittal(69);
RGainSGLUHAMst       = GainsSagittal(70);

% M4 
RGainSGLUcHFLst      = GainsSagittal(71);
RGainSHAMcHFLst      = GainsSagittal(72);
RGainSHFLcGLUst      = GainsSagittal(73);
RGainSRFcGLUst       = GainsSagittal(74);


%% Swing gains
% M6
RGainLRFHFLsw        = GainsSagittal(75);
RGainVRFHFLsw        = GainsSagittal(76);
RGainLHAMGLUsw       = GainsSagittal(77);
RGainVHAMGLUsw       = GainsSagittal(78);

% swing Ctrl (knee_iii)
RGainLHAMsw          = GainsSagittal(79);

% swing Ctrl (stance preparation)
RGainLHFLsw          = GainsSagittal(80);
RGainLGLUsw          = GainsSagittal(81);

%% Target leg angle stuff
RlegLengthClr        = GainsSagittal(82);
RsimbiconLegAngle0   = GainsSagittal(83);
RsimbiconGainD       = GainsSagittal(84);
RsimbiconGainV       = GainsSagittal(85); 

RdeltaLegAngleThr    = GainsSagittal(86); % swing phase

%% transition from stance to swing
RtransSupst          = GainsSagittal(87);
Rtranssw             = GainsSagittal(88);

%% Prestimulations
% Stance
RPreStimHFLst        = GainsSagittal(89);
RPreStimGLUst        = GainsSagittal(90);
RPreStimHAMst        = GainsSagittal(91);
RPreStimRFst         = GainsSagittal(92);

% Swing
RPreStimHFLsw        = GainsSagittal(93);
RPreStimGLUsw        = GainsSagittal(94);
RPreStimHAMsw        = GainsSagittal(95);
RPreStimRFsw         = GainsSagittal(96);

%%
phiHATref           = GainsSagittal(97); % stance phase

