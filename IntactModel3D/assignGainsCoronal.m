% ASSIGNGAINSCORONAL        Script that assigns values to the Coronal neurological controller variables from the Gain vector 

 
%% Left
%% Coronal 
%stance
% M1: realize compliant leg
GainFHABst          = GainsCoronal(1);

% M3: balance trunk
GainPhiHATHABst     = GainsCoronal(2);
GainDphiHATHABst    = GainsCoronal(3);
GainPhiHATHADst     = GainsCoronal(4);
GainDphiHATHADst    = GainsCoronal(5);

% M4: compensate swing leg
GainSHABcHABst      = GainsCoronal(6);
GainSHADcHADst      = GainsCoronal(7);

% swing
% M6: swing hip
GainLHABsw          = GainsCoronal(8);
GainLHADsw          = GainsCoronal(9);

%% Target leg angle stuff
simbiconLegAngle0_C = GainsCoronal(10);
simbiconGainD_C     = GainsCoronal(11);
simbiconGainV_C     = GainsCoronal(12);

%% transition from stance to swing
transSupst_C        = GainsCoronal(13);
transsw_C           = GainsCoronal(14);

%% Prestimulations
% Stance
PreStimHABst        = GainsCoronal(15);
PreStimHADst        = GainsCoronal(16);

% Swing
PreStimHABsw        = GainsCoronal(17);
PreStimHADsw        = GainsCoronal(18);


