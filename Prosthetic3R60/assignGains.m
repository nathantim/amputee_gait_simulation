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


%% Target leg angle stuff
LlegLengthClr        = Gains(39);
LsimbiconLegAngle0   = Gains(40);
LsimbiconGainD       = Gains(41);
LsimbiconGainV       = Gains(42); 

LdeltaLegAngleThr    = Gains(43); % swing phase


%% transition from stance to swing
LtransSupst          = Gains(44);
Ltranssw             = Gains(45);

%% Prestimulations
% Stance
LPreStimHFLst        = Gains(46);
LPreStimGLUst        = Gains(47);
LPreStimHAMst        = Gains(48);
LPreStimRFst         = Gains(49);
LPreStimVASst        = Gains(50);
LPreStimBFSHst       = Gains(51);
LPreStimGASst        = Gains(52);
LPreStimSOLst        = Gains(53);
LPreStimTAst         = Gains(54);

% Swing
LPreStimHFLsw        = Gains(55);
LPreStimGLUsw        = Gains(56);
LPreStimHAMsw        = Gains(57);
LPreStimRFsw         = Gains(58);
LPreStimVASsw        = Gains(59);
LPreStimBFSHsw       = Gains(60);
LPreStimGASsw        = Gains(61);
LPreStimSOLsw        = Gains(62);
LPreStimTAsw         = Gains(63);


%%
phiHATref           = Gains(64); % stance phase

%% Right
%% stance gains
% M1
RGainFGLUst          = Gains(65);

% M2 
RGainFHAMst          = Gains(66);

% M3
RGainPhiHATHFLst     = Gains(67);
RGainDphiHATHFLst    = Gains(68);
RGainPhiHATGLUst     = Gains(69);
RGainDphiHATGLUst    = Gains(70);
RGainSGLUHAMst       = Gains(71);

% M4 
RGainSGLUcHFLst      = Gains(72);
RGainSHAMcHFLst      = Gains(73);
RGainSHFLcGLUst      = Gains(74);
RGainSRFcGLUst       = Gains(75);


%% Swing gains
% M6
RGainLRFHFLsw        = Gains(76);
RGainVRFHFLsw        = Gains(77);
RGainLHAMGLUsw       = Gains(78);
RGainVHAMGLUsw       = Gains(79);

% swing Ctrl (knee_iii)
RGainLHAMsw          = Gains(80);

% swing Ctrl (stance preparation)
RGainLHFLsw          = Gains(81);
RGainLGLUsw          = Gains(82);


%% Target leg angle stuff
RlegLengthClr        = Gains(83);
RsimbiconLegAngle0   = Gains(84);
RsimbiconGainD       = Gains(85);
RsimbiconGainV       = Gains(86); 

RdeltaLegAngleThr    = Gains(87); % swing phase


%% transition from stance to swing
RtransSupst          = Gains(88);
Rtranssw             = Gains(89);

%% Prestimulations
% Stance
RPreStimHFLst        = Gains(90);
RPreStimGLUst        = Gains(91);
RPreStimHAMst        = Gains(92);
RPreStimRFst         = Gains(93);

% Swing
RPreStimHFLsw        = Gains(94);
RPreStimGLUsw        = Gains(95);
RPreStimHAMsw        = Gains(96);
RPreStimRFsw         = Gains(97);



% [groundX, groundZ, groundTheta] = generateGround('flat');
% [groundX, groundZ, groundTheta] = generateGround('const', .05,1);
%[groundX, groundZ, groundTheta] = generateGround('ramp');


