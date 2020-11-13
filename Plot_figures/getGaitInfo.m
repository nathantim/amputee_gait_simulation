function [GaitInfo] = getGaitInfo(t,GaitPhaseData,stepTimes,b_oneGaitPhase,timeInterval)
% GETGAITINFO                       Function that plots the data of healthy and prosthetic simulation together, with optional 
%                                   amputee with CMG simulation
% INPUTS:
%   - t                             Simulation time vector.
%   - GaitPhaseData                 Structure with the gait phase data from the simulation
%   - stepTimes                     Structure with the step time data from simulation.
%   - b_oneGaitPhase                Optional, indicates whether the data should be presented as average over stride or just all.
%   - timeInterval                  Optional, select a time interval for which you want to see the data
%
% OUTPUTS:
%   - GaitInfo                      Structure that contains time vector, percentage vector with points on the data has to 
%                                   be interpolated, stance time, swing  time, double stance time, indices of when a stride 
%                                   starts and ends
%%
if nargin < 5 || isempty(timeInterval)
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
if (b_oneGaitPhase) && min(sum(stepTimes.signals.values(:,1)),sum(stepTimes.signals.values(:,2))) > 1
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

    leftStance = (leftLegState <= GaitState.LiftOff);
    leftDoubleStance = (leftLegState == GaitState.LiftOff);
    leftSwing = (leftLegState > GaitState.LiftOff);
    
    rightStance = (rightLegState <= GaitState.LiftOff);
    rightDoubleStance = (rightLegState == GaitState.LiftOff);
    rightSwing = (rightLegState > GaitState.LiftOff);
    
    
    for ii = 1:length(leftGaitPhaseStartV)
        startIdx = leftGaitPhaseStartV(ii);
        endIdx = leftGaitPhaseEndV(ii);
        tpart = t(startIdx:endIdx);
        Lstance_perc(ii)        = 100*sum(leftStance(startIdx:endIdx))/length(leftStance(startIdx:endIdx));
        Lstance(ii)             = tpart(find(leftStance(startIdx:endIdx)==1,1,'last')) - tpart(find(leftStance(startIdx:endIdx)==1,1,'first'));
        Lswing_perc(ii)        = 100*sum(leftSwing(startIdx:endIdx))/length(leftSwing(startIdx:endIdx));
        Lswing(ii)              = tpart(find(leftSwing(startIdx:endIdx)==1,1,'last')) - tpart(find(leftSwing(startIdx:endIdx)==1,1,'first'));
        LDoubleStance_perc(ii)  = 100*sum(leftDoubleStance(startIdx:endIdx))/length(leftDoubleStance(startIdx:endIdx));
        LDoubleStance(ii)       = tpart(find(leftDoubleStance(startIdx:endIdx)==1,1,'last')) - tpart(find(leftDoubleStance(startIdx:endIdx)==1,1,'first'));
    end
    for ii = 1:length(rightGaitPhaseStartV)
        startIdx = rightGaitPhaseStartV(ii);
        endIdx = rightGaitPhaseEndV(ii);
        tpart = t(startIdx:endIdx);
        Rstance_perc(ii)        = 100*sum(rightStance(startIdx:endIdx))/length(rightStance(startIdx:endIdx));
        Rstance(ii)             = tpart(find(rightStance(startIdx:endIdx)==1,1,'last')) - tpart(find(rightStance(startIdx:endIdx)==1,1,'first'));
        Rswing_perc(ii)        = 100*sum(rightSwing(startIdx:endIdx))/length(rightSwing(startIdx:endIdx));
        Rswing(ii)              = tpart(find(rightSwing(startIdx:endIdx)==1,1,'last')) - tpart(find(rightSwing(startIdx:endIdx)==1,1,'first'));
        RDoubleStance_perc(ii) = 100*sum(rightDoubleStance(startIdx:endIdx))/length(rightDoubleStance(startIdx:endIdx));
        RDoubleStance(ii)       = tpart(find(rightDoubleStance(startIdx:endIdx)==1,1,'last')) - tpart(find(rightDoubleStance(startIdx:endIdx)==1,1,'first'));
    end
    [stanceASI] = getFilterdMean_and_ASI(Lstance,Rstance);
    [stanceASI_perc] = getFilterdMean_and_ASI(Lstance_perc,Rstance_perc);
    [swingASI] = getFilterdMean_and_ASI(Lswing,Rswing);
    [swingASI_perc] = getFilterdMean_and_ASI(Lswing_perc,Rswing_perc);
    [doubleStanceASI] = getFilterdMean_and_ASI(LDoubleStance,RDoubleStance);
    [doubleStanceASI_perc] = getFilterdMean_and_ASI(LDoubleStance_perc,RDoubleStance_perc);

    gaitstate.left.StanceV = (leftLegState <= GaitState.LiftOff);
    gaitstate.left.stanceMeanstdtxt = stanceASI.leftTxt;
    gaitstate.left.swingMeanstdtxt = swingASI.leftTxt;
    gaitstate.left.Stance = stanceASI.leftMean;
    gaitstate.left.Swing = swingASI.leftMean;
    gaitstate.left.DoubleStance = doubleStanceASI.leftMean;
    gaitstate.left.doubleStanceMeanstdtxt = doubleStanceASI.leftTxt;
    
    gaitstate.left.Stance_perc = stanceASI_perc.leftMean;
    gaitstate.left.Swing_perc = swingASI_perc.leftMean;
    gaitstate.left.stanceMeanstdtxt_perc = stanceASI_perc.leftTxt;
    gaitstate.left.swingMeanstdtxt_perc = swingASI_perc.leftTxt;
    gaitstate.left.DoubleStance_perc = doubleStanceASI_perc.leftMean;
    gaitstate.left.doubleStanceMeanstdtxt_perc = doubleStanceASI_perc.leftTxt;
    
    gaitstate.right.StanceV = (rightLegState <= GaitState.LiftOff);
    gaitstate.right.Stance = stanceASI.rightMean;
    gaitstate.right.Swing = swingASI.rightMean;
    gaitstate.right.stanceMeanstdtxt = stanceASI.rightTxt;
    gaitstate.right.swingMeanstdtxt = swingASI.rightTxt;
    gaitstate.right.DoubleStance = doubleStanceASI.rightMean;
    gaitstate.right.doubleStanceMeanstdtxt = doubleStanceASI.rightTxt;
    
    gaitstate.right.Stance_perc = stanceASI_perc.rightMean;
    gaitstate.right.Swing_perc = swingASI_perc.rightMean;
    gaitstate.right.stanceMeanstdtxt_perc = stanceASI_perc.rightTxt;
    gaitstate.right.swingMeanstdtxt_perc = swingASI_perc.rightTxt;
    gaitstate.right.DoubleStance_perc = doubleStanceASI_perc.rightMean;
    gaitstate.right.doubleStanceMeanstdtxt_perc = doubleStanceASI_perc.rightTxt;
    
    gaitstate.stanceASItxt = stanceASI.ASItxt;
    gaitstate.swingASItxt = swingASI.ASItxt;
    gaitstate.doubleStanceASItxt = doubleStanceASI.ASItxt;
    
    gaitstate.stanceASItxt_perc = stanceASI_perc.ASItxt;
    gaitstate.swingASItxt_perc = swingASI_perc.ASItxt;
    gaitstate.doubleStanceASItxt_perc = doubleStanceASI_perc.ASItxt;
    
    gaitstate.Stance = stanceASI.totalMean;
    gaitstate.Stance = swingASI.totalMean;
    gaitstate.DoubleStance = doubleStanceASI.totalMean;
    gaitstate.stanceMeanstdtxt = stanceASI.totalTxt;
    gaitstate.swingMeanstdtxt = swingASI.totalTxt;
    gaitstate.doubleStanceMeanstdtxt = doubleStanceASI.totalTxt;
    
    gaitstate.Stance_perc = stanceASI_perc.totalMean;
    gaitstate.Swing_perc = swingASI_perc.totalMean;
    gaitstate.DoubleStance_perc = doubleStanceASI_perc.totalMean;
    gaitstate.stanceMeanstdtxt_perc = stanceASI_perc.totalTxt;
    gaitstate.swingMeanstdtxt_perc = swingASI_perc.totalTxt;
    gaitstate.doubleStanceMeanstdtxt_perc = doubleStanceASI_perc.totalTxt;
    
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

