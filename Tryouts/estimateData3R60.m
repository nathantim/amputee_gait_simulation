clearvars;
%%
target_angle = 0;
gait_phase = "swing";

L0_swing = 0.0869;              % m
L0_stance =  0.0892;            % m

model = 'knee_mechanism';
rtp = Simulink.BlockDiagram.buildRapidAcceleratorTarget(model);
x0 = [L0_stance,L0_swing];
warning('off')
[x,~,EXITFLAG] = fmincon(@(x) costFunction(x,target_angle,gait_phase,model,rtp),x0,[1,0;0,1;-1,0;0,-1],[0.15;0.15;0;0]);
disp(EXITFLAG);
warning('on');
costFunction(x,target_angle,gait_phase,model,rtp)
%%
function cost = costFunction(x,target_angle,gait_phase,model,rtp)
paramSets = Simulink.BlockDiagram.modifyTunableParameters(rtp, ...
            'L0_stance',               x( 1), ...
            'L0_swing',               x( 2));

try
    simout = sim(model,...
        'RapidAcceleratorParameterSets',paramSets,...
        'RapidAcceleratorUpToDateCheck','off',...
        'TimeOut',2*60,...
        'SaveOutput','on');
catch
    cost = nan;
    disp('Timeout')
    return
end
knee_angle = get(simout,'knee_angle');
ICR = get(simout,'ICR');
pos14_1 = get(simout,'pos14_1');
pos14_2 = get(simout,'pos14_2');
    
idx = find(abs(knee_angle-target_angle) == min(abs(knee_angle-target_angle)),1,'first');
angle_knee = knee_angle(idx,1); % deg


ICR_y = ICR(idx,1)*1000; % mm
ICR_z = ICR(idx,2)*1000; % mm

y_14_1 = pos14_1(idx,2)*1000;
z_14_1 = pos14_1(idx,3)*1000;
y_14_2 = pos14_2(idx,2)*1000;
z_14_2 = pos14_2(idx,3)*1000;

% idx_length = find(angle_knee>140,1,'first')+1;
% if isempty(idx_length)
%     idx_length = length(angle_knee);
% end
% t = ICR.Time(1:idx_length);

origin_swing_y = y_14_2;
origin_swing_z = z_14_2;
origin_stance_y = y_14_1;
origin_stance_z = z_14_1;

if strcmp(gait_phase,"swing")
    origin_y = origin_swing_y;
    origin_z = origin_swing_z;
elseif strcmp(gait_phase,"stance")
    origin_y = origin_stance_y;
    origin_z = origin_stance_z;
else
    error("Unknown gait phase");
end

ICR_y = ICR_y - origin_y;
ICR_z = ICR_z - origin_z;

[ICRotto_y,ICRotto_z,~,~] = getICR_otto(angle_knee,gait_phase);
 
cost = norm([ICR_y;ICR_z]-[ICRotto_y;ICRotto_z]);
end