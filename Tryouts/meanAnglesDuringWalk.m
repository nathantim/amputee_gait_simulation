OptimParams;
t = angularData.time;

leftLegState    = GaitPhaseData.signals.values(:,1);
rightLegState   = GaitPhaseData.signals.values(:,2);
leftLegStateChange = diff(leftLegState);
rightLegStateChange = diff(rightLegState);

[L_changeSwing2StanceIdx] = find(leftLegStateChange == -4); 
[R_changeSwing2StanceIdx] = find(rightLegStateChange == -4);

L_changeSwing2StanceIdx = L_changeSwing2StanceIdx(initiation_steps:end);
R_changeSwing2StanceIdx = R_changeSwing2StanceIdx(initiation_steps:end);

for i = 1:(length(L_changeSwing2StanceIdx)-1)
    leftGaitPhaseEnd = L_changeSwing2StanceIdx(i+1);
    leftGaitPhaseStart = L_changeSwing2StanceIdx(i)+1;
    t_left = t(leftGaitPhaseStart:leftGaitPhaseEnd);
    t_left_perc = (t_left-t_left(1))./(t_left(end)-t_left(1))*100;
    t_left_perc_mod = mod(round(t_left_perc,3,'significant'),10);
    idx_percents = find(t_left_perc_mod<1);
    t_left_perc_filtered = t_left_perc(idx_percents);
    disp(length(t_left_perc_filtered));
end

for j = 1:length(R_changeSwing2StanceIdx)

end
selectStart = max([ceil(1.5*(length(L_changeSwing2StanceIdx)/2)),min(1,length(L_changeSwing2StanceIdx)-1),min(1,length(R_changeSwing2StanceIdx)-1)])
leftGaitPhaseEnd = L_changeSwing2StanceIdx(selectStart+1);
leftGaitPhaseStart = L_changeSwing2StanceIdx(selectStart)+1;

rightGaitPhaseEnd = R_changeSwing2StanceIdx(selectStart+1);
rightGaitPhaseStart = R_changeSwing2StanceIdx(selectStart)+1;

t_left = t_left(leftGaitPhaseStart:leftGaitPhaseEnd);
t_right = t_right(rightGaitPhaseStart:rightGaitPhaseEnd);
t_left_perc = (t_left-t_left(1))./(t_left(end)-t_left(1))*100;
t_right_perc = (t_right-t_right(1))./(t_right(end)-t_right(1))*100;