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
% LheadingIntGain =              GainsCoronal(14);
        
%% transition from stance to swing
LtransSupst_C        = GainsCoronal(14);
Ltranssw_C           = GainsCoronal(15);

%% Prestimulations
% Stance
LPreStimHABst        = GainsCoronal(16);
LPreStimHADst        = GainsCoronal(17);
% Swing
LPreStimHABsw        = GainsCoronal(18);
LPreStimHADsw        = GainsCoronal(19);


%% Right
%% Coronal 
%stance
% M1: realize compliant leg
RGainFHABst          = GainsCoronal(20);

% M3: balance trunk
RGainPhiHATHABst     = GainsCoronal(21);
RGainDphiHATHABst    = GainsCoronal(22);
RGainPhiHATHADst     = GainsCoronal(23);
RGainDphiHATHADst    = GainsCoronal(24);

% M4: compensate swing leg
RGainSHABcHABst      = GainsCoronal(25);
RGainSHADcHADst      = GainsCoronal(26);

% swing
% M6: swing hip
RGainLHABsw          = GainsCoronal(27);
RGainLHADsw          = GainsCoronal(28);

%% Target leg angle stuff
RsimbiconLegAngle0_C = GainsCoronal(29);
RsimbiconGainD_C     = GainsCoronal(30);
RsimbiconGainV_C     = GainsCoronal(31);

RheadingGain =              GainsCoronal(32);
% RheadingIntGain =              GainsCoronal(34);

%% transition from stance to swing
RtransSupst_C        = GainsCoronal(33);
Rtranssw_C           = GainsCoronal(34);

%% Prestimulations
% Stance
RPreStimHABst        = GainsCoronal(35);
RPreStimHADst        = GainsCoronal(36);

% Swing
RPreStimHABsw        = GainsCoronal(37);
RPreStimHADsw        = GainsCoronal(38);



