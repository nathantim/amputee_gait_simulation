function plotAngularData(angularData,StanceData,b_oneGaitPhase)
%%
t = angularData.time;
t_left = t;
t_right = t;
    
if b_oneGaitPhase
    StanceVal = StanceData.signals.values;
    StanceChange = diff(StanceVal,1);

    [changeSwing2StanceRow, changeSwing2StanceCol] = find(StanceChange == 1);
    
    leftGaitPhaseStart = changeSwing2StanceRow(changeSwing2StanceCol==1);
    rightGaitPhaseStart = changeSwing2StanceRow(changeSwing2StanceCol==2);
    
    selectStart = 5;
    leftGaitPhaseEnd = leftGaitPhaseStart(selectStart+1);
    leftGaitPhaseStart = leftGaitPhaseStart(selectStart)+1;
    
    rightGaitPhaseEnd = rightGaitPhaseStart(selectStart+1);
    rightGaitPhaseStart = rightGaitPhaseStart(selectStart)+1;
    
    t_left = (t_left(leftGaitPhaseStart:leftGaitPhaseEnd)-t_left(leftGaitPhaseStart))./(t_left(leftGaitPhaseEnd)-t_left(leftGaitPhaseStart))*100;
    t_right = (t_right(rightGaitPhaseStart:rightGaitPhaseEnd)-t_right(rightGaitPhaseStart))./(t_right(rightGaitPhaseEnd)-t_right(rightGaitPhaseStart))*100;
else   
    leftGaitPhaseEnd = length(t);
    leftGaitPhaseStart = 1;
    
    rightGaitPhaseEnd = length(t);
    rightGaitPhaseStart = 1;
end

%%

HATAngle = angularData.signals.values(:,1);
HATAngleVel = angularData.signals.values(:,2);

hipAngles = [angularData.signals.values(:,3),angularData.signals.values(:,5)];
hipAnglesVel = [angularData.signals.values(:,4),angularData.signals.values(:,6)];

kneeAngles = [angularData.signals.values(:,7),angularData.signals.values(:,9)];
kneeAnglesVel = [angularData.signals.values(:,8),angularData.signals.values(:,10)];

ankleAngles = [angularData.signals.values(:,11),angularData.signals.values(:,13)];
ankleAnglesVel = [angularData.signals.values(:,12),angularData.signals.values(:,14)];



figure();

%%
subplot(4,2,1);
plot(t_left,HATAngle(leftGaitPhaseStart:leftGaitPhaseEnd,1));
title('HAT angle')
ylabel('rad');

subplot(4,2,2);
plot(t_left,HATAngleVel(leftGaitPhaseStart:leftGaitPhaseEnd,1));
title('HAT angular velocity')
ylabel('rad/s')

plotAngularDataInFigure(t_left,hipAngles(leftGaitPhaseStart:leftGaitPhaseEnd,1),hipAnglesVel(leftGaitPhaseStart:leftGaitPhaseEnd,1),...
                        kneeAngles(leftGaitPhaseStart:leftGaitPhaseEnd,1),kneeAnglesVel(leftGaitPhaseStart:leftGaitPhaseEnd,1),...
                            ankleAngles(leftGaitPhaseStart:leftGaitPhaseEnd,1),ankleAnglesVel(leftGaitPhaseStart:leftGaitPhaseEnd,1));

plotAngularDataInFigure(t_right,hipAngles(rightGaitPhaseStart:rightGaitPhaseEnd,2),hipAnglesVel(rightGaitPhaseStart:rightGaitPhaseEnd,2)...
                        ,kneeAngles(rightGaitPhaseStart:rightGaitPhaseEnd,2),kneeAnglesVel(rightGaitPhaseStart:rightGaitPhaseEnd,2), ...
                        ankleAngles(rightGaitPhaseStart:rightGaitPhaseEnd,2),ankleAnglesVel(rightGaitPhaseStart:rightGaitPhaseEnd,2))
