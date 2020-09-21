%% set initial conditions
% conditions from Song
warning('Check init conditions');
vxInit             = (1.3); %[m/s]
vzInit = 0; % not optimize
xInit      = .2; % not optimize
yInit      = -hatLeftHipToCenterDistWidth;% not optimize
zInit      = 0; % not optimize


LphiAnkle0      = -(paramIC(2)   	*100*pi/180 - pi/2); %[rad]
LphiKnee0       = pi - paramIC(3)   	*180*pi/180; %[rad]
LphiHip0        = 1/2*(paramIC(4) 	*165*pi/180 - pi); %[rad]
RphiAnkle0      = paramIC(5)  	*90*pi/180 - pi/2; %[rad]
RphiKnee0       = pi - paramIC(6)  	*165*pi/180; %[rad]
RphiHip0        = -2.8*(paramIC(7)   	*200*pi/180 - pi); %[rad]

vyInit = 0.2*(target_velocity/1.3); %.2
yawInit    = pi/180; % not optimize
rollInit   = -(-1)*pi/180;
LphiHipR0       = -paramIC(8)*(-1)*pi/180; %[rad]
RphiHipR0       = -paramIC(9)*(1)*pi/180; %[rad]


initialTargetAngle  = 70*pi/180;
initialTargetAngleR = 90*pi/180;

LTargetAngleInit    = initialTargetAngle;
LPreStimHFLinit     = LPreStimHFLst;
LPreStimGLUinit     = LPreStimGLUst;
LPreStimHAMinit     = LPreStimHAMst;
LPreStimRFinit      = LPreStimRFst;
LPreStimVASinit     = LPreStimVASst;
LPreStimBFSHinit    = LPreStimBFSHst;
LPreStimGASinit     = LPreStimGASst;
LPreStimSOLinit     = LPreStimSOLst;
LPreStimTAinit      = LPreStimTAst;
LTargetAngleRInit   = initialTargetAngleR;
LPreStimHABinit     = LPreStimHABst;
LPreStimHADinit     = LPreStimHADst;

RTargetAngleInit    = initialTargetAngle;
RPreStimHFLinit     = RPreStimHFLsw;
RPreStimGLUinit     = RPreStimGLUsw;
RPreStimHAMinit     = RPreStimHAMsw;
RPreStimRFinit      = RPreStimRFsw;
RTargetAngleRInit   = initialTargetAngleR;
RPreStimHABinit     = RPreStimHABsw;
RPreStimHADinit     = RPreStimHADsw;
