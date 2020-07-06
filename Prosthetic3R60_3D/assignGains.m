BodyMechParams;
ControlParams;
OptimParams;
Prosthesis3R60Params;
 
%% Left
%% stance gains
% M1
LGainFGLUst          = Gains( 1);
LGainFVASst          = Gains( 2);
LGainFSOLst          = Gains( 3);

% M2 
LGainFHAMst          = Gains( 4);
LLceOffsetBFSHVASst  = Gains( 5);
LGainLBFSHVASst      = Gains( 6);
LLceOffsetBFSHst     = Gains( 7);
LGainLBFSHst         = Gains( 8);
LGainFGASst          = Gains( 9);

% M3
LGainPhiHATHFLst     = Gains(10);
LGainDphiHATHFLst    = Gains(11);
LGainPhiHATGLUst     = Gains(12);
LGainDphiHATGLUst    = Gains(13);
LGainSGLUHAMst       = Gains(14);

% M4 
LGainSGLUcHFLst      = Gains(15);
LGainSHAMcHFLst      = Gains(16);
LGainSHFLcGLUst      = Gains(17);
LGainSRFcGLUst       = Gains(18);

% M5
LLceOffsetTAst       = Gains(19);
LGainLTAst           = Gains(20);
LGainFSOLTAst        = Gains(21);

%% Swing gains
% M5
LGainLTAsw           = Gains(22);
LLceOffsetTAsw       = Gains(23);

% M6
LGainLRFHFLsw        = Gains(24);
LGainVRFHFLsw        = Gains(25);
LGainLHAMGLUsw       = Gains(26);
LGainVHAMGLUsw       = Gains(27);

% swing Ctrl (knee_i) M7
LGainVRFBFSHsw       = Gains(28);

% swing Ctrl (knee_ii) M7
LGainVVASRFsw        = Gains(29);
LGainVBFSHsw         = Gains(30);

% swing Ctrl (knee_iii)
LGainLHAMsw          = Gains(31);
LGainSHAMBFSHsw      = Gains(32);
LGainSHAMGASsw       = Gains(33);
LSHAMthresholdsw     = Gains(34);

% swing Ctrl (stance preparation)
LGainLHFLsw          = Gains(35);
LGainLGLUsw          = Gains(36);
LLceOffsetVASsw      = Gains(37);
LGainLVASsw          = Gains(38);

%% Coronal 
%stance
% M1: realize compliant leg
LGainFHABst          = Gains(39);

% M3: balance trunk
LGainPhiHATHABst     = Gains(40);
LGainDphiHATHABst    = Gains(41);
LGainPhiHATHADst     = Gains(42);
LGainDphiHATHADst    = Gains(43);

% M4: compensate swing leg
LGainSHABcHABst      = Gains(44);
LGainSHADcHADst      = Gains(45);

% swing
% M6: swing hip
LGainLHABsw          = Gains(46);
LGainLHADsw          = Gains(47);

%% Target leg angle stuff
LlegLengthClr        = Gains(48);
LsimbiconLegAngle0   = Gains(49);
LsimbiconGainD       = Gains(50);
LsimbiconGainV       = Gains(51); 

LdeltaLegAngleThr    = Gains(52); % swing phase

LsimbiconLegAngle0_C = Gains(53);
LsimbiconGainD_C     = Gains(54);
LsimbiconGainV_C     = Gains(55);

%% transition from stance to swing
LtransSupst          = Gains(56);
Ltranssw             = Gains(57);
LtransSupst_C        = Gains(58);
Ltranssw_C           = Gains(59);

%% Prestimulations
% Stance
LPreStimHFLst        = Gains(60);
LPreStimGLUst        = Gains(61);
LPreStimHAMst        = Gains(62);
LPreStimRFst         = Gains(63);
LPreStimVASst        = Gains(64);
LPreStimBFSHst       = Gains(65);
LPreStimGASst        = Gains(66);
LPreStimSOLst        = Gains(67);
LPreStimTAst         = Gains(68);

LPreStimHABst        = Gains(69);
LPreStimHADst        = Gains(70);

% Swing
LPreStimHFLsw        = Gains(71);
LPreStimGLUsw        = Gains(72);
LPreStimHAMsw        = Gains(73);
LPreStimRFsw         = Gains(74);
LPreStimVASsw        = Gains(75);
LPreStimBFSHsw       = Gains(76);
LPreStimGASsw        = Gains(77);
LPreStimSOLsw        = Gains(78);
LPreStimTAsw         = Gains(79);

LPreStimHABsw        = Gains(80);
LPreStimHADsw        = Gains(81);

%%
phiHATref           = Gains(82); % stance phase

%% Right
%% stance gains
% M1
RGainFGLUst          = Gains(83);

% M2 
RGainFHAMst          = Gains(84);

% M3
RGainPhiHATHFLst     = Gains(85);
RGainDphiHATHFLst    = Gains(86);
RGainPhiHATGLUst     = Gains(87);
RGainDphiHATGLUst    = Gains(88);
RGainSGLUHAMst       = Gains(89);

% M4 
RGainSGLUcHFLst      = Gains(90);
RGainSHAMcHFLst      = Gains(91);
RGainSHFLcGLUst      = Gains(92);
RGainSRFcGLUst       = Gains(93);


%% Swing gains
% M6
RGainLRFHFLsw        = Gains(94);
RGainVRFHFLsw        = Gains(95);
RGainLHAMGLUsw       = Gains(96);
RGainVHAMGLUsw       = Gains(97);

% swing Ctrl (knee_iii)
RGainLHAMsw          = Gains(98);

% swing Ctrl (stance preparation)
RGainLHFLsw          = Gains(99);
RGainLGLUsw          = Gains(100);

%% Coronal 
%stance
% M1: realize compliant leg
RGainFHABst          = Gains(101);

% M3: balance trunk
RGainPhiHATHABst     = Gains(102);
RGainDphiHATHABst    = Gains(103);
RGainPhiHATHADst     = Gains(104);
RGainDphiHATHADst    = Gains(105);

% M4: compensate swing leg
RGainSHABcHABst      = Gains(106);
RGainSHADcHADst      = Gains(107);

% swing
% M6: swing hip
RGainLHABsw          = Gains(108);
RGainLHADsw          = Gains(109);

%% Target leg angle stuff
RlegLengthClr        = Gains(110);
RsimbiconLegAngle0   = Gains(111);
RsimbiconGainD       = Gains(112);
RsimbiconGainV       = Gains(113); 

RdeltaLegAngleThr    = Gains(114); % swing phase

RsimbiconLegAngle0_C = Gains(115);
RsimbiconGainD_C     = Gains(116);
RsimbiconGainV_C     = Gains(117);

%% transition from stance to swing
RtransSupst          = Gains(118);
Rtranssw             = Gains(119);
RtransSupst_C        = Gains(120);
Rtranssw_C           = Gains(121);

%% Prestimulations
% Stance
RPreStimHFLst        = Gains(122);
RPreStimGLUst        = Gains(123);
RPreStimHAMst        = Gains(124);
RPreStimRFst         = Gains(125);

RPreStimHABst        = Gains(126);
RPreStimHADst        = Gains(127);

% Swing
RPreStimHFLsw        = Gains(128);
RPreStimGLUsw        = Gains(129);
RPreStimHAMsw        = Gains(130);
RPreStimRFsw         = Gains(131);


RPreStimHABsw        = Gains(132);
RPreStimHADsw        = Gains(133);

% [groundX, groundZ, groundTheta] = generateGround('flat');
% [groundX, groundZ, groundTheta] = generateGround('const', .05,1);
%[groundX, groundZ, groundTheta] = generateGround('ramp');


