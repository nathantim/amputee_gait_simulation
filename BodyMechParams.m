% BodyMechParams.m  - Set mechanical parameters of the model.
%
%    This parameter setup includes: 
%    1. segment geometries, masses and inertias,
%    2. muscle-skeleton mechanical links,
%    3. muscle mechanics, and
%    4. ground interaction.
%

% environment
g = 9.80665;
%roughGroundFlag = 1;
%load('groundHeight.mat')

% ********************* %
% 1. BIPED SEGMENTATION %
% ********************* %

% ------------------------
% 1.1 General Foot Segment
% ------------------------

%foot dimensional properties
footLength = 0.2; %[m]
footBallToCenterDist = footLength/2;
footCenterToCGDist = 0.14 - footBallToCenterDist; %[m] 0.14 from ball
footBallToAnkleDist = 0.16; %[m]
footBallToHeelDist = footLength; %[m]

%foot inertial properties
footMass  = 1.25; %[kg] 1.25
footInertia = 0.005; %[kg*m^2] foot inertia about y-axis with (harmut's value)
%footInertia = 0.0112; %[kg*m^2] foot inertia about y-axis from Winter Data

% -------------------------
% 1.2 General Shank Segment
% -------------------------

shankLength = 0.5; %[m]
shankAnkleToCenterDist  = shankLength/2; %[m]
shankCenterToCGDist = 0.3 - shankAnkleToCenterDist; %[m]
shankAnkleToKneeDist = shankLength; %[m]
shankMass = 3.5; %[kg]
shankInertia = 0.05; %[kg*m^2] shank inertia with respect to axis ankle-CG-knee (scaled from other papers)

% -------------------------
% 1.3 General Thigh Segment
% -------------------------

% total thigh length
thighLength = 0.5; %[m]
thighKneeToCenterDist = thighLength/2; %[m]
thighCenterToCGDist = 0.3 - thighKneeToCenterDist; %[m] 
thighKneeToHipDist = thighLength; %[m]
thighMass  = 8.5; %[kg]
thighInertia = 0.15; %[kg*m^2]

% -----------------------------------------
% 1.4 General Head-Arms-Trunk (HAT) Segment
% -----------------------------------------

% HAT length
hatLength = 0.8; %[m]
hatWidth = 0.4; %[m]
hatThickness = 0.2; %[m]
hatHipToCenterDistLen = hatLength/2; %[m]
hatLeftHipToCenterDistWidth = .15; %[m]
hatCenterToCGDist = 0.35 - hatHipToCenterDistLen; %[m]
hatMass = 53.5; %[kg]
hatInertia = 3; %[kg*m^2] 

totalMass = 2*(footMass+shankMass+thighMass)+hatMass;
% --------------------------------
% 1.5 Thigh Segment Pressure Sheet
% --------------------------------

% reference compression corresponding to steady-state with HAT mass
DeltaThRef = 2e-3; %[m]
%DeltaThRef = 5e-3; %[m]

% interaction stiffness
k_pressure = hatMass * g / DeltaThRef; %[N/m]

% max relaxation speed (one side)
v_max_pressure = 0.5; %[m/s]

% ---------------------
% 1.6 Joint Soft Limits
% ---------------------

% angles at which soft limits engages
phiAnkleLowLimit =  -20*pi/180; %[rad]
phiAnkleUpLimit  = 40*pi/180; %[rad]

phiKneeUpLimit  = 5*pi/180; %[rad]

phiHipUpLimit  = 50*pi/180; %[rad]

% soft block reference joint stiffness
c_jointstop     = 0.3 / (pi/180);  %[Nm/rad]

% soft block maximum joint stop relaxation speed
w_max_jointstop = 1 * pi/180; %[rad/s]


% ****************************** %
% 2. BIPED MUSCLE-SKELETON-LINKS %
% ****************************** %

% ----------------------------------------
% 2.1 Ankle Joint Specific Link Parameters
% ----------------------------------------

%%% ankle joint%%%
% SOLeus attachement
rSOL       =       0.05; % [m] radius 
phimaxSOL  = 20*pi/180; % [rad] angle of maximum lever contribution
phirefSOL  =  -10*pi/180; % [rad] reference angle at which MTU length equals sum of lopt and lslack
rhoSOL     =        0.5; %        

% Tibialis Anterior attachement
rTA       =        0.04; % [m]   constant lever contribution 
phimaxTA   =  -10*pi/180; % [rad] angle of maximum lever contribution
phirefTA   = 20*pi/180; % [rad] reference angle at which MTU length equals 
rhoTA      =        0.7; 

% GAStrocnemius attachement 
rGASa      =       0.05; % [m]   constant lever contribution 
phimaxGASa = 20*pi/180; % [rad] angle of maximum lever contribution
phirefGASa =  -10*pi/180; % [rad] reference angle at which MTU length equals 
rhoGASa    =        0.7; %       sum of lopt and lslack 

% GAStrocnemius attachement (knee joint)
rGASk      =       0.05; % [m]   constant lever contribution 
phimaxGASk = 40*pi/180; % [rad] angle of maximum lever contribution
phirefGASk = 15*pi/180; % [rad] reference angle at which MTU length equals 
rhoGASk    =        0.7; %       sum of lopt and lslack 

% VAStus group attachement
rVAS       =       0.06; % [m]   constant lever contribution 
phimaxVAS  = 15*pi/180; % [rad] angle of maximum lever contribution
phirefVAS  = 55*pi/180; % [rad] reference angle at which MTU length equals 
rhoVAS     =        0.7; %       sum of lopt and lslack 
                       
% HAMstring group attachement (knee)
rHAMk      =       0.05; % [m]   constant lever contribution 
phimaxHAMk = 0*pi/180; % [rad] angle of maximum lever contribution
phirefHAMk = 0*pi/180; % [rad] reference angle at which MTU length equals 
rhoHAMk    =        0.7; %       sum of lopt and lslack 
                         
% HAMstring group attachement (hip)
rHAMh      =       0.08; % [m]   constant lever contribution 
phirefHAMh = -25*pi/180; % [rad] reference angle at which MTU length equals 
rhoHAMh    =        0.7; %       sum of lopt and lslack 

% GLUtei group attachement
rGLU       =       0.10; % [m]   constant lever contribution 
phirefGLU  = -30*pi/180; % [rad] reference angle at which MTU length equals 
rhoGLU     =        0.5; %       sum of lopt and lslack 
                         
% Hip FLexor group attachement
rHFL       =       0.10; % [m]   constant lever contribution 
phirefHFL  = 0*pi/180; % [rad] reference angle at which MTU length equals 
rhoHFL     =        0.5; %       sum of lopt and lslack 

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

% soleus muscle
FmaxSOL    = 4000; % maximum isometric force [N]
loptSOL    = 0.04; % optimum fiber length CE [m]
vmaxSOL    =    6; % maximum contraction velocity [lopt/s]
lslackSOL  = 0.26; % tendon slack length [m]

% gastrocnemius muscle
FmaxGAS    = 1500; % maximum isometric force [N]
loptGAS    = 0.05; % optimum fiber length CE [m]
vmaxGAS    =   12; % maximum contraction velocity [lopt/s]
lslackGAS  = 0.40; % tendon slack length [m]

% tibialis anterior
FmaxTA     =  800; % maximum isometric force [N]
loptTA     = 0.06; % optimum fiber length CE [m]
vmaxTA     =   12; % maximum contraction velocity [lopt/s]
lslackTA   = 0.24; % tendon slack length [m]

% vasti muscles
FmaxVAS    = 6000; % maximum isometric force [N]
loptVAS    = 0.08; % optimum fiber length CE [m]
vmaxVAS    =   12; % maximum contraction velocity [lopt/s]
lslackVAS  = 0.23; % tendon slack length [m]

% hamstring muscles
FmaxHAM   = 3000; % maximum isometric force [N]
loptHAM   = 0.10; % optimum fiber length CE [m]
vmaxHAM   =   12; % maximum contraction velocity [lopt/s]
lslackHAM = 0.31; % tendon slack length [m]

% amputated hamstring muscles
FmaxHAMCut   = 3000; % maximum isometric force [N]
loptHAMCut   = (34.87/46)*0.10; % optimum fiber length CE [m]
vmaxHAMCut   = 12; % maximum contraction velocity [lopt/s]
lslackHAMCut = (34.87/46)*0.31; % tendon slack length [m]

% glutei Cscles
FmaxGLU   = 1500; % maximum isometric force [N]
loptGLU   = 0.11; % optimum fiber length CE [m]
vmaxGLU   =   12; % maximum contraction velocity [lopt/s]
lslackGLU = 0.13; % tendon slack length [m]

% glutei muscles
FmaxHFL   = 2000; % maximum isometric force [N]
loptHFL   = 0.11; % optimum fiber length CE [m]
vmaxHFL   =   12; % maximum contraction velocity [lopt/s]
lslackHFL = 0.10; % tendon slack length [m]

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
