% g1 = 1;%3.5; 
% g2 = 1;%0.1;
% g3 = 1;
c_swing_comp     = @(dx)(213.5932*(1./abs(dx))-4927.5);      % Ns/m
c_swing_ext      = @(dx)(146.3288*(1./abs(dx))-8808.5);      % Ns/m
c_stance_comp   = @(dx)(2.1443*(1./abs(dx)) + 885.0653);    % Ns/m
c_stance_ext    = @(dx)(7.0819*(1./abs(dx)) + 65579);       % Ns/m

vel_vect = [ 5 10 20 35 50 70 100 200];
dx_comp = fliplr(-1*vel_vect./(60*1000)); % 0.001:0.001:1 5 10  300 400 500 600 1000
dx_ext  =    vel_vect./(60*1000);


dx = [(dx_comp) 0 dx_ext];

c_swing_comp_tab  = ([58000 124000 178000 251000 363000 635000]);
c_swing_ext_tab   = fliplr([33700 79000 117000 167000 244000 429000]);

c_stance_comp_tab  = ([1340 2110 2600 3720 4910 7080]);
c_stance_ext_tab   = fliplr([61300 70000 74500 77500 81300 83200]);


c_swing = [c_swing_comp(dx_comp) 0 c_swing_ext(dx_ext)];
c_stance = [c_stance_comp(dx_comp) 0 c_stance_ext(dx_ext)];
F_swing = [c_swing_comp(dx_comp).*dx_comp 0 c_swing_ext(dx_ext).*dx_ext];
F_stance = [c_stance_comp(dx_comp).*dx_comp 0 c_stance_ext(dx_ext).*dx_ext];



%% init param

j9_i = -99.5;   % deg
j12_i = 73.55;  % deg
j15_i = 90;     % deg

angle_offset = 0;% deg

c_fric = 0.00235;                  % Nms/deg   nice plot Friction test 

L0_swing = 0.0896;              % m     nice plot Friction test
% L0_swing = 0.0869;            % m  length used for 0 position  visualization
L0_stance =  0.08925;           % m    nice plot Friction test
k_stance = 130000;              % N/m
k_swing = 18750;                % N/m


c_swing_comp_a1 = 213.5932;     % Ns/m
c_swing_comp_a0 = -4927.5;      % (Ns/m)^2
c_swing_ext_a1 = 146.3288;      % Ns/m
c_swing_ext_a0 = -8808.5;       % (Ns/m)^2

c_stance_comp_a0 = 885.0653;    % Ns/m
c_stance_comp_a1 = 2.1443;      % (Ns/m)^2
c_stance_ext_a0 = 65579;        % Ns/m
c_stance_ext_a1 = 7.0819;       % (Ns/m)^2


%% Element lengths
L1  = 88.5*1e-3;    % m
L2  = 1.7*1e-3;     % m
L3  = 40.25*1e-3;   % m
L4  = 14.9*1e-3;    % m
L6  = 95*1e-3;      % m
L7  = 8.2*1e-3;     % m
L9  = 7.9*1e-3;     % m
L10 = 3.3*1e-3;     % m
L11 = 76.95*1e-3;   % m
L12 = 2.8*1e-3;     % m
L13 = 26*1e-3;      % m
L14 = 17.7*1e-3;    % m
L15 = 1.7*1e-3;     % m
L16 = 25.1*1e-3;    % m


%% Element center of mass location
cg1     = (3.6/10.4)*L1;    % m
cg2     = 0;                % m
cg3     = 0;                % m               
cg4     = 0;                % m
cg9     = 0.5*L9;           % m
cg10    = 0.0;              % m
cg6     = 1/2*L6;           % m
cg7     = 0;                % m
cg16    = 1/2*L16;          % m
cg14    = 0;                % m
cg13    = 0;                % m
cg15    = 0;                % m
cg11    = (5.45/11.05)*L11; % m
cg12    = 0;                % m

%% Element angle with previous connection 
a_shank_1   = 18;       % deg
a_1_2       = -90;      % deg
a_1_3       = -112;     % deg
a_1_4       = -98;      % deg
a_9_10      = -118;     % deg
a_6_7       = 90;       % deg
a_16_14     = 116;      % deg
a_16_13     = 122;      % deg
a_16_15     = 34;       % deg
a_16_thigh  = -10;      % deg
a_11_12     = -90;      % deg

%% Lumped element mass
m1234       = 253.3*1e-3;   % kg
m910        = 49.5*1e-3;    % kg
m67         = 123.8*1e-3;   % kg
m13141516   = 196.6*1e-3;   % kg
m1112       = 58.3*1e-3;    % kg

%% Lumped element inertoa
J1234       = (25.96*1e4)*1e-9; % kgm^2
J910        = (4130)*1e-9;      % kgm^2
J67         = (1.18*1e5)*1e-9;  % kgm^2
J13141516   = (6.86*1e4)*1e-9;  % kgm^2
J1112       = (3.59*1e4)*1e-9;  % kgm^2

%% Used for tests
% m30 = 89.6*1e-3; % m
L_shank = 0.3;  % m
L_thigh = 0.3;  % m
m_shank = 150*1e-3; % kg
m_thigh = 8; % kg
% J8 = (4.19*1e4)*1e-9; % kgm^2
% m8 = 143.8*1e-3; % kg
J_shank = m_shank*L_shank^2/12; % kgm^2
J_thigh = m_thigh*L_thigh^2/12; % kgm^2
% J30 = (6.36*1e4)*1e-9; % kgm^2