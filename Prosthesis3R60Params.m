% g1 = 1;%3.5; 
% g2 = 1;%0.1;
% g3 = 1;
c_swing_comp     = @(dx)(213.5932*(1./abs(dx))-4927.5);      % Ns/m
c_swing_ext      = @(dx)(146.3288*(1./abs(dx))-8808.5);      % Ns/m
c_stance_comp   = @(dx)(2.1443*(1./abs(dx)) + 885.0653);    % Ns/m
c_stance_ext    = @(dx)(7.0819*(1./abs(dx)) + 65579);       % Ns/m

% nice friction test plot
% dx_comp = fliplr(-1*[20 35 50 70 100 200]./(60*1000)); % 0.001:0.001:1 5 10  300 400 500 600 1000
% dx_ext  =    [20 35 50 70 100 200]./(60*1000);
vel_vect = [1e-1 1 5 10 20 35 50 70 100 200 300 400 500 700 900];
dx_comp = fliplr(-1*vel_vect./(60*1000)); % 0.001:0.001:1 5 10  300 400 500 600 1000
dx_ext  =    vel_vect./(60*1000);

% dx = [fliplr(dx_comp) -0.00005 0 0.00005 dx_ext];
dx = [(dx_comp) 0 dx_ext];

c_swing_comp_tab  = ([58000 124000 178000 251000 363000 635000]);
c_swing_ext_tab   = fliplr([33700 79000 117000 167000 244000 429000]);

c_stance_comp_tab  = ([1340 2110 2600 3720 4910 7080]);
c_stance_ext_tab   = fliplr([61300 70000 74500 77500 81300 83200]);

% c_swing = [c_swing_comp_tab 705000 0 529000 c_swing_ext_tab];
% c_stance = [c_stance_comp_tab 8080 0 93200 c_stance_ext_tab];
% c_swing = [c_swing_comp_tab 0 c_swing_ext_tab];
% c_stance = [c_stance_comp_tab 0 c_stance_ext_tab];
% F_swing = [c_swing_comp_tab.*dx_comp 0 c_swing_ext_tab.*dx_ext];
% F_stance = [c_stance_comp_tab.*dx_comp 0 c_stance_ext_tab.*dx_ext];

c_swing = [c_swing_comp(dx_comp) 0 c_swing_ext(dx_ext)];
c_stance = [c_stance_comp(dx_comp) 0 c_stance_ext(dx_ext)];
F_swing = [c_swing_comp(dx_comp).*dx_comp 0 c_swing_ext(dx_ext).*dx_ext];
F_stance = [c_stance_comp(dx_comp).*dx_comp 0 c_stance_ext(dx_ext).*dx_ext];

% c_stance = [c_stance_ext(dx_comp) c_stance_comp(dx_ext)];

%% init param
% (almost) zero knee angle:
% L0_swing = 0.0896;              % m
% j10_i = -25.4597;
% j13_i = -42.8862;
% j15_i = 115.697;

% swing phase test
% j10_i = 7.5;
% j13_i = -4.07996;
% j15_i = 129.2;

% L0_swing = 0.0869;              % m
% zero angle 
j10_i = -14.8;%77.49-90;
j13_i = 10;%-27.4019;

j12_i_0 = 73.55;
j15_i_0 = 90;%6.46;
j9_i_0 = -99.5;

%% VANDAEL zero angle 
j10_i_V = -9.2557;%-9;%
j13_i_V = -21.697 - 0.3796;%-27.4019;

j12_i_V = 73.55;
j15_i_V = 112-18+21.697;%115.697;
j9_i_V = 10;%-108.945;%-122+10-j10_i_V;

%% % distance 0.0869 for knee angle 0 for swing element
% % j10_i = -14.8;%77.49-90;
% % j13_i = 10;%-27.4019;
% % 
% % j12_i_0 = 58.3873;
% % j15_i_0 = 94.0079;%6.46;
% % j9_i_0 = -110.541;
% j9_i_0 = -99.5;

% j10_i = 77.49-90;
% j12_i = 79;
% j13_i = -5;
% j15_i = 116.46;

% Friction phase test
j10_i_f = 7.5; % high
j9_i_f = -169.052; % none
j12_i_f = -12.6727; % low
j13_i_f = -4.07996; % none
% j15_i_f = 117.546;

j15_i_f = 129.2; % none

%%
j10_i = -14.8;%77.49-90;
j13_i = 10;%-27.4019;

j12_i = 73.55;
j15_i = 90;%6.46;
j9_i = -99.5;

%%
target_angle = 0;
angle_offset = 0;%2.7424;%0;%3.4272; % deg
dt_visual = 0.001;

% c_fric = 0.00165;                  % Nms/deg nice plot ICR
c_fric = 0.00235;                  % Nms/deg   nice plot Friction test 
% c_fric = 0.00435;                  % Nms/deg  

% c_fric = 0.003523;                  % Nms/deg
% c_fric = 0.07;                  % Nms/rad
% c_fric = 0.07*pi/180;                  % Nms/deg (probably as by Vandael
velThreshold = 20/(60*1000)-0.000001;
t_step = 1.2;
mass = 70;

L0_swing = 0.0896;              % m     nice plot Friction test
% L0_swing = 0.0869;              % m  length used for 0 position
L0_stance =  0.08925;            % m    nice plot Friction test
k_stance = 130000;              % N/mu
k_swing = 18750;                % N/m

% L0_swing = 0.0875; % nice plot ICR
% L0_stance = 0.0894; % nice plot ICR

% from opt
% L0_stance = 0.0878;
% L0_swing = 0.1483;
% c_fric = Simulink.Parameter(0.1855);
% c_fric.CoderInfo.StorageClass = 'SimulinkGlobal';

c_swing_comp_a1 = 213.5932;     % Ns/m
c_swing_comp_a0 = -4927.5;      % (Ns/m)^2
c_swing_ext_a1 = 146.3288;      % Ns/m
c_swing_ext_a0 = -8808.5;       % (Ns/m)^2

c_stance_comp_a0 = 885.0653;    % Ns/m
c_stance_comp_a1 = 2.1443;      % (Ns/m)^2
c_stance_ext_a0 = 65579;        % Ns/m
c_stance_ext_a1 = 7.0819;       % (Ns/m)^2

% c_stance_ext_a0 = 885.0653;    % Ns/m
% c_stance_ext_a1 = 2.1443;      % (Ns/m)^2
% c_stance_comp_a0 = 65579;        % Ns/m
% c_stance_comp_a1 = 7.0819;       % (Ns/m)^2

L3 = 88.5*1e-3;
L4 = 1.7*1e-3;
L6 = 40.25*1e-3;
L7 = 14.9*1e-3;
L10 = 7.9*1e-3;
L11 = 3.3*1e-3;
L14 = 95*1e-3;
L15 = 8.2*1e-3;
L18 = 25.1*1e-3;
L19 = 17.7*1e-3;
L20 = 26*1e-3;
L21 = 1.7*1e-3;
L25 = 76.95*1e-3;
% L25 = 76.45*1e-3;
L26 = 2.8*1e-3;

L_shank = 0.3;
L_thigh = 0.3;

cg3 = (3.6/10.4)*L3;
cg4 = 0;
cg6 = 0;
cg7 = 0;
cg10 = 0.5*L10;
cg11 = 0.0;
cg14 = 1/2*L14;
cg15 = 0;
cg18 = 1/2*L18;
cg19 = 0;
cg20 = 0;
cg21 = 0;
cg25 = (5.45/11.05)*L25;
cg26 = 0;

a_2_3 = 18;
a_3_4 = -90;
a_3_6 = -112;
a_3_7 = -98;
a_10_11 = -118;
a_14_15 = 90;
a_18_19 = 116;
a_18_20 = 122;
a_18_21 = 34;
a_18_23 = -10;
a_25_26 = -90;


m3467 = 253.3*1e-3;
m8 = 143.8*1e-3;
m1011 = 49.5*1e-3;
m1415 = 123.8*1e-3;
m18192021 = 196.6*1e-3;
m2526 = 58.3*1e-3;
m30 = 89.6*1e-3;
m_shank = 150*1e-3;
m_thigh = 8;

J3467 = (25.96*1e4)*1e-9;
J8 = (4.19*1e4)*1e-9;
J1011 = (4130)*1e-9;
J1415 = (1.18*1e5)*1e-9;
J18192021 = (6.86*1e4)*1e-9;
J30 = (6.36*1e4)*1e-9;
J2526 = (3.59*1e4)*1e-9;
J_shank = m_shank*L_shank^2/12;
J_thigh = m_thigh*L_thigh^2/12;

