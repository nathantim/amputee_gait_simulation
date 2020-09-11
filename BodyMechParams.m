% BodyMechParams.m  - Set mechanical parameters of the model.
%
%    This parameter setup includes: 
%    1. segment geometries, masses and inertias,
%    2. muscle-skeleton mechanical links,
%    3. muscle mechanics, and
%    4. ground interaction.
%

%% obstacle
obstacle_height = 0.08;
obstacle_width = 0.15;
obstacle_depth = 0.02;
% obstacle_x = 1.7; %no fall?
% obstacle_x = 1.8; % fall
obstacle_x = 8.65; %fall for Prosthetic_2D 1.2 m/s
% obstacle_x = 8.10; %fall for Prosthetic_2D 0.9 m/s
% obstacle_x = 8.4; % fall
obstacle_y = -1.57; %fall for Prosthetic_2D 1.2 m/s
%%
% environment
g = 9.80665;
%roughGroundFlag = 1;
%load('groundHeight.mat')


% ---------------------
% Joint Soft Limits
% ---------------------

% angles at which soft limits engages
phiAnkleLowLimit =  -20*pi/180; %[rad]
phiAnkleUpLimit  = 40*pi/180; %[rad]

phiKneeUpLimit  = 1*pi/180; %[rad] % used previously
% phiKneeUpLimit  = -1.5*pi/180; %[rad]
% phiKneeUpLimit  = 5*pi/180; %[rad]
warning('Knee limit check, now: %d deg.', phiKneeUpLimit*180/pi);

phiHipUpLimit  = 50*pi/180; %[rad]

phiHipAbdLowLimit  = -15*pi/180; %[rad]
phiHipAbdUpLimit  = 50*pi/180; %[rad]

% soft block reference joint stiffness
c_jointstop     = 0.3 / (pi/180);  %[Nm/rad]

% soft block maximum joint stop relaxation speed
w_max_jointstop = 1 * pi/180; %[rad/s]


% ********************* %
% 1. BIPED SEGMENTATION %
% ********************* %

% ------------------------
% 1.1 General Foot Segment
% ------------------------

%foot dimensional properties
footLength = 0.2; %[m]
footBallToCenterDist = footLength/2; %[m]
footBallToCGDist = 0.14; %[m]
footCenterToCGDist = footBallToCGDist - footBallToCenterDist; %[m] 0.14 from ball
footBallToAnkleDist = 0.16; %[m]
footBallToHeelDist = footLength; %[m]
footCenterlineToBall = 0.1/2; %[m]
footCenterlineToHeel = 0.05/2; %[m]

%foot inertial properties
footMass  = 1.25; %[kg] 1.25
footMassAmp = 1; %kg
footInertia_z = 0.005; %[kg*m^2] foot inertia about y-axis with (harmut's value)
%footInertia = 0.0112; %[kg*m^2] foot inertia about y-axis from Winter Data
footInertia_x   = 0.0007;
footInertia_y   = 0.005;
footInertia = [footInertia_x footInertia_y footInertia_z];
footProsthInertia = [0 0 0];

% -------------------------
% 1.2 General Shank Segment
% -------------------------

shankLength = 0.5; %[m]
shankAnkleToCenterDist  = shankLength/2; %[m]
shankAnkleToCGDist = 0.3; %[m]
shankCenterToCGDist = shankAnkleToCGDist - shankAnkleToCenterDist; %[m]
shankAnkleToKneeDist = shankLength; %[m]
shankMass = 3.5; %[kg]
shankInertia_z = 0.05; %[kg*m^2] shank inertia with respect to axis ankle-CG-knee (scaled from other papers)
shankInertia_x   = 0.003;
shankInertia_y   = 0.05;
shankInertia = [shankInertia_x shankInertia_y shankInertia_z];

% shank prosthesis
shankProsthMass = 0.15; % kg
shankProsthInertia_z = 0.002;
shankProsthInertia_x =  1.2000e-04;
shankProsthInertia_y = 0.002;
shankProsthInertia = [shankProsthInertia_x shankProsthInertia_y shankProsthInertia_z];
% -------------------------
% 1.3 General Thigh Segment
% -------------------------

% total thigh length
thighLength = 0.5; %[m]
thighLateralOffset = 0.1;   %[m]
thighKneeToCenterDist = thighLength/2; %[m]
thighKneeToCG = 0.3;
thighCenterToCGDist = thighKneeToCG - thighKneeToCenterDist; %[m] 
thighKneeToHipDist = thighLength; %[m]
thighMass  = 8.5; %[kg]
thighAmpMass  = 8.5; %[kg]
thighInertia_z = 0.15; %[kg*m^2]
thighInertia_x   = 0.03;
thighInertia_y   = 0.15;
relThighSensorPos = 4/5;
thighAmpInertia = [thighInertia_x thighInertia_y thighInertia_z];
thighInertia = [thighInertia_x thighInertia_y thighInertia_z];

thighInertiaLow = [thighInertia_x*relThighSensorPos thighInertia_y*(relThighSensorPos)^3  thighInertia_z*(relThighSensorPos)^3];
thighInertiaHigh = [thighInertia_x*(1-relThighSensorPos) thighInertia_y*(1-relThighSensorPos)^3  thighInertia_z*(1-relThighSensorPos)^3];

% -----------------------------------------
% 1.4 General Head-Arms-Trunk (HAT) Segment
% -----------------------------------------

% HAT length
hatLength = 0.8; %[m]
hatWidth = 0.4; %[m]
hatThickness = 0.2; %[m]
hatHipToCenterDistLen = hatLength/2; %[m]
hatLeftHipToCenterDistWidth = .1; %[m]
hatLeftHipToCG = 0.35;
hatCenterToCGDist = hatLeftHipToCG - hatHipToCenterDistLen; %[m]
hatMass = 53.5; %[kg]
hatInertia_z = 2.5; %[kg*m^2] 
hatInertia_x = 1.0;
hatInertia_y = 4.0;
hatInertia = [hatInertia_x hatInertia_y hatInertia_z];

totalMass = 2*(footMass+shankMass+thighMass)+hatMass;
% --------------------------------
% 1.5 Thigh Segment Pressure Sheet
% --------------------------------

% reference compression corresponding to steady-state with HAT mass
DeltaThRef = 2e-3; %[m]
% DeltaThRef = 5e-3; %[m]

% interaction stiffness
k_pressure = hatMass * g / DeltaThRef; %[N/m]

% max relaxation speed (one side)
v_max_pressure = 0.5; %[m/s]

% -------------------------------------
% modifications for adding ankle height
% -------------------------------------
ankle_height = 0.08;
footBallToCGDist_y = ankle_height*footBallToCGDist/footBallToAnkleDist;

% shanke
shankLength = shankLength - ankle_height/2;
shankAnkleToCGDist = shankAnkleToCGDist - ankle_height/4;

% thigh
thighLength = thighLength - ankle_height/2; %[m]
thighKneeToCG = thighKneeToCG - ankle_height/4; %[m]

thighLengthAmp = thighLength - 0.1; % amputated thigh length
shankLengthAmp = shankLength - 0.1;

leg_l = [thighLength shankLength];
leg_0 = sum(leg_l); % [m] full leg length (from hip to ankle)
leg_lamp = [thighLengthAmp shankLengthAmp];
leg_0amp = sum(leg_lamp); % [m] full leg length (from hip to ankle)    





% ****************************** %
% 2. BIPED MUSCLE-SKELETON-LINKS %
% ****************************** %

% ----------------------------------------
% 2.1 Ankle Joint Specific Link Parameters
% ----------------------------------------

% =========================== %
% MUSCLE-SKELETON ATTACHMENTS %
% =========================== %
                         
% hip abductor (HAB)
rHAB      =      0.06; % [m]   constant lever contribution 
phirefHAB = 10*pi/180; % [rad] reference angle at which MTU length equals 
rhoHAB    =       0.7; %       sum of lopt and lslack 

% hip adductor (HAD)
rHAD      =      0.03; % [m]   constant lever contribution 
phirefHAD = 15*pi/180; % [rad] reference angle at which MTU length equals 
rhoHAD    =         1; %       sum of lopt and lslack 
       
% Hip FLexor group attachement
rHFL       =       0.08; % [m]   constant lever contribution 
phirefHFL  = (160-180)*pi/180; % [rad] reference angle at which MTU length equals 
rhoHFL     =        0.5; %       sum of lopt and lslack          

% GLUtei group attachement
rGLU       =       0.08; % [m]   constant lever contribution 
phirefGLU  = (120-180)*pi/180; % [rad] reference angle at which MTU length equals 
rhoGLU     =        0.5; %       sum of lopt and lslack 
                         
% HAMstring group attachement (hip)
rHAMh       = 0.08;         % [m]   constant lever contribution 
phirefHAMh  = (150-180)*pi/180;   % [rad] reference angle at which MTU length equals 
rhoHAMh     = 0.5;          %       sum of lopt and lslack 

% HAMstring group attachement (knee)
rHAMk       = 0.05;         % [m]   constant lever contribution 
phirefHAMk  = (180-180)*pi/180;   % [rad] reference angle at which MTU length equals 
rhoHAMk     = 0.5;          %       sum of lopt and lslack 

% RF group attachement (hip)
rRFh      =       0.08; % [m]   constant lever contribution 
phirefRFh = (170-180)*pi/180; % [rad] reference angle at which MTU length equals 
rhoRFh    =        0.3; %       sum of lopt and lslack 

% RF group attachement (knee)
rRFkmax     = 0.06;         % [m]   maximum lever contribution
rRFkmin     = 0.04;         % [m]   minimum lever contribution
phimaxRFk   = (180-165)*pi/180;   % [rad] angle of maximum lever contribution
phiminRFk   =  (180-45)*pi/180;   % [rad] angle of minimum lever contribution
phirefRFk   = (180-125)*pi/180;   % [rad] reference angle at which MTU length equals 
rhoRFk      = 0.5;          %       sum of lopt and lslack 
phiScaleRFk = acos(rRFkmin/rRFkmax)/(phiminRFk-phimaxRFk);

% VAStus group attachement
rVASmax     = 0.06;         % [m]   maximum lever contribution
rVASmin     = 0.04;         % [m]   minimum lever contribution
phimaxVAS   = (180-165)*pi/180;   % [rad] angle of maximum lever contribution
phiminVAS   =  (180-45)*pi/180;   % [rad] angle of minimum lever contribution
phirefVAS   = (180-120)*pi/180;   % [rad] reference angle at which MTU length equals 
rhoVAS      = 0.6;          %       sum of lopt and lslack
phiScaleVAS = acos(rVASmin/rVASmax)/(phiminVAS-phimaxVAS);

% BFSH group attachement
rBFSH    	= 0.04;         % [m]   constant lever contribution 
phirefBFSH 	= (180-160)*pi/180;   % [rad] reference angle at which MTU length equals 
rhoBFSH    	= 0.7;          %       sum of lopt and lslack
   
% GAStrocnemius attachement (knee joint)
rGASkmax    = 0.05;         % [m]   maximum lever contribution
rGASkmin    = 0.02;         % [m]   minimum lever contribution
phimaxGASk  = (180-140)*pi/180;   % [rad] angle of maximum lever contribution
phiminGASk  =  (180-45)*pi/180;   % [rad] angle of minimum lever contribution
phirefGASk  = (180-165)*pi/180;   % [rad] reference angle at which MTU length equals 
rhoGASk     = 0.7;          %       sum of lopt and lslack 
phiScaleGASk = acos(rGASkmin/rGASkmax)/(phiminGASk-phimaxGASk);

% GAStrocnemius attachement (ankle joint)
rGASamax    = 0.06;         % [m]   maximum lever contribution
rGASamin    = 0.02;         % [m]   minimum lever contribution
phimaxGASa  = (100-90)*pi/180;  	% [rad] angle of maximum lever contribution
phiminGASa  = (180-90)*pi/180; 	% [rad] angle of minimum lever contribution
phirefGASa  =  (80-90)*pi/180;  	% [rad] reference angle at which MTU length equals 
rhoGASa     =        0.7; 	%       sum of lopt and lslack 
phiScaleGASa  = acos(rGASamin/rGASamax)/(phiminGASa-phimaxGASa);

% SOLeus attachement
rSOLmax     = 0.06;         % [m]   maximum lever contribution
rSOLmin     = 0.02;         % [m]   minimum lever contribution
phimaxSOL   = (100-90)*pi/180;   % [rad] angle of maximum lever contribution
phiminSOL   = (180-90)*pi/180;   % [rad] angle of minimum lever contribution
phirefSOL   =  (90-90)*pi/180;   % [rad] reference angle at which MTU length equals 
rhoSOL      = 0.5;          %       sum of lopt and lslack 
phiScaleSOL = acos(rSOLmin/rSOLmax)/(phiminSOL-phimaxSOL);

% Tibialis Anterior attachement
rTAmax      = 0.04;         % [m]   maximum lever contribution
rTAmin      = 0.01;         % [m]   minimum lever contribution
phimaxTA    =  (80-90)*pi/180;   % [rad] angle of maximum lever contribution
phiminTA    = (180-90)*pi/180;   % [rad] angle of minimum lever contribution
phirefTA    = (110-90)*pi/180;   % [rad] reference angle at which MTU length equals 
phiScaleTA  = acos(rTAmin/rTAmax)/(phiminTA-phimaxTA);
rhoTA       = 0.7; 

% ************************* %
% 3. BIPED MUSCLE MECHANICS %
% ************************* %

% -----------------------------------
% 3.1 Shared Muscle Tendon Parameters
% -----------------------------------

% excitation-contraction coupling
preA =  0.01; %[] preactivation
tau  =  0.01; %[s] delay time constant

% contractile element (CE) force-length relationship
w    =   0.56; %[lopt] width
c    =   0.05; %[]; remaining force at +/- width

% CE force-velocity relationship
N    =   1.5; %[Fmax] eccentric force enhancement
K    =     5; %[] shape factor

% Series elastic element (SE) force-length relationship
eref =  0.04; %[lslack] tendon reference strain



% ------------------------------
% 3.2 Muscle-Specific Parameters
% ------------------------------

% Force factors for maximum amputated leg muscle force
ampHipFlexFactor = 0.65;
ampHipExtFactor = 0.6;
ampHipAbdFactor = 0.7;
ampHipAddFactor = 0.5;
Lfactor = (34.87/46);

% hip abductor (HAB)
FmaxHAB    =     3000; % maximum isometric force [N]
loptHAB    =     0.09; % optimum fiber length CE [m]
vmaxHAB    =       12; % maximum contraction velocity [lopt/s]
lslackHAB  =     0.07; % tendon slack length [m]

% amputated leg hip abductor (HAB)
FmaxHABamp    =     FmaxHAB*ampHipAbdFactor; % maximum isometric force [N]
loptHABamp    =     0.09; % optimum fiber length CE [m]
vmaxHABamp    =       12; % maximum contraction velocity [lopt/s]
lslackHABamp  =     0.07; % tendon slack length [m]

% hip adductor (HAD)
FmaxHAD    =     4500; % maximum isometric force [N]
loptHAD    =     0.10; % optimum fiber length CE [m]
vmaxHAD    =       12; % maximum contraction velocity [lopt/s]
lslackHAD  =     0.18; % tendon slack length [m]

% amputated leg hip adductor (HAD)
FmaxHADamp    =     FmaxHAD*ampHipAddFactor; % maximum isometric force [N]
loptHADamp    =     0.10; % optimum fiber length CE [m]
vmaxHADamp    =       12; % maximum contraction velocity [lopt/s]
lslackHADamp  =     0.18; % tendon slack length [m]

% hip flexor muscles
FmaxHFL   = 2000; % maximum isometric force [N]
loptHFL   = 0.11; % optimum fiber length CE [m]
vmaxHFL   =   12; % maximum contraction velocity [lopt/s]
lslackHFL = 0.10; % tendon slack length [m]

% amputated leg hip flexor muscles
FmaxHFLamp   = FmaxHFL*ampHipFlexFactor; % maximum isometric force [N]
loptHFLamp   = 0.11; % optimum fiber length CE [m]
vmaxHFLamp   =   12; % maximum contraction velocity [lopt/s]
lslackHFLamp = 0.10; % tendon slack length [m]

% glutei muscles
FmaxGLU   = 1500; % maximum isometric force [N]
loptGLU   = 0.11; % optimum fiber length CE [m]
vmaxGLU   =   12; % maximum contraction velocity [lopt/s]
lslackGLU = 0.13; % tendon slack length [m]

% amputated leg glutei muscles
FmaxGLUamp   = FmaxGLU*ampHipExtFactor; % maximum isometric force [N]
loptGLUamp   = 0.11; % optimum fiber length CE [m]
vmaxGLUamp   =   12; % maximum contraction velocity [lopt/s]
lslackGLUamp = 0.13; % tendon slack length [m]

% hamstring muscles
FmaxHAM   = 3000; % maximum isometric force [N]
loptHAM   = 0.10; % optimum fiber length CE [m]
vmaxHAM   =   12; % maximum contraction velocity [lopt/s]
lslackHAM = 0.31; % tendon slack length [m]

% amputated leg hamstring muscles
FmaxHAMamp   = FmaxHAM*ampHipExtFactor; % maximum isometric force [N]
loptHAMamp   = Lfactor*loptHAM; % optimum fiber length CE [m]
vmaxHAMamp   =   12; % maximum contraction velocity [lopt/s]
lslackHAMamp = Lfactor*lslackHAM; % tendon slack length [m]

% rectus femoris muscles
FmaxRF   = 1200; %  maximum isometric force [N]
loptRF   = 0.08; % optimum fiber length CE [m]
vmaxRF   =   12; % maximum contraction velocity [lopt/s]
lslackRF = 0.35; % tendon slack length [m]

% amputated leg rectus femoris muscles
FmaxRFamp   = FmaxRF*ampHipFlexFactor; %  maximum isometric force [N]
loptRFamp   = Lfactor*loptRF; % optimum fiber length CE [m]
vmaxRFamp   =   12; % maximum contraction velocity [lopt/s]
lslackRFamp = Lfactor*lslackRF; % tendon slack length [m]

% vasti muscles
FmaxVAS     = 6000; % maximum isometric force [N]
loptVAS     = 0.08; % optimum fiber length CE [m]
vmaxVAS     =   12; % maximum contraction velocity [lopt/s]
lslackVAS   = 0.23; % tendon slack length [m]

% BFSH
FmaxBFSH	=  350; % maximum isometric force [N]
loptBFSH    = 0.12; % optimum fiber length CE [m]
vmaxBFSH    =   12; %6 % maximum contraction velocity [lopt/s]
lslackBFSH  = 0.10; % tendon slack length [m]

% gastrocnemius muscle
FmaxGAS    = 1500; % maximum isometric force [N]
loptGAS    = 0.05; % optimum fiber length CE [m]
vmaxGAS    =   12; % maximum contraction velocity [lopt/s]
lslackGAS  = 0.40; % tendon slack length [m]

% soleus muscle
FmaxSOL    = 4000; % maximum isometric force [N]
loptSOL    = 0.04; % optimum fiber length CE [m]
vmaxSOL    =    6; % maximum contraction velocity [lopt/s]
lslackSOL  = 0.26; % tendon slack length [m]

% tibialis anterior
FmaxTA     =  800; % maximum isometric force [N]
loptTA     = 0.06; % optimum fiber length CE [m]
vmaxTA     =   12; % maximum contraction velocity [lopt/s]
lslackTA   = 0.24; % tendon slack length [m]


%Muscle type Percentages 
%(http://sikhinspiredfitness.forums-free.com/muscle-fibre-ratios-t156.html)
FT_SOL=11;
ST_SOL=89;
FT_TA=26.6;
ST_TA=73.4;
FT_GAS=49;
ST_GAS=51;
FT_VAS=56.3;
ST_VAS=43.7;
FT_GLU=47.6;
ST_GLU=52.4;
FT_HFL=50.8;%Psoas
ST_HFL=49.2;%Psoas
FT_HAM=65.6;%Bicep Femoris
ST_HAM=35.4;%Bicep Femoris
FT_HAB=85;
ST_HAB=15;
FT_HAD=58;
ST_HAD=42;

FT_BFSH=33.1;
ST_BFSH=66.9;
FT_RF=62.2;
ST_RF=37.8;

FT_GLUamp=47.6;
ST_GLUamp=52.4;
FT_HFLamp=50.8;%Psoas
ST_HFLamp=49.2;%Psoas
FT_HAMamp=65.6;%Bicep Femoris
ST_HAMamp=35.4;%Bicep Femoris
FT_HABamp=85;
ST_HABamp=15;
FT_HADamp=58;
ST_HADamp=42;
FT_RFamp=62.2;
ST_RFamp=37.8;

% warning('Unknown muscle composition BFSH, RF');
% *************************** %
% 4. Ground Interaction Model %
% *************************** %

% ----------------------
% 4.1 Vertical component
% ----------------------

% stiffness of vertical ground interaction
k_gz = (2*(footMass+shankMass+thighMass)+hatMass)*g/0.01; %[N/m]
k_gn = k_gz;
k_gt = k_gz;

% max relaxation speed of vertical ground interaction
v_gz_max = 0.03; %[m/s]
v_gn_max = v_gz_max; %[m/s]
v_gt_max = v_gz_max; %[m/s]

% ------------------------
% 4.2 Horizontal component
% ------------------------

% sliding friction coefficient
mu_slide = 0.8;

% sliding to stiction transition velocity limit
vLimit = 0.01; %[m/s]

% stiffness of horizontal ground stiction
k_gx = (2*(footMass+shankMass+thighMass)+hatMass)*g/0.1; %[N/m] 0.01

% max relaxation speed of horizontal ground stiction
v_gx_max = 0.03; %[m/s] 0.03

% stiction to sliding transition coefficient
mu_stick = 0.9;


% --------------
% for 3D contact
% --------------

n_Cnt = 8;

k_gn    = k_gn/2;
k_gt    = k_gt/2;

