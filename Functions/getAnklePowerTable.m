function anklePowerTable = getAnklePowerTable(LanklePower,RanklePower,GaitInfo,saveInfo)
anklePowerTable = [];

% Show the maximum ankle power during stance
LanklePowerStance   =  LanklePower.* GaitInfo.gaitstate.left.StanceV;
RanklePowerStance   =  RanklePower.* GaitInfo.gaitstate.right.StanceV;

rowNames = {'ankle max Power'};

maxLanklePowerStance = nan(size(GaitInfo.start.leftV));
maxRanklePowerStance = nan(size(GaitInfo.start.rightV));

for ii = 1:length(GaitInfo.start.leftV)
    startIdx = GaitInfo.start.leftV(ii);
    endIdx = GaitInfo.end.leftV(ii);
    maxLanklePowerStance(ii)   = max(LanklePowerStance(startIdx:endIdx));
end
maxLanklePowerStance = reshape(maxLanklePowerStance,1,length(maxLanklePowerStance));

for ii = 1:length(GaitInfo.start.rightV)
    startIdx = GaitInfo.start.rightV(ii);
    endIdx = GaitInfo.end.rightV(ii);
    maxRanklePowerStance(ii)   = max(RanklePowerStance(startIdx:endIdx));
end
maxRanklePowerStance = reshape(maxRanklePowerStance,1,length(maxRanklePowerStance));

powerAnkleASI = getFilterdMean_and_ASI(maxLanklePowerStance,maxRanklePowerStance);

if contains(saveInfo.info,'prosthetic') || contains(saveInfo.info,'amputee')
    varNames = {'Intact (W/kg)','Prosthetic (W/kg)', 'ASI (%)'};
    vars = {powerAnkleASI.leftTxt, powerAnkleASI.rightTxt, powerAnkleASI.ASItxt};
    anklePowerTable = (table(vars(:,1),vars(:,2),vars(:,3),'VariableNames',varNames,'RowNames',rowNames));
    
else
    varNames = {'Total (W/kg)', 'ASI (%)'};
    vars = {powerAnkleASI.totalTxt, powerAnkleASI.ASItxt};
    anklePowerTable = (table(vars(:,1),vars(:,2),'VariableNames',varNames,'RowNames',rowNames));
    
end

