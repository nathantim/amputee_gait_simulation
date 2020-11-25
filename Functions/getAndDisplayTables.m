function getAndDisplayTables(data,GaitInfo,saveInfo)
disp( getLegStateTable(GaitInfo,saveInfo) );
disp( getStepTimeTable(data.stepTimes,saveInfo,GaitInfo.initiationSteps) );
disp( getStepLengthTable(data.stepLengths,saveInfo,GaitInfo.initiationSteps) );


LankleTorque    = data.jointTorquesData.signals.values(:,3);
RankleTorque    = data.jointTorquesData.signals.values(:,6);
LankleVel       = data.angularData.signals.values(:,12);
RankleVel       = data.angularData.signals.values(:,14);
LanklePower     = LankleTorque.*LankleVel;
RanklePower     = RankleTorque.*RankleVel;
disp( getAnklePowerTable(LanklePower,RanklePower,GaitInfo,saveInfo) );

disp( getGroundImpulseTable(data.GRFData,GaitInfo,saveInfo) );