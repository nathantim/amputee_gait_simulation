function [GaitInfo] = getPartOfGaitData(b_oneGaitPhase,GaitPhaseData,t,stepTimes)
t_left = t;
t_right = t;

%%
if (b_oneGaitPhase) && min(sum(stepTimes(:,1)),sum(stepTimes(:,2))) > 1
    leftLegState    = GaitPhaseData.signals.values(:,1);
    rightLegState   = GaitPhaseData.signals.values(:,2);
    leftLegStateChange = diff(leftLegState);
    rightLegStateChange = diff(rightLegState);
    
    [L_changeSwing2StanceIdx] = find(leftLegStateChange == -4);
    [R_changeSwing2StanceIdx] = find(rightLegStateChange == -4);
    if length(L_changeSwing2StanceIdx) >= 8
        selectStart = max([1, ceil(1.75*(length(L_changeSwing2StanceIdx)/2)),min(1,length(L_changeSwing2StanceIdx)-1),min(1,length(R_changeSwing2StanceIdx)-1)]);
    elseif  length(L_changeSwing2StanceIdx) >= 5
        selectStart = length(L_changeSwing2StanceIdx) - 3;
    elseif  length(L_changeSwing2StanceIdx) > 1
        selectStart = length(L_changeSwing2StanceIdx) - 1;
    end
    leftGaitPhaseEnd = L_changeSwing2StanceIdx(selectStart+1);
    leftGaitPhaseStart = L_changeSwing2StanceIdx(selectStart)+1;
    
    rightGaitPhaseEnd = R_changeSwing2StanceIdx(selectStart+1);
    rightGaitPhaseStart = R_changeSwing2StanceIdx(selectStart)+1;
    
    t_left = t_left(leftGaitPhaseStart:leftGaitPhaseEnd);
    t_right = t_right(rightGaitPhaseStart:rightGaitPhaseEnd);
    t_left_perc = (t_left-t_left(1))./(t_left(end)-t_left(1))*100;
    t_right_perc = (t_right-t_right(1))./(t_right(end)-t_right(1))*100;
else   
    leftGaitPhaseEnd = length(t);
    leftGaitPhaseStart = 1;
    t_left_perc = t_left;
    t_right_perc = t_right;
    rightGaitPhaseEnd = length(t);
    rightGaitPhaseStart = 1;
    b_oneGaitPhase = false;
end

%%
GaitInfo.b_oneGaitPhase = logical(b_oneGaitPhase);
GaitInfo.start.left = leftGaitPhaseStart;
GaitInfo.start.right = rightGaitPhaseStart;
GaitInfo.end.left = leftGaitPhaseEnd;
GaitInfo.end.right = rightGaitPhaseEnd;
GaitInfo.time.left = t_left;
GaitInfo.time.right = t_right;
GaitInfo.time.left_perc = t_left_perc;
GaitInfo.time.right_perc = t_right_perc;

%%
tWinter = [1.45,1.2,0.96];
speedsWinter = {'slow','normal','fast'};
leftLegSteptimes = stepTimes(stepTimes(:,1)~=0,1);
rightLegSteptimes = stepTimes(stepTimes(:,2)~=0,2);
meanStepTime = mean([mean(leftLegSteptimes),mean(rightLegSteptimes)]);
if isnan(meanStepTime)
    meanStepTime = 1.2;
end
% speed2select = find(abs(tWinter - meanStepTime) == min(abs(tWinter - meanStepTime)));
GaitInfo.WinterDataSpeed = speedsWinter{abs(tWinter - meanStepTime) == min(abs(tWinter - meanStepTime))};
