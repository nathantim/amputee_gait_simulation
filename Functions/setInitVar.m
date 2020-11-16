%% set initial conditions
% conditions from Song
vxInit             = (innerOptSettings.targetVelocity); %[m/s]
vzInit = 0; % not optimize
xInit      = .2; % not optimize
yInit      = -hatLeftHipToCenterDistWidth;% not optimize
zInit      = 0; % not optimize


LphiAnkle0      = -(1   	*100*pi/180 - pi/2); %[rad]
LphiKnee0       = pi - 0.9811   	*180*pi/180; %[rad]
LphiHip0        = 1/2*(0.95 	*165*pi/180 - pi); %[rad]
RphiAnkle0      = 0.95  	*90*pi/180 - pi/2; %[rad]
RphiKnee0       = pi - 1.09  	*165*pi/180; %[rad]
RphiHip0        = -2.8*(0.97   	*200*pi/180 - pi); %[rad]

vyInit = 0.2*(innerOptSettings.targetVelocity/1.3); %.2
yawInit    = pi/180; % not optimize
rollInit   = -(-1)*pi/180;
LphiHipR0       = (1)*pi/180; %[rad]
RphiHipR0       = -(1)*pi/180; %[rad]


initialTargetAngle  = 70*pi/180;
initialTargetAngleR = 90*pi/180;

LTargetAngleInit    = initialTargetAngle;
LTargetAngleRInit   = initialTargetAngleR;

try
    LPreStimHFLinit     = PreStimHFLst;
    LPreStimGLUinit     = PreStimGLUst;
    LPreStimHAMinit     = PreStimHAMst;
    LPreStimRFinit      = PreStimRFst;
    LPreStimVASinit     = PreStimVASst;
    LPreStimBFSHinit    = PreStimBFSHst;
    LPreStimGASinit     = PreStimGASst;
    LPreStimSOLinit     = PreStimSOLst;
    LPreStimTAinit      = PreStimTAst;
    
    LPreStimHABinit     = PreStimHABst;
    LPreStimHADinit     = PreStimHADst;
catch
    LPreStimHFLinit     = LPreStimHFLst;
    LPreStimGLUinit     = LPreStimGLUst;
    LPreStimHAMinit     = LPreStimHAMst;
    LPreStimRFinit      = LPreStimRFst;
    LPreStimVASinit     = LPreStimVASst;
    LPreStimBFSHinit    = LPreStimBFSHst;
    LPreStimGASinit     = LPreStimGASst;
    LPreStimSOLinit     = LPreStimSOLst;
    LPreStimTAinit      = LPreStimTAst;
    
    LPreStimHABinit     = LPreStimHABst;
    LPreStimHADinit     = LPreStimHADst;
end

RTargetAngleInit    = initialTargetAngle;
RTargetAngleRInit   = initialTargetAngleR;

try
    RPreStimHFLinit     = PreStimHFLsw;
    RPreStimGLUinit     = PreStimGLUsw;
    RPreStimHAMinit     = PreStimHAMsw;
    RPreStimRFinit      = PreStimRFsw;
    RPreStimVASinit     = PreStimVASst;
    RPreStimBFSHinit    = PreStimBFSHst;
    RPreStimGASinit     = PreStimGASst;
    RPreStimSOLinit     = PreStimSOLst;
    RPreStimTAinit      = PreStimTAst;
    
    RPreStimHABinit     = PreStimHABsw;
    RPreStimHADinit     = PreStimHADsw;
catch
    RPreStimHFLinit     = RPreStimHFLsw;
    RPreStimGLUinit     = RPreStimGLUsw;
    RPreStimHAMinit     = RPreStimHAMsw;
    RPreStimRFinit      = RPreStimRFsw;
    RPreStimVASinit     = RPreStimVASst;
    RPreStimBFSHinit    = RPreStimBFSHst;
    RPreStimGASinit     = RPreStimGASst;
    RPreStimSOLinit     = RPreStimSOLst;
    RPreStimTAinit      = RPreStimTAst;
    
    RPreStimHABinit     = RPreStimHABsw;
    RPreStimHADinit     = RPreStimHADsw;
end
