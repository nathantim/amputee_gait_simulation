function paramSet = setRtpParamset(rtp,Gains)
% SETTRPPARAMSET            Function that creates a parameter set for the rapid accelerator mode
% INPUTS:
%   - rtp                   Rapid accelerator target of the model
%   - Gains                 Gain values that should be inserted in the parameter set
%
% OUTPUTS:
%   - paramSet
%%
paramSet = Simulink.BlockDiagram.modifyTunableParameters(rtp, ...
        'LGainFGLUst',               Gains( 1), ...
        'LGainFVASst',               Gains( 2), ...
        'LGainFSOLst',               Gains( 3), ...
        'LGainFHAMst',               Gains( 4), ...
        'LLceOffsetBFSHVASst',       Gains( 5), ...
        'LGainLBFSHVASst',           Gains( 6), ...
        'LLceOffsetBFSHst',          Gains( 7), ...
        'LGainLBFSHst',              Gains( 8), ...
        'LGainFGASst',               Gains( 9), ...
        'LGainPhiHATHFLst',          Gains(10), ...
        'LGainDphiHATHFLst',         Gains(11), ...
        'LGainPhiHATGLUst',          Gains(12), ...
        'LGainDphiHATGLUst',         Gains(13), ...
        'LGainSGLUHAMst',            Gains(14), ...
        'LGainSGLUcHFLst',           Gains(15), ...
        'LGainSHAMcHFLst',           Gains(16), ...
        'LGainSHFLcGLUst',           Gains(17),...
        'LGainSRFcGLUst',            Gains(18), ...
        'LLceOffsetTAst',            Gains(19), ...
        'LGainLTAst',                Gains(20), ...
        'LGainFSOLTAst',             Gains(21), ...
        'LGainLTAsw',                Gains(22), ...
        'LLceOffsetTAsw',            Gains(23), ...
        'LGainLRFHFLsw',             Gains(24), ...
        'LGainVRFHFLsw',             Gains(25), ...
        'LGainLHAMGLUsw',            Gains(26), ...
        'LGainVHAMGLUsw',            Gains(27), ...
        'LGainVRFBFSHsw',            Gains(28), ...
        'LGainVVASRFsw',             Gains(29), ...
        'LGainVBFSHsw',              Gains(30), ...
        'LGainLHAMsw',               Gains(31),...
        'LGainSHAMBFSHsw',           Gains(32), ...
        'LGainSHAMGASsw',            Gains(33), ...
        'LSHAMthresholdsw',          Gains(34), ...
        'LGainLHFLsw',               Gains(35), ...
        'LGainLGLUsw',               Gains(36), ...
        'LLceOffsetVASsw',           Gains(37), ...
        'LGainLVASsw',               Gains(38), ...
        'LlegLengthClr',             Gains(39), ...
        'LsimbiconLegAngle0',        Gains(40), ...
        'LsimbiconGainD',            Gains(41), ...
        'LsimbiconGainV',            Gains(42), ...
        'LdeltaLegAngleThr',         Gains(43), ...
        'LtransSupst',               Gains(44), ...
        'Ltranssw',                  Gains(45), ...
        'LPreStimHFLst',             Gains(46), ...
        'LPreStimGLUst',             Gains(47), ...
        'LPreStimHAMst',             Gains(48), ...
        'LPreStimRFst',              Gains(49), ...
        'LPreStimVASst',             Gains(50), ...
        'LPreStimBFSHst',            Gains(51), ...
        'LPreStimGASst',             Gains(52), ...
        'LPreStimSOLst',             Gains(53), ...
        'LPreStimTAst',              Gains(54), ...
        'LPreStimHFLsw',             Gains(55), ...
        'LPreStimGLUsw',             Gains(56), ...
        'LPreStimHAMsw',             Gains(57), ...
        'LPreStimRFsw',              Gains(58), ...
        'LPreStimVASsw',             Gains(59), ...
        'LPreStimBFSHsw',            Gains(60), ...
        'LPreStimGASsw',             Gains(61), ...
        'LPreStimSOLsw',             Gains(62), ...
        'LPreStimTAsw',              Gains(63), ...
        'RGainFGLUst',               Gains(64), ...
        'RGainFHAMst',               Gains(65), ...
        'RGainPhiHATHFLst',          Gains(66), ...
        'RGainDphiHATHFLst',         Gains(67), ...
        'RGainPhiHATGLUst',          Gains(68), ...
        'RGainDphiHATGLUst',         Gains(69), ...
        'RGainSGLUHAMst',            Gains(70), ...
        'RGainSGLUcHFLst',           Gains(71), ...
        'RGainSHAMcHFLst',           Gains(72), ...
        'RGainSHFLcGLUst',           Gains(73), ...
        'RGainSRFcGLUst',            Gains(74), ...
        'RGainLRFHFLsw',             Gains(75), ...
        'RGainVRFHFLsw',             Gains(76), ...
        'RGainLHAMGLUsw',            Gains(77), ...
        'RGainVHAMGLUsw',            Gains(78), ...
        'RGainLHAMsw',               Gains(79),...
        'RGainLHFLsw',               Gains(80), ...
        'RGainLGLUsw',               Gains(81), ...
        'RlegLengthClr',             Gains(82), ...
        'RsimbiconLegAngle0',        Gains(83), ...
        'RsimbiconGainD',            Gains(84), ...
        'RsimbiconGainV',            Gains(85), ...
        'RdeltaLegAngleThr',         Gains(86), ...
        'RtransSupst',               Gains(87), ...
        'Rtranssw',                  Gains(88), ...
        'RPreStimHFLst',             Gains(89), ...
        'RPreStimGLUst',             Gains(90), ...
        'RPreStimHAMst',             Gains(91), ...
        'RPreStimRFst',              Gains(92), ...
        'RPreStimHFLsw',             Gains(93), ...
        'RPreStimGLUsw',             Gains(94), ...
        'RPreStimHAMsw',             Gains(95), ...
        'RPreStimRFsw',              Gains(96), ...
        'phiHATref',                 Gains(97), ...
        'vxInit',                    Gains(98), ...
        'LphiHip0',                  Gains(99), ...
        'LphiKnee0',                 Gains(100), ...
        'LphiAnkle0',                Gains(101), ...
        'RphiHip0',                  Gains(102), ...
        'LTargetAngleInit',          Gains(103), ...
        'LPreStimHFLinit',           Gains(104), ...
        'LPreStimGLUinit',           Gains(105), ...
        'LPreStimHAMinit',           Gains(106), ...
        'LPreStimRFinit',            Gains(107), ...
        'LPreStimVASinit',           Gains(108), ...
        'LPreStimBFSHinit',          Gains(109), ...
        'LPreStimGASinit',           Gains(110), ...
        'LPreStimSOLinit',           Gains(111), ...
        'LPreStimTAinit',            Gains(112), ...
        'RTargetAngleInit',          Gains(113), ...
        'RPreStimHFLinit',           Gains(114), ...
        'RPreStimGLUinit',           Gains(115), ...
        'RPreStimHAMinit',           Gains(116), ...
        'RPreStimRFinit',            Gains(117), ...
        'LGainFHABst',               Gains(118), ...
        'LGainPhiHATHABst',          Gains(119), ...
        'LGainDphiHATHABst',         Gains(120), ...
        'LGainPhiHATHADst',          Gains(121), ...
        'LGainDphiHATHADst',         Gains(122), ...
        'LGainSHABcHABst',           Gains(123), ...
        'LGainSHADcHADst',           Gains(124), ...
        'LGainLHABsw',               Gains(125), ...
        'LGainLHADsw',               Gains(126), ...
        'LsimbiconLegAngle0_C',      Gains(127), ...
        'LsimbiconGainD_C',          Gains(128), ...
        'LsimbiconGainV_C',          Gains(129), ...
        'LheadingGain',              Gains(130), ...
        'LheadingIntGain',              Gains(131), ...
        'LtransSupst_C',             Gains(132), ...
        'Ltranssw_C',                Gains(133), ...
        'LPreStimHABst',             Gains(134), ...
        'LPreStimHADst',             Gains(135), ...
        'LPreStimHABsw',             Gains(136), ...
        'LPreStimHADsw',             Gains(137), ...
        'RGainFHABst',               Gains(138), ...
        'RGainPhiHATHABst',          Gains(139), ...
        'RGainDphiHATHABst',         Gains(140), ...
        'RGainPhiHATHADst',          Gains(141), ...
        'RGainDphiHATHADst',         Gains(142), ...
        'RGainSHABcHABst',           Gains(143), ...
        'RGainSHADcHADst',           Gains(144), ...
        'RGainLHABsw',               Gains(145), ...
        'RGainLHADsw',               Gains(146), ...
        'RsimbiconLegAngle0_C',      Gains(147), ...
        'RsimbiconGainD_C',          Gains(148), ...
        'RsimbiconGainV_C',          Gains(149), ...
        'RheadingGain',              Gains(150), ...
        'RheadingIntGain',              Gains(151), ...
        'RtransSupst_C',             Gains(152), ...
        'Rtranssw_C',                Gains(153), ...
        'RPreStimHABst',             Gains(154), ...
        'RPreStimHADst',             Gains(155), ...
        'RPreStimHABsw',             Gains(156), ...
        'RPreStimHADsw',             Gains(157), ...
        'vyInit',                    Gains(158), ...
        'rollInit',                  Gains(159), ...
        'LphiHipR0',                 Gains(160), ...
        'RphiHipR0',                 Gains(161), ...
        'LTargetAngleRInit',         Gains(162), ...
        'LPreStimHABinit',           Gains(163), ...
        'LPreStimHADinit',           Gains(164), ...
        'RTargetAngleRInit',         Gains(165), ...
        'RPreStimHABinit',           Gains(166), ...
        'RPreStimHADinit',           Gains(167));