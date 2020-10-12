function [rangeTable] = createRangeTable(GaitInfo,varNames,LHipRollorGRFx,RHipRollorGRFx,LHiporGRFy,RHiporGRFy,LKneeorGRFz,RKneeorGRFz,LAnkle,RAnkle)
rangeTable = [];
if ~isempty(GaitInfo.gaitstate)
    if nargin < 9
        [LGRFxRange] = getMinMaxStanceSwing(GaitInfo.gaitstate.left,GaitInfo.tp,LHipRollorGRFx);
        [LGRFyRange] = getMinMaxStanceSwing(GaitInfo.gaitstate.left,GaitInfo.tp,LHiporGRFy);
        [LGRFzRange] = getMinMaxStanceSwing(GaitInfo.gaitstate.left,GaitInfo.tp,LKneeorGRFz);
        
        [RGRFxRange] = getMinMaxStanceSwing(GaitInfo.gaitstate.right,GaitInfo.tp,RHipRollorGRFx);
        [RGRFyRange] = getMinMaxStanceSwing(GaitInfo.gaitstate.right,GaitInfo.tp,RHiporGRFy);
        [RGRFzRange] = getMinMaxStanceSwing(GaitInfo.gaitstate.right,GaitInfo.tp,RKneeorGRFz);
        
        rowNames = {'Stance range'};
        rangeTable = table(LGRFxRange(1),RGRFxRange(1),LGRFyRange(1),RGRFyRange(1),LGRFzRange(1),RGRFzRange(1),'VariableNames',varNames,'RowNames',rowNames);
        
    else
        [LhipRollRange] = getMinMaxStanceSwing(GaitInfo.gaitstate.left,GaitInfo.tp,LHipRollorGRFx);
        [LhipRange] = getMinMaxStanceSwing(GaitInfo.gaitstate.left,GaitInfo.tp,LHiporGRFy);
        [LkneeRange] = getMinMaxStanceSwing(GaitInfo.gaitstate.left,GaitInfo.tp,LKneeorGRFz);
        [LankleRange] = getMinMaxStanceSwing(GaitInfo.gaitstate.left,GaitInfo.tp,LAnkle);
        
        [RhipRollRange] = getMinMaxStanceSwing(GaitInfo.gaitstate.right,GaitInfo.tp,RHipRollorGRFx);
        [RhipRange] = getMinMaxStanceSwing(GaitInfo.gaitstate.right,GaitInfo.tp,RHiporGRFy);
        [RkneeRange] = getMinMaxStanceSwing(GaitInfo.gaitstate.right,GaitInfo.tp,RKneeorGRFz);
        [RankleRange] = getMinMaxStanceSwing(GaitInfo.gaitstate.right,GaitInfo.tp,RAnkle);
        
        % tableData = [LhipRollRange, RhipRollRange, LhipRange, RhipRange, LkneeRange, RkneeRange, LankleRange, RankleRange];
        rowNames = {'Stance range','Swing range'};
        rangeTable = table((LhipRollRange), (RhipRollRange), (LhipRange), (RhipRange), (LkneeRange), (RkneeRange), (LankleRange), (RankleRange),'VariableNames',varNames,'RowNames',rowNames);
        
    end
end