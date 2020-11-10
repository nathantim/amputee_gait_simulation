% BodyMechParams;
% ControlParams;
% OptimParams;
% Prosthesis3R60Params;
 
%% Left
%% Coronal 
%stance
% M1: realize compliant leg
LGainFHABst          = GainsCoronal(1);

% M3: balance trunk
LGainPhiHATHABst     = GainsCoronal(2);
LGainDphiHATHABst    = GainsCoronal(3);
LGainPhiHATHADst     = GainsCoronal(4);
LGainDphiHATHADst    = GainsCoronal(5);

% M4: compensate swing leg
LGainSHABcHABst      = GainsCoronal(6);
LGainSHADcHADst      = GainsCoronal(7);

% swing
% M6: swing hip
LGainLHABsw          = GainsCoronal(8);
LGainLHADsw          = GainsCoronal(9);

%% Target leg angle stuff
LsimbiconLegAngle0_C = GainsCoronal(10);
LsimbiconGainD_C     = GainsCoronal(11);
LsimbiconGainV_C     = GainsCoronal(12);

LheadingGain =              GainsCoronal(13);
LheadingIntGain =              GainsCoronal(14);
        
%% transition from stance to swing
LtransSupst_C        = GainsCoronal(15);
Ltranssw_C           = GainsCoronal(16);

%% Prestimulations
% Stance
LPreStimHABst        = GainsCoronal(17);
LPreStimHADst        = GainsCoronal(18);

% Swing
LPreStimHABsw        = GainsCoronal(19);
LPreStimHADsw        = GainsCoronal(20);


%% Right
%% Coronal 
%stance
% M1: realize compliant leg
RGainFHABst          = GainsCoronal(21);

% M3: balance trunk
RGainPhiHATHABst     = GainsCoronal(22);
RGainDphiHATHABst    = GainsCoronal(23);
RGainPhiHATHADst     = GainsCoronal(24);
RGainDphiHATHADst    = GainsCoronal(25);

% M4: compensate swing leg
RGainSHABcHABst      = GainsCoronal(26);
RGainSHADcHADst      = GainsCoronal(27);

% swing
% M6: swing hip
RGainLHABsw          = GainsCoronal(28);
RGainLHADsw          = GainsCoronal(29);

%% Target leg angle stuff
RsimbiconLegAngle0_C = GainsCoronal(30);
RsimbiconGainD_C     = GainsCoronal(31);
RsimbiconGainV_C     = GainsCoronal(32);

RheadingGain =              GainsCoronal(33);
RheadingIntGain =              GainsCoronal(34);

%% transition from stance to swing
RtransSupst_C        = GainsCoronal(35);
Rtranssw_C           = GainsCoronal(36);

%% Prestimulations
% Stance
RPreStimHABst        = GainsCoronal(37);
RPreStimHADst        = GainsCoronal(38);

% Swing
RPreStimHABsw        = GainsCoronal(39);
RPreStimHADsw        = GainsCoronal(40);



