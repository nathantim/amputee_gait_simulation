%% set initial conditions
% conditions from Song

vx0             = paramIC(1)  	*1.3; %[m/s] 
LphiAnkle0      = paramIC(2)   	*100*pi/180 - pi/2; %[rad]
LphiKnee0       = pi - paramIC(3)   	*180*pi/180; %[rad]
LphiHip0        = paramIC(4) 	*165*pi/180 - pi; %[rad]
RphiAnkle0      = paramIC(5)  	*90*pi/180 - pi/2; %[rad]
RphiKnee0       = pi - paramIC(6)  	*165*pi/180; %[rad]
RphiHip0        = paramIC(7)   	*200*pi/180 - pi; %[rad]
LphiHipR0       = paramIC(8)*(-1)*pi/180; %[rad]
RphiHipR0       = paramIC(9)*(1)*pi/180; %[rad]

vy0 = paramIC(10)*.2;

x0      = .2;
y0      = hatLeftHipToCenterDistWidth;
z0      = paramIC(11)      *.01;
yaw0    = pi/180;
roll0   = (-1)*pi/180;

initialTargetAngle  = 70*pi/180;
initialTargetAngleR = 90*pi/180;

