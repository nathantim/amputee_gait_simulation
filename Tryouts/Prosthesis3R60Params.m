c_fric = 0.002423;                  % Ns/m
% c_fric = 0.07;                  % Ns/m
velThreshold = 20/(60*1000)-0.000001;

L0_swing = 0.0896;              % m
L0_stance =  0.0892;            % m
k_bumper = 130000;              % N/m
k_swing = 18750;                % N/m

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
L26 = 2.8*1e-3;

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
a_25_26 = -90;

m3467 = 253.3*1e-3;
m8 = 143.8*1e-3;
m1011 = 49.5*1e-3;
m1415 = 123.8*1e-3;
m18192021 = 196.6*1e-3;
m2526 = 58.3*1e-3;
m30 = 89.6*1e-3;

J3467 = (25.96*1e4)*1e-9;
J8 = (4.19*1e4)*1e-9;
J1011 = (4130)*1e-9;
J1415 = (1.18*1e5)*1e-9;
J18192021 = (6.86*1e4)*1e-9;
J30 = (6.36*1e4)*1e-9;
J2526 = (3.59*1e4)*1e-9;

%% init param
% (almost) zero knee angle:
% j10_i = -25.4597;
% j13_i = -42.8862;
% j15_i = 115.697;

% % swing phase test
j10_i = 7.5;
j13_i = -4.07996;
j15_i = 129.2;