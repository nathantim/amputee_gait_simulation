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

%% transition from stance to swing
LtransSupst_C        = GainsCoronal(13);
Ltranssw_C           = GainsCoronal(14);

%% Prestimulations
% Stance
LPreStimHABst        = GainsCoronal(15);
LPreStimHADst        = GainsCoronal(16);

% Swing
LPreStimHABsw        = GainsCoronal(17);
LPreStimHADsw        = GainsCoronal(18);


%% Right
%% Coronal 
%stance
% M1: realize compliant leg
RGainFHABst          = GainsCoronal(19);

% M3: balance trunk
RGainPhiHATHABst     = GainsCoronal(20);
RGainDphiHATHABst    = GainsCoronal(21);
RGainPhiHATHADst     = GainsCoronal(22);
RGainDphiHATHADst    = GainsCoronal(23);

% M4: compensate swing leg
RGainSHABcHABst      = GainsCoronal(24);
RGainSHADcHADst      = GainsCoronal(25);

% swing
% M6: swing hip
RGainLHABsw          = GainsCoronal(26);
RGainLHADsw          = GainsCoronal(27);

%% Target leg angle stuff
RsimbiconLegAngle0_C = GainsCoronal(28);
RsimbiconGainD_C     = GainsCoronal(29);
RsimbiconGainV_C     = GainsCoronal(30);

%% transition from stance to swing
RtransSupst_C        = GainsCoronal(31);
Rtranssw_C           = GainsCoronal(32);

%% Prestimulations
% Stance
RPreStimHABst        = GainsCoronal(33);
RPreStimHADst        = GainsCoronal(34);

% Swing
RPreStimHABsw        = GainsCoronal(35);
RPreStimHADsw        = GainsCoronal(36);



