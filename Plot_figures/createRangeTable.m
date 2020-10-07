function [rangeTable] = createRangeTable(GaitInfo,LHipRoll,RHipRoll,LHip,RHip,LKnee,RKnee,LAnkle,RAnkle)
rangeTable = [];
if ~isempty(GaitInfo.gaitstate)
    [LhipRollRange] = getMinMaxStanceSwing(GaitInfo.gaitstate.left,GaitInfo.tp,LHipRoll);
    [LhipRange] = getMinMaxStanceSwing(GaitInfo.gaitstate.left,GaitInfo.tp,LHip);
    [LkneeRange] = getMinMaxStanceSwing(GaitInfo.gaitstate.left,GaitInfo.tp,LKnee);
    [LankleRange] = getMinMaxStanceSwing(GaitInfo.gaitstate.left,GaitInfo.tp,LAnkle);
    
    [RhipRollRange] = getMinMaxStanceSwing(GaitInfo.gaitstate.left,GaitInfo.tp,RHipRoll);
    [RhipRange] = getMinMaxStanceSwing(GaitInfo.gaitstate.left,GaitInfo.tp,RHip);
    [RkneeRange] = getMinMaxStanceSwing(GaitInfo.gaitstate.left,GaitInfo.tp,RKnee);
    [RankleRange] = getMinMaxStanceSwing(GaitInfo.gaitstate.left,GaitInfo.tp,RAnkle);
    
    % tableData = [LhipRollRange, RhipRollRange, LhipRange, RhipRange, LkneeRange, RkneeRange, LankleRange, RankleRange];
    rowNames = {'Stance range','Swing range'};
    varNames = {'LHipAbduction','RHipAbduction','LHipFlexion','RHipFlexion','LKneeFlexion','RKneeFlexion','LAnkleDorsiflexion','RAnkleDorsiflexion'};
    rangeTable = table((LhipRollRange), (RhipRollRange), (LhipRange), (RhipRange), (LkneeRange), (RkneeRange), (LankleRange), (RankleRange),'VariableNames',varNames,'RowNames',rowNames);
end