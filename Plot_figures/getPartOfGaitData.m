function [GaitInfo] = getPartOfGaitData(t,GaitPhaseData,stepTimes,saveInfo,b_oneGaitPhase,timeInterval)
if nargin < 6 || isempty(timeInterval)
    idxstart = 1;
    idxend = length(t);
else
    b_oneGaitPhase = false;
    idxstart = find( abs(t  - timeInterval(1)) == min(abs(t-timeInterval(1))) );
    idxend = find(abs(t  - timeInterval(2)) == min(abs(t-timeInterval(2))) );
end
t_left = t(idxstart:idxend);
t_right = t(idxstart:idxend);
OptimParams;

%%
if (b_oneGaitPhase) && min(sum(stepTimes(:,1)),sum(stepTimes(:,2))) > 1
    leftLegState    = GaitPhaseData.signals.values(:,1);
    rightLegState   = GaitPhaseData.signals.values(:,2);
    leftLegStateChange = diff(leftLegState);
    rightLegStateChange = diff(rightLegState);
    
    [L_changeSwing2StanceIdx] = find(leftLegStateChange == -4);
    [R_changeSwing2StanceIdx] = find(rightLegStateChange == -4);
    minSwing2StanceChange = min(length(L_changeSwing2StanceIdx),length(R_changeSwing2StanceIdx));
    if minSwing2StanceChange >= 8
        selectStart = max([1, ceil(1.75*(minSwing2StanceChange/2)),min(1,minSwing2StanceChange-1)]);
    elseif  minSwing2StanceChange >= 5
        selectStart = minSwing2StanceChange - 3;
    elseif  minSwing2StanceChange > 1
        selectStart = minSwing2StanceChange - 1;
    end
    
    leftLegStepsIdx = L_changeSwing2StanceIdx(initiation_steps:end);
    rightLegStepsIdx = R_changeSwing2StanceIdx(initiation_steps:end);
    
    for i = 1:length(leftLegStepsIdx)-1
        leftGaitPhaseEndV(i) = leftLegStepsIdx(i+1);
        leftGaitPhaseStartV(i) = leftLegStepsIdx(i)+1;
    end
    for i = 1:length(rightLegStepsIdx)-1
        rightGaitPhaseEndV(i) = rightLegStepsIdx(i+1);
        rightGaitPhaseStartV(i) = rightLegStepsIdx(i)+1;
    end
    
    leftGaitPhaseEnd = L_changeSwing2StanceIdx(selectStart+1);
    leftGaitPhaseStart = L_changeSwing2StanceIdx(selectStart)+1;
    
    rightGaitPhaseEnd = R_changeSwing2StanceIdx(selectStart+1);
    rightGaitPhaseStart = R_changeSwing2StanceIdx(selectStart)+1;
    
    t_left = t_left(leftGaitPhaseStart:leftGaitPhaseEnd);
    t_right = t_right(rightGaitPhaseStart:rightGaitPhaseEnd);
    t_left_perc = (t_left-t_left(1))./(t_left(end)-t_left(1))*100;
    t_right_perc = (t_right-t_right(1))./(t_right(end)-t_right(1))*100;
    tp = (0:0.5:100)';
    
    %%
    leftLegState    = GaitPhaseData.signals.values(:,1);
    rightLegState   = GaitPhaseData.signals.values(:,2);
    
    leftStanceSwing = leftLegState;
    leftStanceSwing(leftStanceSwing <= GaitState.LiftOff) = 1;
    leftStanceSwing(leftStanceSwing > GaitState.LiftOff) = 0;
    
    rightStanceSwing = rightLegState;
    rightStanceSwing(rightStanceSwing <= GaitState.LiftOff) = 1;
    rightStanceSwing(rightStanceSwing > GaitState.LiftOff) = 0;
    
%     [leftStanceSwing_avg,~] = interpData2perc(t,tp,leftStanceSwing,leftGaitPhaseStartV,leftGaitPhaseEndV,b_oneGaitPhase);
% [rightStanceSwing_avg,~] = interpData2perc(t,tp,rightLegState,rightGaitPhaseStartV,rightGaitPhaseEndV,b_oneGaitPhase);


    
    for ii = 1:length(leftGaitPhaseStartV)
        startIdx = leftGaitPhaseStartV(ii);
        endIdx = leftGaitPhaseEndV(ii);
        Lstance(ii) = 100*find(leftStanceSwing(startIdx:endIdx) == 0,1,'first')/length(leftStanceSwing(startIdx:endIdx));
    end
    for ii = 1:length(rightGaitPhaseStartV)
        startIdx = rightGaitPhaseStartV(ii);
        endIdx = rightGaitPhaseEndV(ii);
        Rstance(ii) = 100*find(rightStanceSwing(startIdx:endIdx) == 0,1,'first')/length(rightStanceSwing(startIdx:endIdx));
    end
    [stanceASI] = getFilterdMean_and_ASI(Lstance,Rstance);
    gaitstate.left.Stance = stanceASI.leftMean;
    gaitstate.left.Swing = 100 - gaitstate.left.Stance;
    gaitstate.left.meanstdtxt = stanceASI.leftTxt;
    
    gaitstate.right.Stance = stanceASI.rightMean;
    gaitstate.right.Swing = 100 - gaitstate.right.Stance;
    gaitstate.right.meanstdtxt = stanceASI.rightTxt;
    gaitstate.ASItxt = stanceASI.ASItxt;
    
    gaitstate.Stance = stanceASI.totalMean;
    gaitstate.Swing = 100 - gaitstate.Stance;
    gaitstate.meanstdtxt = stanceASI.totalTxt;
    
    %%
else
    leftGaitPhaseEnd = idxend;
    leftGaitPhaseStart = idxstart;
    t_left_perc = t_left;
    t_right_perc = t_right;
    rightGaitPhaseEnd = idxend;
    rightGaitPhaseStart = idxstart;
    b_oneGaitPhase = false;
    leftGaitPhaseStartV = idxstart;
    leftGaitPhaseEndV = idxend;
    rightGaitPhaseStartV = idxstart;
    rightGaitPhaseEndV = idxend;
    tp =  t(idxstart:idxend);
    gaitstate = [];
end

%%
GaitInfo.b_oneGaitPhase = logical(b_oneGaitPhase);
GaitInfo.start.left = leftGaitPhaseStart;
GaitInfo.start.right = rightGaitPhaseStart;
GaitInfo.end.left = leftGaitPhaseEnd;
GaitInfo.end.right = rightGaitPhaseEnd;
GaitInfo.start.leftV = leftGaitPhaseStartV;
GaitInfo.start.rightV = rightGaitPhaseStartV;
GaitInfo.end.leftV = leftGaitPhaseEndV;
GaitInfo.end.rightV = rightGaitPhaseEndV;
GaitInfo.time.left = t_left;
GaitInfo.time.right = t_right;
GaitInfo.time.left_perc = t_left_perc;
GaitInfo.time.right_perc = t_right_perc;
GaitInfo.tp = tp;
GaitInfo.t = t;
GaitInfo.gaitstate = gaitstate;
GaitInfo.initiation_steps = initiation_steps;

%%
tWinter = [1.45,1.2,0.96];
speedsWinter = {'slow','normal','fast'};
try
    leftLegSteptimes = stepTimes(stepTimes(:,1)~=0,1);
    rightLegSteptimes = stepTimes(stepTimes(:,2)~=0,2);
    meanStepTime = mean([mean(leftLegSteptimes),mean(rightLegSteptimes)]);
    if isnan(meanStepTime)
        meanStepTime = 1.2;
    end
catch
    meanStepTime = 1.2;
end
% speed2select = find(abs(tWinter - meanStepTime) == min(abs(tWinter - meanStepTime)));
GaitInfo.WinterDataSpeed = speedsWinter{abs(tWinter - meanStepTime) == min(abs(tWinter - meanStepTime))};
