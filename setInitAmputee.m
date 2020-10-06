%% set initial conditions
% conditions from Song
warning('Check init conditions');
vxInit             = paramIC(1)  	*(1.3); %[m/s] 
LphiAnkle0      = -(paramIC(2)   	*100*pi/180 - pi/2); %[rad]
LphiKnee0       = pi - paramIC(3)   	*180*pi/180; %[rad]
LphiHip0        = 1/2*(paramIC(4) 	*165*pi/180 - pi); %[rad]
RphiAnkle0      = paramIC(5)  	*90*pi/180 - pi/2; %[rad]
RphiKnee0       = pi - paramIC(6)  	*165*pi/180; %[rad]
RphiHip0        = -2.8*(paramIC(7)   	*200*pi/180 - pi); %[rad]
LphiHipR0       = -paramIC(8)*(-1)*pi/180; %[rad]
RphiHipR0       = -paramIC(9)*(1)*pi/180; %[rad]

vyInit = paramIC(10)*0.2*(1.3/1.3); %.2
vzInit = 0;
xInit      = .2;
yInit      = -hatLeftHipToCenterDistWidth;
zInit      = paramIC(11)      *.01;
yawInit    = pi/180;
rollInit   = -(-1)*pi/180;

initialTargetAngle  = 70*pi/180;
initialTargetAngleR = 90*pi/180;



