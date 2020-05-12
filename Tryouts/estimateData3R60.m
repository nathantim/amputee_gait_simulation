clearvars;
%%
% target_angle = 0;
% gait_phase = "swing";

L0_swing = 0.0869;              % m
L0_stance =  0.0892;            % m
c_fricp = 0.05*0.00165; 

% https://www.mathworks.com/help/physmod/simscape/ug/set-the-run-time-parameters-visibility-preference.html
model = 'knee_mechanism';
rtp = Simulink.BlockDiagram.buildRapidAcceleratorTarget(model);
x0 = [L0_stance;L0_swing;c_fricp];
warning('off')
[x,~,EXITFLAG] = fmincon(@(x) costFunction(x,model,rtp),x0,[1,0,0;0,1,0;-1,0,0;0,-1,0;0,0,-1],[0.15;0.15;0;0;0]);
disp(EXITFLAG);
warning('on');
costFunction(x0,model,rtp)
costFunction(x,model,rtp)

%%
function total_cost = costFunction(x,model,rtp)
paramSets = Simulink.BlockDiagram.modifyTunableParameters(rtp, ...
            'L0_stance',               x(1), ...
            'L0_swing',                x(2), ...
            'c_fric',                  x(3));

try
    simout = sim(model,...
        'RapidAcceleratorParameterSets',paramSets,...
        'RapidAcceleratorUpToDateCheck','off',...
        'TimeOut',2*60,...
        'SaveOutput','on');
catch
    total_cost = nan;
    disp('Timeout')
    return
end
knee_angle = get(simout,'knee_angle');
ICR = get(simout,'ICR');
pos14_1 = get(simout,'pos14_1');
pos14_2 = get(simout,'pos14_2');
    
phases = ["swing";"stance"];
cost = nan(size(phases));
for j = 1:length(phases)
    gait_phase = phases(j);
    
    [angle_knee,~,ICR_y,ICR_z,~,~,~,~,~,~,~,~] = getICR_model(knee_angle(:,j),gait_phase,[],ICR(:,j*2-1:j*2),pos14_1(:,j*3-2:j*3),pos14_2(:,j*3-2:j*3),[],[]);
    [ICRotto_y,ICRotto_z,~,~] = getICR_otto(angle_knee,gait_phase);
    cost(j) = norm([ICR_y;ICR_z]-[ICRotto_y;ICRotto_z]);
end
 
total_cost = sum(cost);
end