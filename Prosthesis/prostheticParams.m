% ****************** %
% Initial Conditions %
% ****************** %
kneeInitialAngle  = -RphiKnee0;  %rad
ankleInitialAngle = -RphiAnkle0; %rad

% *************** %
% Mass Parameters %
% *************** %
%all masses given in grams
%all lengths given in millimeters
%Inertias given in g*cm^2

gmm2TOgcm2 = 0.01; %convert from g-mm^2 to g-cm^2
gcm2TOkgm2 = 1e-7; %convert from g-cm^2 to kg-m^2

% ----------- %
% Knee Stator %
% ----------- %
kneeStatorMass = 1519.39; %g
kneeStatorCG = [1.81, 13.35, 8.22]; %mm 
kneeStatorMomentOfInertia =  [2616289.10, 1872218.67, 3184916.66]*gmm2TOgcm2; %gcm^2
kneeStatorProductOfInertia = [-175486.41, 8667.81, 43953.96]*gmm2TOgcm2; %gcm^2

% ----- %
% Shank %
% ----- %
shankMassp = 2329.69; %g
shankCG = [10.81 -112.51 10.40]; %mm 
shankMomentOfInertia =  [33104383.41, 4835678.68, 34648284.45]*gmm2TOgcm2; %gcm^2
shankProductOfInertia = [1189363.95, -116651.15, 1193428.67]*gmm2TOgcm2; %gcm^2

% ---------------- %
% Ankle Input Link %
% ---------------- %
ankleInputMass = 2329.69; %g
ankleInputCG = [23.66, 0, 18.53]; %mm 
ankleInputMomentOfInertia =  [1039570.43, 1679088.72, 997440.14]*gmm2TOgcm2; %gcm^2
ankleInputProductOfInertia = [22.84, 7593.67, -36.11]*gmm2TOgcm2; %gcm^2

% --------------- %
% Ankle Tendon %
% --------------- %
ankleTendonMass = 36.26; %g
ankleTendonCG = [0 -164.40 0]; %mm 
ankleTendonMomentOfInertia =  [621439.62, 1974.66, 622335.85]*gmm2TOgcm2; %gcm^2
ankleTendonProductOfInertia = [0.00, 0.00, -1.64]*gmm2TOgcm2; %gcm^2

% ---- %
% Foot %
% ---- %
footMassp = 690.10; %g
footCG = [12.77, -35.78 -5.45]; %mm 
footMomentOfInertia =  [709202.82, 2703199.88, 2795607.30]*gmm2TOgcm2; %gcm^2
footProductOfInertia = [-134642.83, 48061.11, -341142.07]*gmm2TOgcm2; %gcm^2

% ---------- %
% Motor Rotor %
% ---------- %
motorRotorMass = 365.43; %g
motorRotorCG = [0, 0.02, 13.03]; %mm 
motorRotorMomentOfInertia =  [213937.52, 213912.17, 173167.45]*gmm2TOgcm2; %gcm^2
motorRotorProductOfInertia = [61.74, 0, 0]*gmm2TOgcm2; %gcm^2
motorRotorInertia = motorRotorMomentOfInertia(3)*gcm2TOkgm2; %kg-m^2

% *************************** %
% Motor Electrical Parameters %
% *************************** %

motorResistance     = .055; %ohms
motorInductance     = 120e-6; %Henrys
motorTorsionalConst = 0.130; %N-m/A
motorBackEMF        = 0.09167; %V*s/rad
motorMaxCurrent     = 4.5/motorTorsionalConst; %A
motorMaxVoltage     = 48; %V

% ************************** %
% Gear and Spring Parameters %
% ************************** %

% ------------------------- %
% Friction Model Parameters %
% ------------------------- %
dryFrictionStiffness = 1e2;
dryFrictionDamping = 0.1*sqrt(dryFrictionStiffness);
dryFrictionVelThresh = 0.25;

% -------------------------------------- %
% Knee Harmonic Drive and SEA parameters %
% -------------------------------------- %
kneeGearRatio = 50;
kneeGearEff = 1.00;
kneeSEAStiffness = 1500; %N-m/rad
kneeSEADamping   = kneeSEAStiffness/100; %N-m-s/rad
kneeBackDriveGain = 0.8;

kneeFilterSEA = 100;
kneePgain = 0.01;
kneeIgain = 0.00;
kneeDgain = 0.001;
kneeFilterPID = 100;

kneePgainC = kneePgain/motorResistance;
kneeIgainC = kneeIgain/motorResistance;
kneeDgainC = kneeDgain/motorResistance;

kneeCJointstop     = 0.3 / (pi/180); %[Nm/rad]  soft block reference joint stiffness
kneeWMaxJointstop = 1/(pi/180); %[rad/s] soft block maximum joint stop relaxation speed

kneeExtStatic = .463;
kneeExtCoulomb = 0.75*kneeExtStatic;
kneeExtDamping = 0;
kneeIntStatic = .1271;
kneeIntCoulomb = 0.75*kneeIntStatic;
kneeIntDamping = 0;

% --------------------------------------- %
% Ankle Harmonic Drive and SEA parameters %
% --------------------------------------- %
ankleGearRatio = 50;
ankleGearEff = 1.00;
ankleSEAStiffness = 1500; %N/m
ankleSEADamping   = ankleSEAStiffness/100; %N-s/m
ankleBackDriveGain = 0.8;

ankleFilterSEA = 100;
anklePgain = 0.01;
ankleIgain = 0.00;
ankleDgain = 0.001;
ankleFilterPID = 100;
anklePgainC = anklePgain/motorResistance;
ankleIgainC = ankleIgain/motorResistance;
ankleDgainC = ankleDgain/motorResistance;

%link lengths
FourBarL0 = 0.3124988;
FourBarL1 = 0.080;
FourBarL2 = 0.3288;
FourBarL3 = 0.0826238;

% ------------------------------- %
% Ankle Parallel Spring and Limit %
% ------------------------------- %
ankleParallelSpringStiffness =  190; %N-m/rad
ankleParallelSpringDamping =  ankleParallelSpringStiffness/200; %N-m-s/rad
ankleParallelSpringOffset =  0; %rad

anklePlantarLimit = -35*pi/180; %rad
ankleCJointstop    = 1/ (pi/180);  %[Nm/rad]  soft block reference joint stiffness
ankleWMaxJointstop = 1 ; %[rad/s] soft block maximum joint stop relaxation speed

ankleIntStatic = .1271;
ankleIntCoulomb = 0.75*ankleIntStatic;
ankleIntDamping = 0;
